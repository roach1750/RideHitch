//
//  ResultsMapVC.swift
//  RideHitch
//
//  Created by Andrew Roach on 2/1/17.
//  Copyright © 2017 Andrew Roach. All rights reserved.
//

import UIKit
import MapKit

class ResultsMapVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var selectedTrip: RealmTrip?
    var potentialTrips: [RealmTrip]?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
    
        self.title = selectedTrip?._destinationName
        super.viewDidLoad()
        addTripToMap(trip: self.selectedTrip!)
        
        let LI = LambdaInteractor()
        LI.callCloudFunction(trip: selectedTrip!) { results in
            
            self.potentialTrips = results
            self.tableView.reloadData()
            
        }
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        let LI = LambdaInteractor()
        
        LI.callCloudFunction(trip: selectedTrip!) { results in
            
            
            self.potentialTrips = results
            self.tableView.reloadData()
        
        }
        
        
        
        
        
        
    }

    func addTripToMap(trip:RealmTrip) {
        
        let originMapPin = WaypointMapAnnotation(title: "", subtitle: nil, coordinate: CLLocationCoordinate2DMake(trip._originLatitude, trip._originLongitude), color: UIColor.red)
        mapView.addAnnotation(originMapPin)
        
        let destinationMapPin = WaypointMapAnnotation(title: "", subtitle: nil, coordinate: CLLocationCoordinate2DMake(trip._destinationLatitude, trip._destinationLongitude), color: UIColor.red)
        mapView.addAnnotation(destinationMapPin)
        
        mapView.showAnnotations(mapView.annotations, animated:false)
    }
    
    
    ///////////TABLEVIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if potentialTrips != nil {
        
            return (potentialTrips?.count)!
        
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "potentialMatchCell", for: indexPath)
        let trip = potentialTrips?[indexPath.row]
        cell.textLabel?.text = trip?._destinationName
        cell.detailTextLabel?.text = "Creator ID: "  + (trip?._creatorUserID)!
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ////////////////MAP VIEW
    
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectTripSegue" {
            let dV = segue.destination as! AcceptMatchVC
            dV.selectedTrip = self.selectedTrip
            let indexPath = tableView.indexPathForSelectedRow
            let trip = potentialTrips?[(indexPath?.row)!]
            dV.matchedTrip = trip
            
            
        }
        
    }

}
