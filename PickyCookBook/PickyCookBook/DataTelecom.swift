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

class DataTelecom {
    
    static let shared: DataTelecom = DataTelecom()
    
    var user: User?
    var recipe: Recipe?
    
    //var recipe_review: [Recipe_Review]?
//    var recipe_comment: [Recipe_Comment]?
    //var recipe_step: [Recipe_Step]?
        // MARK: 데이터 가져오기
    // 서버에서 데이터 가져와서 저장함
    // SignIn시에 user에 데이터 저장함
    func myPageUserData(){
        print("====================================================================")
        print("========================myPageUserData()============================")
        print("====================================================================")
//        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
//        let userpk = UserDefaults.standard.object(forKey: "userpk") as! Int
        
//        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        let tokenValue = TokenAuth()
        guard let headers: HTTPHeaders = tokenValue.getAuthHeaders() else { return }
        guard let userpk = tokenValue.load(serviceName, account: "userpk") else { return }
        let call = Alamofire.request(rootDomain + "member/detail/\(userpk)/", method: .get, headers: headers)
        
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
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
        let recipepk = UserDefaults.standard.integer(forKey: "recipepk")
        print("recipepkkkkkkkkkkkk:",recipepk)
        
        let call = Alamofire.request(rootDomain + "recipe/detail/\(recipepk)", method: .get)
        
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                
//                self.recipe_comment = DataCentre.shared.commentList(response: json["recipes"][0]["comments"]) // Comment
                //self.recipe_step = DataCentre.shared.recipeStepList(response: json["recipes"]) //Step
                print("recipe",self.recipe ?? "데이터없음")
                print("============================================")
//                print("recipe_comment",self.recipe_comment ?? "데이터없음")
                print("============================================")
               // print("recipe_step",self.recipe_step ?? "데이터없음")
                print("============================================")
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    // MARK: AllRecipe
    //
    //
    
}
