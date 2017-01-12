//
//  ConfigureTripVC.swift
//  RideHitch
//
//  Created by Andrew Roach on 12/28/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit

class ConfigureTripVC: UIViewController {

    var trip = TripTable()
    
    @IBOutlet weak var depatureTimeTextField: UITextField!
    
    @IBOutlet weak var arrivalTimeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextFieldInputView()
    }

    func initializeTextFieldInputView() {
        // Add date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.time
        datePicker.addTarget(self, action: #selector(ConfigureTripVC.updateTextField), for: UIControlEvents.valueChanged)
        depatureTimeTextField.inputView = datePicker
        arrivalTimeTextField.inputView = datePicker
        
        // Add toolbar with done button on the right
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        let flexibleSeparator = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ConfigureTripVC.doneButtonPressed))
        toolbar.items = [flexibleSeparator, doneButton]
        depatureTimeTextField.inputAccessoryView = toolbar
        arrivalTimeTextField.inputAccessoryView = toolbar

    }
    @IBAction func requestButtonPressed(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        trip?._originDate = dateFormatter.date(from: depatureTimeTextField.text!)?.timeIntervalSince1970 as NSNumber?
        trip?._destinationDate = dateFormatter.date(from: arrivalTimeTextField.text!)?.timeIntervalSince1970 as NSNumber?
        
        DynamoDBInteractor().uploadTrip(trip: trip!)
        
        
        let allViewController: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        
        for aviewcontroller : UIViewController in allViewController
        {
            if aviewcontroller is TripsViewController
            {
                _ = self.navigationController?.popToViewController(aviewcontroller, animated: true)
            }
        }
        
        
        
        
        
    }

    func doneButtonPressed(){
        view.endEditing(true)
    }
    
    func updateTextField(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        if depatureTimeTextField.isFirstResponder {
            depatureTimeTextField.text = dateFormatter.string(from: datePicker.date)
        }
        else if arrivalTimeTextField.isFirstResponder {
            arrivalTimeTextField.text = dateFormatter.string(from: datePicker.date)
        }
    }

}
