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
    //    @IBOutlet var cellview: UIView!
    
    var allRecipe: PickyCookBook.Recipe? { didSet { updateAllUI()}}
    var myRecipe: PickyCookBook.Recipe? { didSet { updateMyUI()}}
    
    private func updateAllUI() {
        let count_like = allRecipe?.like_count
        let sum_rate = allRecipe?.rate_sum
        
        title.text = allRecipe?.title
        descriptions.text = allRecipe?.description
        tags.text = allRecipe?.tag
        like_count.text = "좋아요 " + "\(count_like ?? 1)"
        rate_sum.text = "평점 " + "\(sum_rate ?? 1)"
        DispatchQueue.global().async {
            guard let path = self.allRecipe?.img_recipe else { return }
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
    
    private func updateMyUI() {
        let count_like = myRecipe?.like_count
        let sum_rate = myRecipe?.rate_sum
        
        title.text = myRecipe?.title
        descriptions.text = myRecipe?.description
        tags.text = myRecipe?.tag
        like_count.text = "좋아요 " + "\(count_like ?? 1)"
        rate_sum.text = "평점 " + "\(sum_rate ?? 1)"
        
        DispatchQueue.global().async {
            guard let path = self.myRecipe?.img_recipe else { return }
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
