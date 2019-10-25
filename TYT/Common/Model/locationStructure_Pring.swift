//
//  locationStructure_Pring.swift
//  TYT
//
//  Created by 이승윤 on 2019. 1. 7..
//  Copyright © 2019년 Dustin Lee. All rights reserved.
//

import Foundation
import Pring
import Firebase

@objcMembers
class locationStructure_Pring: Object{
    dynamic var fullAddress:String?
    dynamic var shortAddress:String?
    dynamic var coordinate: GeoPoint?
}
