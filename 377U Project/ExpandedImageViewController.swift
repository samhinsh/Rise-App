//
//  ExpandedImageViewController.swift
//  377U Project
//
//  Created by Samuel Hinshelwood on 4/28/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit

class ExpandedImageViewController: UIViewController {
    
    /* the expanded image */
    @IBOutlet private weak var imageView: UIImageView!
    
    var incomingImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(incomingImage != nil){
            imageView.image = incomingImage
        }
        
        // Google Analytics Listeners
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Expanded Image Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}