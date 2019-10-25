//
//  ChangeEmailViewController.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 6..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import UIKit

class ChangeEmailViewController: UIViewController {
    @IBOutlet weak var newEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateEmailTapped(_ sender: Any) {
        AccountManager(vc: self).updateEmail(newEmail: newEmail.text ?? "") { (error) in
            if error == nil{
                print("success")
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
