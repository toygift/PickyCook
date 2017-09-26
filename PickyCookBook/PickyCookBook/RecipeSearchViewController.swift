//
//  RecipeSearchViewController.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 9..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster

class RecipeSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate {

    
        @IBOutlet var tableView: UITableView!
        
        var searchController: UISearchController!
        
        //    let searchController = UISearchController(searchResultsController: nil)

    
        //검색결과레시피
        var recipe_search: [Recipe_Search] = []
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            if #available(iOS 11.0, *) {
                navigationController?.navigationBar.prefersLargeTitles = true
                
            } else {
                
            }
            
            //                refreshControl = UIRefreshControl()
            //        if #available(iOS 11.0, *) {
            //            navigationItem.hidesSearchBarWhenScrolling = false
            //            searchBar.isHidden = true
            //        } else {
            //            // Fallback on earlier versions
            //        }
            //        searchController.searchBar.delegate = self
            //        searchBar.delegate = self
            //        searchController.searchBar.placeholder = "검색할 재료를 입력하세요"
            tableView.delegate = self
            tableView.rowHeight = UITableViewAutomaticDimension
            
            //add
            
            searchController = UISearchController(searchResultsController: nil)
//            searchController.searchResultsUpdater = self
            if #available(iOS 11.0, *) {
                navigationItem.searchController = searchController
                navigationItem.hidesSearchBarWhenScrolling = false
            } else {
                // Fallback on earlier versions
            }
            
            searchController.searchBar.delegate = self
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.dimsBackgroundDuringPresentation = false
            searchController.searchBar.searchBarStyle = .prominent
            searchController.searchBar.sizeToFit()
//            tableView.tableHeaderView = searchController.searchBar
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            guard let searchText = searchController.searchBar.text else { return }
            recipeSearch(recipeSearch: searchText)
            searchController.searchBar.resignFirstResponder()
            searchController.searchBar.endEditing(true)
            
            
            //        searchBar.showsCancelButton = false
            //        searchBar.endEditing(true)
            
            
            
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
        }
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            //        searchBar.showsCancelButton = false
            //        searchBar.text = ""
            //        searchBar.endEditing(true)
        }
        func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            //        searchBar.showsCancelButton = true
        }
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            //        disablesAutomaticKeyboardDismissal = true
            searchController.searchBar.resignFirstResponder()
        }
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            //        searchBar.resignFirstResponder()
            //        searchBar.endEditing(true)
            //        tableView.touchesBegan(touches, with: recipe_search.endEditing(true))
        }
        func didDismissSearchController(_ searchController: UISearchController) {
            //        searchController.searchBar.resignFirstResponder()
            //        searchController.searchBar.endEditing(true)
        }
        func willDismissSearchController(_ searchController: UISearchController) {
            searchController.searchBar.resignFirstResponder()
            searchController.searchBar.endEditing(true)
        }
        
        // MARK: TableView
        //
        //
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return recipe_search.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SEARCH", for: indexPath) as? RecipeSearchTableViewCell
            
            let searchRecipes: Recipe_Search = recipe_search[indexPath.row]
            
            cell?.searchRecipe = searchRecipes

            return cell!
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "RECIPEDETAIL") as? RecipeDetailViewController else {
                return
            }
            let recipePk = self.recipe_search[indexPath.row].pk
            nextViewController.recipepk_r = recipePk
            print("recipePk  :  ",recipePk)
            
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableViewAutomaticDimension
        }
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            
            let bookmark = UITableViewRowAction(style: .default, title: "북마크") { (action, indexPath) in
                let recipepk = self.recipe_search[indexPath.row].pk
                print("ppkpkpkpkpkpkpkpkpkpkpkpkpk     ",recipepk)
                
                let alertController = UIAlertController(title: "북마크", message: "메모를작성해주세요", preferredStyle: .alert)
                alertController.addTextField(configurationHandler: { (textfield) in
                    textfield.placeholder = "메모를 입력하세요"
                })
                alertController.addAction((UIAlertAction(title: "확인", style: .default, handler: { (action) in
                    if let title = alertController.textFields?[0].text {
                        if title.isEmpty == false {
                            
                            self.bookmarkRecipe(recipepks: recipepk, memo: title)
                            UIApplication.shared.isNetworkActivityIndicatorVisible = true
                            self.tableView.reloadData()
                        } else {
                            
                        }
                    }
                })))
                alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                print("레시피 PK :                  ",recipepk)
            }
            bookmark.backgroundColor = UIColor.lightGray
            return [bookmark]
        }
        
    }
    extension RecipeSearchViewController {
            func recipeSearch(recipeSearch: String){
                print("====================================================================")
                print("=======================recipeSearch()===============================")
                print("====================================================================")
        
                let recipesURL = rootDomain + "/recipe/search/?search=" + recipeSearch
                let searchEncoding = recipesURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
                let call = Alamofire.request(searchEncoding!)
        
                call.responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print(json)
                        self.recipe_search = DataCentre.shared.recipeSearchList(response: json["results"])
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    case .failure(let error):
                        print(error)
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
                    }
                }
            }
  
        func bookmarkRecipe(recipepks: Int, memo: String){
            print("====================================================================")
            print("========================bookmarkRecipe()============================")
            print("====================================================================")
            //        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
            //        //        let userPK = UserDefaults.standard.object(forKey: "userpk") as! Int
            //        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
            let tokenValue = TokenAuth()
            guard let headers = tokenValue.getAuthHeaders() else { return }
            
            let parameters: Parameters = ["memo":memo]
            let call = Alamofire.request(rootDomain + "recipe/bookmark/\(recipepks)/", method: .post, parameters: parameters, headers: headers)
            
            print("========================bookmarkRecipe()============================")
            call.responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    print("========================bookmarkRecipe()============================")
                    let json = JSON(value)
                    print(json)
                    if !(json["memo"].stringValue.isEmpty) == true {
                        Toast(text: "북마크 되었습니다").show()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    } else if !(json["detail"].stringValue.isEmpty) == true {
                        Toast(text: "이미 북마크 되었습니다").show()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    //                self.myrecipes = DataCentre.shared.allRecipeList(response: json) // AllRecipe
                    //                //print("Recipes   :   ", self.recipes?.count ?? "데이터없음")
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                case .failure(let error):
                    print(error)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                }
            }
        }
}
