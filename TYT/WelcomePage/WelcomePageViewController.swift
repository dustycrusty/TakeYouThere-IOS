//
//  WelcomePageViewController.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 19..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import UIKit
import TextFieldEffects
import GoogleMaps
import GooglePlaces
import Firebase

class WelcomePageViewController: UIViewController {
    @IBOutlet weak var SearchBox: HoshiTextField!
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var zoomLevel: Float = 15.0
    
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    var updated = false
    var locStruct:locationStructure?
    var placesClient:GMSPlacesClient!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("USER LOGGED IN: ", Auth.auth().currentUser?.email)
        placesClient = GMSPlacesClient.shared()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.activityType = .automotiveNavigation
        locationManager.distanceFilter = 10.0
        mapView.delegate = self
        mapStyler(mapView: mapView)
        
        let camera = GMSCameraPosition.camera(
            withLatitude: defaultLocation.coordinate.latitude,
            longitude: defaultLocation.coordinate.longitude,
            zoom: zoomLevel)
        mapView.settings.myLocationButton = false
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
        mapView.isHidden = true
        
        mapView.settings.setAllGesturesEnabled(false)
        
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
//        ApplydarkNavigationBar(navController: (self.navigationController)!)
         locationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
    }
    
    @IBAction func useCurrentLocationTapped(_ sender: Any) {
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            print("in here")
            if error != nil {
                print("in here2")
                showAlertAction(VC: self, title: "Error Occurred", message: "Please Try again.", type: UIAlertController.Style.alert)
            }
            
            if let placeLikelihood = placeLikelihoods?.likelihoods.first {
                let place = placeLikelihood.place
                let loc = locationStructure(fullAddress: place.formattedAddress ?? "", shortAddress: place.name, coordinate: GeoPoint(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
                self.locStruct = loc
                print(self.locStruct)
                self.performSegue(withIdentifier: "fromCurrentLocationToRequest", sender: self)
                
                
            }
        })
    }
    
    @IBAction func mapTapped(_ sender: Any){
        print("map tapped")
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
                        print("in here")
                        if error != nil {
                            print("in here2")
                            showAlertAction(VC: self, title: "Error Occurred", message: "Please Try again.", type: UIAlertController.Style.alert)
                        }

                        if let placeLikelihood = placeLikelihoods?.likelihoods.first {
                            let place = placeLikelihood.place
                            let loc = locationStructure(fullAddress: place.formattedAddress ?? "", shortAddress: place.name, coordinate: GeoPoint(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
                            self.locStruct = loc
                            print(self.locStruct)
                            self.performSegue(withIdentifier: "fromWelcomeToMap", sender: self)


                        }
                    })
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
                            print("GEOCODE: Formatted Address: \(lines)")
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearchResult"{
            let nVC = segue.destination as! SearchResultPageViewController
            nVC.string = SearchBox.text ?? ""
        }
        else if segue.identifier == "fromCurrentLocationToRequest"{
            let nVC = segue.destination as! PrepareRequestViewController
            nVC.locationStruct = locStruct


        }
        else if segue.identifier == "fromWelcomeToMap"{
            let nVc = segue.destination as! MapCurrentLocationViewController
            print(locStruct)
//            nVc.locStruct = locStruct!
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

extension WelcomePageViewController: CLLocationManagerDelegate {
    
   
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("done")
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        let camera = GMSCameraPosition.camera(
            withLatitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: zoomLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
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
    }
    
}
extension WelcomePageViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        reverseGeocoding(geopoint: GeoPoint(latitude: position.target.latitude, longitude: position.target.longitude))
    }
}
