//
//  AllRecipeTableViewCell.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 7..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit

class AllRecipeTableViewCell: UITableViewCell {

    
    @IBOutlet var img_recipe: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var descriptions: UILabel!
    @IBOutlet var tags: UILabel!
    @IBOutlet var like_count: UILabel!
    @IBOutlet var rate_sum: UILabel!
    @IBOutlet var cellview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
