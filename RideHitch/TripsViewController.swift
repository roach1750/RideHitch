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
        configureColors()
        super.viewDidLoad()
    }
    
    func configureColors(){
        //Navigation Bar
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.barTintColor = RHRED
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        //Segmented controler 
        riderDriverSegmentedControl.tintColor = RHRED
        
        //View
        view.backgroundColor = RHBACKGROUNDDARKGRREEN
        
        //Tableview
        
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        

    }
    
    @IBAction func reload(_ sender: UIBarButtonItem) {
        let RI = RealmInteractor()
        data = RI.fetchTrips()!
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (data.count) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section >= (data.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewRideCell", for: indexPath) as! ButtonTableViewCell
            cell.buttonActionTitleLabel.text = "Request New Ride"
            cell.backgroundColor = RHRED
            cell.buttonActionTitleLabel?.textColor = UIColor.white
            cell.layer.cornerRadius = 5
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
            let trip  = data[indexPath.section]
            cell.backgroundColor = RHRED
            cell.textLabel?.text =  trip._destinationName
            cell.detailTextLabel?.text = "No Matches"
            cell.layer.cornerRadius = 5
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section >= (data.count) {
            tableView.deselectRow(at: indexPath, animated: false)
            performSegue(withIdentifier: "addNewRide", sender: nil)
        }
        else {
            let trip = data[indexPath.section]
            let LI = LambdaInteractor()
            LI.callCloudFunction(trip: trip)

        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewToReturn = UIView()
        viewToReturn.backgroundColor = UIColor.clear
        return viewToReturn
    }
    
    
}
