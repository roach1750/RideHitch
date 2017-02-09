//
//  AcceptMatchVC.swift
//  RideHitch
//
//  Created by Andrew Roach on 2/7/17.
//  Copyright © 2017 Andrew Roach. All rights reserved.
//

import UIKit

class AcceptMatchVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var selectedTrip: RealmTrip?
    var matchedTrip: RealmTrip?

    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func requestButtonPressed(_ sender: UIButton) {
    
        let LI = LambdaInteractor()
        
        LI.callMatchFuction(usersTrip: selectedTrip!, matchedTrip: matchedTrip!)
        
        
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripDetailsCell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = selectedTrip?._tripID
                cell.detailTextLabel?.text = "Trip ID"
            case 1:
                cell.textLabel?.text = selectedTrip?._destinationName
                cell.detailTextLabel?.text = "Destination Name"
            case 2:
                cell.textLabel?.text = selectedTrip?._creatorUserID
                cell.textLabel?.adjustsFontSizeToFitWidth = true
                cell.detailTextLabel?.text = "Creator Name"
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = matchedTrip?._tripID
                cell.detailTextLabel?.text = "Trip ID"
            case 1:
                cell.textLabel?.text = matchedTrip?._destinationName
                cell.detailTextLabel?.text = "Destination Name"
            case 2:
                cell.textLabel?.text = matchedTrip?._creatorUserID
                cell.textLabel?.adjustsFontSizeToFitWidth = true
                cell.detailTextLabel?.text = "Creator Name"
            default:
                break
            }
        default:
            break
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "My Trip"
        case 1:
            return "Potential Trip"
        default:
            return nil
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

