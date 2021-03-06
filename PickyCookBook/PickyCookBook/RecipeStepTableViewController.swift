//
//  RecipeStepTableViewController.swift
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

class RecipeStepTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var recipepk_r: Int!
    let imagePicker: UIImagePickerController = UIImagePickerController()
    var flagImageSave = false
    var captureImage: UIImage!
    var videoURL: URL!
    var is_timer = true
    
    
    @IBOutlet var timerSwitch: UISwitch!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var timer: UITextField!
    
    @IBAction func is_timerOn(_ sender: UISwitch) {
        is_timer = sender.isOn
        if is_timer == true {
            timer.isHidden = false
        } else {
            timer.isHidden = true
        }
    }
    @IBOutlet var img_recipe: UIImageView!
    @IBAction func recipeStepComplete(_ sender: UIButton) {
        upDateStep()
    }
    
    @IBAction func completeStep(_ sender: UIButton) {
        let alert = UIAlertController(title: "완료하시겠습니까?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "저장후 완료", style: .default, handler: { (_) in
            self.upDateStep()
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "완료", style: .default, handler: { (_) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        })
        
    }
    func upDateStep() {
        
        if is_timer == true {
            if descriptionTextField.text == "" {
                Toast(text: "설명을 입력해주세요").show()
            } else if timer.text == "" {
                Toast(text: "시간을 입력해주세요").show()
            } else if captureImage == nil {
                self.captureImage = UIImage(named: "ss.jpg")
            } else {
                let timer = Int(self.timer.text!)
                recipeStepCreate(recipepk: recipepk_r, description: descriptionTextField.text!, is_timer: is_timer, timer: timer!, img_step: self.captureImage)
            }
        } else if is_timer == false {
            if descriptionTextField.text == "" {
                Toast(text: "설명을 입력해주세요").show()
            } else if captureImage == nil {
                self.captureImage = UIImage(named: "ss.jpg")
            } else {
                recipeStepCreate(recipepk: recipepk_r, description: descriptionTextField.text!, is_timer: is_timer, timer: 0, img_step: self.captureImage)
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        //        if descriptionTextField.text == "" {
        //            Toast(text: "설명을 입력해주세요").show()
        //        } else if is_timer == true {
        //            if self.timer.text == "" {
        //                Toast(text: "시간을 입력해주세요").show()
        //            }
        //        } else if captureImage == nil {
        //            self.captureImage = UIImage(named: "ss.jpg")
        //        }
        //
        //        guard let recipepk = recipepk_r else { return }
        //        guard let desc = descriptionTextField.text else { return }
        //        let timer = Int(self.timer.text!)
        //        let image = captureImage
        //        recipeStepCreate(recipepk: recipepk, description: desc, is_timer: self.is_timer, timer: timer!, img_step: image!)
        //
        
//        if descriptionTextField.text == "" {
//            Toast(text: "설명을 입력해주세요").show()
//        } else if captureImage == nil {
//            Toast(text: "이미지를 선택해주세요").show()
//        }
//
//
//
//        //        guard let is_timer = timerSwitch.isOn else { return }
//        guard let image = captureImage else { return }
//
//
//        if is_timer == true {
//            if self.timer.text == "" {
//                Toast(text: "시간을 입력해주세요").show()
//            }
//            recipeStepCreate(recipepk: recipepk, description: desc, is_timer: is_timer, timer: timer!, img_step: image)
//        } else {
//
//            recipeStepCreate(recipepk: recipepk, description: desc, is_timer: is_timer, timer: 0, img_step: image)
//        }
        
        
        
//        recipeStepCreate(recipepk: recipepk, description: desc, is_timer: timerSwitch.isOn, timer: timer, img_step: image)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("================================================================")
        print("====================RecipeStepTableViewController===============")
        print("===========================viewDidLoad==========================")
        print("================================================================")
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.title = "레시피 스텝 입력"
        } else {
            
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedProfile(_:)))
        self.img_recipe.addGestureRecognizer(gesture)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        
        descriptionTextField.delegate = self
        timer.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        descriptionTextField.resignFirstResponder()
        timer.resignFirstResponder()
        timerSwitch.resignFirstResponder()
        img_recipe.resignFirstResponder()
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
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        descriptionTextField.resignFirstResponder()
//        timer.resignFirstResponder()
//        timerSwitch.resignFirstResponder()
//        img_recipe.resignFirstResponder()
//
//    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.isEqual(self.descriptionTextField)) {
            self.timerSwitch.becomeFirstResponder()
        }else if (UISwitch.isEqual(self.timerSwitch))  {
            self.timer.becomeFirstResponder()
        }else if(textField.isEqual(self.timer)) {
            self.img_recipe.becomeFirstResponder()
        }else if(UIImageView.isEqual(self.img_recipe)) {
            self.view.endEditing(true)
        }
        
        return true
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,1,2,3,4:
            return 1
        default:
            return 1
        }
    }
}
extension RecipeStepTableViewController {
    func recipeStepCreate(recipepk: Int, description: String, is_timer: Bool, timer: Int, img_step: UIImage){
        //        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        print("알라모파이어!:!:!:!:?")
        let url = rootDomain + "recipe/step/create/"
        let parameters : [String:Any] = ["recipe":recipepk, "description": description, "is_timer":is_timer, "timer":timer*60, "img_step":img_step]
        //        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        
        let tokenValue = TokenAuth()
        guard let headers = tokenValue.getAuthHeaders() else { return }
        
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
                        print("왜 안되지???",json)
                        if !(json["title_error"].stringValue.isEmpty) {
                            Toast(text: "제목을 입력하세요").show()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        } else if !(json["description_error"].stringValue.isEmpty) {
                            Toast(text: "설명을 입력하세요").show()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        } else if !(json["ingredient_error"].stringValue.isEmpty) {
                            Toast(text: "재료를 입력하세요").show()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        } else {
                            guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "RECIPESTEPS") as? RecipeStepTableViewController else { return }
                            nextViewController.recipepk_r = self.recipepk_r
                            self.navigationController?.pushViewController(nextViewController, animated: true)

                        }
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    case .failure(let error):
                        print(error)
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    
                })
                
            case .failure(let encodingError):
                print(encodingError)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        
    }
}
extension RecipeStepTableViewController {
    
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
            self.img_recipe.image = self.captureImage
        }
        
    }
    
    
    // MARK: 사진, 비디오 취소시
    //
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

