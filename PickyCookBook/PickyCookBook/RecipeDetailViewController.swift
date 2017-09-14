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


class RecipeDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet var uiView: UIView!
    
    var recipe_step: [Recipe_Step] = []
    
    var recipepk_r: Int!
    var star_sum: String = ""
    
    @IBOutlet var tableView: UITableView!
    @IBAction func review(_ sender: UIButton) {
        guard let nextViewController = storyboard?.instantiateViewController(withIdentifier: "RECEIPEREVIEW") as? RecipeReviewViewController else { return }
        
        nextViewController.recipepk = recipepk_r
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    @IBAction func like(_ sender: UIButton) {
        let contentVC = StarViewController()
        
        let alert = UIAlertController(title: nil, message: "평점입력", preferredStyle: .alert)
        alert.setValue(contentVC, forKey: "contentViewController")
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: false) {
            print("alert")
            print(self.star_sum)
            
        }
    }
    @IBAction func rate(_ sender: UIButton) {
        
    }
    
    
    
    @IBAction func reviewWrite(_ sender: UIButton){
        print("rkrkrkrkk")
    }
    
    
    // MARK: TableView
    //
    //
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "가나다라마"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe_step.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let stepRecipes: Recipe_Step = recipe_step[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "STEPCELL", for: indexPath) as? StepTableViewCell
        
        cell?.stepRecipe = stepRecipes
        
        return cell!
        
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("----------------------------------didsecect-----------------------------------")
        
        guard let nextViewController = storyboard?.instantiateViewController(withIdentifier: "RECIPECOMMENT") as? RecipeStepViewController else { return }
        
        nextViewController.recipepk = recipepk_r
        nextViewController.commentpk = self.recipe_step[indexPath.row].pk
        self.navigationController?.pushViewController(nextViewController, animated: true)
  
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    // MARK: Life Cycle
    //
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recipeDetailList(recipePk: self.recipepk_r)
//        tableView.estimatedRowHeight = tableView.rowHeight
//        tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("------------------------------------------------------------viewDidLoad---------------------------------------------------------")
        self.navigationItem.title = "레시피스텝"
        
        
    }
}


extension RecipeDetailViewController {
    
    func recipeDetailList(recipePk: Int){
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
                print(json)
                self.recipe_step = DataCentre.shared.recipeStepList(response: json["recipes"])
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
