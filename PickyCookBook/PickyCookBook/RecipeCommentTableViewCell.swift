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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}