//
//  CustomNavigationBar.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 17..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = UIColor.clear
        navigationItem.backBarButtonItem?.title = ""
//        if self.navigationController?.parent?.view.backgroundColor == UIColor().mainBackgroundColor_Dark(){
//            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor().mainBackgroundColor_Light(), NSAttributedString.Key.font: UIFont(name: "Ubuntu", size: 16)!]
//        }
//        else{
//            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor().mainBackgroundColor_Dark(), NSAttributedString.Key.font: UIFont(name: "Ubuntu", size: 16)!]
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if (self.children[0].view.backgroundColor?.isEqual(UIColor().mainBackgroundColor_Light()))!
                {
                    self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor().mainBackgroundColor_Dark(), NSAttributedString.Key.font: UIFont(name: "Ubuntu", size: 16)!]
                }
                else{
                    print("IN ELSE")
                    self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor().mainBackgroundColor_Light(), NSAttributedString.Key.font: UIFont(name: "Ubuntu", size: 16)!]
                }
    }
    
    
}
