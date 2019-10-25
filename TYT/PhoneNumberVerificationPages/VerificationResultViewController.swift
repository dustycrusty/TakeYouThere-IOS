//
//  VerificationResultViewController.swift
//  
//
//  Created by 이승윤 on 2018. 12. 5..
//

import UIKit

class VerificationResultViewController: UIViewController {

    @IBOutlet var successIndication: UILabel! = UILabel()
    
    var message: String?
    var phoneNumber: String?
    
    override func viewDidLoad() {
        if let resultToDisplay = message {
            successIndication.text = resultToDisplay
        } else {
            successIndication.text = "Something went wrong!"
        }
        super.viewDidLoad()
    }
    @IBAction func DonePressed(_sender: Any){
        self.performSegue(withIdentifier: "unwindToCreateUserSegue", sender: self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? creatUserViewController{
            vc.phoneNumber.text = self.phoneNumber ?? "None"
            vc.phoneNumberVerified = true
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}
