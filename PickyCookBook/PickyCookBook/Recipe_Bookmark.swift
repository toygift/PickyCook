//
//  Recipe_Bookmark.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 6..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import Foundation

struct Recipe_Bookmark {
    let pk: Int
    let user: Int
    let recipe: Int
    var title: String
    var memo: String
    var img_recipe: String
    var like_count: Int
    var rate_sum: Double
}
