//
//  DataTelecom.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 4..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Toaster

let rootDomain: String = "http://pickycookbook.co.kr/api/"



class DataTelecom {
    
    static let shared: DataTelecom = DataTelecom()
    
    var user: User?
    var recipe: Recipe?
    var recipe_review: [Recipe_Review]?
    var recipe_comment: [Recipe_Comment]?
    var recipe_step: [Recipe_Step]?
    
    // MARK: 데이터 가져오기
    // 서버에서 데이터 가져와서 저장함
    // SignIn시에 user에 데이터 저장함
    func myPageUserData(){
        print("====================================================================")
        print("========================myPageUserData()============================")
        print("====================================================================")
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let userPK = UserDefaults.standard.object(forKey: "userpk") as! Int
        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        
        let call = Alamofire.request(rootDomain + "member/detail/\(userPK)/", method: .get, headers: headers)
        
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                self.user = DataCentre.shared.userList(response: json)
                print("유저프린트   :   ",self.user ?? "데이터없음")
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    // MARK: Recipe
    //
    //
    func recipeList(){
        print("====================================================================")
        print("=========================recipeList()===============================")
        print("====================================================================")
        //        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        //        let userPK = UserDefaults.standard.object(forKey: "userpk") as! Int
        //        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        
        let call = Alamofire.request(rootDomain + "recipe/detail/1/", method: .get)
        
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                self.recipe = DataCentre.shared.recipeList(response: json) // Recipe
                self.recipe_comment = DataCentre.shared.commentList(response: json["recipes"][0]["comments"]) // Comment
                self.recipe_review = DataCentre.shared.recipeReviewList(response: json["reviews"]) // Review
                self.recipe_step = DataCentre.shared.recipeStepList(response: json["recipes"]) //Step
                print("recipe",self.recipe ?? "데이터없음")
                print("============================================")
                print("recipe_comment",self.recipe_comment ?? "데이터없음")
                print("============================================")
                print("recipe_review",self.recipe_review ?? "데이터없음")
                print("============================================")
                print("recipe_step",self.recipe_step ?? "데이터없음")
                print("============================================")
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
        
    
    // MARK: SignIn
    //
    //
    func signIn(email: String, password: String) {
        
        let parameters: Parameters = ["email": email, "password": password]
        
        let call = Alamofire.request(rootDomain + "member/login/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("response   :   ",json)
                
                if !json["empty_email"].stringValue.isEmpty {
                    Toast(text: "email을 입력하세요.").show()
                    break
                } else if !json["empty_password"].stringValue.isEmpty {
                    Toast(text: "password를 입력하세요.").show()
                    break
                } else if !json["empty_error"].stringValue.isEmpty {
                    Toast(text: "email과 password를 입력하세요.").show()
                    break
                } else if !json["login_error"].stringValue.isEmpty {
                    Toast(text: "email 또는 password가 맞지 않습니다.").show()
                    break
                } else {
                    
                    let userToken = json["token"].stringValue
                    let userPK = json["pk"].intValue
                    
                    UserDefaults.standard.set(userToken, forKey: "token")
                    print("UserDefaults Set Token   :   ", UserDefaults.standard.string(forKey: "token") ?? "데이터없음")
                    UserDefaults.standard.set(userPK, forKey: "userpk")
                    print("UserDefaults Set UserPK  :   ", UserDefaults.standard.string(forKey: "userpk") ?? "데이터없음")
                    DispatchQueue.main.async {
                        self.myPageUserData()
                    }
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController: UIViewController = HomeViewController()
                    guard let nextViewController = storyboard.instantiateViewController(withIdentifier: "HOME") as? HomeViewController else { return }
                    viewController.present(nextViewController, animated: true, completion: nil)
                    
                    
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
