//
//  PasswordResetPage.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 6..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import UIKit
import Firebase

class PasswordResetPage: UIViewController {

    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: email.text ?? "") { (error) in
            if let error = error {
                showAlertAction(VC: self, title: "Password Reset Error", message: error.localizedDescription, type: .alert)
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
