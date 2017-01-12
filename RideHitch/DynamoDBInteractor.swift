//
//  DynamoDBInteractor.swift
//  RideHitch
//
//  Created by Andrew Roach on 12/29/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit
import AWSDynamoDB
import AWSMobileHubHelper
import AWSLambda

class DynamoDBInteractor: NSObject {

    
    func uploadTrip(trip: TripTable) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        objectMapper.save(trip) { (error) in
            if let error = error {
                print(error)
                return
            }
            print("Success")
        }
    
    }
    
    
    
    
    
}
