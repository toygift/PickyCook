//
//  RecipeDetailViewController.swift
//  
//
//  Created by jaeseong on 2017. 9. 7..
//
//

import UIKit
import Alamofire
import SwiftyJSON


class RecipeDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var recipe_review: [Recipe_Review]?
    var recipepk_r: Int!
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func reviewWrite(_ sender: UIButton){
        
    }
    
        
    // MARK: TableView
    //
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.recipe_review?.count ?? 1)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: "REVIEW", for: indexPath) as? RecipeDetailTableViewCell
        cell?.content.text = self.recipe_review?[indexPath.row].content
        cell?.nickname.text = self.recipe_review?[indexPath.row].nickname
        return cell!
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "REVIEWS"
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: Life Cycle
    //
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeList(recipePk: recipepk_r)
        print("viewDidLoad")
        self.navigationItem.title = "레시피상세"
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        print("viewWillAppear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }    
}
extension RecipeDetailViewController {
    func recipeList(recipePk: Int){
        print("====================================================================")
        print("=========================recipeList()===============================")
        print("====================================================================")
        
        let call = Alamofire.request(rootDomain + "recipe/detail/\(recipePk)", method: .get)
        
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                self.recipe_review = DataCentre.shared.recipeReviewList(response: json["reviews"]) // Review
                print("DATATELECOM",self.recipe_review ?? "no")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
}
