//
//  ResultsMapVC.swift
//  RideHitch
//
//  Created by Andrew Roach on 2/1/17.
//  Copyright © 2017 Andrew Roach. All rights reserved.
//

import UIKit
import MapKit

class ResultsMapVC: UIViewController {

    var selectedTrip: RealmTrip?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
    
        self.title = selectedTrip?._destinationName
        super.viewDidLoad()
        addTripToMap(trip: self.selectedTrip!)

    }
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        
        let LI = LambdaInteractor()
        LI.callCloudFunction(trip: selectedTrip!)
        
    }

    func addTripToMap(trip:RealmTrip) {
        
        let originMapPin = WaypointMapAnnotation(title: "", subtitle: nil, coordinate: CLLocationCoordinate2DMake(trip._originLatitude, trip._originLongitude), color: UIColor.red)
        mapView.addAnnotation(originMapPin)
        
        let destinationMapPin = WaypointMapAnnotation(title: "", subtitle: nil, coordinate: CLLocationCoordinate2DMake(trip._destinationLatitude, trip._destinationLongitude), color: UIColor.red)
        mapView.addAnnotation(destinationMapPin)
        
        mapView.showAnnotations(mapView.annotations, animated:false)
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
    
    

}
