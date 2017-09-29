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




class RecipeDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, StepTableViewCellDelegate {
    
    var recipe_step: [Recipe_Step] = []
    
    var recipepk_r: Int!
//    var star_sum: Float = 5.0
    var rateBool: Bool = false
    @IBOutlet var tableView: UITableView!
    @IBAction func review(_ sender: UIButton) {
        guard let nextViewController = storyboard?.instantiateViewController(withIdentifier: "RECEIPEREVIEW") as? RecipeReviewViewController else { return }
        
        nextViewController.recipepk = recipepk_r
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    // MARK : StepTableViewCellDelegate
    //
    //
    func timerSetModal(timer: Int) {
        guard let nextViewController = storyboard?.instantiateViewController(withIdentifier: "TIMER") as? TimerViewController else { return }
        nextViewController.seconds = timer
        nextViewController.modalPresentationStyle = .overCurrentContext
        self.present(nextViewController, animated: false, completion: nil)
        
    }
    
    @IBAction func like(_ sender: UIButton) {
        // 좋아요
        
        var dict:[Any] = []
        for i in recipe_step {
            
            let image = try? Data(contentsOf: URL(string: i.img_step)!)
            let desc = i.description
            dict.append(image!)
            dict.append(desc)
   
        }
       
        print(dict)
        
        let acti = UIActivityViewController(activityItems: dict, applicationActivities: nil)
        self.present(acti, animated: true, completion: nil)
        
        }
    
    @IBAction func rate(_ sender: UIButton) {
        let contentVC = StarViewController()
        
        let alert = UIAlertController(title: nil, message: "평점입력", preferredStyle: .alert)
        alert.setValue(contentVC, forKey: "contentViewController")
        let okAction = UIAlertAction(title: "확인", style: .default) { (_) in
            self.rateCreate(recipePk: self.recipepk_r, rate: contentVC.star)
            print("평점 불리언 값 Before : ", self.rateBool)
//            print("알럿  : ", self.star_sum)
            //유저디폴트????저장????불리언값?????
            self.rateBool = true
            print("평점 불리언 값 After : ", self.rateBool)
        }
        alert.addAction(okAction)
        self.present(alert, animated: false) {
            print("alert")
//            print("프레젠트  : ", self.star_sum)
        }
 
    }
 
    @IBAction func reviewWrite(_ sender: UIButton){
        //리뷰쓰기
    }
   
    
    // MARK: TableView
    //
    //
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "가나다라마"
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe_step.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let stepRecipes: Recipe_Step = recipe_step[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "STEPCELL") as? StepTableViewCell
        
        cell?.stepRecipe = stepRecipes
        cell?.stepTableViewCellDelegate = self
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
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
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            
            } else {
            self.navigationItem.title = "레시피스텝"
            
        }
        self.navigationItem.title = "레시피스텝"

        self.recipeDetailList(recipePk: self.recipepk_r)
//        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("------------------------------------------------------------viewDidLoad---------------------------------------------------------")
        
        
        
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
    
    func rateCreate(recipePk: Int, rate: Float){
        print("====================================================================")
        print("=====================레시피디테일리스트()================================")
        print("====================================================================")
        
        let tokenValue = TokenAuth()
        guard let headers = tokenValue.getAuthHeaders() else { return }

        let call: DataRequest?
        let parameters: Parameters = ["rate":rate]
        switch self.rateBool {
        case true:
            call = Alamofire.request(rootDomain + "recipe/rate/\(recipePk)/", method: .patch, parameters: parameters, headers: headers)
        default:
            call = Alamofire.request(rootDomain + "recipe/rate/\(recipePk)/", method: .post, parameters: parameters, headers: headers)
        }
        
        
        call?.responseJSON { (response) in
            print("------------------------------------------------------response in-----------------------------------------------------------")
            switch response.result {
            case .success(let value):
                print("------------------------------------------------------successs in-----------------------------------------------------------")
                let json = JSON(value)
                print(json)
                
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            case .failure(let error):
                print(error)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            }
        }
    }
}
