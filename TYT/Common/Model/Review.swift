//
//  Review.swift
//  TYT
//
//  Created by 이승윤 on 2019. 1. 7..
//  Copyright © 2019년 Dustin Lee. All rights reserved.
//

import Foundation
import Pring

@objcMembers
class Review: Object{
    dynamic var user: User?
    dynamic var message: String?
    dynamic var starRating: Double?
    dynamic var time: Date?
}
