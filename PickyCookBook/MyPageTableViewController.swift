//
//  MyPageTableViewController.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 25..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Toaster

class MyPageTableViewController: UITableViewController {
    let tokenValue = TokenAuth()
    
    @IBOutlet var img_profile: UIImageView!
    @IBOutlet var email: UILabel!
    
    
    @IBAction func mycreateRecipe(_ sender: UIButton) {
        print("1")
        guard let nextViewController = storyboard?.instantiateViewController(withIdentifier: "HOME") as? HomeViewController else { return }
        nextViewController.select = true
        //        nextViewController.selects = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    @IBAction func myInfoChange(_ sender: UIButton) {
        print("2")
        guard let nextViewController = storyboard?.instantiateViewController(withIdentifier: "INFO") as? InfoModifiedTableViewController else { return }
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        print("3")
        let alertController = UIAlertController(title: "알림", message: "로그아웃 하시겠습니까?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { (_) in
            self.userSignOut()
            DataTelecom.shared.user = nil
            self.img_profile.image = nil
            self.email.text = nil
            self.tabBarController?.selectedIndex = 0
            print(DataTelecom.shared.user ?? "데이터 없음!")
        }))
        self.present(alertController, animated: true, completion: {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        })
    }
    
   
    @IBAction func withDrawal(_ sender: UIButton) {
        print("4")
        let alertController = UIAlertController(title: "경고", message: "탈퇴하시겠습니까?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { (_) in
            self.userWithDrawal()
            DataTelecom.shared.user = nil
            self.tabBarController?.selectedIndex = 0
            
            print(DataTelecom.shared.user ?? "데이터 없음!")
        }))
        self.present(alertController, animated: true, completion: {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        })
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad()")
        
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.title = "계정"
        } else {
            navigationItem.title = "계정"
        }
        print("================================================================")
        print("===========================viewDidLoad==========================")
        print("================================================================")
     
        self.email.text = DataTelecom.shared.user?.email
        //        let back = UIImage(named: "no_image.jpg")
        //        self.img_profile.setImage(back?.withRenderingMode(.alwaysOriginal), for: .normal)
        DispatchQueue.global().async {
            guard let path = DataTelecom.shared.user?.img_profile else { return }
            if let imageURL = URL(string: path) {
                let task = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
                    guard let putImage = data else { return }
                    DispatchQueue.main.async {
                        self.img_profile.image = UIImage(data: putImage)
                    }
                })
                task.resume()
            }
        }
        
       
    }

    override func viewDidAppear(_ animated: Bool) {
        self.email.text = DataTelecom.shared.user?.email
        //        let back = UIImage(named: "no_image.jpg")
        //        self.img_profile.setImage(back?.withRenderingMode(.alwaysOriginal), for: .normal)
        DispatchQueue.global().async {
            guard let path = DataTelecom.shared.user?.img_profile else { return }
            if let imageURL = URL(string: path) {
                let task = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
                    guard let putImage = data else { return }
                    DispatchQueue.main.async {
                        self.img_profile.image = UIImage(data: putImage)
                    }
                })
                task.resume()
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        default:
            return 1
        }
        
        
    }
}
extension MyPageTableViewController {
    
    
    func userWithDrawal(){
        //        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        //        let userpk = UserDefaults.standard.object(forKey: "userpk") as! Int
        //        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        
        
        let tokenValue = TokenAuth()
        guard let headers: HTTPHeaders = tokenValue.getAuthHeaders() else { return }
        guard let userpk = Int(tokenValue.load(serviceName, account: "userpk")!) else { return }
        //"member/update/\(userpk)/"
        let call = Alamofire.request(rootDomain + "member/update/\(userpk)/", method: .delete, headers: headers)
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                if !json["result"].stringValue.isEmpty {
                    Toast(text: "탈퇴되었습니다").show()
                    guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "SIGNIN") as? SignInViewController else { return }
                    self.present(nextViewController, animated: true, completion: nil)
                }
                tokenValue.delete(serviceName, account: "accessToken")
                tokenValue.delete(serviceName, account: "userpk")
                tokenValue.delete(serviceName, account: "id")
                tokenValue.delete(serviceName, account: "password")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            case .failure(let error):
                print(error)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    func userSignOut(){
        //        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        //        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        
        let tokenValue = TokenAuth()
        guard let headers = tokenValue.getAuthHeaders() else { return }
        print("rkrkrjkrjkrjkrjrkjrk :  ", headers)
        let call = Alamofire.request(rootDomain + "member/logout/", method: .post, headers: headers)
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                if !json["result"].stringValue.isEmpty {
                    Toast(text: "로그아웃되었습니다").show()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                tokenValue.delete(serviceName, account: "accessToken")
                tokenValue.delete(serviceName, account: "userpk")
                tokenValue.delete(serviceName, account: "id")
                tokenValue.delete(serviceName, account: "password")
                print(tokenValue.load(serviceName, account: "accessToken") ?? "ㅜno data")
            case .failure(let error):
                print(error)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
}

