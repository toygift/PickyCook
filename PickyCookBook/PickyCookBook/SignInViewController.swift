//
//  SignInViewController.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 4..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster

class SignInViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    // MARK: OUTLET 및 Properties
    // 
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var buttonSignIn: UIButton!
    
    @IBAction func signInButton(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        self.signIn(email: email, password: password)
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        guard let nextViewController = storyboard?.instantiateViewController(withIdentifier: "SIGNUP") as? SignUpViewController else { return }
        self.show(nextViewController, sender: self)
        //(nextViewController, animated: true, completion: nil)
        
    }

    // MARK: Textfield Delegate
    // 화면터치시 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.isEqual(self.emailTextField)) {
            self.passwordTextField.becomeFirstResponder()
        } else if (textField.isEqual(self.passwordTextField)) {
            //self.view.endEditing(true)
            self.signInButton(buttonSignIn)
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    // MARK: Life Cycle
    // 라이프사이클 관리
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.becomeFirstResponder()
        DataTelecom.shared.allRecipeList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SignInViewController {
    // MARK: SignIn Func
    // http 통신할경우 info.plist 수정 해야함
    func signIn(email: String, password: String) {
        let parameters: Parameters = ["email": email, "password": password]
        let call = Alamofire.request(rootDomain + "member/login/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("=================================================================")
                print("==========================    SignIn    =========================")
                print("=================================================================")
                
                if !json["empty_email"].stringValue.isEmpty {
                    Toast(text: "email을 입력하세요.").show()
                    break
                } else if !json["empty_password"].stringValue.isEmpty {
                    Toast(text: "password를 입력하세요.").show()
                    break
                } else if !json["empty_error"].stringValue.isEmpty {
                    Toast(text: "email과 password를 입력하세요.").show()
                    break
                } else if !json["login_error"].stringValue.isEmpty {
                    Toast(text: "email 또는 password가 맞지 않습니다.").show()
                    break
                } else {
                    
                    let userToken = json["token"].stringValue
                    let userPK = json["pk"].intValue
                    
                    UserDefaults.standard.set(userToken, forKey: "token")
                    print("UserDefaults Set Token   :   ", UserDefaults.standard.string(forKey: "token") ?? "데이터없음")
                    UserDefaults.standard.set(userPK, forKey: "userpk")
                    print("UserDefaults Set UserPK  :   ", UserDefaults.standard.string(forKey: "userpk") ?? "데이터없음")

                    DataTelecom.shared.myPageUserData()
                    
                    guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "TABBAR") as? MainTabBar else { return }
                    self.present(nextViewController, animated: true, completion: nil)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }

}
