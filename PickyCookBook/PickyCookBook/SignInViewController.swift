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
import LocalAuthentication


// MARK: 로그인관련 프로토콜
//
//
@objc
protocol SignInViewControllerDelegate: class {
    func signInDidDismiss(signIn: SignInViewController)
    func signInCompleteDismiss(signIn: SignInViewController)
}

class SignInViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, FBSDKLoginButtonDelegate {

    weak var signIndelegate: SignInViewControllerDelegate?
    
    let touchID = TouchID()
    
    
    // MARK: OUTLET 및 Properties
    // 
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var buttonSignIn: UIButton!
    @IBOutlet var cancel: UIButton!
    // MARK : SignIn
    //
    //
    @IBAction func signInButton(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        self.signIn(email: email, password: password)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    @IBAction func cancel(_ sender: UIButton) {
        self.signIndelegate?.signInDidDismiss(signIn: self)
        
        print("캔슬버튼 클릭")

    }
    
    // MARK : TouchID
    //
    //
    @IBAction func touchIdSignIn(_ sender: UIButton) {
        touchID.authUser() { ms7 in
            if let messages = ms7 {
//                let alert = UIAlertController(title: "에러", message: messages, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
//                self.present(alert, animated: true, completion: nil)  -> 왜  여기서 크래쉬가 나는거지..????
                Toast(text: messages).show()
            } else {
                let tokenValue = TokenAuth()
                let a = tokenValue.load(serviceName, account: "id")
                let b = tokenValue.load(serviceName, account: "password")
                if a != nil && b != nil {
                    guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "TABBAR") as? MainTabBar else { return }
                    self.present(nextViewController, animated: true, completion: {
                        DataTelecom.shared.myPageUserData()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    })
                    
                } else {
//                    let alert = UIAlertController(title: "에러", message: "메롱", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
                    Toast(text: "최초 가입 및 로그아웃시 다시 한번 ID/PW로 로그인해야합니다", delay: 0.0, duration: Delay.long).show()
                    
                }
            }
        }
    }
    
    // MARK: Facebook signin
    //
    //
    @IBAction func signInFacebook(_ sender: UIButton){
        
        sender.addTarget(self, action: #selector(handleCostomFBlogin), for: .touchUpInside)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
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
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                } else if !json["empty_password"].stringValue.isEmpty {
                    Toast(text: "password를 입력하세요.").show()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                } else if !json["empty_error"].stringValue.isEmpty {
                    Toast(text: "email과 password를 입력하세요.").show()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                } else if !json["login_error"].stringValue.isEmpty {
                    Toast(text: "email 또는 password가 맞지 않습니다.").show()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                } else {
                    
                    let accessToken = json["token"].stringValue
                    print(accessToken)
                    let userpk = json["pk"].stringValue
                    
                    
                    let tokenValue = TokenAuth()
                    tokenValue.save(serviceName, account: "accessToken", value: accessToken)
                    tokenValue.save(serviceName, account: "userpk", value: "\(userpk)")
                    
                    guard let email = self.emailTextField.text else { return }
                    guard let password = self.passwordTextField.text else { return }
                    /********************************************************************************************/
                    //        이거.페북 로그인에도 구현해야 되는데..페북로그인..다 하고 나서........
                    /********************************************************************************************/
                    tokenValue.save(serviceName, account: "id", value: email)
                    tokenValue.save(serviceName, account: "password", value: password)
                    
                    /********************************************************************************************/
                    // SignInViewControllerDelegate
                    //
                    //
                    self.signIndelegate?.signInCompleteDismiss(signIn: self)

                    
                    
                }
                
            case .failure(let error):
                print(error)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    // MARK: Facebook AlamoFire
    //
    //
    func faceBookSignin(token: String){
        //페이스북 토큰도 키체인에 저장해야 하나..?
        //
        let parameters: Parameters = ["token":token]
        let call = Alamofire.request(rootDomain + "/member/facebook-login/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
        call.responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                print("=================================================================")
                print("======================    FacebookSignIn    =====================")
                print("=================================================================")
                
//                UserDefaults.standard.set(userToken, forKey: "token")
//                print("UserDefaults Set Token   :   ", UserDefaults.standard.string(forKey: "token") ?? "데이터없음")
                let accessToken = json["token"].stringValue
                let userpk = json["pk"].intValue
                
                let tokenValue = TokenAuth()
                tokenValue.save(serviceName, account: "accessToken", value: accessToken)
                tokenValue.save(serviceName, account: "userpk", value: "\(userpk)")
                
                
//                UserDefaults.standard.set(userpk, forKey: "userpk")
//                print("UserDefaults Set UserPK  :   ", UserDefaults.standard.string(forKey: "userpk") ?? "데이터없음")
//                // UserDefaults 에 토큰 저장
                
                
                guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "TABBAR") as? MainTabBar else { return }
                self.present(nextViewController, animated: true, completion: {
                  UIApplication.shared.isNetworkActivityIndicatorVisible = false
                })
                    
                
            case .failure(let error):
                Toast(text: "네트워크에러").show()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                print(error)
            }
        }
    }
}

extension SignInViewController {
    
   
}
