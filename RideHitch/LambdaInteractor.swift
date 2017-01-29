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
        let httpBody = "{ \n  \"key1\":\"value1\", \n  \"key2\":\"value2\", \n  \"key3\":\"value3\"\n}"
        
        // Construct the request object
        let apiRequest = AWSAPIGatewayRequest(httpMethod: httpMethodName,
                                              urlString: URLString,
                                              queryParameters: queryStringParameters,
                                              headerParameters: headerParameters,
                                              httpBody: httpBody)
        
        // Fetch the Cloud Logic client to be used for invocation
        // Change the `AWSAPI_XE21FG_MyCloudLogicClient` class name to the client class for your generated SDK
        let invocationClient = AWSAPI_W7L04QUFUB_HitchAPIMobileHubClient.init(forKey: AWSCloudLogicDefaultConfigurationKey)
        
        invocationClient.invoke(apiRequest).continue({(task: AWSTask) -> AnyObject? in
//            guard let strongSelf = self else { return nil } This returens when uncomments, what is the error?
            
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
            
            print(responseString!)
            print(result?.statusCode as Any)
            
            return nil
        })
        
        
        
    }
    
    
    
    
    
    
}
