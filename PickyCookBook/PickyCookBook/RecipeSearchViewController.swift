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

class RecipeSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var searchBar: UISearchBar!
    
    var recipe_search: [Recipe_Search] = []
    
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        searchBar.placeholder = "검색할 재료를 입력하세요"
        //recipe_search.isSearchResultsButtonSelected = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text else { return }
        recipeSearch(recipeSearch: searchText)
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //disablesAutomaticKeyboardDismissal = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
//        tableView.touchesBegan(touches, with: recipe_search.endEditing(true))
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
}
