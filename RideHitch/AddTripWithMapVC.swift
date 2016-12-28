//
//  AddTripWithMapVC.swift
//  RideHitch
//
//  Created by Andrew Roach on 12/28/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit
import MapKit


class AddTripWithMapVC: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var routesSegmentedControl: UIToolbar!
    
    var locationManager: CLLocationManager?

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if searchBar.text == "" {
//            let RI = RealmInteractor()
//            let data = RI.fetchFavoritePlaces()
//            return (data?.count)!
//        }
//            
//        else if GPF.results != nil {
//            return GPF.results!.count
//        }
//        else {
//            return 0
//        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
//        if searchBar.text == "" {
//            let RI = RealmInteractor()
//            let data = RI.fetchFavoritePlaces()
//            cell.textLabel?.text = data?[indexPath.row].placeName
//        }
//        else {
//            
//            let autocompletePlace = GPF.results?[indexPath.row]
//            cell.textLabel?.text = autocompletePlace?.attributedFullText.string
//        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if searchBar.text == "" {
//            let RI = RealmInteractor()
//            let data = RI.fetchFavoritePlaces()
//            let favoritePlace = data?[indexPath.row]
//            GPF.fetchPlaceForAutocompletePrediction(prediction: nil, id: (favoritePlace?.placeID)!)
//        }
//        else {
//            let destination = GPF.results?[indexPath.row]
//            GPF.fetchPlaceForAutocompletePrediction(prediction: destination!, id: (destination?.placeID)!)
//        }
//        
        tableView.isHidden = true
        searchBar.resignFirstResponder()
        searchBar.text = ""
        
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
        tableView.reloadData()
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        
//        let GPF = GooglePlaceFetcher.sharedInstance
//        
//        let nePoint = CGPoint(x: self.mapView.bounds.origin.x + mapView.bounds.size.width, y: mapView.bounds.origin.y)
//        let swPoint = CGPoint(x: self.mapView.bounds.origin.x, y: (mapView.bounds.origin.y + mapView.bounds.size.height))
//        let neCord = mapView.convert(nePoint, toCoordinateFrom: mapView)
//        let swCord = mapView.convert(swPoint, toCoordinateFrom: mapView)
//        
//        let bounds = GMSCoordinateBounds(coordinate: neCord, coordinate: swCord)
        
//        GPF.fetchPlacesForString(string: searchText, bounds: bounds)
    }
    
    
    
    
    
    

}
