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
    // MARK: Life Cycle
    //
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bookmarkList()
        
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
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        
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
            case .failure(let error):
                print(error)
                
            }
        }
    }

}
