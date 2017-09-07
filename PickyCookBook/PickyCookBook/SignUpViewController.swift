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

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {

    
    // MARK: OUTLET & Properties
    //
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordConfirmTextField: UITextField!
    @IBOutlet var contentTextField: UITextField!
    
    @IBOutlet var buttonConfirm: UIButton!
    @IBOutlet var pictureConfirm: UIButton!
    
    
    let imagePicker: UIImagePickerController = UIImagePickerController()
    var flagImageSave = false
    var captureImage: UIImage!
    var videoURL: URL!
    
    @IBAction func pictureSelect(_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photo = UIAlertAction(title: "포토라이브러리", style: .default) { (_) in
            self.media(.photoLibrary, flag: false, editing: true)
            //self.media(.photoLibrary, flag: false, editing: true)
        }
        let carema = UIAlertAction(title: "카메라", style: .default) { (_) in
            self.media(.camera, flag: true, editing: false)
            //self.media(.camera, flag: true, editing: false)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(photo)
        alert.addAction(carema)
        
        self.present(alert, animated: true, completion: nil)
        self.pictureConfirm.setBackgroundImage(captureImage, for: .normal)
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
        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
        nicknameTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmTextField.delegate = self
        contentTextField.delegate = self
        DataTelecom.shared.allRecipeList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//extension SignUpViewController {
//    func media(_ type: UIImagePickerControllerSourceType, flag: Bool, editing: Bool){
//        if (UIImagePickerController.isSourceTypeAvailable(type)) {
//            flagImageSave = flag
//            imagePicker.delegate = self
//            imagePicker.sourceType = type
//            imagePicker.mediaTypes = [kUTTypeImage as String]
//            imagePicker.allowsEditing = editing
//            
//            present(imagePicker, animated: true, completion: nil)
//        } else {
//            if type == .photoLibrary{
//                Toast(text: "포토라이브러리에 접근할수 없음").show()
//            } else {
//                Toast(text: "카메라에 접근할수 없음").show()
//            }
//        }
//    }
//    
//    // MARK: 사진, 비디오, 포토라이브러리 선택 끝났을때
//    //
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        
//        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
//        
//        if mediaType.isEqual(to: kUTTypeImage as NSString as String){
//            captureImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//            if flagImageSave {
//                UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
//            }
//            //capture image(이미지 저장된것 처리)
//        }
//            // 비디오 처리(사용하진 않음)
//        else if mediaType.isEqual(to: kUTTypeMovie as NSString as String) {
//            if flagImageSave {
//                videoURL = (info[UIImagePickerControllerMediaURL] as! URL)
//                
//                UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath, self, nil, nil)
//            }
//        }
//        //self.pictureConfirm.setBackgroundImage(captureImage, for: .normal)
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    // MARK: 사진, 비디오 취소시
//    //
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.dismiss(animated: true, completion: nil)
//    }
//}

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
                        } else if !json["empty_password1"].stringValue.isEmpty {
                            Toast(text: "password를 입력해주세요").show()
                        } else if !json["empty_password2"].stringValue.isEmpty {
                            Toast(text: "password가 다릅니다").show()
                        } else if !json["email_invalid"].stringValue.isEmpty {
                            Toast(text: "유효한 email을 입력하세요").show()
                        } else if !json["passwords_not_match"].stringValue.isEmpty {
                            Toast(text: "입력된 패스워드가 일치하지 않습니다").show()
                        } else if !json["too_short_password"].stringValue.isEmpty {
                            Toast(text: "패드워드는 최소 4글자 이상이어야 합니다").show()
                        } else if !json["email_error"].stringValue.isEmpty {
                            Toast(text: "사용중인 email입니다.").show()
                        } else if !json["nickname_error"].stringValue.isEmpty {
                            Toast(text: "사용중인 nickname입니다.").show()
                        } else {
                            let userToken = json["token"].stringValue
                            let userPK = json["pk"].intValue
                            
                            UserDefaults.standard.set(userToken, forKey: "token")
                            print("UserDefaults Set Token   :   ", UserDefaults.standard.string(forKey: "token") ?? "데이터없음")
                            UserDefaults.standard.set(userPK, forKey: "userpk")
                            print("UserDefaults Set UserPK  :   ", UserDefaults.standard.string(forKey: "userpk") ?? "데이터없음")
                            guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "TABBAR") as? MainTabBar else { return }
                            self.present(nextViewController, animated: true, completion: { 
                                    DataTelecom.shared.myPageUserData()
                                
                                
                            })
                        }
                    case .failure(let error):
                        print(error)
                    }
                    
                })
            case .failure(let error):
                print(error)
                Toast(text: "네트워크에러").show()
            }
        }
    }
}
