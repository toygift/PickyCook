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
    var recipes: [Recipe]?
    var recipe_review: [Recipe_Review]?
    var recipe_comment: [Recipe_Comment]?
    var recipe_step: [Recipe_Step]?
    var recipe_bookmark: [Recipe_Bookmark]?
    // MARK: Bookmark 가져오기
    //
    //
    func bookmarkList(){
        print("====================================================================")
        print("==========================bookmarkList()============================")
        print("====================================================================")
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        
        let call = Alamofire.request(rootDomain + "recipe/bookmark/", method: .get, headers: headers)
        
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                self.recipe_bookmark = DataCentre.shared.recipeBookmarkList(response: json)
                print("유저프린트   :   ",self.recipe_bookmark ?? "데이터없음")
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
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
                
                self.recipe = DataCentre.shared.recipeList(response: json) // Recipe
                self.recipe_comment = DataCentre.shared.commentList(response: json["recipes"][0]["comments"]) // Comment
                self.recipe_step = DataCentre.shared.recipeStepList(response: json["recipes"]) //Step
                print("recipe",self.recipe ?? "데이터없음")
                print("============================================")
                print("recipe_comment",self.recipe_comment ?? "데이터없음")
                print("============================================")
                print("recipe_step",self.recipe_step ?? "데이터없음")
                print("============================================")
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    // MARK: AllRecipe
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
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
}
