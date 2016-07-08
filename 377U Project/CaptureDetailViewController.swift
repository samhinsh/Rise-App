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
    
    // event image titles, loaded on previous screen
    var eventImages: [String] = [String]()
    
    // actual event images, loaded dynamically & asynchronously from server on viewDidLoad
    private var imageArray: [UIImage] = [UIImage]()
    
    // counter for images completely loaded asynchronously
    private var imagesLoaded = 0 {
        didSet {
            eventCollectionView.reloadData()
            if imagesLoaded == eventImages.count {
                print("Images Loaded: \(imagesLoaded)")
                eventCollectionView.setNeedsDisplay()
            }
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
        
        // download all images from Amazon AWS S3 from image titles
        for imageName in eventImages {
            print("Adding image with name \(imageName)")
            
            // create server path to existing S3 image
            let endpoint: String = "https://s3-us-west-2.amazonaws.com/samrisepics"
            let img: String = imageName
            let fullurl: String = endpoint.stringByAppendingPathComponent(img)
            
            print("Show url_Img_FULL: %@", fullurl)
            
            // download image data asynchronously
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak weakSelf = self] in
                let image = UIImage(data: NSData(contentsOfURL: NSURL(string: fullurl)!)!)
                
                // load the images into the view synchronously b/c they interact with the view
                dispatch_async( dispatch_get_main_queue()) {
                    if image != nil {
                        weakSelf?.imageArray.append(image!)
                        print("Loaded a real image")
                    } else {
                        weakSelf?.imageArray.append(UIImage())
                        print("Loaded an empty image")
                    }
                    self.imagesLoaded += 1
                    
                }
            }
            
        }
    }
    
    // MARK: - View
    
    /* Event media collection view */
    @IBOutlet weak var eventCollectionView: UICollectionView!
    
    /* Description box at the top of the screen */
    @IBOutlet private weak var eventDescription: UILabel!
    
    // getter/setter for eventDescription label
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
    
    // MARK: - UICollectionView Delegate Methods
    
    // Event Media cell identifiers
    private struct MediaBoard {
        static let EventImageIdentifier = "Event Image"
        static let EventVideoIdentifier = "Event Video"
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesLoaded //thisEvent.media.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MediaBoard.EventImageIdentifier, forIndexPath: indexPath) as! ImageCollectionViewCell
        
        // configure the cell...
        cell.imageView?.image = imageArray[indexPath.row]
        
        print("Returning another cell")
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
        
        unpackEvent() // load this events images & labels into the view
    }
    
    override func viewWillAppear(animated: Bool) {
        eventCollectionView.setNeedsDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
