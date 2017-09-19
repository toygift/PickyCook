//
//  ViewController.swift
//  test
//
//  Created by jaeseong on 2017. 9. 14..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit

class StarViewController: UIViewController, FloatRatingViewDelegate {

    let statRating = FloatRatingView()
    var star: Float = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statRating.emptyImage = UIImage(named: "star2")
        self.statRating.fullImage = UIImage(named: "star")
        self.statRating.delegate = self
        self.statRating.contentMode = UIViewContentMode.scaleAspectFit
        self.statRating.maxRating = 5
        self.statRating.minRating = 0
        self.statRating.rating = 2.5
        //self.statRating.editable = true
        self.statRating.halfRatings = true
        //self.statRating.floatRatings = false
        
        self.statRating.frame = CGRect(x: 0, y: 0, width: 170, height: 30)
        self.view.addSubview(self.statRating)
        
        self.preferredContentSize = CGSize(width: self.statRating.frame.width, height: self.statRating.frame.height+10)
    }
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        self.star = self.statRating.rating
        print("메인  :  ",self.star)
    }
}
