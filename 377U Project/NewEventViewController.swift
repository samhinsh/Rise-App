//
//  NewEventViewController.swift
//  377U Project
//
//  Created by Samuel Hinshelwood on 5/5/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit
import Firebase

class NewEventViewController: UIViewController, UITextFieldDelegate {
    
    var location: (latitude: Double, longitude: Double)?
    
    /* User event-details input text fields */
    
    @IBOutlet weak var eventNameTextField: UITextField!
    
    @IBOutlet weak var eventDescriptionTextField: UITextField!
    
    @IBOutlet weak var eventTagTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func CloseNewEvent(sender: AnyObject) {
        let tracker = GAI.sharedInstance().defaultTracker
        
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Close Event", action: "Cancel New Event", label: "New event not created ", value: nil).build() as [NSObject : AnyObject])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "New Event Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private struct Storyboard {
        static let CancelNewEventRegistrationIdentifier = "Cancel New Event"
        static let RegisterNewEventWithServerIdentifier = "Send New Event"
    }
    
    // Mark: - TextField Delegation
    
    // default behavior of text field on return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder() // hide keyboard
        return true // perform default behavior
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        textField.text = nil;
        textField.textColor = UIColor.blackColor()
        
        if textField == eventTagTextField {
            textField.text = "#"
        }
        
        if textField == eventTagTextField {
            scrollView.setContentOffset(CGPointMake(0, 50), animated: true)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" || (textField == eventTagTextField && textField.text == "#") {
            textField.text = "(Required)"
            textField.textColor = UIColor.darkGrayColor()
        }
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationvc = segue.destinationViewController
        if let navcon = destinationvc as? UINavigationController {
            destinationvc = navcon.visibleViewController ?? destinationvc
        }
        if let _ = destinationvc as? StartScreenViewController {
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
                    //work on getting coordinates
                    
                    var coordinate: String {
                        if let _location = location {
                            return "\(_location.latitude),\(_location.longitude)"
                        }
                        return "37.4320965,-122.1605481" // default
                    }
                    
                    print("The coordinate was: \(coordinate)")
                    
                    let myRootRef = Firebase(url:"https://radiant-torch-3623.firebaseio.com")
                    let newEvent = ["title" : String(eventTitle!),
                                    "about" : String(eventAbout!),
                                    "coordinates" : coordinate,
                                    "media" : ["newEvent.png"],
                                    "hashtag" : String(eventHashtag!)
                    ]
                    
                    let eventsRef = myRootRef.childByAppendingPath("events")
                    eventsRef.childByAppendingPath(String(eventTitle!)).setValue(newEvent)
                    
                    
                case Storyboard.CancelNewEventRegistrationIdentifier: break
                default: break
                }
            }
        }
    }
    
    // stop the graph segway if a fully formed function has not been input
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
    {
        switch identifier {
            
        // TODO: more validation
        case Storyboard.RegisterNewEventWithServerIdentifier:
            if eventNameTextField.text == "(Required)" ||  eventDescriptionTextField.text == "(Required)" || eventTagTextField.text == "(Required)" {
                return false
            }
        default: break
        }
        return true
    }
}
