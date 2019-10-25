//
//  ChangeNameViewController.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 6..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import UIKit

class ChangeNameViewController: UIViewController {
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateNameTapped(_ sender: Any) {
        if firstName.text == "" || lastName.text == ""{
            showAlertAction(VC: self, title: "Update Failed", message: "Name fields cannot be empty.", type: .alert)
        }
        else{
            AccountManager(vc:self).updateName(firstName: firstName.text!, lastName: lastName.text!) { (error) in
                if error == nil{
                    print("success")
                }
        }
        }}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
