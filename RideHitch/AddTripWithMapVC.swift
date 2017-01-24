//
//  AddTripWithMapVC.swift
//  RideHitch
//
//  Created by Andrew Roach on 12/28/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces
import RealmSwift
import AWSMobileHubHelper
import AWSCognitoIdentityProvider


class AddTripWithMapVC: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var routesToolbar: UIToolbar!
    var routesSegmentedControl: UISegmentedControl!
    
    var locationManager: CLLocationManager?
    
    var currentResult: GMSPlace?
    var results: [GMSAutocompletePrediction]?

    let RouteCalc = RouteCalculator.sharedInstance
    var currentLocation: CLLocation?
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        tableView.isHidden = true
        nextButton.isEnabled = false
        routesToolbar.isHidden = true
        requestLocationData()
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddTripWithMapVC.routesReady), name: NSNotification.Name(rawValue: "RouteCalculated"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "RouteCalculated"), object: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "configureTripSegue" {
            let dV = segue.destination as! ConfigureTripVC
            
            let newTrip = TripTable()!
            newTrip._creationDate = NSDate().timeIntervalSince1970 as Double
            newTrip._creatorUserID = AWSIdentityManager.defaultIdentityManager().identityId!
            newTrip._isDriver = false
            
            newTrip._isMatched = false
            newTrip._originLatitude = (currentLocation?.coordinate.latitude)! as Double
            newTrip._originLongitude = (currentLocation?.coordinate.longitude)! as Double
            newTrip._originName = "Current Location"
            newTrip._destinationLatitude = (currentResult?.coordinate.latitude)! as Double
            newTrip._destinationLongitude = (currentResult?.coordinate.longitude)! as Double
            newTrip._destinationName = (currentResult?.name)!
            newTrip._tripID = Int(arc4random())
            newTrip._polygonGeohash = RouteCalculator.sharedInstance.routePolygonGeohash!
            dV.trip = newTrip
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text == "" {
            let RI = RealmInteractor()
            let data = RI.fetchFavoritePlaces()
            return (data?.count)!
        }
        else if results != nil {
            return results!.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if searchBar.text == "" {
            let RI = RealmInteractor()
            let data = RI.fetchFavoritePlaces()
            cell.textLabel?.text = data?[indexPath.row].placeName
        }
        else {
            
            let autocompletePlace = results?[indexPath.row]
            cell.textLabel?.text = autocompletePlace?.attributedFullText.string
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placeFetcher = GooglePlaceFetcher()

        if searchBar.text == "" {
            let RI = RealmInteractor()
            let data = RI.fetchFavoritePlaces()
            let favoritePlace = data?[indexPath.row]
            placeFetcher.fetchPlaceForAutocompletePrediction(prediction: nil, id: (favoritePlace?.placeID)!)  { result in
                
                self.currentResult = result
                self.addPlaceToMap()
            }
        }
        else {
            let destination = results?[indexPath.row]
            placeFetcher.fetchPlaceForAutocompletePrediction(prediction: destination!, id: (destination?.placeID)!) { result in
                self.currentResult = result
                self.addPlaceToMap()
            }
        }
        
        tableView.isHidden = true
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
        tableView.reloadData()
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        let placeFetcher = GooglePlaceFetcher()

        let nePoint = CGPoint(x: self.mapView.bounds.origin.x + mapView.bounds.size.width, y: mapView.bounds.origin.y)
        let swPoint = CGPoint(x: self.mapView.bounds.origin.x, y: (mapView.bounds.origin.y + mapView.bounds.size.height))
        let neCord = mapView.convert(nePoint, toCoordinateFrom: mapView)
        let swCord = mapView.convert(swPoint, toCoordinateFrom: mapView)
        
        let bounds = GMSCoordinateBounds(coordinate: neCord, coordinate: swCord)
        
        placeFetcher.fetchPlacesForString(string: searchText, bounds: bounds) { results in
            self.results = results
            self.tableView.reloadData()
        }
    }
    
    
    func addPlaceToMap() {
        if let place = self.currentResult {
            let mapPin = WaypointMapAnnotation(title: place.name, subtitle: nil, coordinate: place.coordinate, color: UIColor.red)
            mapView.addAnnotation(mapPin)
            mapView.selectAnnotation(mapPin, animated: true)
            calculateRouteToPlace(place: place)
        }
    }
    
    
    func calculateRouteToPlace(place: GMSPlace) {
        
        let sourcePlacemark = MKPlacemark(coordinate: (currentLocation?.coordinate)!)
        let destinationPlacemark = MKPlacemark(coordinate: place.coordinate)
        RouteCalc.calculateDirectionsForPlacemark(fromPlace: sourcePlacemark, toPlace: destinationPlacemark)
    }
    
    
    func routesReady() {
        addSegmentedControl()
        addRouteToMap(withIndex: 0)
    }
    
    //Addes the route to map and then adds the polygon points to the map in green
    func addRouteToMap(withIndex: Int) {
        nextButton.isEnabled = true

        mapView.removeOverlays(mapView.overlays)
        

        let route = RouteCalc.routes![withIndex]
        self.mapView.addOverlays([(route.polyline)], level: .aboveRoads)

        
        let routePolygon = RouteCalc.routePolygonPonts
        for point in routePolygon! {
            let wMA = WaypointMapAnnotation(title: nil, subtitle: nil, coordinate: CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude), color: UIColor.green)
            self.mapView.addAnnotation(wMA)
        }
        addOverlay(points: routePolygon!)

    }
    
    
    
    func addSegmentedControl() {
        
        let segmentedControl = UISegmentedControl()
        segmentedControl.addTarget(self, action: #selector(AddTripWithMapVC.changeRoute), for: .valueChanged)
    
        if let numRoutes = RouteCalc.routes?.count {
                for i in 1...numRoutes {
                    segmentedControl.insertSegment(withTitle: "Route \(String(i))", at: i-1, animated: false)
                }
        }
        segmentedControl.isMomentary = false
        segmentedControl.frame = CGRect(x: 50, y: 50, width: routesToolbar.frame.width - 20, height: 30)

        segmentedControl.selectedSegmentIndex = 0
        
        let barItem = UIBarButtonItem(customView: segmentedControl)
        let barSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barObjects: Array<UIBarButtonItem> = [barSpace,barItem,barSpace]
        self.routesToolbar.items = barObjects
        
        
        routesToolbar.isHidden = false

        
    }
    
    func changeRoute(sender: UISegmentedControl){
        addRouteToMap(withIndex: sender.selectedSegmentIndex)
    }
    
    
    func addOverlay(points: [CLLocationCoordinate2D])
    {
        let polygon = MKPolygon(coordinates: points, count: points.count)
        self.mapView.add(polygon)
    }
    
    
    func addCoordsToMap(coords:[Dictionary<String, AnyObject>] ) {
        for dictPair in coords {
            let lat = dictPair["latitude"]!
            let long = dictPair["longitude"]!
            
            let mapPin = WaypointMapAnnotation(title: nil, subtitle: nil, coordinate: CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees), color: UIColor.green)
            
            mapView.addAnnotation(mapPin)
            
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if (overlay is MKPolyline) {
            polylineRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.75)
            polylineRenderer.lineWidth = 5
            mapView.setVisibleMapRect(overlay.boundingMapRect, edgePadding: UIEdgeInsetsMake(50.0, 50.0, 50.0, 50.0), animated: true)
        }
            
        else if (overlay is MKPolygon) {
            
            polylineRenderer.fillColor = UIColor.black
            polylineRenderer.strokeColor = UIColor.green.withAlphaComponent(1.0)
            
            polylineRenderer.alpha = 1.0
            polylineRenderer.lineWidth = 5
            
        }
        
        return polylineRenderer
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation.isKind(of: MKUserLocation.self)
        {
            return nil
        }
        else if annotation.isKind(of: WaypointMapAnnotation.self){
            let waypointAnnotation = annotation as! WaypointMapAnnotation
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinAnnotationView.pinTintColor = waypointAnnotation.color
            pinAnnotationView.canShowCallout = waypointAnnotation.title == nil ? false : true
            
            
            return pinAnnotationView
        }
        else {
            return nil
        }
    }

    
    func requestLocationData() {
        let location: PrivateResource = .location(.whenInUse)
        proposeToAccess(location, agreed: {
            self.locationManager = CLLocationManager()
            self.locationManager!.delegate = self
            self.locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager!.startUpdatingLocation()
        }, rejected: {
            print("Location denied")
        })
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region = MKCoordinateRegionMake(center, MKCoordinateSpanMake(0.05, 0.05))
            currentLocation = location
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
            mapView.delegate = self
            locationManager!.stopUpdatingLocation()
            locationManager = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        print(error)
    }
    
    
    
    

}
