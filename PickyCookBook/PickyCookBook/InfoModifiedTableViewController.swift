//
//  InfoModifiedTableViewController.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 25..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster
import MobileCoreServices


class InfoModifiedTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet var img_profile: UIImageView!
    
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
    
    
    @IBAction func modifyComplete(_ sender: UIButton){
        guard let nickname = modifyNickname.text else { return }
        guard let password = oldPassword.text else { return }
        guard let password1 = newModifyPassword.text else { return }
        guard let password2 = newModifyPasswordConfirm.text else { return }
        guard let content = modifyContent.text else { return }
        self.fetchUserData(nickname: nickname, password: password, password1: password1, password2: password2, content: content)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
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
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        modifyNickname.resignFirstResponder()
//        modifyContent.resignFirstResponder()
//        oldPassword.resignFirstResponder()
//        newModifyPassword.resignFirstResponder()
//        newModifyPasswordConfirm.resignFirstResponder()
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.title = "정보변경"
        } else {
            
        }
        print("================================================================")
        print("===========================viewDidLoad==========================")
        print("================================================================")
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedProfile(_:)))
        self.img_profile.addGestureRecognizer(gesture)
        
        self.email.text = DataTelecom.shared.user?.email
        self.nickname.text = DataTelecom.shared.user?.nickname
        
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
        
        
        modifyNickname.delegate = self
        modifyContent.delegate = self
        oldPassword.delegate = self
        newModifyPassword.delegate = self
        newModifyPasswordConfirm.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        modifyNickname.resignFirstResponder()
        modifyContent.resignFirstResponder()
        oldPassword.resignFirstResponder()
        newModifyPassword.resignFirstResponder()
        newModifyPasswordConfirm.resignFirstResponder()
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
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        case 2:
            return 1
        default:
            return 1
        }
    }
}
extension InfoModifiedTableViewController {
    func fetchUserData(nickname: String, password: String, password1: String, password2: String, content: String) {
        
        //        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        //        let userpk = UserDefaults.standard.object(forKey: "userpk") as! Int
        let parameters: Parameters = ["nickname":nickname, "password":password,"password1":password1,"password2":password2,"content":content]
        //        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        let tokenValue = TokenAuth()
        guard let headers = tokenValue.getAuthHeaders() else { return }
        guard let userpk = tokenValue.load(serviceName, account: "userpk") else { return }
        
        
        let call = Alamofire.request(rootDomain + "member/update/\(userpk)/", method: .patch, parameters: parameters, headers: headers)
        
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("=================================================================")
                print("======================    fetchUserData    ======================")
                print("=================================================================")
                if !json["nickname_exists"].stringValue.isEmpty {
                    Toast(text: "이미 사용중인 넥네임입니다").show()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                } else if !json["empty_old_password"].stringValue.isEmpty {
                    Toast(text: "기존 패스워드를 입력해주세요").show()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                } else if !json["empty_password1"].stringValue.isEmpty {
                    Toast(text: "새 비밀번호를 입력해주세요").show()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                } else if !json["empty_password2"].stringValue.isEmpty {
                    Toast(text: "새 비밀번호 확인을 입력해주세요").show()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                } else if !json["password_not_match"].stringValue.isEmpty {
                    Toast(text: "입력된 패스워드가 일치 하지 않습니다").show()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                } else if !json["too_short_password"].stringValue.isEmpty {
                    Toast(text: "패스워드는 최소 4글자 이상이어야 합니다.").show()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                } else if !json["old_password_error"].stringValue.isEmpty {
                    Toast(text: "기존 패스워드가 맞지 않습니다").show()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                } else {
                    DispatchQueue.main.async {
                        DataTelecom.shared.myPageUserData()
                    }
                    self.navigationController?.popViewController(animated: true)
                    
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            case .failure(let error):
                print(error)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            }
        }
    }
    func fetchUserPhoto(img_profile: UIImage){
        //        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        //        let userpk = UserDefaults.standard.object(forKey: "userpk") as! Int
        
        //let parameters: Parameters = ["img_profile": img_profile]
        //        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        let tokenValue = TokenAuth()
        guard let headers = tokenValue.getAuthHeaders() else { return }
        guard let userpk = tokenValue.load(serviceName, account: "userpk") else { return }
        let url = rootDomain + "member/update/\(userpk)/"
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let imgData = UIImageJPEGRepresentation(img_profile, 0.25) {
                multipartFormData.append(imgData, withName: "img_profile", fileName: "photo.jpg", mimeType: "image/jpg")
            }
            
        }, to: url, method: .patch, headers: headers) { (response) in
            switch response {
            case .success(let upload, _, _):
                print("업로드 성공")
                upload.responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(_):
                        print("=================================================================")
                        print("=====================    fetchUserPhoto    ======================")
                        print("=================================================================")
                        DispatchQueue.main.async {
                            DataTelecom.shared.myPageUserData()
                        }
                        Toast(text: "사진이변경됨").show()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    case .failure(let error):
                        print(error)
                    }
                })
            case .failure(let error):
                print(error)
                Toast(text: "네트워크에러").show()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
}

extension InfoModifiedTableViewController {
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
        self.dismiss(animated: true) {
            self.fetchUserPhoto(img_profile: self.captureImage)
            self.img_profile.image = self.captureImage
        }
        
    }
    
    // MARK: 사진, 비디오 취소시
    //
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

