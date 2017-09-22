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

    lazy var refreshControl = UIRefreshControl()
    var recipe_bookmark: [Recipe_Bookmark] = []
    let tokenValue = TokenAuth()
    var accessToken: String?
    var title_A: String = ""
    
    @IBOutlet var tableView: UITableView!
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipe_bookmark.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BOOKMARKREUSE") as? BookMarkTableViewCell
        
        let bookmarkRecipes: Recipe_Bookmark = recipe_bookmark[indexPath.row]
        cell?.bookmarkRecipe = bookmarkRecipes
        
//        let count_like = self.recipe_bookmark[indexPath.row].like_count
//        let sum_rate = self.recipe_bookmark[indexPath.row].rate_sum
//        
//        cell?.title.text = self.recipe_bookmark[indexPath.row].title
//        cell?.memo.text = self.recipe_bookmark[indexPath.row].memo
//        cell?.like_count.text = "좋아요 " + "\(count_like)"
//        cell?.rate_sum.text = "평점 " + "\(sum_rate)"
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "RECIPEDETAIL") as? RecipeDetailViewController else {
            return
        }
        let recipePk = self.recipe_bookmark[indexPath.row].recipe
        print("====================================================================================================================================================")
        print("====================================================================================================================================================")
        print("recipePk  :  ",recipePk)
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
            

            let recipepk = self.recipe_bookmark[indexPath.row].recipe
            print("레시피 PK :                  ",recipepk)
            self.recipe_bookmark.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.bookmarkListDelete(recipepks: recipepk, selectAlamo: true)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
        }
        let patch = UITableViewRowAction(style: .default, title: "수정") { (action, indexPath) in
            let recipepk = self.recipe_bookmark[indexPath.row].recipe
            let alertController = UIAlertController(title: "메모수정", message: nil, preferredStyle: .alert)
            alertController.addTextField(configurationHandler: { (textfield) in
                textfield.placeholder = "수정할 메모를 입력하세요"
            })
            alertController.addAction((UIAlertAction(title: "확인", style: .default, handler: { (action) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                if let title = alertController.textFields?[0].text {
                    if title.isEmpty == false {
                        self.recipe_bookmark[indexPath.row].memo = title
                        self.title_A = title
                        self.bookmarkListDelete(recipepks: recipepk, selectAlamo: false, memo: title)
                        self.tableView.reloadData()
                    } else {
                        
                    }
                }
            })))
            alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            print("레시피 PK :                  ",recipepk)
        }
        patch.backgroundColor = UIColor.lightGray
    
        return [delete, patch]
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
  
    // MARK: Life Cycle
    //
    //
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("************************************************************************************************************************")
        print("************************************     BookMarkViewController     ****************************************************")
        print("************************************   override func viewDidLoad()  ****************************************************")
        print("************************************************************************************************************************")
        self.bookmarkList()
        self.refreshControl.attributedTitle = NSAttributedString(string: "잡아당기면 리프레쉬")
        self.refreshControl.addTarget(self, action: #selector(HomeViewController.refresh), for: UIControlEvents.valueChanged)
        self.refreshControl.tintColor = UIColor.darkGray
        self.tableView.addSubview(refreshControl)

        
    }
    func refresh() {
        self.bookmarkList()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        print("북마크 viewWillAppear")
        print("************************************************************************************************************************")
        print("************************************     BookMarkViewController     ****************************************************")
        print("************************************   override func viewWillAppear ****************************************************")
        print("************************************************************************************************************************")
        
        
//        if tokenValue.load(serviceName, account: "accessToken") == nil {
//            guard let nextViewcontroller = storyboard?.instantiateViewController(withIdentifier: "SIGNIN") else { return }
//            self.present(nextViewcontroller, animated: true, completion: nil)
//        } else {
//            self.bookmarkList()
//            tableView.rowHeight = UITableViewAutomaticDimension
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true
//            print("북마크 viewDidLoad")
//        }
//        self.bookmarkList()
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
    }
    override func viewDidAppear(_ animated: Bool) {
//        self.bookmarkList()
        print("************************************************************************************************************************")
        print("************************************     BookMarkViewController     ****************************************************")
        print("************************************   override func viewDidAppear  ****************************************************")
        print("************************************************************************************************************************")
        print("북마크 viewDidAppear")
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

//        let tokenValue = TokenAuth()
        guard let headers = tokenValue.getAuthHeaders() else { return }
        
        let call = Alamofire.request(rootDomain + "recipe/bookmark/", method: .get, headers: headers)
        
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                self.recipe_bookmark = DataCentre.shared.recipeBookmarkList(response: json)
                //print("북마크   :   ",self.recipe_bookmark)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.refreshControl.endRefreshing()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            case .failure(let error):
                print(error)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            }
        }
    }
    func bookmarkListDelete(recipepks: Int, selectAlamo: Bool, memo: String = ""){
        print("====================================================================")
        print("====================bookmarkListDelete()============================")
        print("====================================================================")
//        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
//        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
//        let tokenValue = TokenAuth()
        guard let headers = tokenValue.getAuthHeaders() else { return }
        
        let call: DataRequest?
        if selectAlamo == true {
            call = Alamofire.request(rootDomain + "recipe/bookmark/\(recipepks)/", method: .delete, headers: headers)
            
        } else {
            let parameters: Parameters = ["memo": memo]
            call = Alamofire.request(rootDomain + "recipe/bookmark/\(recipepks)/", method: .patch, parameters: parameters, headers: headers)
            
        }
        
        call?.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("삭제완료 : ",json)
                //refresh가 필요없음...
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

}


