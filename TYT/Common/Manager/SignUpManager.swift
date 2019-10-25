//
//  SignUpManager.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 5..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import Foundation
import Firebase
import Pring

class SignUpManager {
    
    var email:String?
    var password:String?
    var fName:String?
    var lName:String?
    var phoneNumber:String?
    var phoneNumberVerified:Bool = false
    var passwordRetype:String?
    
    var vc:UIViewController?
    
    required init(email: String, password:String, passwordRetype:String, firstName:String, lastName:String, phoneNumber:String, phoneNumberVerified:Bool, vc:UIViewController) {
        self.vc = vc
        self.email = email
        self.password = password
        self.passwordRetype = passwordRetype
        self.fName = firstName
        self.lName = lastName
        self.phoneNumber = phoneNumber
        self.phoneNumberVerified = phoneNumberVerified
    }
    
    func firebaseSignUp(completion: @escaping (Error?) ->()){
        Auth.auth().createUser(withEmail: self.email ?? "", password: self.password ?? "") { (result, error) in
            if let error = error{
                completion(error)
            }
            else{
                let newUser = User(id: (result?.user.uid)!)
                newUser.FirstName = self.fName
                newUser.lastName = self.lName
                newUser.phoneNumber = self.phoneNumber
                newUser.emailAddress = self.email
                newUser.update({ (error) in
                    completion(error)
                })
                
            }
        }
    }
        
    func checkDataValidity() -> Bool{
        let errorManager = SignUpErrorManager(vc: self.vc!)
        let error = errorManager.returnErrorType(email: email ?? "", phoneNumber: phoneNumber ?? "", pnChecked: phoneNumberVerified, password: password ?? "", retype: passwordRetype ?? "", firstName: fName ?? "", lastName: lName ?? "")
        let passed = errorManager.showSignUpError(ErrorType: error)
        return passed
    }

    
    func signUpFlow(passed: @escaping (Bool)->()){
        if checkDataValidity() == true{
            firebaseSignUp { (error) in
                if let error = error{
                    showAlertAction(VC: self.vc!, title: "Sign Up Error", message: error.localizedDescription, type: .alert)
                    passed(false)
                }
                else{
                    passed(true)
                }
            }
        }
    }
    

}
