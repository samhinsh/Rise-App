//
//  FeedbackViewController.swift
//  377U Project
//
//  Created by Samuel Hinshelwood on 5/24/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit
import Firebase

class FeedbackViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var feedbackTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackTextView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        feedbackTextView.text = ""
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let _ = segue.destinationViewController as? NewEventViewController {
            if let identifier = segue.identifier {
                switch identifier {
                
                // send user feedback to server
                case "Send Feedback":
                    
                    let feedback = feedbackTextView.text
                    let myRootRef = Firebase(url:"https://radiant-torch-3623.firebaseio.com")
                    let feedbackRef = myRootRef.childByAppendingPath("feedback")
                    let newFeedbackRef = feedbackRef.childByAutoId()
                    newFeedbackRef.setValue(feedback)
//                    feedbackRef.childByAppendingPath(String(eventTitle!)).setValue(newEvent)
                    
                    print("Sending feedback: \(feedback)")
                    
                    break // TODO: remove
                    // TODO: Insert Firebase code to send feedback to Firebase server
                    
                default:
                    break
                }
            }
        }
    }

}
