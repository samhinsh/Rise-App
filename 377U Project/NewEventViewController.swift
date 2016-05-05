//
//  NewEventViewController.swift
//  377U Project
//
//  Created by Samuel Hinshelwood on 5/5/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit

class NewEventViewController: UIViewController {

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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if ((segue.destinationViewController as? StartScreenViewController) != nil) {
            if let identifier = segue.identifier {
                switch identifier {
                case Storyboard.RegisterNewEventWithServerIdentifier:
                    
                    print("\n\n=========\n\nOkay, sending this event to the server!\n\n=========\n\n")
                    
                    /* ========= TODO: Add Server code ========= */
                    
                case Storyboard.CancelNewEventRegistrationIdentifier: break
                default: break
                }
            }
        }
    }
}
