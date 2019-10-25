//
//  commonFunction.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 6..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleMaps

public func showAlertAction(VC: UIViewController, title: String, message: String, type: UIAlertController.Style){
    let alert = UIAlertController(title: title, message: message, preferredStyle: type)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        switch action.style{
        case .default:
            print("default")
            
        case .cancel:
            print("cancel")
            
        case .destructive:
            print("destructive")
            
            
        }}))
    VC.present(alert, animated: true, completion: nil)
}

public func popVC(VC: UIViewController){
    VC.navigationController?.popViewController(animated: true)
    
}


public func mapStyler(mapView: GMSMapView){
            do {
                // Set the map style by passing the URL of the local file.
                if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                    mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                } else {
                    NSLog("Unable to find style.json")
                }
            } catch {
                NSLog("One or more of the map styles failed to load. \(error)")
            }
    
        }

public func ApplydarkNavigationBar(navController: UINavigationController){
    let navbar = navController.navigationBar
    navController.navigationItem.backBarButtonItem?.title = ""
    navbar.backItem?.title = ""
    navbar.barTintColor = UIColor().mainBackgroundColor_Dark()
    navbar.tintColor = UIColor().mainBackgroundColor_Light()
    navbar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor().mainBackgroundColor_Light(), NSAttributedString.Key.font: UIFont(name: "Ubuntu", size: 17)!]
}

public func ApplyLightNavigationBar(navController:UINavigationController){
    let navbar = navController.navigationBar
    navController.navigationItem.backBarButtonItem?.title = ""
    navbar.backItem?.title = ""
    navbar.barTintColor = UIColor().mainBackgroundColor_Light()
    navbar.tintColor = UIColor().mainBackgroundColor_Dark()
    navbar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor().mainBackgroundColor_Dark(), NSAttributedString.Key.font: UIFont(name: "Ubuntu", size: 17)!]
}

func searchForDriver(request: Request, completion: @escaping (([Driver]?) -> Void)){
    let searchDriverQueue = DispatchQueue(label: "com.Firestore.Driver.SearchQueue", attributes: DispatchQueue.Attributes.concurrent)
    Driver.where(\Driver.available, isEqualTo: true).where(\Driver.city, isEqualTo: request.city!).where(\Driver.country, isEqualTo: request.country!).get { (snapshot, error) in
        
        if (error != nil){
            print(error?.localizedDescription)
            completion(nil)
        }
        else{
            if snapshot != nil{
                var driversList:[Driver] = []
                searchDriverQueue.sync {
                    print("1")
                    print("count", snapshot?.documents.count)
                    for doc in (snapshot?.documents)!{
                        let driver = Driver(snapshot: doc)
                        print(driver?.conditions)
                        let driverCond = Set((driver?.conditions)!)
                        print(driverCond)
                        let requestCond = Set(request.conditions)
                        print(requestCond)
                        if requestCond.isSubset(of: driverCond){
                        driversList.append(driver!)
                        print("2")
                        }
                    }
                }
                print("3")
                completion(driversList)
            }
            else{
                print("NO SNAPSHOT")
                completion(nil)
            }
            
        }
    }
}

func getConditionArrayWithConditionType(array: Array<Int>?) -> [conditionType]?{
    var conArray:[conditionType] = []
    if let array = array{
        for type in array{
            conArray.append(conditionType(rawValue: type)!)
        }
        return conArray
    }
    return conArray
    
}
