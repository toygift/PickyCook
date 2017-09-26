//
//  BookMarkViewController.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 5..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BookMarkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var recipe_bookmark: [Recipe_Bookmark]?

    @IBOutlet var tableView: UITableView!
    
    var title_A: String = ""
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.recipe_bookmark?.count ?? 1)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BOOKMARKREUSE") as? BookMarkTableViewCell
        let count_like = self.recipe_bookmark?[indexPath.row].like_count
        let sum_rate = self.recipe_bookmark?[indexPath.row].rate_sum
        
        cell?.title.text = self.recipe_bookmark?[indexPath.row].title
        cell?.memo.text = self.recipe_bookmark?[indexPath.row].memo
        cell?.like_count.text = "좋아요 " + "\(count_like ?? 1)"
        cell?.rate_sum.text = "평점 " + "\(sum_rate ?? 1)"
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "RECIPEDETAIL") as? RecipeDetailViewController else {
            return
        }
        let recipePk = self.recipe_bookmark?[indexPath.row].recipe
        print("====================================================================================================================================================")
        print("====================================================================================================================================================")
        print("recipePk  :  ",recipePk ?? "NO")
        print("====================================================================================================================================================")
        print("====================================================================================================================================================")
        print("====================================================================================================================================================")
        nextViewController.recipepk_r = recipePk
        
    
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "삭제") { (action, indexPath) in
            

            let recipepk = self.recipe_bookmark?[indexPath.row].recipe
            print("레시피 PK :                  ",recipepk ?? "no")
            self.recipe_bookmark?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.bookmarkListDelete(recipepks: recipepk!, selectAlamo: true)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
        }
        let patch = UITableViewRowAction(style: .default, title: "수정") { (action, indexPath) in
            let recipepk = self.recipe_bookmark?[indexPath.row].recipe
            let alertController = UIAlertController(title: "메모수정", message: nil, preferredStyle: .alert)
            alertController.addTextField(configurationHandler: { (textfield) in
                textfield.placeholder = "수정할 메모를 입력하세요"
            })
            alertController.addAction((UIAlertAction(title: "확인", style: .default, handler: { (action) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                if let title = alertController.textFields?[0].text {
                    if title.isEmpty == false {
                        self.recipe_bookmark?[indexPath.row].memo = title
                        self.title_A = title
                        self.bookmarkListDelete(recipepks: recipepk!, selectAlamo: false)
                        self.tableView.reloadData()
                    } else {
                        
                    }
                }
            })))
            alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            print("레시피 PK :                  ",recipepk ?? "no")
        }
        patch.backgroundColor = UIColor.lightGray
    
        return [delete, patch]
    }
  
    // MARK: Life Cycle
    //
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bookmarkList()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BookMarkViewController {
    
    // MARK: Bookmark 가져오기
    //
    //
    func bookmarkList(){
        print("====================================================================")
        print("==========================bookmarkList()============================")
        print("====================================================================")
//        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
//        let headers: HTTPHeaders = ["Authorization":"token \(token)"]

        let tokenValue = TokenAuth()
        guard let headers = tokenValue.getAuthHeaders() else { return }
        
        let call = Alamofire.request(rootDomain + "recipe/bookmark/", method: .get, headers: headers)
        
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                self.recipe_bookmark = DataCentre.shared.recipeBookmarkList(response: json)
                print("유저프린트   :   ",self.recipe_bookmark ?? "데이터없음")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            case .failure(let error):
                print(error)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            }
        }
    }
    func bookmarkListDelete(recipepks: Int, selectAlamo: Bool){
        print("====================================================================")
        print("====================bookmarkListDelete()============================")
        print("====================================================================")
//        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
//        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        let tokenValue = TokenAuth()
        guard let headers = tokenValue.getAuthHeaders() else { return }
        
        let call: DataRequest?
        if selectAlamo == true {
            call = Alamofire.request(rootDomain + "recipe/bookmark/\(recipepks)/", method: .delete, headers: headers)
            
        } else {
            let parameters: Parameters = ["memo": self.title_A]
            call = Alamofire.request(rootDomain + "recipe/bookmark/\(recipepks)/", method: .patch, parameters: parameters, headers: headers)
            
        }
        
        call?.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                //refresh가 필요없음...
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            case .failure(let error):
                print(error)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            }
        }
    }

}
