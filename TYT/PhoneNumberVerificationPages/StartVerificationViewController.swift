//
//  StartVerificationViewController.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 5..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import UIKit
import FlagPhoneNumber

class StartVerificationViewController: UIViewController {

    @IBOutlet weak var phoneNumberField: FPNTextField!
    
    @IBAction func sendVerification() {
        if let phoneNumber = phoneNumberField.getRawPhoneNumber(),
            let countryCode = phoneNumberField.getFormattedPhoneNumber(format: FPNFormat.International)?.split(separator: " ")[0] {
            VerifyAPI.sendVerificationCode(String(countryCode), phoneNumber)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? CheckVerificationViewController {
            dest.countryCode = String((phoneNumberField.getFormattedPhoneNumber(format: FPNFormat.International)?.split(separator: " ")[0])!)
            dest.phoneNumber = phoneNumberField.getRawPhoneNumber()
        }
    }
    

}
