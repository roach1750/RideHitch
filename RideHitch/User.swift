//
//  User.swift
//  RideHitch
//
//  Created by Andrew Roach on 1/12/17.
//  Copyright © 2017 Andrew Roach. All rights reserved.
//

import UIKit
import RealmSwift


class User: Object {
    dynamic var userName = ""
    dynamic var givenName = ""
    dynamic var surName = ""
    dynamic var email = ""
    dynamic var password = ""
}
