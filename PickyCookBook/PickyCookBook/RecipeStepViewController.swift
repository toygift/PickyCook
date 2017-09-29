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
//    var heightArray: NSMutableArray = []
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            
        } else {
            
        }
        self.navigationItem.title = "레시피스텝코멘트"
        //Gggggg
        autoLayout()
        
        recipeCommentList(recipePk: self.recipepk!)
        tableView.rowHeight = UITableViewAutomaticDimension
//        let count = recipe_comment.count
//        for _ in 0...count - 1 {
//            heightArray.add(false)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : TableView
    //
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe_comment.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "COMMENT", for: indexPath) as? RecipeCommentTableViewCell
        let commentRecipes: Recipe_Comment = recipe_comment[indexPath.row]
        cell?.commentRecipe = commentRecipes
        
        // 터치시 확장
        //
//        if heightArray[indexPath.row] as! Bool == false {
//            cell?.content.numberOfLines = 1
//        } else {
//            cell?.content.numberOfLines = 0
//        }
        
        return cell!
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if heightArray[indexPath.row] as? Bool == false {
//            heightArray.replaceObject(at: indexPath.row, with: true)
//        } else {
//            heightArray.replaceObject(at: indexPath.row, with: false)
//        }
//        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
//    }
    // 자동계산
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
extension RecipeStepViewController {
    func autoLayout(){
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }
}
