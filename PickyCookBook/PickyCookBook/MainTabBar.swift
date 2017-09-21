//
//  MainTabBar.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 4..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import LocalAuthentication

class MainTabBar: UITabBarController {

    
    let tokenValue = TokenAuth()
    var accessToken: String?
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
  
        if tabBar.items?.index(of: item) == 0 {
            print("홈")
        } else if tabBar.items?.index(of: item) == 1 {
            if accessToken == nil {
                print("토큰 비었음?")
                guard let nextview = storyboard?.instantiateViewController(withIdentifier: "SIGNIN") as? SignInViewController else { return }
                self.present(nextview, animated: true, completion: nil)
            } else {
                print("메롱메롱")
            }
        } else if tabBar.items?.index(of: item) == 2 {
            if accessToken == nil {
                print("토큰 비었음?")
                guard let nextview = storyboard?.instantiateViewController(withIdentifier: "SIGNIN") as? SignInViewController else { return }
                self.present(nextview, animated: true, completion: nil)
            } else {
                print("메롱메롱")
            }
        } else if tabBar.items?.index(of: item) == 3 {
            print("검색")
        } else if tabBar.items?.index(of: item) == 4 {
            if accessToken == nil {
                print("토큰 비었음?")
                guard let nextview = storyboard?.instantiateViewController(withIdentifier: "SIGNIN") as? SignInViewController else { return }
                self.present(nextview, animated: true, completion: nil)
            } else {
                print("메롱메롱")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("로드")
        self.accessToken = tokenValue.load(serviceName, account: "accessToken")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        print("어피어")
        self.accessToken = tokenValue.load(serviceName, account: "accessToken")
        
    }
}
