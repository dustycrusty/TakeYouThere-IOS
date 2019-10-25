//
//  CustomSideDrawerViewController.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 22..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import UIKit
import SideMenu
class CustomSideDrawerViewController: UISideMenuNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(self.children[0].view.backgroundColor?.description, UIColor().mainBackgroundColor_Light())
        if (self.children[0].view.backgroundColor?.isEqual(UIColor().mainBackgroundColor_Light()))!
        {
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor().mainBackgroundColor_Dark(), NSAttributedString.Key.font: UIFont(name: "Ubuntu", size: 16)!]
        }
        else{
            print("IN ELSE")
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor().mainBackgroundColor_Light(), NSAttributedString.Key.font: UIFont(name: "Ubuntu", size: 16)!]
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
