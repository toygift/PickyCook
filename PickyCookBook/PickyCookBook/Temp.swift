////
////  temp.swift
////  PickyCookBook
////
////  Created by jaeseong on 2017. 9. 7..
////  Copyright © 2017년 jaeseong. All rights reserved.
////
//
//import Foundation
//import Alamofire
//import SwiftyJSON
//
//class Temp {
//    // MARK: RecipeComment
//    //
//    //
//    func recipeCommentList(){
//        print("====================================================================")
//        print("========================recipeCommentList()=========================")
//        print("====================================================================")
//        
//        let call = Alamofire.request(rootDomain + "recipe/detail/1/", method: .get)
//        
//        call.responseJSON { (response) in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                
//                self.recipe_comment = DataCentre.shared.commentList(response: json["recipes"][0]["comments"])
//                print("코멘트프린트 : ", self.recipe_comment ?? "데이터없음")
//            case .failure(let error):
//                print(error)
//                
//            }
//        }
//        
//    }
//    // MARK: RecipeDetail-review가져오기
//    //
//    //
//    func recipeReviewList(){
//        print("====================================================================")
//        print("=======================recipeReviewList()===========================")
//        print("====================================================================")
//        
//        
//        let call = Alamofire.request(rootDomain + "recipe/detail/1/", method: .get)
//        
//        call.responseJSON { (response) in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                
//                self.recipe_review = DataCentre.shared.recipeReviewList(response: json["reviews"])
//            //print("리뷰프린트   :   ",self.recipe_review ?? "데이터없음")
//            case .failure(let error):
//                print(error)
//                
//            }
//        }
//    }
//    
//    // MARK: RecipeDetail-review가져오기
//    //
//    //
//    func recipeDetail(){
//        print("====================================================================")
//        print("=========================recipeDetail()=============================")
//        print("====================================================================")
//        //        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
//        //        let userPK = UserDefaults.standard.object(forKey: "userpk") as! Int
//        //        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
//        
//        let call = Alamofire.request(rootDomain + "recipe/detail/1/", method: .get)
//        
//        call.responseJSON { (response) in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                
//                self.recipe_step = DataCentre.shared.recipeStepList(response: json["recipes"])
//                print("recipe",self.recipe_step ?? "데이터없음")
//            case .failure(let error):
//                print(error)
//                
//            }
//        }
//    }
//
//}
