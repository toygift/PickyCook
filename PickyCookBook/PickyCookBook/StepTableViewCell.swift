//
//  StepTableViewCell.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 12..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster


class StepTableViewCell: UITableViewCell {

    var recipe_comment: [Recipe_Comment] = []
    
    @IBOutlet var stepLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var img_step: UIImageView!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib in ---------------------------------------------------------")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("setSelected in ---------------------------------------------------------")
        
        // Configure the view for the selected state
    }
    
}

