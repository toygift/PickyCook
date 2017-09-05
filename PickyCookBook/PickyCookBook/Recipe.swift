//
//  Recipe.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 2..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Recipe {
    let pk: JSON
    let user: JSON
    var title: JSON
    var img_recipe: JSON
    var ingredient: JSON
    let description: JSON
    var like_count: JSON
    var rate_sum: JSON
    var tag: JSON
    
    init (recipe: JSON) {
        self.pk = recipe["pk"]
        self.user = recipe["user"]
        self.title = recipe["title"]
        self.img_recipe = recipe["img_recipe"]
        self.ingredient = recipe["ingredient"]
        self.description = recipe["description"]
        self.like_count = recipe["like_count"]
        self.rate_sum = recipe["rate_sum"]
        self.tag = recipe["tag"]
    }
    
    var dictionary: [String:Any] {
        get {
            let tempDictionary: [String:Any] = ["pk":pk.intValue,
                                                "user":user.stringValue,
                                                "title":title.stringValue,
                                                "img_recipe":img_recipe.stringValue,
                                                "ingredient":ingredient.stringValue,
                                                "description":description.stringValue,
                                                "like_count":like_count.stringValue,
                                                "rate_sum":rate_sum.stringValue,
                                                "tag":tag.stringValue]
            return tempDictionary
        }
    }
}
