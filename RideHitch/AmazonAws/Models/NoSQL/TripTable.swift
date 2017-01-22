//
//  TripTable.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.8
//

import Foundation
import UIKit
import AWSDynamoDB

class TripTable: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _tripID = 0
    var _creationDate = 0.0
    var _creatorUserID = ""
    var _destinationDate = 0.0
    var _destinationLatitude = 0.0
    var _destinationLongitude = 0.0
    var _destinationName = ""
    var _destinationGeohash = ""
    var _isDriver =  false
    var _isMatched = false
    var _originDate = 0.0
    var _originLatitude = 0.0
    var _originLongitude = 0.0
    var _originName = ""
    var _originGeohash = ""
    var _polygonGeohash = ""


    
    class func dynamoDBTableName() -> String {

        return "hitch-mobilehub-1320700761-TripTable"
    }
    
    class func hashKeyAttribute() -> String {

        return "_tripID"
    }
    
    public override static func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
               "_tripID" : "tripID",
               "_creationDate" : "creationDate",
               "_creatorUserID" : "creatorUserID",
               "_destinationCoordinates" : "destinationCoordinates",
               "_destinationDate" : "destinationDate",
               "_destinationLatitude" : "destinationLatitude",
               "_destinationLongitude" : "destinationLongitude",
               "_destinationName" : "destinationName",
               "_destinationGeohash" : "destinationGeohash",
               "_isDriver" : "isDriver",
               "_isMatched" : "isMatched",
               "_originCoordinates" : "originCoordinates",
               "_originDate" : "originDate",
               "_originLatitude" : "originLatitude",
               "_originLongitude" : "originLongitude",
               "_originName" : "originName",
               "_originGeohash" : "originGeohash",
               "_polygonGeohash" : "polygonGeohash"

        ]
    }
}
