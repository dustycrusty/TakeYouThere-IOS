//
//  MapCurrentLocationViewController.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 19..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase

protocol popWithData
{
    func popWithDataResponse(locStruct: locationStructure)
}

class MapCurrentLocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var labelContainingView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var zoomLevel: Float = 15.0
    
    var placesClient:GMSPlacesClient!
    
    var delegate: popWithData?

    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    var prioritizeLocation:Bool = false
    var locationSelected:GMSPlace?
    

    var updated = false
    
    var locStruct: locationStructure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
//        self.hero.isEnabled = true
//        mapView.hero.id = "map"
//        labelContainingView.hero.modifiers = [.translate(y:100)]
//        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.activityType = .automotiveNavigation
        locationManager.distanceFilter = 10.0
        mapView.delegate = self
        mapStyler(mapView: mapView)
        
//        let camera = GMSCameraPosition.camera(
//            withLatitude: defaultLocation.coordinate.latitude,
//            longitude: defaultLocation.coordinate.longitude,
//            zoom: zoomLevel)
        mapView.settings.myLocationButton = false
//        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
        mapView.isHidden = true
        

        if CLLocationManager.locationServicesEnabled() {
            print("success")
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
        else{
            print("failed")
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locationManager.requestWhenInUseAuthorization()
        labelContainingView.layer.cornerRadius = labelContainingView.frame.size.height / 2
        
    }
    
    func reverseGeocoding(geopoint:GeoPoint){
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: geopoint.latitude, longitude: geopoint.longitude)) { response, error in
            //
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            } else {
                if let places = response?.results() {
                    if let place = places.first {
                        

                        if let lines = place.lines {
                            var str:String = ""
                            for x in lines{
                                str += x + " "
                            }
                            self.locStruct = locationStructure(fullAddress: str, shortAddress: place.lines?[0] ?? "", coordinate: GeoPoint(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
                            print("GEOCODE: Formatted Address: \(lines)")
                            self.addressLabel.text = lines[0]
                            if self.mapView.isHidden{
                                self.mapView.isHidden = false
                            }
                            
                        }
                        
                    } else {
                        print("GEOCODE: nil first in places")
                    }
                } else {
                    print("GEOCODE: nil in places")
                }
            }
        }
    }
    
    @IBAction func selectTapped(sender: Any){
        let count = self.navigationController?.viewControllers.count
        if self.navigationController?.viewControllers[count! - 2].isKind(of: PrepareRequestViewController.self) == true{
            let a = self.navigationController?.viewControllers[count! - 2] as! PrepareRequestViewController
            a.locationStruct = locStruct
            self.navigationController?.popViewController(animated: true)
        }
        else{
        
        self.performSegue(withIdentifier: "fromMapToRequest", sender: self)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "fromMapToRequest"{
            let nVC = segue.destination as! PrepareRequestViewController
           nVC.locationStruct = locStruct
            
            
        }
    }
    

}
extension MapCurrentLocationViewController: CLLocationManagerDelegate {
    
   
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("done")
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        if prioritizeLocation == false{
        let camera = GMSCameraPosition.camera(
            withLatitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: zoomLevel)
            if mapView.isHidden {
                mapView.isHidden = false
                mapView.camera = camera
            }
        }
        else{
            let camera = GMSCameraPosition.camera(
                withLatitude: locStruct?.coordinate.latitude ?? -33.869405,
                longitude: locStruct?.coordinate.longitude ?? 151.199,
                zoom: zoomLevel)
            if mapView.isHidden && locStruct != nil{
                mapView.isHidden = false
                mapView.camera = camera
            }
        }

        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
        addressLabel.text = "Sorry, there was an error. Please try again or report to us the error."
        selectButton.titleLabel?.text = "Disabled."
        selectButton.isUserInteractionEnabled = false
        
    }
    
}
extension MapCurrentLocationViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        reverseGeocoding(geopoint: GeoPoint(latitude: position.target.latitude, longitude: position.target.longitude))
    }
    
    func mapViewSnapshotReady(_ mapView: GMSMapView) {
        reverseGeocoding(geopoint: GeoPoint(latitude: mapView.camera.target.latitude, longitude: mapView.camera.target.longitude))
    }
}

