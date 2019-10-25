//
//  CheckVerificationViewController.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 5..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import UIKit

class CheckVerificationViewController: UIViewController {

    @IBOutlet var codeField: UITextField! = UITextField()
    
    var countryCode: String?
    var phoneNumber: String?
    var resultMessage: String?
    
    @IBAction func validateCode() {
        if let code = codeField.text {
            VerifyAPI.validateVerificationCode(self.countryCode!, self.phoneNumber!, code) { checked in
                if (checked.success) {
                    self.resultMessage = checked.message
                    self.performSegue(withIdentifier: "unwindToCreateUserSegue", sender: self)
                } else {
                    //TODO: ERROR HANDLING
                    print(checked.message)
                }
            }
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? creatUserViewController {
            dest.phoneNumber.text = (countryCode ?? "") + (phoneNumber ?? "")
            dest.phoneNumberVerified = true
        }
    }
}
