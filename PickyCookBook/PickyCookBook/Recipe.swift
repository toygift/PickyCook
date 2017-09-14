//
//  Recipe.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 2..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import Foundation

struct Recipe {
    let pk: Int
    let user: Int
    var title: String
    var img_recipe: String
    var ingredient: String
    let description: String
    var like_count: Int
    var rate_sum: Double
    var tag: String

}

