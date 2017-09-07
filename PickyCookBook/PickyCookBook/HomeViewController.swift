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

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (DataTelecom.shared.recipes?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ALLRECIPE", for: indexPath) as? AllRecipeTableViewCell
        
        let count_like = DataTelecom.shared.recipes?[indexPath.row].like_count
        let sum_rate = DataTelecom.shared.recipes?[indexPath.row].rate_sum
        
        cell?.title.text = DataTelecom.shared.recipes?[indexPath.row].title
        cell?.descriptions.text = DataTelecom.shared.recipes?[indexPath.row].description
        cell?.tags.text = DataTelecom.shared.recipes?[indexPath.row].tag
        cell?.like_count.text = "좋아요 " + "\(count_like!)"
        cell?.rate_sum.text = "평점 " + "\(sum_rate!)"
        
        if let path = DataTelecom.shared.recipes?[indexPath.row].img_recipe {
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
        let recipePk = DataTelecom.shared.recipes?[indexPath.row].pk
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
        DataTelecom.shared.allRecipeList()
        
    }
    override func viewWillAppear(_ animated: Bool) {


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }
}
