//
//  RecipeDetailTableViewCell.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 7..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit

class RecipeDetailTableViewCell: UITableViewCell {

    @IBOutlet var content: UILabel!
    @IBOutlet var nickname: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}