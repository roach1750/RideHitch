//
//  GooglePlaceFetcher.swift
//  Hitch
//
//  Created by Andrew Roach on 10/21/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit
import GooglePlaces
import RealmSwift


class GooglePlaceFetcher: NSObject {
    
    class var sharedInstance: GooglePlaceFetcher {
        struct Singleton {
            static let instance = GooglePlaceFetcher()
        }
        return Singleton.instance
    }
    
    var placesClient = GMSPlacesClient()
    
    var results: [GMSAutocompletePrediction]?
    
    func fetchPlacesForString(string: String, bounds: GMSCoordinateBounds){
        placesClient = GMSPlacesClient.shared()
        let filter = GMSAutocompleteFilter()
        
        
        filter.type = .noFilter
        
        placesClient.autocompleteQuery(string, bounds: bounds, filter: filter) { (results, error) in
            if error != nil {
                print(error as! String)
            }
            else {
                self.results = results
                NotificationCenter.default.post(name: Notification.Name(rawValue: "GoogleAutoCompleteDone"), object: nil)

            }
        }
    }
    
    var currentResult: GMSPlace?
    
    func fetchPlaceForAutocompletePrediction(prediction: GMSAutocompletePrediction?, id: String ) {
        if prediction != nil {
            let favoritePlace = FavoritePlace()
            favoritePlace.placeID = (prediction?.placeID!)!
            favoritePlace.placeName = (prediction?.attributedFullText.string)!
            favoritePlace.creationDate = NSDate()
            let RI = RealmInteractor()
            RI.saveFavoritePlace(place: favoritePlace)
        }
        
        let placesClient = GMSPlacesClient()
        placesClient.lookUpPlaceID(id) { (result, error) in
            self.currentResult = result
            NotificationCenter.default.post(name: Notification.Name(rawValue: "GMSPlaceDownloaded"), object: nil)

        }
        
    }
    
}
