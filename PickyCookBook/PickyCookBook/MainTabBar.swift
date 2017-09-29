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

    // MARK : SignInViewControllerDelegate
    //
    //
    func signInDidDismiss(signIn: SignInViewController) {
        print("프로토콜 로그인취소 메소드 호출됨")
        signIn.dismiss(animated: false) {
            self.selectedIndex = 0
        }
    }
    // MARK : SignInViewControllerDelegate
    //
    //
    func signInCompleteDismiss(signIn: SignInViewController) {
        if tabBarIndexofItem == 1 || tabBarIndexofItem == 2 || tabBarIndexofItem == 4 {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            signIn.dismiss(animated: true, completion: {
                DataTelecom.shared.myPageUserData()                
                self.tabBarController?.selectedIndex = self.tabBarIndexofItem!
            })
        }
    }
    
    // MARK : UITabBarDelegate
    //
    //
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("텝바 디드셀렉트")
        self.tabBarIndexofItem = tabBar.items?.index(of: item)
        
        if tabBarIndexofItem == 1 || tabBarIndexofItem == 2 || tabBarIndexofItem == 4 {
            print("IF")
            if tokenValue.load(serviceName, account: "accessToken") == nil {
                print("토큰 비었음?")
                guard let nextViewController = storyboard?.instantiateViewController(withIdentifier: "SIGNIN") as? SignInViewController else { return }
                nextViewController.signIndelegate = self
                nextViewController.modalPresentationStyle = .overCurrentContext
                self.present(nextViewController, animated: false, completion: nil)
            } else {
                print("메롱메롱")
            }
        } else {
            print("PASS")
        }
    }
    // MARK : UITabBarDelegate
    //
    //
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("뷰컨트롤러",tabBarController.selectedIndex)
    }
    
    // MARK : LifeCycle
    //
    //
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("TabbarController viewWillAppear")
    }
}
