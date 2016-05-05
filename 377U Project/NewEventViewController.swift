//
//  NewEventViewController.swift
//  377U Project
//
//  Created by Samuel Hinshelwood on 5/5/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit

class NewEventViewController: UIViewController, UITextFieldDelegate {
    
    /* User event-details input text fields */
    
    @IBOutlet weak var eventNameTextField: UITextField!

    @IBOutlet weak var eventDescriptionTextField: UITextField!
    
    @IBOutlet weak var eventTagTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private struct Storyboard {
        static let CancelNewEventRegistrationIdentifier = "Cancel New Event"
        static let RegisterNewEventWithServerIdentifier = "Send New Event"
    }
    
    // default behavior of text field on return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder() // hide keyboard
        return true // perform default behavior
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if ((segue.destinationViewController as? StartScreenViewController) != nil) {
            if let identifier = segue.identifier {
                switch identifier {
                    
                // if 'Let It Rise' was pushed
                case Storyboard.RegisterNewEventWithServerIdentifier:
                    
                    print("\n\n=========\n\nOkay, sending this event to the server!\n\n=========\n\n")
                    
                    /* ========= TODO: Add Server code ========= */
                    
                    let eventTitle = eventNameTextField.text
                    let eventAbout = eventDescriptionTextField.text
                    let eventHashtag = eventTagTextField.text
                    
                    // grab the text from the UI elements (done already), jsonify them into the format used in data.json (must include all fields, even if empty, i.e. no media present)
                    
                case Storyboard.CancelNewEventRegistrationIdentifier: break
                default: break
                }
            }
        }
    }
}
