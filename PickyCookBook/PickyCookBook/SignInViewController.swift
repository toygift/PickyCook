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
import FBSDKLoginKit
import FBSDKCoreKit

class SignInViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, FBSDKLoginButtonDelegate {

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
    
    // MARK: Facebook signin
    @IBAction func signInFacebook(_ sender: UIButton){
      sender.addTarget(self, action: #selector(handleCostomFBlogin), for: .touchUpInside)
    }
    func handleCostomFBlogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            if err != nil {
                print(11)
                return
            }
            
            let accessToken = FBSDKAccessToken.current()
            
            guard let accessTokenString = accessToken?.tokenString else { return }
            print("페이스북토큰:   ",accessTokenString)
            self.faceBookSignin(token: accessTokenString)
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("did log out facebook")
    }
    
    // MARK: Facebook login get Token
    //
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error)
            return
        }
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email"]).start { (connection, result, err) in
            if err != nil {
                return 
            }
            print(result ?? "dd")
        }
        
    }

        @IBAction func signUpButton(_ sender: UIButton) {
        guard let nextViewController = storyboard?.instantiateViewController(withIdentifier: "SIGNUP") as? SignUpViewController else { return }
        self.present(nextViewController, animated: true, completion: nil)
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
        //DataTelecom.shared.allRecipeList()
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
    // MARK: Facebook AlamoFire
    //
    //
    func faceBookSignin(token: String){
        let url = "http://pickycookbook.co.kr/api/member/facebook-login/"
        let parameters: Parameters = ["token":token]
        let call = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
        call.responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                print("=================================================================")
                print("======================    FacebookSignIn    =====================")
                print("=================================================================")
                let userToken = json["token"].stringValue
                let userPK = json["pk"].intValue
                UserDefaults.standard.set(userToken, forKey: "token")
                print("UserDefaults Set Token   :   ", UserDefaults.standard.string(forKey: "token") ?? "데이터없음")
                
                UserDefaults.standard.set(userPK, forKey: "userpk")
                print("UserDefaults Set UserPK  :   ", UserDefaults.standard.string(forKey: "userpk") ?? "데이터없음")
                // UserDefaults 에 토큰 저장
                
                
                guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "TABBAR") as? MainTabBar else { return }
                self.present(nextViewController, animated: true, completion: nil)
                
            case .failure(let error):
                Toast(text: "네트워크에러").show()
                print(error)
            }
        }
    }


}
