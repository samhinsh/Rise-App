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
    
    var imageArray: [UIImage] = [UIImage]()
    
    
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
    
    // set instance properties, display images in this event
    func unpackEvent() {
        print("This event is: \(thisEvent.title)")
        eventDescriptionDisplayValue = thisEvent.about
        print("Event media: \(thisEvent.media)")
        
        eventImages = thisEvent.media
        
        // convert all names to images
        for imageName in eventImages {
            print("Adding image with name \(imageName)")
            let image = UIImage(named: imageName)
            if image != nil {
                imageArray.append(image!)
            } else {
                imageArray.append(UIImage())
            }
        }
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MediaBoard.EventImageIdentifier, forIndexPath: indexPath) as! ImageCollectionViewCell
        
        // configure the cell...
        cell.imageView?.image = imageArray[indexPath.row]
        
        // get NSImage from imagename
        // set image of cell
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("Show ExpandedImage", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.eventCollectionView.delegate = self
        self.eventCollectionView.dataSource = self
        
        unpackEvent()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "Show ExpandedImage" {
            let indexPaths = self.eventCollectionView!.indexPathsForSelectedItems()
            
            if(indexPaths != nil){
                let indexPath = indexPaths![0]
            
                // TODO: !-safe
                if let vc = segue.destinationViewController as? ExpandedImageViewController {
                    
                    vc.incomingImage = imageArray[indexPath.row]
                }
            }
        }
    
     }
    
}
