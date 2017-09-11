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
    
    
    // MARK: OUTLER 및 Properties
    //
    //
    @IBOutlet var email: UILabel!
    
    @IBOutlet var img_profile: UIImageView!
    @IBOutlet var signOut: UIButton!
    @IBOutlet var withdrawal: UIButton!
    @IBOutlet var topView: UIView!
    
    @IBAction func mycreateRecipe(_ sender: UIButton){
        guard let nextViewController = storyboard?.instantiateViewController(withIdentifier: "HOME") as? HomeViewController else { return }
        nextViewController.select = true
//        nextViewController.selects = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func myInfoChange(_ sender: UIButton) {
        guard let nextViewController = storyboard?.instantiateViewController(withIdentifier: "INFOMODIFY") as? InfoModifyViewController else { return }
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    // MARK: 회원탈퇴
    // 탈퇴버튼 클릭시 Alert창 띄움
    // 싱글톤에 저장된 유저정보 지움
    @IBAction func withdrawal(_ sender: UIButton) {
        let alertController = UIAlertController(title: "경고", message: "탈퇴하시겠습니까?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { (_) in
            self.userWithDrawal()
            DataTelecom.shared.user = nil
            print(DataTelecom.shared.user ?? "데이터 없음!")
        }))
        self.present(alertController, animated: true, completion: {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        })
    }
    // MARK: 로그아웃
    // 로그아웃버튼 클릭시 Alert창 띄움
    // 싱글톤에 저장된 유저정보 지움
    @IBAction func signOut(_ sender: UIButton) {
        let alertController = UIAlertController(title: "알림", message: "로그아웃 하시겠습니까?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { (_) in
            self.userSignOut()
            DataTelecom.shared.user = nil
            print(DataTelecom.shared.user ?? "데이터 없음!")
        }))
        self.present(alertController, animated: true, completion: {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        })
    }
    
    // MARK: Life Cycle
    //
    // 뷰가 나타나기전에 싱글톤 데이터 가져와서 표시
    override func viewDidLoad() {
        super.viewDidLoad()
        print("================================================================")
        print("===========================viewDidLoad==========================")
        print("================================================================")
        //여기서 사진등등 띄우니 수정후에 안뜨는 문제발생
        //그래서 viewWillAppear에서 띄움
        self.img_profile.layer.cornerRadius = self.img_profile.frame.width / 2
        self.img_profile.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("================================================================")
        print("=========================viewWillAppear=========================")
        print("================================================================")
        
        
        
        self.email.text = DataTelecom.shared.user?.email
        //        let back = UIImage(named: "no_image.jpg")
        //        self.img_profile.setImage(back?.withRenderingMode(.alwaysOriginal), for: .normal)
        DispatchQueue.main.async {
            if let path = DataTelecom.shared.user?.img_profile {
                if let imageData = try? Data(contentsOf: URL(string: path)!) {
                    self.img_profile.image = UIImage(data: imageData)
                }
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
}
