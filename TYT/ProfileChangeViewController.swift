//
//  ProfileChangeViewController.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 6..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import UIKit

class ProfileChangeViewController: UIViewController {

    var am:AccountManager?
    @IBOutlet weak var status: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        am = AccountManager(vc: self)

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logoutTapped(_ sender: Any) {
        am?.logout(completion: { (success) in
            if success{
                self.status.text  = "success!"
                self.performSegue(withIdentifier: "unwindToLoginPageSegue", sender: self)
            }
        })
    }
    
    @IBAction func deleteAccountTapped(_ sender: Any) {
        am?.deleteAccount(completion: { (success) in
            if success{
                self.status.text  = "success!"
                self.performSegue(withIdentifier: "unwindToLoginPageSegue", sender: self)

            }
        })
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
