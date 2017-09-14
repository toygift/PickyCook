//
//  RecipeReviewViewController.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 14..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RecipeReviewViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    var recipepk: Int?
    var recipe_review: [Recipe_Review] = []
    @IBOutlet var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe_review.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reviewRecipes: Recipe_Review = recipe_review[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "REVIEW", for: indexPath) as? RecipeReviewTableViewCell
        
        cell?.reviewRecipe = reviewRecipes
        
        return cell!

    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    // MARK : Life Cycle
    //
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recipeReviewList(recipePk: recipepk!)
        tableView.rowHeight = UITableViewAutomaticDimension
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.navigationItem.title = "레시피리뷰"
    }

    


}
extension RecipeReviewViewController {
    
    func recipeReviewList(recipePk: Int){
        print("====================================================================")
        print("=====================레시피디테일리스트()================================")
        print("====================================================================")
        
        let call: DataRequest?
        call = Alamofire.request(rootDomain + "recipe/detail/\(recipePk)/", method: .get)
        
        call?.responseJSON { [unowned self] (response) in
            print("------------------------------------------------------response in-----------------------------------------------------------")
            switch response.result {
            case .success(let value):
                print("------------------------------------------------------successs in-----------------------------------------------------------")
                let json = JSON(value)
                
                self.recipe_review = DataCentre.shared.recipeReviewList(response: json["reviews"]) // Review
                
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
