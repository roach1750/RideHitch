//
//  FavoritePlace.swift
//  Hitch
//
//  Created by Andrew Roach on 10/26/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit
import RealmSwift

class FavoritePlace: Object {
    dynamic var placeName = ""
    dynamic var placeID = ""
    dynamic var creationDate = NSDate()
}
