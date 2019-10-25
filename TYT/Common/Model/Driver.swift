//
//  Driver.swift
//  TYT
//
//  Created by 이승윤 on 2019. 1. 7..
//  Copyright © 2019년 Dustin Lee. All rights reserved.
//

import Foundation
import Pring

@objcMembers
class Driver: Object{
    
    
    dynamic var thumbnail:File?
    dynamic var carImage:File?
    dynamic var carModel:String?
    dynamic var introduction:String?
    dynamic var rating: Double = 0
    dynamic var reviews:NestedCollection<Review> = []
    dynamic var FirstName:String?
    dynamic var lastName:String?
    dynamic var phoneNumber:String?
    dynamic var emailAddress:String?
    dynamic var inbox: NestedCollection<Request> = []
    dynamic var driveHistory: NestedCollection<Request> = []
    
    dynamic var provider_id:String?
    
    dynamic var conditions:[Int]?
    dynamic var available: Bool = false
    
    dynamic var city: String?
    dynamic var country: String?
    
//    override func encode(_ key: String, value: Any?) -> Any? {
//        if key == "conditions" {
//            if self.conditions != nil{
//                var returnVal:[conditionType.RawValue] = []
//                for condition in self.conditions!{
//                    returnVal.append(condition.rawValue)
//                }
//                return returnVal
//            }
//            return nil
//        }
//        return nil
//    }
//    
//    override func decode(_ key: String, value: Any?) -> Bool {
//        if key == "conditions" {
//
//            print("value", self.value["conditions"])
//            let decodeQueue = DispatchQueue(label: "com.Firestore.conditions.decodeQueue", attributes: DispatchQueue.Attributes.concurrent)
//            var cond: [conditionType] = []
//            decodeQueue.sync {
//                for condition in self.conditions ?? [] {
//                    print("condition", condition)
//                    cond.append(conditionType(rawValue: condition)!)
//                }
//            }
//            self.conditionsTypeArray = cond
//
//            return true
//        }
//        return false
//    }
}
