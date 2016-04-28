//
//  RegisterEventViewController.swift
//  377U Project
//
//  Created by Samuel Hinshelwood on 4/28/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit

@IBDesignable class RegisterEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var helpLabel: UILabel!
    
    var didTouchRiseButton = false
    
    /* text placeholder for image */
    @IBOutlet weak var picturePlaceholder: UILabel!
    
    /* The image itself */
    @IBOutlet weak var imageView: UIImageView!
    
    /* It's not here! button */
    @IBAction func newEventButton(sender: UIButton) {
        
    }
    
    /* Events picker */
    @IBOutlet weak var eventPicker: UIPickerView!
    
    /* Rise button action */
    @IBAction func touchedRiseButton(sender: AnyObject) {
        
        // if first time touching Rise button
        if didTouchRiseButton == false {
            didTouchRiseButton = true
            
            // fade help labels
            UILabel.transitionWithView(
                helpLabel,
                duration: 0.25,
                options: [.TransitionCrossDissolve], animations:
                {
                    self.helpLabel.text = (rand() % 2 == 0) ? self.helpLabel.text! : " "
                }, completion: nil
            )
            UILabel.transitionWithView(
                picturePlaceholder,
                duration: 0.25,
                options: [.TransitionCrossDissolve], animations:
                {
                    self.picturePlaceholder.text = (rand() % 2 == 0) ? self.picturePlaceholder.text! : " "
                }, completion: nil
            )
        }
        
        // take picture
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .Camera
        
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Image Picker Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        didTouchRiseButton = true
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
