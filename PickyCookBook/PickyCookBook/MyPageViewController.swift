//
//  MyPageViewController.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 4..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol IssueDelegate : class {
    func dispatchQueue()
}

class MyPageViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var email: UILabel!
    @IBOutlet var nickname: UILabel!
    @IBOutlet var content: UILabel!
    
    @IBOutlet var modifyNickname: UITextField!
    @IBOutlet var modifyContent: UITextField!
    @IBOutlet var currentPassword: UITextField!
    @IBOutlet var newPassword: UITextField!
    @IBOutlet var newConfirmPassword: UITextField!
    
    @IBOutlet var img_profile: UIButton!
    @IBOutlet var cancel: UIButton!
    @IBOutlet var modifyComplete: UIButton!
    @IBOutlet var logout: UIButton!
    @IBOutlet var withdrawal: UIButton!
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: Life Cycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modifyNickname.delegate = self
        modifyContent.delegate = self
        currentPassword.delegate = self
        newPassword.delegate = self
        newConfirmPassword.delegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.myPageUserData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MyPageViewController {
    func myPageUserData(){
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let userPK = UserDefaults.standard.object(forKey: "userpk") as! Int
        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        
        let call = Alamofire.request(rootDomain + "member/detail/\(userPK)/", method: .get, headers: headers)
        
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                self.email.text = json["email"].stringValue
                self.nickname.text = json["nickname"].stringValue
                self.content.text = json["content"].stringValue
                if let path = json["img_profile"].string {
                    if let imageData = try? Data(contentsOf: URL(string: path)!) {
                        self.img_profile.setImage(UIImage(data: imageData), for: .normal)
                    }
                }
            case .failure(let error):
                print(error)
                break
            }
        }
    }

}
