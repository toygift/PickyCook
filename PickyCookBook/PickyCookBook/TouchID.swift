//
//  TouchID.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 9. 11..
//  Copyright © 2017년 jaeseong. All rights reserved.
//

import Foundation
import LocalAuthentication
import Toaster

class TouchID {
    let context = LAContext()
    
    var error: NSError?
    let message = "TouchID로 로그인합니다"
    let deviceAuth = LAPolicy.deviceOwnerAuthenticationWithBiometrics
    
    func canEvalPolicy() -> Bool {
        return context.canEvaluatePolicy(deviceAuth, error: nil)
    }
    func authUser(completion: @escaping (String?) -> Void) {
        guard canEvalPolicy() else { return }
        
        context.evaluatePolicy(deviceAuth, localizedReason: message) {
            (success, err) in
            
            if success {
                
                DispatchQueue.main.async {
                    completion(nil)
                }
                
                
            } else {
                
                let message: String
                switch (err) {
                case LAError.systemCancel?:
                    message = "시스템에 의해 인증이 취소됨"
                case LAError.userCancel?:
                    message = "사용자에 의해 인증이 취소됨"
                //self.commonlogout
                case LAError.userFallback?:
                    message = "암호입력?"
                default:
                    message = "메롱"
                }
                completion(message)
            }
            
        }
        
    }
}


//class TouchID {
//    func touch(){
//        let context = LAContext()
//        
//        var error: NSError?
//        let message = "인증이 필요합니다"
//        let deviceAuth = LAPolicy.deviceOwnerAuthenticationWithBiometrics
//        
//        if context.canEvaluatePolicy(deviceAuth, error: &error) {
//            context.evaluatePolicy(deviceAuth, localizedReason: message) { (success, error) in
//                if success {
//                    
//                } else {
//                    switch (error!._code) {
//                    case LAError.systemCancel.rawValue:
//                        Toast(text: "시스템 인증취소").show()
//                    case LAError.userCancel.rawValue:
//                        Toast(text: "사용자취소").show()
//                    case LAError.userFallback.rawValue:
//                        Toast(text: "암호입력").show()
//                    default:
//                        Toast(text: "암호입력2").show()
//                    }
//                }
//            }
//        } else {
//            switch (error!.code){
//            case LAError.touchIDNotEnrolled.rawValue:
//                Toast(text: "터치아이디가등록되지않음").show()
//                print("터치아이디가등록되지않음")
//            case LAError.passcodeNotSet.rawValue:
//                Toast(text: "패스코드등록되지않음").show()
//                print("패스코드등록되지않음")
//            default:
//                print("터치아이디사용불가")
//            }
//            OperationQueue.main.addOperation {
//                
//            }
//        }
//        
//    }
//    
//    
//    
//}
