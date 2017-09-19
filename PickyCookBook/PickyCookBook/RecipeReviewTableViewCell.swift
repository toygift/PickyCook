//
//  RecipeDetailTableViewCell.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 7..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import SnapKit

class RecipeReviewTableViewCell: UITableViewCell {

    var reviewRecipe: PickyCookBook.Recipe_Review? { didSet { updateUI()}}
    
    @IBOutlet var nickname: UILabel!
    @IBOutlet var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoLayout()
    }
    
    private func updateUI() {
        
        content.text = reviewRecipe?.content
        nickname.text = reviewRecipe?.nickname
    }
}

extension RecipeReviewTableViewCell {
    func autoLayout() {
        nickname.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).inset(5)
            make.left.equalTo(self.contentView).inset(10)
            make.right.equalTo(self.contentView).inset(10)
//            make.bottom.equalTo(content).inset(10)
        }
        content.snp.makeConstraints { (make) in
            make.top.equalTo(nickname).inset(25)
            make.left.equalTo(self.contentView).inset(10)
            make.right.equalTo(self.contentView).inset(10)
            make.bottom.equalTo(self.contentView).inset(5)
        }
    }
}
