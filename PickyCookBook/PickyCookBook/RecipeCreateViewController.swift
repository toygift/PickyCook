//
//  RecipeCreateViewController.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 8..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster

class RecipeCreateViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker: UIImagePickerController = UIImagePickerController()
    var flagImageSave = false
    var captureImage: UIImage!
    var videoURL: URL!
    let no_image = UIImage(named: "no_im.png")
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var ingredientTextField: UITextField!
    @IBOutlet var tagTextField: UITextField!
    @IBOutlet var img_recipe: UIButton!
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
    @IBAction func createRecipe(_ sender: UIButton){
        guard let title = titleTextField.text else { return }
        guard let description = descriptionTextField.text else { return }
        guard let ingredient = ingredientTextField.text else { return }
        guard let tag = tagTextField.text else { return }
        guard let img_recipe = captureImage else { return }
        
        createRecipe(title: title, description: description, ingredient: ingredient, tag: tag, img_recipe: img_recipe)
        
        titleTextField.text = ""
        descriptionTextField.text = ""
        ingredientTextField.text = ""
        tagTextField.text = ""
        self.img_recipe.setBackgroundImage(no_image?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    // MARK: Life Cycle
    //
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        ingredientTextField.delegate = self
        tagTextField.delegate = self
        self.img_recipe.setBackgroundImage(no_image?.withRenderingMode(.alwaysOriginal), for: .normal)
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        ingredientTextField.resignFirstResponder()
        tagTextField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.isEqual(self.titleTextField)) {
            self.descriptionTextField.becomeFirstResponder()
        } else if(textField.isEqual(self.descriptionTextField)){
            self.ingredientTextField.becomeFirstResponder()
        } else if(textField.isEqual(self.ingredientTextField)){
            self.tagTextField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension RecipeCreateViewController {
    
    func createRecipe(title: String, description: String, ingredient: String, tag: String, img_recipe: UIImage) {
        
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        
        
        let url = "http://pickycookbook.co.kr/api/recipe/create/"
        let parameters : [String:Any] = ["title":title, "description":description, "ingredient":ingredient,"tag":tag, "img_recipe":img_recipe]
        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            
            for (key, value) in parameters {
                
                if key == "title" || key == "description" || key == "ingredient" || key == "tag" {
                    
                    multipartFormData.append(("\(value)").data(using: .utf8)!, withName: key)
                } else if let photo = self.captureImage, let imgData = UIImageJPEGRepresentation(photo, 0.25) {
                    multipartFormData.append(imgData, withName: "img_recipe", fileName: "photo.jpg", mimeType: "image/jpg")
                }
                
            }//for
            
        }, to: url, method: .post, headers: headers)
        { (response) in
            switch response {
            case .success(let upload, _, _):
                print("업로드드드드드", upload)
                upload.responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        let recipepk = JSON(value)["pk"].intValue
                        if !(json["title_error"].stringValue.isEmpty) {
                            Toast(text: "제목을 입력하세요").show()
                        } else if !(json["description_error"].stringValue.isEmpty) {
                            Toast(text: "설명을 입력하세요").show()
                        } else if !(json["ingredient_error"].stringValue.isEmpty) {
                            Toast(text: "재료를 입력하세요").show()
                        } else {
                            print("피케이값을 알려줘라",recipepk)
                            
                            print("JSON                   :", value)
                            guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "RECIPESTEP") as? RecipeStepCreateViewController else { return
                            }
                            nextViewController.recipepk_r = recipepk
                            guard let nextViewControllers = self.storyboard?.instantiateViewController(withIdentifier: "HOME") as? HomeViewController else { return }
                            nextViewControllers.select = false
                            self.navigationController?.pushViewController(nextViewController, animated: true)
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                    print("리스폰스스스스스: ",response)
                    
                })
                
            case .failure(let encodingError):
                print(encodingError)
                Toast(text: "네트워크에러").show()
            }
        }
    }
    //    func recipeCreate(){
    //        print("====================================================================")
    //        print("========================mycreateRecipe()============================")
    //        print("====================================================================")
    //        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
    //        let parameters: Parameters =
    //        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
    //
    //        let call = Alamofire.request(rootDomain + "recipe/create/", method: .post, headers: headers)
    //
    //        print("========================mycreateRecipe()============================")
    //        call.responseJSON { (response) in
    //            switch response.result {
    //            case .success(let value):
    //                print("========================mycreateRecipe()============================")
    //                let json = JSON(value)
    //
    //                self.recipes = DataCentre.shared.allRecipeList(response: json) // AllRecipe
    //                //print("Recipes   :   ", self.recipes?.count ?? "데이터없음")
    //                DispatchQueue.main.async {
    //                    self.tableView.reloadData()
    //                }
    //            case .failure(let error):
    //                print(error)
    //
    //            }
    //        }
    //    }
    
}
