//
//  LambdaInteractor.swift
//  RideHitch
//
//  Created by Andrew Roach on 1/11/17.
//  Copyright © 2017 Andrew Roach. All rights reserved.
//

import UIKit
import AWSMobileHubHelper
import AWSAPIGateway
import AWSLambda

class LambdaInteractor: NSObject {
    
    
    
    var cloudLogicAPI: CloudLogicAPI?
    
    
    
    func callCloudFunction(trip: RealmTrip) {
        
        cloudLogicAPI = CloudLogicAPIFactory.supportedCloudLogicAPIs[1]
        
        
        
        let httpMethodName = "POST"
        let URLString = "/items"
        let queryStringParameters = ["lang":"en"]
        let headerParameters = ["Accept": "application/json", "Content-Type": "application/json"]

        
        //        let httpBody = "{ \n  \"key1\":\"value1\", \n  \"key2\":\"value2\", \n  \"key3\":\"value3\"\n}"
        
//        let userID = AWSIdentityManager.defaultIdentityManager().identityId!
        //let httpBody = "{\"currentUserID" : userID }"
        
//        let polygon = ["latMax" : "15"]
        
//        let jsonObject: [String: AnyObject] = [
//            "userID": userID as AnyObject,
//            "geohash" : trip._geohash as AnyObject,
//            "polygon" : polygon as AnyObject
//        ]
//        
        
        let apiRequest = AWSAPIGatewayRequest(httpMethod: httpMethodName, urlString: URLString, queryParameters: queryStringParameters, headerParameters: headerParameters, httpBody: nil)
        
        
        print(apiRequest)
        
        cloudLogicAPI?.apiClient?.invoke(apiRequest).continue({ (task) -> Any? in
            
            
            let result = task.result! as AWSAPIGatewayResponse
        
            print(result.statusCode)
            let responseString = String(data: result.responseData!, encoding: String.Encoding.utf8)
            
            print(responseString!)
            
            return nil
            
        }, cancellationToken: nil)
        
        
        

        
        
    }
    
    
}
