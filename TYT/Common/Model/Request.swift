//
//  Request.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 6..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import Foundation
import Pring
import Firebase

@objc enum conditionType:Int{
    case nightTimeAvail, recommendPlaces, playsOwnMusic, playsYourMusic, dontTalkMuch, talkative
}

@objcMembers
class Request:Object{
    
    @objc enum Status: Int {
        case accepted
        case rejected
        case pending
    }
    
    
    dynamic var conditions:[Int] = []
    dynamic var pickUpLocation:GeoPoint?
    dynamic var city:String?
    dynamic var country:String?
    dynamic var pickUpTime:Date?
    dynamic var endTime:Date?
    dynamic var driver: Reference<Driver>?
    dynamic var price: Double = 0.0
    dynamic var status:Status = .pending
    
    override func encode(_ key: String, value: Any?) -> Any? {
        if key == "status" {
            return self.status.rawValue
        }
        return nil
    }
    
    override func decode(_ key: String, value: Any?) -> Bool {
        if key == "status" {
            self.status = Status(rawValue: value as! Int)!
            return true
        }
        return false
    }
//    override func encode(_ key: String, value: Any?) -> Any? {
//        if key == "conditions" {
//            if self.conditions != nil{
//                var returnVal:[conditionType.RawValue] = []
//                for condition in self.conditions{
//                    returnVal.append(condition)
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
//            for condition in self.value{
//                self.conditions.append(conditionType(rawValue: condition as! Int)!)
//            }
//            return true
//        }
//        return false
//    }

}


