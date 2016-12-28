//
//  RouteCalculator.swift
//  Hitch
//
//  Created by Andrew Roach on 11/12/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit
import MapKit

class RouteCalculator: NSObject {
    
    class var sharedInstance: RouteCalculator {
        struct Singleton {
            static let instance = RouteCalculator()
        }
        return Singleton.instance
    }
    
    var routes: [MKRoute]?
    var routePolygonPonts: [CLLocationCoordinate2D]?
    
    func calculateDirectionsForPlacemark(fromPlace: MKPlacemark, toPlace: MKPlacemark){
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: fromPlace)
        request.destination = MKMapItem(placemark: toPlace)
        request.transportType = .automobile
        
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            if error == nil {
                self.routes  = response?.routes
                self.calculatePolygonForRoute()
            }
        }
    }
    
    func calculateDirectionsForTrip(trip: Trip){
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: (CLLocationCoordinate2DMake((trip.originLatitude), (trip.originLongitude)))))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: (CLLocationCoordinate2DMake((trip.destinationLatitude), (trip.destinationLongitude)))))
        request.transportType = .automobile
        
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            if error == nil {
                self.routes  = response?.routes
                self.calculatePolygonForRoute()
            }
        }

    }
    
    
    
    func calculatePolygonForRoute() {
        let route = routes?[0]
        let pointCount = route?.polyline.pointCount
        let coordsPointer = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: pointCount!)
        route?.polyline.getCoordinates(coordsPointer, range: NSRange(location: 0, length: pointCount!))
        var coords: [Dictionary<String, AnyObject>] = []
        var latArray = [Double]()
        var longArray = [Double]()
        
        for i in 0..<pointCount! {
            let latitude = NSNumber(value: coordsPointer[i].latitude)
            let longitude = NSNumber(value: coordsPointer[i].longitude)
            
            latArray.append(Double(latitude))
            longArray.append(Double(longitude))
            
            let coord = ["latitude" : latitude, "longitude" : longitude]
            coords.append(coord)
        }
        
        let factor = 0.005
        let minX = latArray.min()! - factor
        let maxX = latArray.max()! + factor
        let minY = longArray.min()! - factor
        let maxY = longArray.max()! + factor
        
        let point1 = CLLocationCoordinate2DMake(CLLocationDegrees(minX), CLLocationDegrees(minY))
        let point2 = CLLocationCoordinate2DMake(CLLocationDegrees(maxX), CLLocationDegrees(minY))
        let point3 = CLLocationCoordinate2DMake(CLLocationDegrees(maxX), CLLocationDegrees(maxY))
        let point4 = CLLocationCoordinate2DMake(CLLocationDegrees(minX), CLLocationDegrees(maxY))
        routePolygonPonts = [point1, point2, point3, point4]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "RouteCalculated"), object: nil)
        
        
    }
    
    
}
