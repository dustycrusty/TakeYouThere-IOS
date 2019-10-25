//
//  PrepareRequestViewController.swift
//  TYT
//
//  Created by 이승윤 on 2019. 1. 3..
//  Copyright © 2019년 Dustin Lee. All rights reserved.
//

import UIKit
import M13Checkbox
import DatePickerDialog
import GoogleMaps
import Firebase

class PrepareRequestViewController: UIViewController, popWithData {
    func popWithDataResponse(locStruct: locationStructure) {
        self.locationStruct = locStruct
    }
    

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var fromTime: UIButton!
    @IBOutlet weak var untilTime: UIButton!
    @IBOutlet weak var estimatedPrice: UILabel!
    
    
    @IBOutlet weak var nightTimeAvail: M13Checkbox!
    @IBOutlet weak var recommendPlaces: M13Checkbox!
    @IBOutlet weak var playsOwnMusic: M13Checkbox!
    @IBOutlet weak var playsYourMusic: M13Checkbox!
    @IBOutlet weak var dontTalkMuch: M13Checkbox!
    @IBOutlet weak var talkative: M13Checkbox!
    
    var dateSelected = [0:false, 1: false]
        
    
    var address:String?
    var locationStruct:locationStructure?
    
    var from:Date?{
        didSet{
            if from != nil && until != nil{
                estimatePrice()
            }
        }
    }
    
    var until:Date?{
        didSet{
            if from != nil && until != nil{
                estimatePrice()
            }
        }
    }
    
