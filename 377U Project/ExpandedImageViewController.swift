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
