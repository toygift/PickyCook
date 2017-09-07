//
//  HomeViewController.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 5..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet var tableView: UITableView!
    var recipes: [Recipe]?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.recipes?.count ?? 1)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ALLRECIPE", for: indexPath) as? AllRecipeTableViewCell
        
        let count_like = self.recipes?[indexPath.row].like_count
        let sum_rate = self.recipes?[indexPath.row].rate_sum
        
        cell?.title.text = self.recipes?[indexPath.row].title
        cell?.descriptions.text = self.recipes?[indexPath.row].description
        cell?.tags.text = self.recipes?[indexPath.row].tag
        cell?.like_count.text = "좋아요 " + "\(count_like ?? 1)"
        cell?.rate_sum.text = "평점 " + "\(sum_rate ?? 1)"
        
        if let path = self.recipes?[indexPath.row].img_recipe {
            if let image = try? Data(contentsOf: URL(string: path)!) {
                cell?.img_recipe.image = UIImage(data: image)
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "RECIPEDETAIL") as? RecipeDetailViewController else {
            return
        }
        let recipePk = self.recipes?[indexPath.row].pk
        nextViewController.recipepk_r = recipePk
        print("recipePk  :  ",recipePk ?? "NO")
//        UserDefaults.standard.set(recipePk, forKey: "recipepk")
        
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    // MARK: Life Cycle
    //
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allRecipeList()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }
}
extension HomeViewController {
    func allRecipeList(){
        print("====================================================================")
        print("=========================AllrecipeList()============================")
        print("====================================================================")
        //        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        //        let userPK = UserDefaults.standard.object(forKey: "userpk") as! Int
        //        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        
        let call = Alamofire.request(rootDomain + "recipe/", method: .get)
        print("=========================AllrecipeList()============================")
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("=========================AllrecipeList()============================")
                let json = JSON(value)
                
                self.recipes = DataCentre.shared.allRecipeList(response: json) // AllRecipe
                //print("Recipes   :   ", self.recipes?.count ?? "데이터없음")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
}
