//
//  AccountManager.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 6..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import Foundation
import Firebase
import Pring

class AccountManager{
    
    var user:User?
    var currentFirUser = Auth.auth().currentUser
    
    var vc:UIViewController?
    
    init(vc:UIViewController) {
        let currentUser = User(id: (currentFirUser?.uid)!)
        self.user = currentUser
        self.vc = vc
    }
    
    func logout(completion: @escaping (Bool)->()){
        do {
            try Auth.auth().signOut()
            completion(true)

        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            showAlertAction(VC: self.vc!, title: "Sign Out Error", message: signOutError.localizedDescription, type: .alert)
            completion(false)
        }
    }
    
    func deleteAccount(completion: @escaping (Bool)->()){
        user?.delete({ (error) in
            if let error = error{
                showAlertAction(VC: self.vc!, title: "Delete Account Error", message: error.localizedDescription, type: .alert)
                completion(false)
            }
            else{
                self.currentFirUser?.delete(completion: { (error) in
                    if let error = error{
                        showAlertAction(VC: self.vc!, title: "Delete Account Error", message: error.localizedDescription, type: .alert)
                        completion(false)

                    }
                    else{
                        completion(true)

                    }
                })
            }
        })
    }
    
    func sendResetPassword(email:String, completion: @escaping (Bool)->()){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error{
                showAlertAction(VC: self.vc!, title: "Password reset error", message: error.localizedDescription, type: .alert)
                completion(false)
            }
            else{
                completion(true)
            }
        }
    }
    
    func updatePassword(newPassword: String, completion: @escaping (Error?)->()){
        currentFirUser?.updatePassword(to: newPassword, completion: { (error) in
            if let error = error{
                self.alertActionForAccountManager(error: error)
                completion(error)
            }
            else{
                print("success!")
                completion(error)

            }
        })
    }
    
    func updateEmail(newEmail: String, completion: @escaping (Error?)->()){
        currentFirUser?.updateEmail(to: newEmail, completion: { (error) in
            if let error = error{
                self.alertActionForAccountManager(error: error)
                completion(error)

            }
            else{
                User.get((self.currentFirUser?.uid)!, block: { (user, error) in
                    if let error = error{
                        self.alertActionForAccountManager(error: error)
                    }
                })
                print("success!")
                completion(error)

            }
        })
    }
    
    func updateThumbnail(data: Data, completion: @escaping (Error?)->()){
        let img = File(data: data,mimeType: .png)
        user?.thumbnail = img
        user?.update({ (error) in
            if let error = error{
                self.alertActionForAccountManager(error: error)
                completion(error)

            }
            else{
                print("success!")
                completion(error)

            }
        })
    }
    
    func updateName(firstName:String, lastName:String, completion: @escaping (Error?)->()){
        user?.FirstName = firstName
        user?.lastName = lastName
        user?.update({ (error) in
            if let error = error{
                self.alertActionForAccountManager(error: error)
                completion(error)

            }
            else{
                print("success!")
                completion(error)

            }
        })
    }
    
    private func alertActionForAccountManager(error:Error){
        showAlertAction(VC: self.vc!, title: "Update Failed", message: error.localizedDescription, type: .alert)
    }
}
