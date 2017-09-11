//
//  RecipeStepCreateViewController.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 8..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster
import MobileCoreServices

class RecipeStepCreateViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var recipepk_r: Int!
    let imagePicker: UIImagePickerController = UIImagePickerController()
    var flagImageSave = false
    var captureImage: UIImage!
    var videoURL: URL!
    var is_timer: Bool!
    
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var img_step: UIButton!
    @IBOutlet var timer: UITextField!
    @IBAction func is_timerOn(_ sender: UISwitch) {
        is_timer = sender.isOn
    }
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
    @IBAction func recipeStepComplete(_ sender: UIButton) {
        guard let desc = descriptionTextField.text else { return }
        guard let timer = Int(timer.text!) else { return }
        guard let recipepk = recipepk_r else { return }
        guard let is_timer = is_timer else { return }
        
        recipeStepCreate(recipepk: recipepk, description: desc, is_timer: is_timer, timer: timer, img_step: captureImage)
    }
    
    @IBAction func completeStep(_ sender: UIButton) {
        let alert = UIAlertController(title: "완료", message: "완료하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    // MARK: Life Cycle
    //
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextField.delegate = self
        timer.delegate = self
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        descriptionTextField.resignFirstResponder()
        timer.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.isEqual(self.descriptionTextField)) {
            self.timer.becomeFirstResponder()
        }else {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension RecipeStepCreateViewController {
    func recipeStepCreate(recipepk: Int, description: String, is_timer: Bool, timer: Int, img_step:UIImage){
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        
        let url = "http://pickycookbook.co.kr/api/recipe/step/create/"
        let parameters : [String:Any] = ["recipe":recipepk, "description": description, "is_timer":is_timer, "timer":timer*60, "img_step":img_step]
        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            
            for (key, value) in parameters {
                
                if key == "description" || key == "timer" || key == "is_timer" || key == "recipe" {
                    print("됨됨됨 \(value)")
                    
                    multipartFormData.append(("\(value)").data(using: .utf8)!, withName: key)
                } else if let photo = self.captureImage, let imgData = UIImageJPEGRepresentation(photo, 0.25) {
                    multipartFormData.append(imgData, withName: "img_step", fileName: "photo.jpg", mimeType: "image/jpg")
                }
                
                
            }//for
            
            
            
        }, to: url, method: .post, headers: headers)
        { (response) in
            switch response {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        
                        if !(json["title_error"].stringValue.isEmpty) {
                            Toast(text: "제목을 입력하세요").show()
                        } else if !(json["description_error"].stringValue.isEmpty) {
                            Toast(text: "설명을 입력하세요").show()
                        } else if !(json["ingredient_error"].stringValue.isEmpty) {
                            Toast(text: "재료를 입력하세요").show()
                        } else {
                            guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "RECIPESTEP") else { return }
                            self.navigationController?.pushViewController(nextViewController, animated: true)
                           
                            
                        }
                    case .failure(let error):
                        print(error)
                    }
              
                })
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        
    }
}

// func
//

extension RecipeStepCreateViewController {
    
    // MARK: 포토라이브러리, 카메라
    //
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
        }else {
            print("something is worng")
        }
        self.dismiss(animated: true) {
            self.img_step.setImage(self.captureImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
    }
    
    
    // MARK: 사진, 비디오 취소시
    //
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

