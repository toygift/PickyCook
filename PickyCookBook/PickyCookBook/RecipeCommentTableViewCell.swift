//
//  RecipeCommentTableViewCell.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 13..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import SnapKit

class RecipeCommentTableViewCell: UITableViewCell {

    @IBOutlet var content: UILabel!

    var commentRecipe: PickyCookBook.Recipe_Comment? { didSet { updateUI()}}
    
    private func updateUI() {
        content.text = commentRecipe?.content
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        print("____________________________________________________________")
        autoLayout()
    }
}

extension RecipeCommentTableViewCell {
    func autoLayout() {
        content.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).inset(10)
            make.left.equalTo(self.contentView).inset(10)
            make.right.equalTo(self.contentView).inset(10)
            make.bottom.equalTo(self.contentView).inset(10)
        }
    }
}
