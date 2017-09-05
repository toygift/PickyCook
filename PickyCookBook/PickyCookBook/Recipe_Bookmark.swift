//
//  Recipe_Bookmark.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 2..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Recipe_Bookmark {
    let pk: JSON
    let user: JSON
    let recipe: JSON
    let memo: JSON
    
    init (bookmark: JSON){
        self.pk = bookmark["pk"]
        self.user = bookmark["user"]
        self.recipe = bookmark["recipe"]
        self.memo = bookmark["memo"]
        
    }
    
    var dictionary: [String:Any] {
        get {
            let tempDictionary: [String:Any] = ["pk":pk.intValue,
                                                "user":user.stringValue,
                                                "recipe":recipe.stringValue,
                                                "memo":memo.stringValue]
                                                
            return tempDictionary
        }
    }
}
