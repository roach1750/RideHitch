//
//  WaypointMapAnnotation.swift
//  Hitch
//
//  Created by Andrew Roach on 10/27/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit
import MapKit

class WaypointMapAnnotation: NSObject, MKAnnotation {
    
    let title:String?
    let subtitle:String?
    let coordinate: CLLocationCoordinate2D
    let color: UIColor?
    
    init(title: String?, subtitle:String?, coordinate: CLLocationCoordinate2D, color: UIColor?)
    {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.color = color
        super.init()
    }
}
