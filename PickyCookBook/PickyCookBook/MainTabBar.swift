//
//  MainTabBar.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 4..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import UIKit
import LocalAuthentication

class MainTabBar: UITabBarController, UITabBarControllerDelegate, SignInViewControllerDelegate {

    let tokenValue = TokenAuth()
    var accessToken: String?
    
//    lazy var signIn = SignInViewController()
    
    func loginDidDismiss(login: SignInViewController) {
        print("프로토콜 메소드 호출됨")
        login.dismiss(animated: true) {
            self.selectedIndex = 0
        }
        
    }
  
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
  
        let tabBarIndexofItem = tabBar.items?.index(of: item)
        
        if tabBarIndexofItem == 1 || tabBarIndexofItem == 2 || tabBarIndexofItem == 4 {
            if accessToken == nil {
                print("토큰 비었음?")
                guard let nextview = storyboard?.instantiateViewController(withIdentifier: "SIGNIN") as? SignInViewController else { return }
                nextview.signIndelegate = self
                self.present(nextview, animated: true, completion: nil)
            } else {
                print("메롱메롱")
            }
        } else {
            print("PASS")
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("뷰컨트롤러",tabBarController.selectedIndex)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TabbarController")
        
        self.accessToken = tokenValue.load(serviceName, account: "accessToken")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        print("TabbarController viewWillAppear")
//        self.accessToken = tokenValue.load(serviceName, account: "accessToken")
        
    }
}
