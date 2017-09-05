//
//  InfoModifyViewController.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 5..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster
import MobileCoreServices

class InfoModifyViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet var img_profile: UIButton!
    @IBOutlet var completeModify: UIButton!
    @IBOutlet var email: UILabel!
    @IBOutlet var nickname: UILabel!
    @IBOutlet var modifyNickname: UITextField!
    @IBOutlet var modifyContent: UITextField!
    @IBOutlet var oldPassword: UITextField!
    @IBOutlet var newModifyPassword: UITextField!
    @IBOutlet var newModifyPasswordConfirm: UITextField!
    
    let imagePicker: UIImagePickerController = UIImagePickerController()
    var flagImageSave = false
    var captureImage: UIImage!
    var videoURL: URL!
    
    
    @IBAction func selectPicture(_ sender: UIButton){
        let alert = UIAlertController(title: "선택", message: "선택해주세요", preferredStyle: .actionSheet)
        let photo = UIAlertAction(title: "포토라이브러리", style: .default) { (_) in
            self.media(.photoLibrary, flag: false, editing: true)
            //            DataTelecom.shared.myPageUserData()
            //self.media(.photoLibrary, flag: false, editing: true)
        }
        let carema = UIAlertAction(title: "카메라", style: .default) { (_) in
            self.media(.camera, flag: true, editing: false)
            //            DataTelecom.shared.myPageUserData()
            //self.media(.camera, flag: true, editing: false)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(photo)
        alert.addAction(carema)
        
        self.present(alert, animated: true, completion: nil)
//        self.fetchUserPhoto(img_profile: captureImage)
//        DataTelecom.shared.myPageUserData()
        
    }
    @IBAction func modifyComplete(_ sender: UIButton){
        guard let nickname = modifyNickname.text else { return }
        guard let password = oldPassword.text else { return }
        guard let password1 = newModifyPassword.text else { return }
        guard let password2 = newModifyPasswordConfirm.text else { return }
        guard let content = modifyContent.text else { return }
        self.fetchUserData(nickname: nickname, password: password, password1: password1, password2: password2, content: content)
    }
    // MARK: 정보수정(사진제외)
    //
    //
    func fetchUserData(nickname: String, password: String, password1: String, password2: String, content: String) {
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let userPK = UserDefaults.standard.object(forKey: "userpk") as! Int
        let parameters: Parameters = ["nickname":nickname, "password":password,"password1":password1,"password2":password2,"content":content]
        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        
        let call = Alamofire.request(rootDomain + "member/update/\(userPK)/", method: .patch, parameters: parameters, headers: headers)
        
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                if !json["nickname_exists"].stringValue.isEmpty {
                    Toast(text: "이미 사용중인 넥네임입니다").show()
                } else if !json["empty_old_password"].stringValue.isEmpty {
                    Toast(text: "기존 패스워드를 입력해주세요").show()
                } else if !json["empty_password1"].stringValue.isEmpty {
                    Toast(text: "새 비밀번호를 입력해주세요").show()
                } else if !json["empty_password2"].stringValue.isEmpty {
                    Toast(text: "새 비밀번호 확인을 입력해주세요").show()
                } else if !json["password_not_match"].stringValue.isEmpty {
                    Toast(text: "입력된 패스워드가 일치 하지 않습니다").show()
                } else if !json["too_short_password"].stringValue.isEmpty {
                    Toast(text: "패스워드는 최소 4글자 이상이어야 합니다.").show()
                } else if !json["old_password_error"].stringValue.isEmpty {
                    Toast(text: "기존 패스워드가 맞지 않습니다").show()
                } else {
                    DataTelecom.shared.myPageUserData()
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    
    // MARK: 사진수정
    //
    //
    func fetchUserPhoto(img_profile: UIImage){
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let userPK = UserDefaults.standard.object(forKey: "userpk") as! Int
        let url = rootDomain + "member/update/\(userPK)/"
        //let parameters: Parameters = ["img_profile": img_profile]
        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            //for (key, value) in parameters {
            //  if key == "email" || key == "nickname" || key == "password1" || key == "password2" || key == "content" {
            //    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            //} else if let imgData = UIImageJPEGRepresentation(img_profile, 0.25) {
            if let imgData = UIImageJPEGRepresentation(img_profile, 0.25) {
                multipartFormData.append(imgData, withName: "img_profile", fileName: "photo.jpg", mimeType: "image/jpg")
            }
            
        }, to: url, method: .patch, headers: headers) { (response) in
            switch response {
            case .success(let upload, _, _):
                print("업로드 성공", upload)
                upload.responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print("fetchUserPhoto()   :   ",json)
                        DataTelecom.shared.myPageUserData()
                        Toast(text: "사진이변경됨").show()
                        self.navigationController?.popViewController(animated: true)
                        
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
    
    
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        // MARK: Textfield Delegate
        // 화면터치시 키보드 내림
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if (textField.isEqual(self.modifyNickname)) {
                self.modifyContent.becomeFirstResponder()
            } else if (textField.isEqual(self.modifyContent)) {
                self.oldPassword.becomeFirstResponder()
            } else if (textField.isEqual(self.oldPassword)) {
                self.newModifyPassword.becomeFirstResponder()
            } else if (textField.isEqual(self.newModifyPassword)) {
                self.newModifyPasswordConfirm.becomeFirstResponder()
            } else {
                //self.view.endEditing(true)
                self.modifyComplete(completeModify)
            }
            return true
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            modifyNickname.resignFirstResponder()
            modifyContent.resignFirstResponder()
            oldPassword.resignFirstResponder()
            newModifyPassword.resignFirstResponder()
            newModifyPasswordConfirm.resignFirstResponder()
        }
        
        // MARK: Life Cycle
        //
        override func viewDidLoad() {
            super.viewDidLoad()
            
            modifyNickname.delegate = self
            modifyContent.delegate = self
            oldPassword.delegate = self
            newModifyPassword.delegate = self
            newModifyPasswordConfirm.delegate = self
            
            
        }
        // 뷰가 나타나기전에 싱글톤 데이터 가져와서 표시
        override func viewWillAppear(_ animated: Bool) {
            self.img_profile.clipsToBounds = true
            self.img_profile.layer.cornerRadius = self.img_profile.frame.width/2
            self.email.text = DataTelecom.shared.user?.email.stringValue
            self.nickname.text = DataTelecom.shared.user?.nickname.stringValue
            
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
    extension InfoModifyViewController {
        func media(_ type: UIImagePickerControllerSourceType, flag: Bool, editing: Bool){
            if (UIImagePickerController.isSourceTypeAvailable(type)) {
                flagImageSave = flag
                imagePicker.delegate = self
                imagePicker.sourceType = type
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = editing
                
                present(imagePicker, animated: true, completion: nil)
            } else {
                if type == .photoLibrary{
                    Toast(text: "포토라이브러리에 접근할수 없음").show()
                } else {
                    Toast(text: "카메라에 접근할수 없음").show()
                }
            }
        }
        
        // MARK: 사진, 비디오, 포토라이브러리 선택 끝났을때
        //
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            
            let mediaType = info[UIImagePickerControllerMediaType] as! NSString
            
            if mediaType.isEqual(to: kUTTypeImage as NSString as String){
                captureImage = info[UIImagePickerControllerOriginalImage] as! UIImage
                if flagImageSave {
                    UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
                }
                //capture image(이미지 저장된것 처리)
            }
                // 비디오 처리(사용하진 않음)
            else if mediaType.isEqual(to: kUTTypeMovie as NSString as String) {
                if flagImageSave {
                    videoURL = (info[UIImagePickerControllerMediaURL] as! URL)
                    
                    UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath, self, nil, nil)
                }
            }
            self.fetchUserPhoto(img_profile: captureImage)
            self.dismiss(animated: true, completion: nil)
            
            
        }
        
        // MARK: 사진, 비디오 취소시
        //
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.dismiss(animated: true, completion: nil)
        }
}
