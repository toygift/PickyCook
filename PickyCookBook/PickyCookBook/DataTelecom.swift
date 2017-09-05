//
//  DataTelecom.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 4..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Toaster

let rootDomain: String = "http://pickycookbook.co.kr/api/"



class DataTelecom {
    
    static let shared: DataTelecom = DataTelecom()
    
    var user: User?
    
    // MARK: 데이터 가져오기
    // 서버에서 데이터 가져와서 저장함
    // SignIn시에 user에 데이터 저장함
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
                self.user = User(user: json)
                print("유저프린트   :   ",self.user ?? "데이터없음")
                
                case .failure(let error):
                print(error)
                
            }
        }
    }

    func signIn(email: String, password: String) {
        
        let parameters: Parameters = ["email": email, "password": password]
        
        let call = Alamofire.request(rootDomain + "member/login/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("response   :   ",json)
                
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
                    self.myPageUserData()
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController: UIViewController = HomeViewController()
                    guard let nextViewController = storyboard.instantiateViewController(withIdentifier: "HOME") as? HomeViewController else { return }
                    viewController.present(nextViewController, animated: true, completion: nil)
                    

                }
                                
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: SignIn Func
    // http 통신할경우 info.plist 수정 해야함
//    func signIn(email: String, password: String) {
//        
//        let parameters: Parameters = ["email": email, "password": password]
//        
//        let call = Alamofire.request(rootDomain + "member/login/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
//        
//        call.responseJSON { (response) in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                print("response   :   ",json)
//                if !json["empty_email"].stringValue.isEmpty {
//                    Toast(text: "email을 입력하세요.").show()
//                } else if !json["empty_password"].stringValue.isEmpty {
//                    Toast(text: "password를 입력하세요.").show()
//                } else if !json["empty_error"].stringValue.isEmpty {
//                    Toast(text: "email과 password를 입력하세요.").show()
//                } else if !json["login_error"].stringValue.isEmpty {
//                    Toast(text: "email 또는 password가 맞지 않습니다.").show()
//                }
//                
//                let userToken = json["token"].stringValue
//                let userPK = json["pk"].intValue
//                
//                UserDefaults.standard.set(userToken, forKey: "token")
//                print("UserDefaults Set Token   :   ", UserDefaults.standard.string(forKey: "token") ?? "데이터없음")
//                UserDefaults.standard.set(userPK, forKey: "userpk")
//                print("UserDefaults Set UserPK  :   ", UserDefaults.standard.string(forKey: "userpk") ?? "데이터없음")
//                
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
//    // MARK: SignUp Func
//    // Multipart
//    // 포토라이브러리 및 카메라 이용
//    // info.plist 수정 해야함.
//    
//    func signUp(email: String, nickname: String, password: String, passwordConfirm: String, content: String, img_profile: UIImage) {
//        let url = rootDomain + "member/create/"
//        let parameters: Parameters = ["email":email, "nickname":nickname, "password1":password, "password2":passwordConfirm, "content":content, "img_profile": img_profile]
//        
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            for (key, value) in parameters {
//                if key == "email" || key == "nickname" || key == "password1" || key == "password2" || key == "content" {
//                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
//                } else if let imgData = UIImageJPEGRepresentation(img_profile, 0.25) {
//                    multipartFormData.append(imgData, withName: "img_profile", fileName: "photo.jpg", mimeType: "image/jpg")
//                }
//            }
//        }, to: url, method: .post) { (response) in
//            switch response {
//            case .success(let upload, _, _):
//                print("업로드 성공", upload)
//                upload.responseJSON(completionHandler: { (response) in
//                    switch response.result {
//                    case .success(let value):
//                        let json = JSON(value)
//                        print(json)
//                        
//                        if !json["email_empty"].stringValue.isEmpty {
//                            Toast(text: "email을 입력해주세요").show()
//                        } else if !json["empty_password1"].stringValue.isEmpty {
//                            Toast(text: "password를 입력해주세요").show()
//                        } else if !json["empty_password2"].stringValue.isEmpty {
//                            Toast(text: "password가 다릅니다").show()
//                        } else if !json["email_invalid"].stringValue.isEmpty {
//                            Toast(text: "유효한 email을 입력하세요").show()
//                        } else if !json["passwords_not_match"].stringValue.isEmpty {
//                            Toast(text: "입력된 패스워드가 일치하지 않습니다").show()
//                        } else if !json["too_short_password"].stringValue.isEmpty {
//                            Toast(text: "패드워드는 최소 4글자 이상이어야 합니다").show()
//                        } else if !json["email_error"].stringValue.isEmpty {
//                            Toast(text: "사용중인 email입니다.").show()
//                        } else if !json["nickname_error"].stringValue.isEmpty {
//                            Toast(text: "사용중인 nickname입니다.").show()
//                        } else {
//                            let userToken = json["token"].stringValue
//                            let userPK = json["pk"].intValue
//                            
//                            UserDefaults.standard.set(userToken, forKey: "token")
//                            print("UserDefaults Set Token   :   ", UserDefaults.standard.string(forKey: "token") ?? "데이터없음")
//                            UserDefaults.standard.set(userPK, forKey: "userpk")
//                            print("UserDefaults Set UserPK  :   ", UserDefaults.standard.string(forKey: "userpk") ?? "데이터없음")
//                            
//                        }
//                    case .failure(let error):
//                        print(error)
//                    }
//                    
//                })
//            case .failure(let error):
//                print(error)
//                Toast(text: "네트워크에러").show()
//            }
//        }
//    }
    
    
//    // MARK: User Detail
//    // 마이페이지 회원정보
//    var email: String?
//    var nickname: String?
//    var content: String?
//    var img_profile: UIImage?
//    
//    func myPageUserData(){
//        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
//        let userPK = UserDefaults.standard.object(forKey: "userpk") as! Int
//        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
//        
//        let call = Alamofire.request(rootDomain + "member/detail/\(userPK)/", method: .get, headers: headers)
//        
//        call.responseJSON { (response) in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                print(json)
//                
//                self.email = json["email"].stringValue
//                self.nickname = json["nickname"].stringValue
//                self.content = json["content"].stringValue
//                ////////////////////////////////////////////////////////
//                if let path = json["img_profile"].string {
//                    if let imageData = try? Data(contentsOf: URL(string: path)!) {
////                        self.profile_image.image = UIImage(data: imageData)
//                        self.img_profile = UIImage(data: imageData)
//                        
//                    }
//                }
//                
////                ////////////////////////////////////////////////////////
////                
////                let password = json["password"].stringValue
////                UserDefaults.standard.set(password, forKey: "password")
//            case .failure(let error):
//                print(error)
//                break
//            }
//        }
//    }
}
