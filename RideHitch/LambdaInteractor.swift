//
//  LambdaInteractor.swift
//  RideHitch
//
//  Created by Andrew Roach on 1/11/17.
//  Copyright © 2017 Andrew Roach. All rights reserved.
//

import UIKit

class LambdaInteractor: NSObject {

    
    func callCloudFunction(trip: RealmTrip, completion: @escaping ([RealmTrip]?) -> Void) {
        
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
            "userID" : trip._creatorUserID as AnyObject,
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
            
            let jsonData = self.convertToDictionary(text: responseString!)
            print(result?.statusCode as Any)
            
            
            let items = jsonData!["Items"]! as! NSArray
            
//            print(items)
            
            
            var results = [RealmTrip]()
            
            for i in 0..<items.count {
                
                print(i)
                
                let jsonTrip = items[i] as! Dictionary<String, Any> 

                let trip = RealmTrip()
                trip._geohash = (jsonTrip["geohash"]! as! Dictionary<String, Any>)["S"] as! String
                trip._tripID =  (jsonTrip["tripID"]! as! Dictionary<String, Any>)["S"] as! String
                trip._creationDate = Double((jsonTrip["creationDate"]! as! Dictionary<String, Any>)["N"] as! String)!
                trip._creatorUserID = (jsonTrip["creatorUserID"]! as! Dictionary<String, Any>)["S"] as! String
                
                trip._destinationDate = Double((jsonTrip["destinationDate"]! as! Dictionary<String, Any>)["N"] as! String)!
                trip._destinationLatitude = Double((jsonTrip["destinationLatitude"]! as! Dictionary<String, Any>)["N"] as! String)!
                trip._destinationLongitude = Double((jsonTrip["destinationLongitude"]! as! Dictionary<String, Any>)["N"] as! String)!
                
                trip._destinationName = (jsonTrip["destinationName"]! as! Dictionary<String, Any>)["S"] as! String
                
                
//                trip._isDriver =  Bool(NSNumber(value: (jsonTrip["isDriver"]! as! Dictionary<String, Any>)["BOOL"] as! Double))
//                trip._isMatched = Bool(NSNumber(value: (jsonTrip["isMatched"]! as! Dictionary<String, Any>)["BOOL"] as! Double))
                
                trip._originDate = Double((jsonTrip["originDate"]! as! Dictionary<String, Any>)["N"] as! String)!
                trip._originLatitude = Double((jsonTrip["originLatitude"]! as! Dictionary<String, Any>)["N"] as! String)!
                trip._originLongitude = Double((jsonTrip["originLongitude"]! as! Dictionary<String, Any>)["N"] as! String)!
                
                trip._originName = (jsonTrip["originName"]! as! Dictionary<String, Any>)["S"] as! String
                trip._polygon = (jsonTrip["polygon"]! as! Dictionary<String, Any>)["S"] as! String

                
                results.append(trip)
                
            }
            
            print(results)
            
            DispatchQueue.main.async {
                completion(results)
            }
                        print("This request took: \(endTime.timeIntervalSince(startTime)) seconds")
            return nil
        })
        
        
        
    }
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    
    
    
    ///need to call the other cloud function with requestedTripID and requestedTripID
    
    func callMatchFuction(usersTrip: RealmTrip, matchedTrip: RealmTrip) {
        
        let httpMethodName = "POST"
        let URLString = "/matches"
        let queryStringParameters = ["key1":"value1"]
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let date = NSDate().timeIntervalSince1970
        
        let jsonObject: [String: AnyObject] = [
            "requestedTripID": matchedTrip._tripID as AnyObject,
            "requesterTripID": usersTrip._tripID as AnyObject,
            "creationDate": date as AnyObject
        ]
        
        
        // Construct the request object
        let apiRequest = AWSAPIGatewayRequest(httpMethod: httpMethodName,
                                              urlString: URLString,
                                              queryParameters: queryStringParameters,
                                              headerParameters: headerParameters,
                                              httpBody: jsonObject)
    
        let invocationClient = AWSAPI_W7L04QUFUB_HitchAPIMobileHubClient.init(forKey: AWSCloudLogicDefaultConfigurationKey)
        
        
        invocationClient.invoke(apiRequest).continue({(task: AWSTask) -> AnyObject? in
           
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
            
            let jsonData = self.convertToDictionary(text: responseString!)
            
            print(result?.statusCode as Any)
            
            
            return nil
            
        })
    
    
    
    
    
    
    
    }
    
    
    

    
    
    
}
