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
  
    @IBOutlet var segment: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    var count: Int = 0
    @IBAction func segmentTouch(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
        print(self.segment.selectedSegmentIndex)
    }
    
    var recipe_step: [Recipe_Step] = []
    var recipe_review: [Recipe_Review] = []
    
    var recipepk_r: Int!
    
    
    @IBAction func reviewWrite(_ sender: UIButton){
        
    }
    
        
    // MARK: TableView
    //
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("---------------------------------------------------------numberOfRowsInSection---------------------------------------------------------")
////        var count: Int = 0
        if self.segment.selectedSegmentIndex == 0 {
            return self.recipe_step.count
        } else {
            return self.recipe_review.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("---------------------------------------------------------cellForRowAt---------------------------------------------------------")
        if segment.selectedSegmentIndex == 0 {
            print("세그먼트 0번 번 번 번 ")
            let cell = tableView.dequeueReusableCell(withIdentifier: "STEPCELL", for: indexPath) as? StepTableViewCell
            cell?.stepLabel.text = String(describing: self.recipe_step[indexPath.row].step)
            cell?.descriptionLabel.text = self.recipe_step[indexPath.row].description
            cell?.timerLabel.text = String(describing: self.recipe_step[indexPath.row].timer)
            
            //cell?.recipeCommentList(recipePk: self.recipepk_r)
            DispatchQueue.main.async {
                let path = self.recipe_step[indexPath.row].img_step
                    if let image = try? Data(contentsOf: URL(string: path)!) {
                        cell?.img_step.image = UIImage(data: image)
                    }
                }
            
            return cell!
        } else  {
            
            print("세그먼트 1번 번 번 번 ")
            let cell = tableView.dequeueReusableCell(withIdentifier: "REVIEW", for: indexPath) as? RecipeDetailTableViewCell
            cell?.content.text = self.recipe_review[indexPath.row].content
            cell?.nickname.text = self.recipe_review[indexPath.row].nickname
            
            return cell!
            
        }
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 다시보기
        print("---------------------------------------------------------heightForRowAt---------------------------------------------------------")
        if segment.selectedSegmentIndex == 0 {
            return 400
        } else {
            return 150
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("----------------------------------didsecect-----------------------------------")
        if segment.selectedSegmentIndex == 0 {
            guard let nextViewController = storyboard?.instantiateViewController(withIdentifier: "RECIPECOMMENT") as? RecipeStepViewController else { return }
            
            nextViewController.recipepk = recipepk_r
            nextViewController.commentpk = self.recipe_step[indexPath.row].pk
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
        
        
    }
    // MARK: Life Cycle
    //
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recipeDetailList(recipePk: self.recipepk_r)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("---------------------------------------------------------viewDidLoad---------------------------------------------------------")
        self.navigationItem.title = "레시피상세"
        
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
        print("---------------------------------------------------------viewWillAppear---------------------------------------------------------")
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("---------------------------------------------------------viewWillDisappear---------------------------------------------------------")
    }    
}
extension RecipeDetailViewController {
//    func recipeStepList(recipePk: Int){
//        print("====================================================================")
//        print("======================레시피 스텝 리스트()===============================")
//        print("====================================================================")
//        
//        let call = Alamofire.request(rootDomain + "recipe/detail/\(recipePk)", method: .get)
//        
//        call.responseJSON { (response) in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                print("스텝 : ",json)
//                self.recipe_step = DataCentre.shared.recipeStepList(response: json["recipes"])
//                
//                print("DATATELECOM",self.recipe_step ?? "no")
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//                UIApplication.shared.isNetworkActivityIndicatorVisible = false
//            case .failure(let error):
//                print(error)
//                UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                
//            }
//        }
//    }
    
    func recipeDetailList(recipePk: Int){
        print("====================================================================")
        print("=====================레시피디테일리스트()================================")
        print("====================================================================")
        
        let call = Alamofire.request(rootDomain + "recipe/detail/\(recipePk)/", method: .get)
        
        call.responseJSON { (response) in
            print("response in ---------------------------------------------------------")
            switch response.result {
            case .success(let value):
                print("Success in ---------------------------------------------------------")
                let json = JSON(value)
                print("---------------------------------------------------------리뷰 : ",json)
                self.recipe_review = DataCentre.shared.recipeReviewList(response: json["reviews"]) // Review
                self.recipe_step = DataCentre.shared.recipeStepList(response: json["recipes"])
                print("---------------------------------------------------------DATATELECOM",self.recipe_review)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            case .failure(let error):
                print(error)
                print("실패 ---------------------------------------------------------")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            }
        }
    }
}
