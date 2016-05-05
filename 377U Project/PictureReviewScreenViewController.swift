//
//  PictureReviewScreenViewController.swift
//  377U Project
//
//  Created by Samuel Hinshelwood on 5/5/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit

class PictureReviewScreenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var nearbyEvents: [CaptureEvent] = [CaptureEvent]()
    
    @IBOutlet var takenImage: UIImageView!
    
    private var myImage: UIImage?
    
    /* Events picker */
    @IBOutlet weak var eventPicker: UIPickerView!
    
    /* Events nearby */
    @IBOutlet weak var eventsNearbyLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func goBack(sender: UIButton) {
        self.navigationController?.popToViewController(self.parentViewController!, animated: false)
            print("Going to parent!")
    }
    
    // MARK: - Set model
    func setModel(events: [CaptureEvent], image: UIImage?) {
        nearbyEvents = events
        myImage = image
        
    }
    
    // MARK: - EventsPicker
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return nearbyEvents.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = nearbyEvents[row].title
        let titleLength = title.characters.count
        let range = NSRange(location: 0, length: titleLength)
        let pickerTitle = NSMutableAttributedString(string: title)
        pickerTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: range)
        return pickerTitle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventPicker.delegate = self
        self.eventPicker.dataSource = self
        
        takenImage.image = myImage

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
