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

    var placesClient = GMSPlacesClient()
    
    func fetchPlacesForString(string: String, bounds: GMSCoordinateBounds, completion: @escaping (([GMSAutocompletePrediction]?) -> Void)){
        placesClient = GMSPlacesClient.shared()
        let filter = GMSAutocompleteFilter()
        
        
        filter.type = .noFilter
        
        
        placesClient.autocompleteQuery(string, bounds: bounds, filter: filter) { (results, error) in
            if error != nil {
                
                print(error!)
            }
            else {
                completion(results)
            }
        }
    }
    
    func fetchPlaceForAutocompletePrediction(prediction: GMSAutocompletePrediction?, id: String, completion: @escaping(GMSPlace?) -> Void) {
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
            completion(result)
        }
        
    }
    
}
