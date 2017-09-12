//
//  RecipeStepViewController.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 12..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster

class RecipeStepViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var recipepk: Int?
    var commentpk: Int?
    var recipe_comment: [Recipe_Comment] = []
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "레시피스텝코멘트"
        recipeCommentList(recipePk: self.recipepk!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe_comment.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "COMMENT", for: indexPath) as? RecipeCommentTableViewCell
        cell?.content.text = self.recipe_comment[indexPath.row].content
        return cell!
    }

}
extension RecipeStepViewController {
    func recipeCommentList(recipePk: Int){
        print("====================================================================")
        print("=====================레시피코멘트()================================")
        print("====================================================================")
        
        let call = Alamofire.request(rootDomain + "recipe/detail/\(recipePk)/", method: .get)
        
        call.responseJSON { (response) in
            print("response in ---------------------------------------------------------")
            switch response.result {
            case .success(let value):
                print("Success in ---------------------------------------------------------")
                let json = JSON(value)
                print("-----------dfdf----------------------------------------------리뷰 : ",json)
                self.recipe_comment = DataCentre.shared.commentList(response: json["recipes"][self.commentpk! - 1]["comments"])
                
                print("----------------dfdf-----------------------------------------DATATELECOM",self.recipe_comment)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
                print("실패 ---------------------------------------------------------")
                
                
            }
        }
    }
}
