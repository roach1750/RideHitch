//
//  RealmTrip.swift
//  RideHitch
//
//  Created by Andrew Roach on 1/17/17.
//  Copyright © 2017 Andrew Roach. All rights reserved.
//

import UIKit
import RealmSwift

class RealmTrip: Object {
    
    dynamic var _geohash = ""
    dynamic var _tripID = ""
    dynamic var _creationDate = 0.0
    dynamic var _creatorUserID = ""
    dynamic var _destinationDate = 0.0
    dynamic var _destinationLatitude = 0.0
    dynamic var _destinationLongitude = 0.0
    dynamic var _destinationName = ""
    dynamic var _isDriver = false
    dynamic var _isMatched = false
    dynamic var _originDate = 0.0
    dynamic var _originLatitude = 0.0
    dynamic var _originLongitude = 0.0
    dynamic var _originName = ""
    dynamic var _polygon = ""

    
    
}
