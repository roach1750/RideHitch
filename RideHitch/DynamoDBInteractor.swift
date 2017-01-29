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

    
    func uploadTrip(trip: Trips) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        objectMapper.save(trip) { (error) in
            if let error = error {
                print(error)
                return
            }
            print("Success")
            let RI = RealmInteractor()
            RI.saveAWSTrip(trip: trip)
        }
    
    }
    
    
    func query(trip: RealmTrip){
        
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#geohash = :geohash"
        queryExpression.filterExpression = "#creationDate = :creationDate"
        queryExpression.expressionAttributeNames = ["#geohash": "geohash","#creationDate": "creationDate"]
        queryExpression.expressionAttributeValues = [":geohash": trip._geohash, ":creationDate": 1485396558.101692,]
        
        objectMapper.query(Trips.self, expression: queryExpression) { (results, error) in
            print(results?.items as Any)
        }
        
        
        
        
    }
    
    
    
    
}
