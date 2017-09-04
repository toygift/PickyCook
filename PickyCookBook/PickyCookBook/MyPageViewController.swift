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
import Toaster



class MyPageViewController: UIViewController {
    
    var signup: SignUpViewController = SignUpViewController()
    
    @IBOutlet var email: UILabel!
    
    @IBOutlet var img_profile: UIButton!
    @IBOutlet var signOut: UIButton!
    @IBOutlet var withdrawal: UIButton!
    @IBOutlet var topView: UIView!
    
    @IBAction func myInfoChange(_ sender: UIButton) {
        guard let nextViewController = storyboard?.instantiateViewController(withIdentifier: "INFOMODIFY") as? InfoModifyViewController else { return }
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    @IBAction func withdrawal(_ sender: UIButton) {
        let alertController = UIAlertController(title: "경고", message: "탈퇴하시겠습니까?", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "확인", style: .destructive) { (_) in
            self.userWithDrawal()
            DataTelecom.shared.user = nil
            print(DataTelecom.shared.user ?? "데이터 없음!")
        }
        alertController.addAction(cancel)
        alertController.addAction(ok)
        
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func signOut(_ sender: UIButton) {
        let alertController = UIAlertController(title: "알림", message: "로그아웃 하시겠습니까?", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "확인", style: .destructive) { (_) in
            self.userSignOut()
            DataTelecom.shared.user = nil
            print(DataTelecom.shared.user ?? "데이터 없음!")
        }
        alertController.addAction(cancel)
        alertController.addAction(ok)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Life Cycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.img_profile.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.img_profile.layer.cornerRadius = self.img_profile.frame.width/2
        self.email.text = DataTelecom.shared.user?.email.stringValue
        
        if let path = DataTelecom.shared.user?.img_profile.string {
            if let imageData = try? Data(contentsOf: URL(string: path)!) {
                let back = UIImage(data: imageData)
                self.img_profile.setBackgroundImage(back, for: .normal)
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MyPageViewController {
 
    
    func userWithDrawal(){
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let userPK = UserDefaults.standard.object(forKey: "userpk") as! Int
        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        
        let call = Alamofire.request(rootDomain + "member/update/\(userPK)/", method: .delete, headers: headers)
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                if !json["result"].stringValue.isEmpty {
                    Toast(text: "탈퇴되었습니다").show()
                    guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "SIGNIN") as? SignInViewController else { return }
                    self.present(nextViewController, animated: true, completion: nil)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func userSignOut(){
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        
        let call = Alamofire.request(rootDomain + "member/logout/", method: .post, headers: headers)
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                if !json["result"].stringValue.isEmpty {
                    Toast(text: "로그아웃되었습니다").show()
                    guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "SIGNIN") as? SignInViewController else { return }
                    self.present(nextViewController, animated: true, completion: nil)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
