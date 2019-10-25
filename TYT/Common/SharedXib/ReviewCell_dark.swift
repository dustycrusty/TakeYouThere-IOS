//
//  ReviewCell_dark.swift
//  TYT
//
//  Created by 이승윤 on 2019. 1. 13..
//  Copyright © 2019년 Dustin Lee. All rights reserved.
//

import UIKit

class ReviewCell_dark: UITableViewCell {

    @IBOutlet weak var reviewRating: UILabel!
    @IBOutlet weak var reviewActionButton: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var reviewContent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let lightColor = UIColor().mainBackgroundColor_Light()
        self.reviewRating.textColor = lightColor
        self.reviewContent.textColor = lightColor
        self.name.textColor = lightColor
    }


}
