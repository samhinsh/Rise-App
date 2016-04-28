//
//  CaptureDetailViewController.swift
//  377U Project
//
//  Created by Samuel Hinshelwood on 4/28/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit

@IBDesignable class CaptureDetailViewController: UIViewController {
    
    // MARK: - Model
    
    private var thisEvent: CaptureEvent = CaptureEvent()
    
    /* Description box at the top of the screen */
    @IBOutlet private weak var eventDescription: UILabel!
    
    private var eventDescriptionDisplayValue: String {
        get {
            if eventDescription.text != nil {
                return eventDescription.text!
            }
            return ""
            
        }
        set {
            eventDescription.text = newValue
        }
    }
    
    func setModel(event: CaptureEvent) {
        thisEvent = event
    }
    
    func unpackEvent() {
        print("This event is: \(thisEvent.title)")
        eventDescriptionDisplayValue = thisEvent.about
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        unpackEvent()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
