//
//  LambdaInteractor.swift
//  RideHitch
//
//  Created by Andrew Roach on 1/11/17.
//  Copyright © 2017 Andrew Roach. All rights reserved.
//

import UIKit

class LambdaInteractor: NSObject {
    
    
    
    

    
    func callCloudFunction(trip: RealmTrip) {
        
        let httpMethodName = "POST"
        let URLString = "/items"
        let queryStringParameters = ["key1":"value1"]
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
//        let httpBody = "{ \n  \"key1\":\"value1\", \n  \"key2\":\"value2\", \n  \"key3\":\"value3\"\n}"
        
        
        let jsonObject: [String: AnyObject] = [
            "geohash": trip._geohash as AnyObject,
            "polygon": trip._polygon as AnyObject,
            "tripID": trip._tripID as AnyObject,
            "destinationDate": trip._destinationDate as AnyObject,
            "originDate": trip._originDate as AnyObject,
            "originLatitude": trip._originLatitude as AnyObject,
            "originLongitude": trip._originLongitude as AnyObject,
            "userID": trip._creatorUserID as AnyObject
        ]
        
        
        // Construct the request object
        let apiRequest = AWSAPIGatewayRequest(httpMethod: httpMethodName,
                                              urlString: URLString,
                                              queryParameters: queryStringParameters,
                                              headerParameters: headerParameters,
                                              httpBody: jsonObject)
        
        // Fetch the Cloud Logic client to be used for invocation
        let invocationClient = AWSAPI_W7L04QUFUB_HitchAPIMobileHubClient.init(forKey: AWSCloudLogicDefaultConfigurationKey)
        
        let startTime = Date()
        
        invocationClient.invoke(apiRequest).continue({(task: AWSTask) -> AnyObject? in
//            guard let strongSelf = self else { return nil } This returens when uncomments, what is the error?
            let endTime = Date()
            
            if let error = task.error {
                print("Error occurred: \(error)")
                // Handle error here
                return nil
            }
            
            if let exception = task.exception {
                print("Exception Occurred: \(exception)")
                // Handle exception here
                return nil
            }
            
            // Handle successful result here
            let result = task.result
            let responseString = String(data: (result?.responseData)!, encoding: String.Encoding.utf8)
            
            
            
            print(result?.statusCode as Any)
            
            print(responseString as Any)
            
            print("This request took: \(endTime.timeIntervalSince(startTime)) seconds")
            return nil
        })
        
        
        
    }
    
    
    
    
    
    
}
