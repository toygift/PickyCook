//
//  RecipeCommentTableViewCell.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 13..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit

class RecipeCommentTableViewCell: UITableViewCell {

    @IBOutlet var content: UILabel!

    var commentRecipe: PickyCookBook.Recipe_Comment? { didSet { updateUI()}}
    
    private func updateUI() {
        content.text = commentRecipe?.content
    }
}
