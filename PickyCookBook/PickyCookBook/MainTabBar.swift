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

    var tabBarIndexofItem: Int?
    
    let tokenValue = TokenAuth()
//    var accessToken: String = ""
    
//    lazy var signIn = SignInViewController()
    
    
    func signInDidDismiss(signIn: SignInViewController) {
        print("프로토콜 로그인취소 메소드 호출됨")
        signIn.dismiss(animated: true) {
            self.selectedIndex = 0
        }
    }
    func signInCompleteDismiss(signIn: SignInViewController) {
        if tabBarIndexofItem == 1 || tabBarIndexofItem == 2 || tabBarIndexofItem == 4 {
            DataTelecom.shared.myPageUserData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            signIn.dismiss(animated: true, completion: nil)
            tabBarController?.selectedIndex = tabBarIndexofItem!
        }
//        } else if self.selectedIndex == 2 {
//            DataTelecom.shared.myPageUserData()
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//            signIn.dismiss(animated: true, completion: nil)
//            tabBarController?.selectedIndex = 2
//        } else if self.selectedIndex == 4 {
//            DataTelecom.shared.myPageUserData()
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//            signIn.dismiss(animated: true, completion: nil)
//            tabBarController?.selectedIndex = 4
//
//        }
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
  
        self.tabBarIndexofItem = tabBar.items?.index(of: item)
        
        if tabBarIndexofItem == 1 || tabBarIndexofItem == 2 || tabBarIndexofItem == 4 {
            if tokenValue.load(serviceName, account: "accessToken") == nil {
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
        print("TabbarController", tokenValue.load(serviceName, account: "accessToken") ?? "no data")
        if tokenValue.load(serviceName, account: "accessToken") != nil {
            DataTelecom.shared.myPageUserData()
            
        }
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            
        } else {
            
        }
//        self.accessToken = tokenValue.load(serviceName, account: "accessToken")
//        
    }

    override func viewWillAppear(_ animated: Bool) {
        print("TabbarController viewWillAppear")
//        self.accessToken = tokenValue.load(serviceName, account: "accessToken")
        
    }
}
