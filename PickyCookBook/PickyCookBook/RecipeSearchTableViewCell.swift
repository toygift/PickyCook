//
//  RecipeSearchTableViewCell.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 9..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import SnapKit

class RecipeSearchTableViewCell: UITableViewCell {

    @IBOutlet var stackView: UIStackView!
    
    @IBOutlet var img_recipe: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var descriptions: UILabel!
    @IBOutlet var ingredient: UILabel!
    @IBOutlet var tags: UILabel!
    
    var searchRecipe: PickyCookBook.Recipe_Search? { didSet { updateUI()}}
    override func awakeFromNib() {
        super.awakeFromNib()
        autoLayout()
    }
    private func updateUI() {
        title.text = searchRecipe?.title
        descriptions.text = searchRecipe?.description
        ingredient.text = searchRecipe?.ingredient
        tags.text = searchRecipe?.tag
        DispatchQueue.global().async {
            guard let path = self.searchRecipe?.img_recipe else { return }
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
extension RecipeSearchTableViewCell {
    func autoLayout(){
        img_recipe.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).inset(10)
            make.left.equalTo(self.contentView).inset(10)
            make.right.equalTo(stackView).inset(10)
            make.bottom.equalTo(self.contentView).inset(10)
        }
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).inset(10)
//            make.left.equalTo(self.contentView).inset(10)
            make.right.equalTo(self.contentView).inset(10)
            make.bottom.equalTo(self.contentView).inset(10)
        }
    }
}
