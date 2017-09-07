//
//  DataCentre.swift
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

class DataCentre {
    
    static let shared: DataCentre = DataCentre()
   
    // MARK: User
    ///
    //
    func userList(response json: JSON) -> User {
        let user = User(pk: json["pk"].intValue,
                        email: json["email"].stringValue,
                        nickname: json["nickname"].stringValue,
                        content: json["content"].stringValue,
                        img_profile: json["img_profile"].stringValue,
                        id_type: json["id_type"].stringValue)
        return user
    }

    
    // MARK: Recipe
    ///
    ///
    func recipeList(response json: JSON) -> Recipe {
        let recipe = Recipe(pk: json["pk"].intValue,
                            user: json["user"].intValue,
                            title: json["title"].stringValue,
                            img_recipe: json["img_recipe"].stringValue,
                            ingredient: json["ingredient"].stringValue,
                            description: json["description"].stringValue,
                            like_count: json["like_count"].intValue,
                            rate_sum: json["rate_sum"].doubleValue,
                            tag: json["tag"].stringValue)
        return recipe
    }
    // MARK: AllRecipe
    ///
    ///
    func allRecipeList(response json: JSON) -> [Recipe] {
        let recipe: [Recipe] = json.arrayValue.map { (jsonmap) -> Recipe in
            let value = Recipe(pk: jsonmap["pk"].intValue,
                               user: jsonmap["user"].intValue,
                               title: jsonmap["title"].stringValue,
                               img_recipe: jsonmap["img_recipe"].stringValue,
                               ingredient: jsonmap["ingredient"].stringValue,
                               description: jsonmap["description"].stringValue,
                               like_count: jsonmap["like_count"].intValue,
                               rate_sum: jsonmap["rate_sum"].doubleValue,
                               tag: jsonmap["tag"].stringValue)
            return value
        }
        return recipe
    }
    
    // MARK: CommentList
    //
    //
    func commentList(response json: JSON) -> [Recipe_Comment] {
        let comment: [Recipe_Comment] = json.arrayValue.map { (jsonmap) -> Recipe_Comment in
            
            let value = Recipe_Comment(pk: jsonmap["pk"].intValue,
                                       recipe_step: jsonmap["recipe_step"].intValue,
                                       user: jsonmap["user"].intValue,
                                       content: jsonmap["content"].stringValue)
            return value
        }
        return comment
    }
    
    // MARK: Recipe_Review
    //
    //
    func recipeReviewList(response json: JSON) -> [Recipe_Review] {
        let review: [Recipe_Review] = json.arrayValue.map { (jsonmap) -> Recipe_Review in
            let value = Recipe_Review(pk: jsonmap["pk"].intValue,
                                      recipe: jsonmap["recipe"].intValue,
                                      user: jsonmap["user"].intValue,
                                      content: jsonmap["content"].stringValue,
                                      img_review: jsonmap["img_review"].stringValue,
                                      nickname: jsonmap["nickname"].stringValue)
//            let value = Recipe_Review(pk: jsonmap["pk"].intValue,
//                                      recipe: jsonmap["recipe"].intValue,
//                                      user: jsonmap["user"].intValue,
//                                      content: jsonmap["content"].stringValue,
//                                      img_review: jsonmap["img_review"].stringValue,
//                                      nickname: jsonmap["nickname"].stringValue)
//            
            
            return value
        }
        print("RecipeReviewList")
        print("review   :   ", review)
       return review
    }
    // MARK: Recipe_Step
    //
    //
    func recipeStepList(response json: JSON) -> [Recipe_Step] {
        let step: [Recipe_Step] = json.arrayValue.map { (jsonmap) -> Recipe_Step in
            let value = Recipe_Step(pk: jsonmap["pk"].intValue,
                                    step: jsonmap["step"].intValue,
                                    description: jsonmap["description"].stringValue,
                                    is_timer: jsonmap["is_timer"].boolValue,
                                    timer: jsonmap["timer"].intValue,
                                    img_step: jsonmap["img_step"].stringValue)
            
            return value
        }
        return step
    }
    // MARK: Recipe_Bookmark
    //
    //
    func recipeBookmarkList(response json: JSON) -> [Recipe_Bookmark] {
        let step: [Recipe_Bookmark] = json.arrayValue.map { (jsonmap) -> Recipe_Bookmark in
            let value = Recipe_Bookmark(pk: jsonmap["pk"].intValue,
                                        user: jsonmap["user"].intValue,
                                        titie: jsonmap["title"].stringValue,
                                        memo: jsonmap["memo"].stringValue,
                                        img_recipe: jsonmap["img_recipe"].stringValue)
            
            return value
        }
        return step
    }

}
