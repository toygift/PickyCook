//
//  BookMarkTableViewCell.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 5..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit

class BookMarkTableViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var memo: UILabel!
    @IBOutlet var like_count: UILabel!
    @IBOutlet var rate_sum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
