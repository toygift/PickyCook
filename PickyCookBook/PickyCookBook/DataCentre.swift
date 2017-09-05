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
    var user: User = User(user: <#JSON#>)
    var recipe: Recipe = Recipe(recipe: <#JSON#>)
    var recipe_bookmark: Recipe_Bookmark = Recipe_Bookmark(bookmark: <#JSON#>)
    
}