    var price:Double?
    var request:Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapStyler(mapView: mapView)
//        let camera = GMSCameraPosition.camera(withLatitude: (locationStruct?.coordinate.latitude)!, longitude: (locationStruct?.coordinate.longitude)!, zoom: 12)
//        mapView.camera = camera
//        location.text = locationStruct?.fullAddress ?? "Error occurred while retrieving location. Please try again."
        // Do any additional setup after loading the view.
        let boxes: [M13Checkbox] = [nightTimeAvail, recommendPlaces, playsOwnMusic, playsYourMusic, dontTalkMuch, talkative]
            prepAllCheckBox(boxes: boxes)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let camera = GMSCameraPosition.camera(withLatitude: (locationStruct?.coordinate.latitude)!, longitude: (locationStruct?.coordinate.longitude)!, zoom: 12)
        mapView.camera = camera
        location.text = locationStruct?.fullAddress ?? "Error occurred while retrieving location. Please try again."
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(request)
    }
    
    func estimatePrice(){
        let hourlyRate:Double = 10.0
        let seconds = Int((until?.timeIntervalSince(from!))!)
        print(from, until)
        print("seconds:", seconds)
        let hms = secondsToHoursMinutesSeconds(seconds: Double(seconds))
        let hrs = hms
        print("hrs:", hrs)
        let price = hrs * hourlyRate
        print("price:" , price)
        self.price = price
        let string = "$ \(price) + $ 1 / 10 min Overtime"
        estimatedPrice.text = string
    }
    
    func getConditions() -> [conditionType.RawValue]{
        var returnArr:[conditionType.RawValue] = []
            if nightTimeAvail.checkState == .checked{
                returnArr.append(conditionType.nightTimeAvail.rawValue)
            }
            if recommendPlaces.checkState == .checked{
                returnArr.append(conditionType.recommendPlaces.rawValue)
            }
            if playsOwnMusic.checkState == .checked{
                returnArr.append(conditionType.playsOwnMusic.rawValue)
            }
            if playsYourMusic.checkState == .checked{
                returnArr.append(conditionType.playsYourMusic.rawValue)
            }
            if dontTalkMuch.checkState == .checked{
                returnArr.append(conditionType.dontTalkMuch.rawValue)
            }
            if talkative.checkState == .checked{
                returnArr.append(conditionType.talkative.rawValue)
            }
        
        return returnArr
    }
    
    func secondsToHoursMinutesSeconds (seconds : Double) -> (Double) {
        return (Double(seconds / 3600))
    }
    
    func determineH() -> Date? {
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let now = Date()
        var components = gregorian.components([.year, .month, .day, .hour, .minute, .second], from: now )
        
        if components.minute != 0 {
            components.hour = components.hour! + 1
            components.minute = 0
        }
        
        let date = gregorian.date(from: components)!
        return date
    }
    
    func HwithHourMore() -> Date?{
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let now = determineH()
        var components = gregorian.components([.year, .month, .day, .hour, .minute, .second], from: now! )
        
            components.hour = components.hour! + 1
            components.minute = 0
        
        
        let date = gregorian.date(from: components)!
        return date
    }
    
    func prepAllCheckBox(boxes: [M13Checkbox]){
        for box in boxes{
            box.boxType = .square
            box.markType = .radio
            box.secondaryTintColor = UIColor.white
            box.tintColor = UIColor.white
            box.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func mapTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "fromRequestToMap", sender: self)
    }
    @IBAction func fromTimeTapped(_ sender: Any) {
        
        let picker = DatePickerDialog(textColor: UIColor().mainBackgroundColor_Dark(), buttonColor: UIColor().mainBackgroundColor_Dark(), font: UIFont(name: "Ubuntu", size: 15)!, locale: nil, showCancelButton: true)
            picker.datePicker.minuteInterval = 30
        picker.show("From:", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: Date(), minimumDate: determineH(), maximumDate: nil, datePickerMode: .dateAndTime) { (date) in
            if date != nil{
                self.fromTime.titleLabel?.text = date?.toString()
                self.from = date
                self.dateSelected[0] = true
            }
        }
    }
    
    @IBAction func untilTimeTapped(_ sender: Any) {
        let picker = DatePickerDialog(textColor: UIColor().mainBackgroundColor_Dark(), buttonColor: UIColor().mainBackgroundColor_Dark(), font: UIFont(name: "Ubuntu", size: 15)!, locale: nil, showCancelButton: true)
        picker.datePicker.minuteInterval = 30
        picker.show("Until:", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: Date(), minimumDate: HwithHourMore(), maximumDate: nil, datePickerMode: .dateAndTime) { (date) in
            if date != nil{
                self.untilTime.titleLabel?.text = date?.toString()
                self.until = date
                self.dateSelected[1] = true
            }
        }
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        if until == nil || from == nil{
            showAlertAction(VC: self, title: "Not Yet!", message: "Please fully select date!", type: .alert)
        }
        else if self.price! <= Double(0) {
            showAlertAction(VC: self, title: "Not Yet!", message: "Please recheck your date!", type: .alert)
        }
        else{
        reverseGeocoding(geopoint: (locationStruct?.coordinate)!) { (tuple) in
            let request = Request()
            request.pickUpTime = self.from
            request.endTime = self.until
            request.pickUpLocation = GeoPoint(latitude: (self.locationStruct?.coordinate.latitude)!, longitude: (self.locationStruct?.coordinate.longitude)!)
            request.price = self.price!
            request.conditions = self.getConditions()
            request.city = tuple?.1
            request.country = tuple?.0
            self.request = request
            self.performSegue(withIdentifier: "fromPrepareToDriverSearchResult", sender: self)
        }
        }
        
       
    }
    
    func reverseGeocoding(geopoint:GeoPoint, completion: @escaping (((String, String)?) -> Void)){
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: geopoint.latitude, longitude: geopoint.longitude)) { response, error in
            //
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            } else {
                if let places = response?.results() {
                    if let place = places.first {
                        print(place.country, place.locality)
                        completion((place.country, place.locality) as! (String, String))
                    } else {
                        print("GEOCODE: nil first in places")
                        completion(nil)
                    }
                } else {
                    print("GEOCODE: nil in places")
                    completion(nil)
                }
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "fromRequestToMap"{
            let nVc = segue.destination as! MapCurrentLocationViewController
            nVc.locStruct = self.locationStruct
            nVc.prioritizeLocation = true
        }
        else if segue.identifier == "fromPrepareToDriverSearchResult"{
            let nVc = segue.destination as! SearchDriversResultPageTableViewController
            nVc.request = self.request
           
            
        }
    }
    

}
