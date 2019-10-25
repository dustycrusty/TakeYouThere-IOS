//
//  User.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 5..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import Foundation
import Pring

@objcMembers
class User: Object{
    
    dynamic var thumbnail:File?
    dynamic var FirstName:String?
    dynamic var lastName:String?
    dynamic var phoneNumber:String?
    dynamic var emailAddress:String?
    dynamic var request: NestedCollection<Request> = []
    dynamic var requestHistory: NestedCollection<Request> = []
    dynamic var provider_id:String?
    dynamic var available: Bool = true
    dynamic var tokens: [Any]?
    dynamic var sources: [Any]?
    dynamic var defaultCardId: Any?
    dynamic var customer_id:String?
    dynamic var stripe_userId:String?
    
}
