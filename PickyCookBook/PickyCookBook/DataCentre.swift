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
                            like_count: json["like_count"].doubleValue,
                            rate_sum: json["rate_sum"].doubleValue,
                            tag: json["tag"].stringValue)
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
                                      img_review: jsonmap["img_review"].stringValue)
            
            
            return value
        }
       return review
    }
    // MARK: Recipe_step
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
}
