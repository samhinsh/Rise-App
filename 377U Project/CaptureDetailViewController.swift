//
//  CaptureDetailViewController.swift
//  377U Project
//
//  Created by Samuel Hinshelwood on 4/28/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit

@IBDesignable class CaptureDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Model
    
    /* The CaptureEvent this class is representing*/
    private var thisEvent: CaptureEvent = CaptureEvent()
    
    /* Event media collection view */
    @IBOutlet weak var eventCollectionView: UICollectionView!
    
    /* Description box at the top of the screen */
    @IBOutlet private weak var eventDescription: UILabel!
    
    var eventImages: [String] = [String]()
    
    
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
        print("Event media: \(thisEvent.media)")
        
        eventImages = thisEvent.media
        
        
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    private struct MediaBoard {
        
        // identifier of cells in MediaBoard
        static let EventImageIdentifier = "Event Image"
        static let EventVideoIdentifier = "Event Video"
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thisEvent.media.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MediaBoard.EventImageIdentifier, forIndexPath: indexPath)
        
        // configure the cell...
        let imageName = self.thisEvent.media[indexPath.row]
        
        // get NSImage from imagename
        // set image of cell
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.eventCollectionView.delegate = self
        self.eventCollectionView.dataSource = self
        
        self.eventCollectionView.backgroundColor = UIColor.whiteColor()
        
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
