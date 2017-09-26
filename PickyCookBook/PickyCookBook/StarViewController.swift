//
//  ViewController.swift
//  test
//
//  Created by jaeseong on 2017. 9. 14..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit

class StarViewController: UIViewController, FloatRatingViewDelegate {

    let starRating = FloatRatingView()
    var star: Float = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.starRating.emptyImage = UIImage(named: "star2")
        self.starRating.fullImage = UIImage(named: "star")
        self.starRating.delegate = self
        self.starRating.contentMode = UIViewContentMode.scaleAspectFit
        self.starRating.maxRating = 5
        self.starRating.minRating = 0
        self.starRating.rating = 2.5
        //self.statRating.editable = true
        self.starRating.halfRatings = true
        //self.statRating.floatRatings = false
        
        self.starRating.frame = CGRect(x: 0, y: 0, width: 170, height: 30)
        self.view.addSubview(self.starRating)
        
        self.preferredContentSize = CGSize(width: self.starRating.frame.width, height: self.starRating.frame.height+10)
    }
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        self.star = self.starRating.rating
        print("메인  :  ",self.star)
    }
}


