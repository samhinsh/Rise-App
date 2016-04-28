//
//  RegisterEventViewController.swift
//  377U Project
//
//  Created by Samuel Hinshelwood on 4/28/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit

@IBDesignable class RegisterEventViewController: UIViewController {
    
    @IBOutlet weak var helpLabel: UILabel!
    
    var didTouchRiseButton = false
    
    /* Rise button action */
    @IBAction func touchedRiseButton(sender: AnyObject) {
        if didTouchRiseButton == false {
            didTouchRiseButton = true
            UILabel.transitionWithView(helpLabel, duration: 0.25, options: [.TransitionCrossDissolve], animations: {
                self.helpLabel.text = (rand() % 2 == 0) ? "Take a photo!" : " "
                }, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
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
