//
//  Recipe_Step.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 2..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Recipe_Step {
    let pk: Int
    let step: Int
    let description: String
    var is_timer: Bool
    var timer: Int
    let img_step: String

}
