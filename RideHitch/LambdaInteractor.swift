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
        
        let userID = AWSIdentityManager.defaultIdentityManager().identityId!
        //let httpBody = "{\"currentUserID" : userID }"
        
        
        let jsonObject: [String: AnyObject] = [
            "userID": userID as AnyObject,
            "geohash" : trip._geohash as AnyObject,
            "polygon" : ["latMax" : "15"] as AnyObject
        ]
        
        print(jsonObject)
        
        let apiRequest = AWSAPIGatewayRequest(httpMethod: httpMethodName, urlString: URLString, queryParameters: queryStringParameters, headerParameters: headerParameters, httpBody: jsonObject)
        
        
//        let cloudLogicAPI = CloudLogicAPI(displayName: "riderPolygonFinder",apiDescription: "", paths: ["/items", "/items/123",                ],
//                                          endPoint: "https://03rmtzmv63.execute-api.us-east-1.amazonaws.com/Development",
//                                          apiClient: AWSAPI_03RMTZMV63_RiderPolygonFinderMobileHubClient.init(forKey: AWSCloudLogicDefaultConfigurationKey)
//        )
        
        
        
        let cloudLogicAPI2 =   CloudLogicAPI(displayName: "funcitonTwo",
                                             apiDescription: "",
                                             paths: [
                                                "/items", "/items/123",                ],
                                             endPoint: "https://wm412qkrjb.execute-api.us-east-1.amazonaws.com/Development",
                                             apiClient: AWSAPI_WM412QKRJB_FuncitonTwoMobileHubClient.init(forKey: AWSCloudLogicDefaultConfigurationKey)
        )
        
        
        
        cloudLogicAPI2.apiClient?.invoke(apiRequest).continue({ (task) -> Any? in
            let result = task.result!
            let responseString = String(data: result.responseData!, encoding: String.Encoding.utf8)
            
            print(responseString!)
            print(result.statusCode)
            print(result.headers)
            
            return nil
            
            
        }, cancellationToken: nil)
        
        
        
        
        
    }
    
    
}
