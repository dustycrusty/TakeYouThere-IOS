//
//  creatUserViewController.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 5..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import UIKit

class creatUserViewController: UIViewController {

    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordRetype: UITextField!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    var phoneNumberVerified = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func createPassed(_ sender: Any) {
        SignUpManager(email: email.text ?? "", password: password.text ?? "", passwordRetype: passwordRetype.text ?? "", firstName: fName.text ?? "", lastName: lName.text ?? "", phoneNumber: phoneNumber.text ?? "", phoneNumberVerified: phoneNumberVerified, vc: self).signUpFlow
            { (passed) in
                if passed{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "toMainPage")
                self.present(vc, animated: true, completion: nil)
                }
        }
    }
    
    @IBAction func unwindToCreatUserPage(segue:UIStoryboardSegue){}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
