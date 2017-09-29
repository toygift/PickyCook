//
//  TimerViewController.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 26..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    
    
    var seconds: Int = 0
    var timer = Timer()
    
    var isTimerRunning = false
    var resumeTapped = false
    
    
    
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var pauseButton: UIButton!
    @IBAction func backToTheHome(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startButtonAction(_ sender: UIButton) {
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
            timerLabel.text = timeString(time: TimeInterval(seconds))
        }
        
    }
    @IBAction func pauseButtonAction(_ sender: UIButton) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
