//
//  ConfigureTripVC.swift
//  RideHitch
//
//  Created by Andrew Roach on 12/28/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit

class ConfigureTripVC: UIViewController {

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
