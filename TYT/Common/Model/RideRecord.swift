//
//  RideRecord.swift
//  TYT
//
//  Created by 이승윤 on 2019. 1. 7..
//  Copyright © 2019년 Dustin Lee. All rights reserved.
//

import Foundation
import Pring

@objcMembers
class RideRecord: Object{
    
    dynamic var Driver:Reference<User>?
    dynamic var from: Date?
    dynamic var until: Date?
    dynamic var price: Double?
    dynamic var pickUpLocation: locationStructure?
    
    
}
