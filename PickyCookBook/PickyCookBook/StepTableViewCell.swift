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


protocol StepTableViewCellDelegate {
    func timerSetModal(timer: Int)
}

class StepTableViewCell: UITableViewCell {
    
    var stepTableViewCellDelegate: StepTableViewCellDelegate?
    var stepRecipe: PickyCookBook.Recipe_Step? { didSet { updateUI()}}
    
    @IBOutlet var timerGoButton: UIButton!
    @IBOutlet var stepLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var img_step: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if stepRecipe?.is_timer == false {
            timerGoButton.isHidden = true
        }
    }
    var seconds: Int = 0
    var timer = Timer()
    
    var isTimerRunning = false
    var resumeTapped = false
    
    func autoauto() {
        // 레시피 이미지 받아오기
        // 우선 오토레이아웃부터 설정해야함
        // 2017.9.27
        
        let width = (img_step.image?.size.width)! / img_step.frame.size.width
        let height = (img_step.image?.size.height)! / img_step.frame.size.height
        let ratio = width / height
        
        
    }

    
    @IBAction func timerGo(_ sender: UIButton) {
        self.stepTableViewCellDelegate?.timerSetModal(timer: (stepRecipe?.timer)!)
     
    }
    
    @IBAction func startTimer(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer()
        }
    }
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(StepTableViewCell.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
        } else {
            seconds -= 1
//            timerLabel.text = timeString(time: TimeInterval(seconds))
        }
        
    }
    @IBAction func pauseTimer(_ sender: UIButton) {
        if self.resumeTapped == false {
            timer.invalidate()
            isTimerRunning = false
            self.resumeTapped = true
        } else {
            runTimer()
            self.resumeTapped = false
            isTimerRunning = true
        }
    }
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    private func updateUI() {
        let stepNumber = stepRecipe?.step
//        let stepTimer = stepRecipe?.timer
        
        stepLabel.text = "스텝번호 " + "\(stepNumber ?? 1)"
        descriptionLabel.text = stepRecipe?.description
        self.seconds = (stepRecipe?.timer)!
//        timerLabel.text = "소요시간 " + "\(stepTimer ?? 1)"
        
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

