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
    @IBOutlet var img_recipe: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    var bookmarkRecipe: PickyCookBook.Recipe_Bookmark? { didSet { updateUI()}}
    
    private func updateUI() {
        let count_like = bookmarkRecipe?.like_count
        let sum_rate = bookmarkRecipe?.rate_sum
        
        title.text = bookmarkRecipe?.title
        memo.text = bookmarkRecipe?.memo
        like_count.text = "좋아요 " + "\(count_like ?? 1)"
        rate_sum.text = "평점 " + "\(sum_rate ?? 1)"
        
        DispatchQueue.global().async {
            guard let path = self.bookmarkRecipe?.img_recipe else { return }
            if let imageURL = URL(string: path) {
                let task = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
                    guard let putImage = data else { return }
                    DispatchQueue.main.async {
                        self.img_recipe.image = UIImage(data: putImage)
                    }
                })
                task.resume()
            }
        }
    }

}

