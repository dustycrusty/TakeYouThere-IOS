//
//  SearchResultPageViewController.swift
//  TYT
//
//  Created by 이승윤 on 2018. 12. 19..
//  Copyright © 2018년 Dustin Lee. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Hero
import TextFieldEffects
import Firebase

struct cellData {
    var opened = Bool()
    var text = String()
    var extraText = String()
    var coord = GMSPlace()
}

class SearchResultPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    var selectedSection:Int?
    
    var placesClient:GMSPlacesClient!
    
    var tableViewData = [cellData]()
    
    @IBOutlet weak var searchfield:HoshiTextField!
    
    @IBOutlet weak var tableview:UITableView!
    
    var fetcher: GMSAutocompleteFetcher?

    var string:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        
        fetcher = GMSAutocompleteFetcher(bounds: nil, filter: filter)
        fetcher?.delegate = self as GMSAutocompleteFetcherDelegate
        searchfield.addTarget(self, action: #selector(SearchResultPageViewController.textFieldDidChanged(_:)), for: UIControl.Event.allEvents)
        if string != ""{
            searchfield.text = string
            fetcher?.sourceTextHasChanged(searchfield.text)
        }
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.reloadData()
        
        
        
        tableview.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellReuseIdentifier: "SearchResultCell")
         tableview.register(UINib(nibName: "SearchResultCell_MapView", bundle: nil), forCellReuseIdentifier: "SearchResult_MapCell")
        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldDidChanged(_ textField:UITextField ){
        print(searchfield.text!)
        fetcher?.sourceTextHasChanged(searchfield.text!)
    }
    
    @objc func tapButtonTapped(_ sender: UIButton){
        let vc = sender.parentContainerViewController() as! SearchResultPageViewController
        let ip = vc.tableview.indexPath(for: sender.superview?.superview as! SearchResultCell)
        selectedSection = ip?.section
        print(selectedSection)
        self.performSegue(withIdentifier: "fromSearchResultToPrepareRequest", sender: self)
    }
    @objc func mapTapped(_ sender: UIButton){
        print("map tapped")
//        print(sender.superview?.superview?.superview)
        let vc = sender.parentContainerViewController() as! SearchResultPageViewController
        let ip = vc.tableview.indexPath(for: sender.superview?.superview as! SearchResult_MapCell)
       selectedSection = ip?.section
        print(selectedSection)
         self.performSegue(withIdentifier: "fromSearchToMap", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true{
            return 2
        }
        else{
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") as! SearchResultCell
            cell.addressLabel.text = tableViewData[indexPath.section].text
            cell.extraInfo.text = tableViewData[indexPath.section].extraText
            cell.tapButton.addTarget(self, action: #selector(tapButtonTapped(_:)), for: .touchUpInside)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResult_MapCell") as! SearchResult_MapCell
            let place = tableViewData[indexPath.section].coord
            let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 10)
            cell.mapView.camera = camera
            mapStyler(mapView: cell.mapView)
            let marker = GMSMarker()
            marker.position = place.coordinate
            marker.icon = UIImage(named: "TYTLocationIndicator")
            marker.map = cell.mapView
            cell.mapView.settings.setAllGesturesEnabled(false)
            cell.button.addTarget(self, action: #selector(self.mapTapped(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath)
        if tableViewData[indexPath.section].opened == true{
            tableViewData[indexPath.section].opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .fade)
           
        }else{
            tableViewData[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "fromSearchToMap"{
            let newVC = segue.destination as! MapCurrentLocationViewController
            newVC.prioritizeLocation = true
            let locStruct = locationStructure(fullAddress: tableViewData[selectedSection!].extraText, shortAddress: tableViewData[selectedSection!].text, coordinate: GeoPoint(latitude: tableViewData[selectedSection!].coord.coordinate.latitude, longitude: tableViewData[selectedSection!].coord.coordinate.longitude))
            newVC.locStruct = locStruct
        }
        else if segue.identifier == "fromSearchResultToPrepareRequest"{
            let newVc = segue.destination as! PrepareRequestViewController
            let locStruct = locationStructure(fullAddress: tableViewData[selectedSection!].extraText, shortAddress: tableViewData[selectedSection!].text, coordinate: GeoPoint(latitude: tableViewData[selectedSection!].coord.coordinate.latitude, longitude: tableViewData[selectedSection!].coord.coordinate.longitude))
            newVc.locationStruct = locStruct
        }
    }
    

}

extension SearchResultPageViewController: GMSAutocompleteFetcherDelegate {
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        tableViewData.removeAll()
        
        for prediction in predictions {
            if prediction.placeID != nil{
                placesClient.lookUpPlaceID(prediction.placeID!) { (place, error) in
                    if error != nil{
                        print("here1", error!.localizedDescription)
                    }
                    else{
                        self.tableViewData.append(cellData(opened: false, text: prediction.attributedPrimaryText.string, extraText: (prediction.attributedSecondaryText?.string) ?? "", coord: place!))
                    }
                    self.tableview.reloadData()
                }
            print("\n",prediction.attributedFullText.string)
            //print("\n",prediction.attributedPrimaryText.string)
            print("\n********")
            }
        }
        
        
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print("here", error.localizedDescription)
    }
}


