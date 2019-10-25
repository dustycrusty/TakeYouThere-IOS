//
//  RequestStatusCell.swift
//  TYT
//
//  Created by 이승윤 on 2019. 1. 13..
//  Copyright © 2019년 Dustin Lee. All rights reserved.
//

import UIKit
import Pring

class RequestStatusCell: UITableViewCell {
    
    @IBOutlet weak var DriverImage: RoundDriverImage!
    var disposer: Disposer<Request>?
    @IBOutlet weak var carImage: RoundDriverImage!
    @IBOutlet weak var dateFromUntil: UILabel!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var requestStatus: UILabel!

}
