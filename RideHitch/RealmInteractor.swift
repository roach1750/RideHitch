//
//  RealmFetcher.swift
//  Hitch
//
//  Created by Andrew Roach on 10/26/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit
import RealmSwift

class RealmInteractor: NSObject {
    
    
    func saveAWSTrip(trip: TripTable) {
        
        let realm = try! Realm()
        do {
            try! realm.write {
                realm.create(RealmTrip.self, value: trip, update: false)
            }
        }
    }
        
    func fetchTrips() -> [RealmTrip]? {
        let realm = try! Realm()
        let allObjects = Array(realm.objects(RealmTrip.self).sorted(byProperty: "creationDate", ascending:false))
        return allObjects
    }
    //
    //    func deleteAllRealmObjects() {
    //        let realm = try! Realm()
    //        try! realm.write {
    //            realm.deleteAll()
    //        }
    //    }
    
    
    func saveUser(user: User) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(user)
        }
    }
    
    func fetchUser() -> User?{
        let realm = try! Realm()
        let user = realm.objects(User.self)
        return user.first
    }
    
    
    
    func saveFavoritePlace(place: FavoritePlace) {
        
        let favoritePlaces = fetchFavoritePlaces()
        if (favoritePlaces?.count)! > 5 {
            let realm = try! Realm()
            let objectToDelete = realm.objects(FavoritePlace.self).sorted(byProperty: "creationDate", ascending:true).first
            try! realm.write {
                realm.delete(objectToDelete!)
            }
        }
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(place)
        }
        
    }
    
    func fetchFavoritePlaces() -> [FavoritePlace]? {
        let realm = try! Realm()
        let allObjects = Array(realm.objects(FavoritePlace.self).sorted(byProperty: "creationDate", ascending:false))
        return allObjects
    }
    
    
}
