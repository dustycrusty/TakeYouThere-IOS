//
//  SignUpErrorManager.swift
//
//  Created by 이승윤 on 2018. 11. 11..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import Foundation
import UIKit

class SignUpErrorManager{
    
    let parentvc:UIViewController
    let signUpErrorMessage = "Sign Up Error"
    enum SignUpError{
        case email, password, passwordCond, passwordRetype, pwMatchFalse, phoneVerified, phoneNumber, firstName, lastName, none
    }
    
    init(vc: UIViewController) {
        self.parentvc = vc
    }
    
    func returnErrorType(email: String, phoneNumber:String, pnChecked: Bool, password: String, retype: String, firstName:String, lastName:String) -> SignUpError{
        let errorTypeNone = SignUpError.none
        if email == ""{
            return .email
        }
        else if firstName == "" || firstName.containsWhiteSpace() == true{
            return .firstName
        }
        else if lastName == "" || lastName.containsWhiteSpace() == true{
            return .lastName
        }
        else if password == ""{
            return .password
        }
        else if password.containsNumbers() == false &&
            password.count <= 6 &&
            password.containsWhiteSpace() == true &&
            password.rangeOfCharacter(from: CharacterSet.uppercaseLetters) == nil &&
            password.rangeOfCharacter(from: CharacterSet.lowercaseLetters) == nil
        {
            return .passwordCond
        }
        else if retype == ""{
            return .passwordRetype
        }
        else if password != retype{
            return .pwMatchFalse
        }
        else if pnChecked == false{
            return .phoneVerified
        }
        else if phoneNumber == ""{
            return .phoneNumber
        }
        else{
            return errorTypeNone
        }
    }
    
    func showSignUpError(ErrorType:SignUpError) -> Bool{
        switch ErrorType {
            
        case .email:
            showAlertAction(VC: self.parentvc, title: signUpErrorMessage, message: "Email field is empty.", type: .alert)
            return false
        case.password:
            showAlertAction(VC: self.parentvc, title: signUpErrorMessage, message: "Password field is empty.", type: .alert)
            return false
        case .passwordCond:
            showAlertAction(VC: self.parentvc, title: signUpErrorMessage, message: "Password does not match the existing condition.", type: .alert)
            return false
        case .passwordRetype:
            showAlertAction(VC: self.parentvc, title: signUpErrorMessage, message: "Retype password field is empty.", type: .alert)
            return false
        case .pwMatchFalse:
            showAlertAction(VC: self.parentvc, title: signUpErrorMessage, message: "Password fields do not match.", type: .alert)
            return false
        case .phoneVerified:
            showAlertAction(VC: self.parentvc, title: signUpErrorMessage, message: "Please verify your phone number.", type: .alert)
            return false
        case .phoneNumber:
            showAlertAction(VC: self.parentvc, title: signUpErrorMessage, message: "Please add a phone number to your account.", type: .alert)
            return false
        case .lastName:
            showAlertAction(VC: self.parentvc, title: signUpErrorMessage, message: "Last name field cannot be empty.", type: .alert)
            return false
        case .firstName:
            showAlertAction(VC: self.parentvc, title: signUpErrorMessage, message: "First name field cannot be empty.", type: .alert)
            return false
        case .none:
            return true
        }
    }
}


extension String {
    
    func containsNumbers() -> Bool {
        
        // check if there's a range for a number
        let range = self.rangeOfCharacter(from: .decimalDigits)
        
        // range will be nil if no whitespace is found
        if let _ = range {
            return true
        } else {
            return false
        }
        
    }
    
    func containsWhiteSpace() -> Bool {
        
        // check if there's a range for a whitespace
        let range = self.rangeOfCharacter(from: .whitespacesAndNewlines)
        
        // range will be nil if no whitespace is found
        if let _ = range {
            return true
        } else {
            return false
        }
    }
}
