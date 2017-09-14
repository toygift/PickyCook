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

    var stepRecipe: PickyCookBook.Recipe_Step? { didSet { updateUI()}}
    
    @IBOutlet var stepLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var img_step: UIImageView!
    @IBOutlet var timerLabel: UILabel!

    
    private func updateUI() {
        let stepNumber = stepRecipe?.step
        let stepTimer = stepRecipe?.timer
        
        stepLabel.text = "스텝번호 " + "\(stepNumber ?? 1)"
        descriptionLabel.text = stepRecipe?.description
        timerLabel.text = "소요시간 " + "\(stepTimer ?? 1)"
        
        //cell?.recipeCommentList(recipePk: self.recipepk_r)
        DispatchQueue.global().async {
            guard let path = self.stepRecipe?.img_step else { return }
            if let imageURL = URL(string: path) {
                let task = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
                    guard let putImage = data else { return }
                    DispatchQueue.main.async {
                        self.img_step.image = UIImage(data: putImage)
                    }
                })
                task.resume()
            }
        } 
    }
}

