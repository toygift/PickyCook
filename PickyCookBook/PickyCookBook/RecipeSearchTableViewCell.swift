//
//  RecipeSearchTableViewCell.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 9..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit

class RecipeSearchTableViewCell: UITableViewCell {

    @IBOutlet var img_recipe: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var descriptions: UILabel!
    @IBOutlet var ingredient: UILabel!
    @IBOutlet var tags: UILabel!
    
    
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
