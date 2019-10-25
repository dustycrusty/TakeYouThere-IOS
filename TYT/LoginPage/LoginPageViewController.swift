//
//  LoginPageViewController.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 6..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let sm = SignInManager(email: emailField.text ?? "", password: passwordField.text ?? "", vc: self)
        sm.firebaseSignIn { (error) in
            if error == nil{
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toMainPage")
                self.present(vc, animated: true, completion: nil)
//                self.performSegue(withIdentifier: "fromLogintoMainPageSegue", sender: self)
            }
        }
    }
    
    @IBAction func unwindToLoginPage(segue:UIStoryboardSegue){}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
