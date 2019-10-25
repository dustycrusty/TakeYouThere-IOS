//
//  SignInManager.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 5..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import Foundation
import Firebase

class SignInManager{
    
    var email:String?
    var password:String?
    var vc:UIViewController?
    
    required init(email:String, password:String, vc:UIViewController) {
        self.email = email
        self.password = password
        self.vc = vc
    }
    
    func firebaseSignIn(completion: @escaping (Error?) -> ()){
        Auth.auth().signIn(withEmail: self.email ?? "", password: self.password ?? "") { (_, error) in
            if let error = error{
                showAlertAction(VC: self.vc!, title: "Sign In Failed", message: (error.localizedDescription), type: .alert)
            completion(error)
            }
            else{
                completion(error)
            }
        }
    }
    
}
