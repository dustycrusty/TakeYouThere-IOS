//
//  TYTCustomerContext.swift
//  TYT
//
//  Created by 이승윤 on 2019. 1. 10..
//  Copyright © 2019년 Dustin Lee. All rights reserved.
//

import Foundation
import Stripe
import Firebase
import Pring

class TYTCustomer:STPCustomer{
    var customSources:[STPSourceProtocol] = []
    var customDefaultSource: STPSourceProtocol!
    
    
    override init(){
        self.customSources = []
        self.customDefaultSource = nil
    }
    
    func getCustomer(){
        User.get((Auth.auth().currentUser?.uid)!, block: {(user, error) in
            if error != nil{
                self.customSources = []
                self.customDefaultSource = nil
            }
            else{
                self.customSources = user!.sources as? [STPSourceProtocol] ?? []
                self.customDefaultSource = user!.defaultCardId as? STPSourceProtocol ?? nil
            }
        })
    }


        
    
    
    override var sources: [STPSourceProtocol] {
        get {
            return customSources
        }
        set {
            customSources = newValue
        }
    }
    
    override var defaultSource: STPSourceProtocol? {
        get {
            return customDefaultSource
        }
        set {
            customDefaultSource = newValue
        }
    }
}

class TYTCustomerContext:STPCustomerContext{
    
    var customer:TYTCustomer = TYTCustomer()
    
    var error:Error? = nil
    
    override init(keyProvider key:STPEphemeralKeyProvider) {
        customer.getCustomer()
        super.init(keyProvider: key)
    }
    
    override func retrieveCustomer(_ completion: STPCustomerCompletionBlock? = nil) {
        completion!(customer,error)
    }
    
    override func selectDefaultCustomerSource(_ source: STPSourceProtocol, completion: @escaping STPErrorBlock) {
        User.get((Auth.auth().currentUser?.uid)!) { (user, error) in
            user?.defaultCardId = source
            user?.update({ (error) in
                completion(error)
            })
        }
    }
    
    override func attachSource(toCustomer source: STPSourceProtocol, completion: @escaping STPErrorBlock) {
        User.get((Auth.auth().currentUser?.uid)!) { (user, error) in
            user?.sources?.append(source)
            user?.update({ (error) in
                completion(error)
            })
        }
    }
    
    override func detachSource(fromCustomer source: STPSourceProtocol, completion: STPErrorBlock? = nil) {
        User.get((Auth.auth().currentUser?.uid)!) { (user, error) in
            if let error = error{
                completion!(error)
            }
            else {
                if user?.sources != nil, let sources = user?.sources as? [STPSourceProtocol]{
                user!.sources = sources.filter{$0.stripeID == source.stripeID}
                user?.update({ (error) in
                    completion!(error)
                })
            }
                else {
                    completion!(error)
                }
            }
        }
    }
}
