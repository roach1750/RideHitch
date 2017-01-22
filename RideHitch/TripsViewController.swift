//
//  TripsViewController.swift
//  RideHitch
//
//  Created by Andrew Roach on 12/28/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit


class TripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var riderDriverSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [RealmTrip]()
    
    override func viewDidLoad() {
        reload(UIBarButtonItem())
        tableView.tableFooterView = UIView()
        super.viewDidLoad()
    }
    
    @IBAction func reload(_ sender: UIBarButtonItem) {
        let RI = RealmInteractor()
        data = RI.fetchTrips()!
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (data.count) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row >= (data.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewRideCell", for: indexPath) as! ButtonTableViewCell
            cell.buttonActionTitleLabel.text = "Request New Ride"
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
            let trip  = data[indexPath.row]
            cell.textLabel?.text =  trip._destinationName
            cell.detailTextLabel?.text = trip._polygonGeohash
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= (data.count) {
            tableView.deselectRow(at: indexPath, animated: false)
            performSegue(withIdentifier: "addNewRide", sender: nil)
        }
        else {
            let trip = data[indexPath.row]
            let LI = LambdaInteractor()
            LI.callCloudFunction(trip: trip)

        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}
