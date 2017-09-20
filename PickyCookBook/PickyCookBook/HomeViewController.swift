//
//  HomeViewController.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 5..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster
import Social
import MobileCoreServices

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tableView: UITableView!
    
    var recipes: [Recipe] = []
    var myrecipes: [Recipe] = []
    var select: Bool = false
    
    
    
    // MARK : TableView
    //
    //
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue: Int = 0
        if select == false {
            returnValue = (self.recipes.count)
        } else {
            returnValue = (self.myrecipes.count)
        }
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ALLRECIPE", for: indexPath) as? AllRecipeTableViewCell
        
        if self.select == false {
            let allRecipes: Recipe = recipes[indexPath.row]
            cell?.allRecipe = allRecipes
            
        } else  {
            let myRecipes: Recipe = myrecipes[indexPath.row]
            cell?.myRecipe = myRecipes
            
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("====================================================================")
        print("=========================didSelectRowAt=============================")
        print("====================================================================")
        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "RECIPEDETAIL") as? RecipeDetailViewController else {
            return
        }
        let recipePk:Int!
        if select == false {
            recipePk = self.recipes[indexPath.row].pk
            nextViewController.recipepk_r = recipePk
            
            print("recipePk 메인레시피 :  ",recipePk ?? "NO")
            
        } else if select == true {
            let recipePk = self.myrecipes[indexPath.row].pk
            nextViewController.recipepk_r = recipePk
            print("recipePk 내가작성한 레시피 :  ",recipePk)
            
        }
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let bookmark = UITableViewRowAction(style: .default, title: "북마크") { (action, indexPath) in
            let recipepk = self.recipes[indexPath.row].pk
            print("ppkpkpkpkpkpkpkpkpkpkpkpkpk     ",recipepk)
            
            let alertController = UIAlertController(title: "북마크", message: "메모를작성해주세요", preferredStyle: .alert)
            alertController.addTextField(configurationHandler: { (textfield) in
                textfield.placeholder = "메모를 입력하세요"
            })
            alertController.addAction((UIAlertAction(title: "확인", style: .default, handler: { (action) in
                if let title = alertController.textFields?[0].text {
                    if title.isEmpty == false {
                        
                        self.bookmarkRecipe(recipepks: recipepk, memo: title)
                        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                        self.tableView.reloadData()
                    } else {
                        
                    }
                }
            })))
            alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            print("레시피 PK :                  ",recipepk)
        }
        
        
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "보내기") { (action, indexPath) in
            
            
            
            let defaultText = "PickyCookBook에서 공유하는 레시피 입니다   \n" + self.recipes[indexPath.row].title
            
            let imageData = try? Data(contentsOf: URL(string: self.recipes[indexPath.row].img_recipe)!)
            let activityController = UIActivityViewController(activityItems: [defaultText, imageData!], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
            
        }

        bookmark.backgroundColor = UIColor.lightGray
        
        shareAction.backgroundColor = UIColor.brown
        
        return [shareAction, bookmark]
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: Life Cycle
    //
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customViewLoadAppear()
        
        self.navigationItem.title = "레시피"
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("HOMEviewWillAppear")
        //self.customViewLoadAppear()
    }
    // MARK: view Load and Appear
    func customViewLoadAppear(){
        if select == false {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            //            self.navigationItem.title = "레시피"
            self.allRecipeList()
            print("select : false", select)
        } else if select == true {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            //            self.navigationItem.title = "My레시피"
            self.mycreateRecipe()
            print("select : true", select)
            
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
extension HomeViewController {
    // MARK: 전체레시피 함수
    //
    //
    
    func allRecipeList(){
        print("====================================================================")
        print("=========================AllrecipeList()============================")
        print("====================================================================")
        //        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        //        let userPK = UserDefaults.standard.object(forKey: "userpk") as! Int
        //        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        
        let call: DataRequest?
        call = Alamofire.request(rootDomain + "recipe/", method: .get)
        print("=========================AllrecipeList()============================")
        call?.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("=========================AllrecipeList()============================")
                let json = JSON(value)
                
                self.recipes = DataCentre.shared.allRecipeList(response: json) // AllRecipe
                //print("Recipes   :   ", self.recipes?.count ?? "데이터없음")
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
    // MARK: 내가 작성한 레시피 함수
    //
    //
    func mycreateRecipe(){
        print("====================================================================")
        print("========================mycreateRecipe()============================")
        print("====================================================================")
        //        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        //        //        let userPK = UserDefaults.standard.object(forKey: "userpk") as! Int
        //        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        
        let tokenValue = TokenAuth()
        guard let headers = tokenValue.getAuthHeaders() else { return }
        
        let call = Alamofire.request(rootDomain + "recipe/myrecipe/", method: .get, headers: headers)
        
        print("========================mycreateRecipe()============================")
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("========================mycreateRecipe()============================")
                let json = JSON(value)
                print(json)
                self.myrecipes = DataCentre.shared.allRecipeList(response: json) // AllRecipe
                //print("Recipes   :   ", self.recipes?.count ?? "데이터없음")
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
    func bookmarkRecipe(recipepks: Int, memo: String){
        print("====================================================================")
        print("========================bookmarkRecipe()============================")
        print("====================================================================")
        //        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        //        //        let userPK = UserDefaults.standard.object(forKey: "userpk") as! Int
        //        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        let tokenValue = TokenAuth()
        guard let headers = tokenValue.getAuthHeaders() else { return }
        
        let parameters: Parameters = ["memo":memo]
        let call = Alamofire.request(rootDomain + "recipe/bookmark/\(recipepks)/", method: .post, parameters: parameters, headers: headers)
        
        print("========================bookmarkRecipe()============================")
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("========================bookmarkRecipe()============================")
                let json = JSON(value)
                print(json)
                if !(json["memo"].stringValue.isEmpty) == true {
                    Toast(text: "북마크 되었습니다").show()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                } else if !(json["detail"].stringValue.isEmpty) == true {
                    Toast(text: "이미 북마크 되었습니다").show()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                //                self.myrecipes = DataCentre.shared.allRecipeList(response: json) // AllRecipe
                //                //print("Recipes   :   ", self.recipes?.count ?? "데이터없음")
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



