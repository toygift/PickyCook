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

protocol Refresh {
    func refresh()
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet var tableView: UITableView!
    var recipes: [Recipe]?
    var myrecipes: [Recipe]?
    var select: Bool = false
    var selects: Bool = false
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.recipes?.count ?? 1)!
    }
    // MARK : TableView
    //
    //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ALLRECIPE", for: indexPath) as? AllRecipeTableViewCell
        
        if select == false {
            let count_like = self.recipes?[indexPath.row].like_count
            let sum_rate = self.recipes?[indexPath.row].rate_sum
            
            cell?.title.text = self.recipes?[indexPath.row].title
            cell?.descriptions.text = self.recipes?[indexPath.row].description
            cell?.tags.text = self.recipes?[indexPath.row].tag
            cell?.like_count.text = "좋아요 " + "\(count_like ?? 1)"
            cell?.rate_sum.text = "평점 " + "\(sum_rate ?? 1)"
            
            DispatchQueue.main.async {
                if let path = self.recipes?[indexPath.row].img_recipe {
                    if let image = try? Data(contentsOf: URL(string: path)!) {
                        cell?.img_recipe.image = UIImage(data: image)
                    }
                }
            }
            
            
        } else if select == true {
            let count_like = self.myrecipes?[indexPath.row].like_count
            let sum_rate = self.myrecipes?[indexPath.row].rate_sum
            
            cell?.title.text = self.myrecipes?[indexPath.row].title
            cell?.descriptions.text = self.myrecipes?[indexPath.row].description
            cell?.tags.text = self.myrecipes?[indexPath.row].tag
            cell?.like_count.text = "좋아요 " + "\(count_like ?? 1)"
            cell?.rate_sum.text = "평점 " + "\(sum_rate ?? 1)"
            
            DispatchQueue.main.async {
                if let path = self.myrecipes?[indexPath.row].img_recipe {
                    if let image = try? Data(contentsOf: URL(string: path)!) {
                        cell?.img_recipe.image = UIImage(data: image)
                    }
                }
            }
            
            
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
            recipePk = self.recipes?[indexPath.row].pk
            nextViewController.recipepk_r = recipePk
            print("recipePk 메인레시피 :  ",recipePk ?? "NO")
            
        } else if select == true {
            let recipePk = self.myrecipes?[indexPath.row].pk
            nextViewController.recipepk_r = recipePk
            print("recipePk 내가작성한 레시피 :  ",recipePk ?? "NO")
            
        }
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       
            let bookmark = UITableViewRowAction(style: .default, title: "북마크") { (action, indexPath) in
            let recipepk = self.recipes?[indexPath.row].pk
            print("ppkpkpkpkpkpkpkpkpkpkpkpkpk     ",recipepk ?? 1)
            
            let alertController = UIAlertController(title: "북마크", message: "메모를작성해주세요", preferredStyle: .alert)
            alertController.addTextField(configurationHandler: { (textfield) in
                textfield.placeholder = "메모를 입력하세요"
            })
            alertController.addAction((UIAlertAction(title: "확인", style: .default, handler: { (action) in
                if let title = alertController.textFields?[0].text {
                    if title.isEmpty == false {
                        
                        self.bookmarkRecipe(recipepks: recipepk!, memo: title)
                        self.tableView.reloadData()
                    } else {
                        
                    }
                }
            })))
            alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            print("레시피 PK :                  ",recipepk ?? "no")
        }
        bookmark.backgroundColor = UIColor.lightGray
        
        return [bookmark]
    }
    
    // MARK: Life Cycle
    //
    //
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("HOMEviewWillAppear")
        
        if select == false {
            self.navigationItem.title = "레시피"
            self.allRecipeList()
            print("select : false", select)
        } else if select == true {
            self.navigationItem.title = "내가작성한레시피"
            self.mycreateRecipe()
            print("select : true", select)
            
        }
        //
        //
        //        if selects == false {
        //            self.allRecipeList()
        //            selects = false
        //        }else {
        //            self.mycreateRecipe()
        //            selects = true
        //        }
        //
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
        
        let call = Alamofire.request(rootDomain + "recipe/", method: .get)
        print("=========================AllrecipeList()============================")
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("=========================AllrecipeList()============================")
                let json = JSON(value)
                
                self.recipes = DataCentre.shared.allRecipeList(response: json) // AllRecipe
                //print("Recipes   :   ", self.recipes?.count ?? "데이터없음")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
                
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
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        //        let userPK = UserDefaults.standard.object(forKey: "userpk") as! Int
        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        
        let call = Alamofire.request(rootDomain + "recipe/myrecipe/", method: .get, headers: headers)
        
        print("========================mycreateRecipe()============================")
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("========================mycreateRecipe()============================")
                let json = JSON(value)
                
                self.myrecipes = DataCentre.shared.allRecipeList(response: json) // AllRecipe
                //print("Recipes   :   ", self.recipes?.count ?? "데이터없음")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
    func bookmarkRecipe(recipepks: Int, memo: String){
        print("====================================================================")
        print("========================bookmarkRecipe()============================")
        print("====================================================================")
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        //        let userPK = UserDefaults.standard.object(forKey: "userpk") as! Int
        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
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
                } else if !(json["detail"].stringValue.isEmpty) == true {
                    Toast(text: "이미 북마크 되었습니다").show()
                }
                //                self.myrecipes = DataCentre.shared.allRecipeList(response: json) // AllRecipe
                //                //print("Recipes   :   ", self.recipes?.count ?? "데이터없음")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
}
