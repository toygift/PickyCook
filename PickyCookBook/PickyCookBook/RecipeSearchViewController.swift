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
    
    @IBOutlet var recipe_search: UISearchBar!
    
    var searchRecipe: [Recipe_Search]?
    
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipe_search.delegate = self
        //recipe_search.isSearchResultsButtonSelected = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.placeholder = "검색할 재료를 입력하세요"
        guard let searchText = recipe_search.text else { return }
        recipeSearch(recipeSearch: searchText)
        recipe_search.resignFirstResponder()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //disablesAutomaticKeyboardDismissal = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        recipe_search.resignFirstResponder()
    }
    // MARK: TableView
    //
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchRecipe?.count == nil {
            return 1
        } else {
            return (searchRecipe?.count)!
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SEARCH", for: indexPath) as? RecipeSearchTableViewCell
        //let sum_cal = self.searchRecipe?[indexPath.row].cal_sum
        
        cell?.title.text = self.searchRecipe?[indexPath.row].title
        cell?.descriptions.text = self.searchRecipe?[indexPath.row].description
        cell?.ingredient.text = self.searchRecipe?[indexPath.row].ingredient
        cell?.tags.text = self.searchRecipe?[indexPath.row].tag
        
        
        DispatchQueue.main.async {
            if let path = self.searchRecipe?[indexPath.row].img_recipe{
                if let image = try? Data(contentsOf: URL(string: path)!) {
                    cell?.img_recipe.image = UIImage(data: image)
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "RECIPEDETAIL") as? RecipeDetailViewController else {
            return
        }
        let recipePk = self.searchRecipe?[indexPath.row].pk
        nextViewController.recipepk_r = recipePk
        print("recipePk  :  ",recipePk ?? "NO")
        
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

    
}
extension RecipeSearchViewController {
    func recipeSearch(recipeSearch: String){
        print("====================================================================")
        print("=======================recipeSearch()===============================")
        print("====================================================================")
        
        let recipesURL = "http://pickycookbook.co.kr/api/recipe/search/?search=" + recipeSearch
        let searchEncoding = recipesURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        let call = Alamofire.request(searchEncoding!)
        
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                self.searchRecipe = DataCentre.shared.recipeSearchList(response: json["results"])
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
