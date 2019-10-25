//
//  DriverTableViewCell.swift
//  TYT
//
//  Created by 이승윤 on 2019. 1. 7..
//  Copyright © 2019년 Dustin Lee. All rights reserved.
//

import UIKit

class DriverTableViewCell: UITableViewCell {

    @IBOutlet weak var driverThumbnail: RoundDriverImage!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var carThumbmail: RoundDriverImage!
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var rating: UILabel!

}
