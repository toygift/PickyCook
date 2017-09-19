//
//  BookMarkTableViewCell.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 5..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import SnapKit

class BookMarkTableViewCell: UITableViewCell {

    @IBOutlet var stackView: UIStackView!
    @IBOutlet var stackViewMiddle: UIStackView!
    @IBOutlet var stackViewBottom: UIStackView!
    
    
    @IBOutlet var title: UILabel!
    @IBOutlet var memo: UILabel!
    @IBOutlet var like_count: UILabel!
    @IBOutlet var rate_sum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoLayout()
    }
    var bookmarkRecipe: PickyCookBook.Recipe_Bookmark? { didSet { updateUI()}}
    
    private func updateUI() {
        let count_like = bookmarkRecipe?.like_count
        let sum_rate = bookmarkRecipe?.rate_sum
        
        title.text = bookmarkRecipe?.title
        memo.text = bookmarkRecipe?.memo
        like_count.text = "좋아요 " + "\(count_like ?? 1)"
        rate_sum.text = "평점 " + "\(sum_rate ?? 1)"
        
    }

}
extension BookMarkTableViewCell {
    func autoLayout() {
        
        
    }
}
