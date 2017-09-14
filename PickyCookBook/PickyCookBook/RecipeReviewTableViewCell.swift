//
//  RecipeDetailTableViewCell.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 7..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit

class RecipeReviewTableViewCell: UITableViewCell {

    var reviewRecipe: PickyCookBook.Recipe_Review? { didSet { updateUI()}}
    
    @IBOutlet var nickname: UILabel!
    @IBOutlet var content: UILabel!
    
    
    private func updateUI() {
        
        content.text = reviewRecipe?.content
        nickname.text = reviewRecipe?.nickname
    }
    
        

}
