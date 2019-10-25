//
//  ChangePasswordViewController.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 6..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var newPasswordRetype: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        ApplyLightNavigationBar(navController: (self.navigationController)!)
    }
    
    @IBAction func updatePassword(_ sender: Any) {
        if newPassword.text == "" || newPasswordRetype.text == ""{
            showAlertAction(VC: self, title: "Failed", message: "Password field cannot be empty.", type: .alert)
        }
        
        else if newPassword.text != newPasswordRetype.text{
             showAlertAction(VC: self, title: "Failed", message: "Password fields must match.", type: .alert)
        }
        else if newPassword.text?.containsNumbers() == false &&
            (newPassword.text?.count)! <= 6 &&
            newPassword.text?.containsWhiteSpace() == true &&
            newPassword.text?.rangeOfCharacter(from: CharacterSet.uppercaseLetters) == nil &&
            newPassword.text?.rangeOfCharacter(from: CharacterSet.lowercaseLetters) == nil{
             showAlertAction(VC: self, title: "Failed", message: "Password does not match the given condition.", type: .alert)
        }
        else{
            AccountManager(vc: self).updatePassword(newPassword: newPassword.text ?? "") { (error) in
                if error == nil{
                    print("success")
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
