//
//  User.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 2..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User {
    let pk: JSON
    let email: JSON
    let nickname: JSON
    var content: JSON
    var img_profile: JSON
    let id_type: JSON
    
    init (user: JSON){
        self.pk = user["pk"]
        self.email = user["email"]
        self.nickname = user["nickname"]
        self.content = user["content"]
        self.img_profile = user["img_profile"]
        self.id_type = user["id_type"]
    }
    
    var dictionary: [String:Any] {
        get {
            let tempDictionary: [String:Any] = ["pk":pk.intValue,
                                                "email":email.stringValue,
                                                "nickname":nickname.stringValue,
                                                "content":content.stringValue,
                                                "img_profile":img_profile.stringValue,
                                                "id_type":id_type.stringValue]
            return tempDictionary
        }
    }
}
