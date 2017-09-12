//
//  StepTableViewCell.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 12..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster


class StepTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    var recipe_comment: [Recipe_Comment] = []
    @IBOutlet var stepLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var img_step: UIImageView!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    var recipePK:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib in ---------------------------------------------------------")
        self.recipeCommentList(recipePk: self.recipePK)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("setSelected in ---------------------------------------------------------")
        // Configure the view for the selected state
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe_comment.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "STEPCOMMENT") as? StepCommnetTableViewCell
        cell?.comment.text = self.recipe_comment[indexPath.row].content
        return cell!
    }

}
extension StepTableViewCell {
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
                print("---------------------------------------------------------리뷰 : ",json)
                self.recipe_comment = DataCentre.shared.commentList(response: json["recipes"][0]["comments"])
                
                print("---------------------------------------------------------DATATELECOM",self.recipe_comment)
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
