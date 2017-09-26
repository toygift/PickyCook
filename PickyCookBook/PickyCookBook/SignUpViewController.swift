//
//  SignUpViewController.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 4..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import MobileCoreServices
import Toaster
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    
    // MARK: OUTLET & Properties
    //
    
    @IBOutlet var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let tfFrame = CGRect(x: 20, y: 0, width: cell.bounds.width - 20, height: 37)
        switch indexPath.row {
        case 0:
            self.emailTextField = UITextField(frame: tfFrame)
            self.emailTextField.placeholder = "이메일"
            self.emailTextField.borderStyle = .none
            self.emailTextField.autocapitalizationType = .none
            self.emailTextField.font = UIFont.systemFont(ofSize: 14)
            cell.addSubview(self.emailTextField)
        case 1:
            self.nicknameTextField = UITextField(frame: tfFrame)
            self.nicknameTextField.placeholder = "닉네임"
            self.nicknameTextField.borderStyle = .none
            self.nicknameTextField.autocapitalizationType = .none
            self.nicknameTextField.font = UIFont.systemFont(ofSize: 14)
            cell.addSubview(self.nicknameTextField)
        case 2:
            self.passwordTextField = UITextField(frame: tfFrame)
            self.passwordTextField.placeholder = "패스워드"
            self.passwordTextField.borderStyle = .none
            self.passwordTextField.autocapitalizationType = .none
            self.passwordTextField.font = UIFont.systemFont(ofSize: 14)
            cell.addSubview(self.passwordTextField)
        case 3:
            self.passwordConfirmTextField = UITextField(frame: tfFrame)
            self.passwordConfirmTextField.placeholder = "패스워드 확인"
            self.passwordConfirmTextField.borderStyle = .none
            self.passwordConfirmTextField.autocapitalizationType = .none
            self.passwordConfirmTextField.font = UIFont.systemFont(ofSize: 14)
            cell.addSubview(self.passwordConfirmTextField)
        case 4:
            self.contentTextField = UITextField(frame: tfFrame)
            self.contentTextField.placeholder = "자기소개"
            self.contentTextField.borderStyle = .none
            
            self.contentTextField.font = UIFont.systemFont(ofSize: 14)
            cell.addSubview(self.contentTextField)
        default:
            ()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordConfirmTextField: UITextField!
    @IBOutlet var contentTextField: UITextField!
    
    @IBOutlet var buttonConfirm: UIButton!
    @IBOutlet var pictureConfirm: UIImageView!
    
    
    let imagePicker: UIImagePickerController = UIImagePickerController()
    var flagImageSave = false
    var captureImage: UIImage!
    var videoURL: URL!
    
    @IBAction func pictureSelect(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "포토라이브러리", style: .default, handler: { (_) in
            self.media(.photoLibrary, flag: false, editing: true)
        }))
        alertController.addAction(UIAlertAction(title: "카메라", style: .default, handler: { (_) in
            self.media(.camera, flag: true, editing: false)
        }))
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
       
        guard let email = emailTextField.text else { return }
        guard let nickname = nicknameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let passwordConfirm = passwordConfirmTextField.text else { return }
        guard let content = contentTextField.text else { return }
        
        if captureImage == nil {
            captureImage = UIImage(named: "no_image.jpg")
        }
        
        signUp(email: email, nickname: nickname, password: password, passwordConfirm: passwordConfirm, content: content, img_profile: captureImage)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    @IBAction func signUpCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: Textfield Delegate
    // 화면터치시 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.isEqual(self.emailTextField)) {
            self.nicknameTextField.becomeFirstResponder()
        } else if (textField.isEqual(self.nicknameTextField)) {
            self.passwordTextField.becomeFirstResponder()
        } else if (textField.isEqual(self.passwordTextField)) {
            self.passwordConfirmTextField.becomeFirstResponder()
        } else if (textField.isEqual(self.passwordConfirmTextField)) {
            self.contentTextField.becomeFirstResponder()
        } else {
            //self.view.endEditing(true)
            self.signUpButton(buttonConfirm)
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        nicknameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        passwordConfirmTextField.resignFirstResponder()
        contentTextField.resignFirstResponder()
    }

    
    
    // MARK: Life Cycle
    // 라이프사이클 관리
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedProfile(_:)))
        self.pictureConfirm.addGestureRecognizer(gesture)
        
        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
        nicknameTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmTextField.delegate = self
        contentTextField.delegate = self
        //DataTelecom.shared.allRecipeList()
        

    }
    @objc func tappedProfile(_ sender: Any){
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "포토라이브러리", style: .default, handler: { (_) in
            self.media(.photoLibrary, flag: false, editing: true)
        }))
        alertController.addAction(UIAlertAction(title: "카메라", style: .default, handler: { (_) in
            self.media(.camera, flag: true, editing: false)
        }))
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SignUpViewController {
    // MARK: SignUp Func
    // Multipart
    // 포토라이브러리 및 카메라 이용
    // info.plist 수정 해야함.
    
    func signUp(email: String, nickname: String, password: String, passwordConfirm: String, content: String, img_profile: UIImage) {
        let url = rootDomain + "member/create/"
        let parameters: Parameters = ["email":email, "nickname":nickname, "password1":password, "password2":passwordConfirm, "content":content, "img_profile": img_profile]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                if key == "email" || key == "nickname" || key == "password1" || key == "password2" || key == "content" {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                } else if let imgData = UIImageJPEGRepresentation(img_profile, 0.25) {
                    multipartFormData.append(imgData, withName: "img_profile", fileName: "photo.jpg", mimeType: "image/jpg")
                }
            }
        }, to: url, method: .post) { (response) in
            switch response {
            case .success(let upload, _, _):
                print("업로드 성공", upload)
                upload.responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print("=================================================================")
                        print("==========================    SignUp    =========================")
                        print("=================================================================")
                        
                        if !json["email_empty"].stringValue.isEmpty {
                            Toast(text: "email을 입력해주세요").show()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        } else if !json["empty_password1"].stringValue.isEmpty {
                            Toast(text: "password를 입력해주세요").show()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        } else if !json["empty_password2"].stringValue.isEmpty {
                            Toast(text: "password가 다릅니다").show()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        } else if !json["email_invalid"].stringValue.isEmpty {
                            Toast(text: "유효한 email을 입력하세요").show()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        } else if !json["passwords_not_match"].stringValue.isEmpty {
                            Toast(text: "입력된 패스워드가 일치하지 않습니다").show()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        } else if !json["too_short_password"].stringValue.isEmpty {
                            Toast(text: "패드워드는 최소 4글자 이상이어야 합니다").show()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        } else if !json["email_error"].stringValue.isEmpty {
                            Toast(text: "사용중인 email입니다.").show()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        } else if !json["nickname_error"].stringValue.isEmpty {
                            Toast(text: "사용중인 nickname입니다.").show()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        } else {
                            let accessToken = json["token"].stringValue
                            let userpk = json["pk"].intValue
                            
//                            UserDefaults.standard.set(userToken, forKey: "token")
//                            print("UserDefaults Set Token   :   ", UserDefaults.standard.string(forKey: "token") ?? "데이터없음")
                            let tokenValue = TokenAuth()
                            tokenValue.save(serviceName, account: "accessToken", value: accessToken)
                            tokenValue.save(serviceName, account: "userpk", value: "\(userpk)")

//                            UserDefaults.standard.set(userpk, forKey: "userpk")
//                            print("UserDefaults Set UserPK  :   ", UserDefaults.standard.string(forKey: "userpk") ?? "데이터없음")
                            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarView") {
                                UIApplication.shared.keyWindow?.rootViewController = viewController
                                DataTelecom.shared.myPageUserData()
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                self.dismiss(animated: true, completion: nil)
                            }
//                            guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "TABBAR") as? MainTabBar else { return }
//                            self.present(nextViewController, animated: true, completion: {
//                                
//                                DataTelecom.shared.myPageUserData()
//                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                                
//                                
//                            })
                        }
                    case .failure(let error):
                        print(error)
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    
                })
            case .failure(let error):
                print(error)
                Toast(text: "네트워크에러").show()
            }
        }
    }
}
