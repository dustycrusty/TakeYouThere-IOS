//
//  RoundDriverImage.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 19..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class RoundDriverImage: UIImageView
{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
        self.clipsToBounds = true
    }
}
