//
//  ReviewCell_light.swift
//  TYT
//
//  Created by 이승윤 on 2019. 1. 13..
//  Copyright © 2019년 Dustin Lee. All rights reserved.
//

import UIKit

class ReviewCell_light: UITableViewCell {
    @IBOutlet weak var reviewRating: UILabel!
    @IBOutlet weak var reviewActionButton: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var reviewContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let darkColor = UIColor().mainBackgroundColor_Dark()
        self.reviewRating.textColor = darkColor
        self.reviewContent.textColor = darkColor
        self.name.textColor = darkColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
