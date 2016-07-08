//
//  PictureReviewScreenViewController.swift
//  377U Project
//
//  Created by Samuel Hinshelwood on 5/5/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit
import Firebase
import AWSS3
import AWSCore
import AWSCognito

extension UIImage {
    
    // correct image orientation
    func normalizedImage() -> UIImage {
        
        if (self.imageOrientation == UIImageOrientation.Up) {
            return self;
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.drawInRect(rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return normalizedImage;
    }
}

extension String {
    
    var lastPathComponent: String {
        get {
            return (self as NSString).lastPathComponent
        }
    }
    var pathExtension: String {
        get {
            return (self as NSString).pathExtension
        }
    }
    var stringByDeletingLastPathComponent: String {
        
        get {
            return (self as NSString).stringByDeletingLastPathComponent
        }
    }
    var stringByDeletingPathExtension: String {
        get {
            return (self as NSString).stringByDeletingPathExtension
        }
    }
    var pathComponents: [String] {
        get {
            return (self as NSString).pathComponents
        }
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.stringByAppendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(ext: String) -> String? {
        let nsSt = self as NSString
        return nsSt.stringByAppendingPathExtension(ext)
    }
}


class PictureReviewScreenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var filesize:Int64 = 0
    var amountUploaded:Int64 = 0
    var loadingBg:UIView?
    var progressView:UIView?
    var progressLabel:UILabel?
    var uploadRequest: AWSS3TransferManagerUploadRequest?
    
    var nearbyEvents: [CaptureEvent] = [CaptureEvent]()
    
    private var myImage: UIImage?
    
    @IBOutlet var takenImage: UIImageView!
    
    /* Events picker */
    @IBOutlet weak var eventPicker: UIPickerView!
    
    /* Events nearby */
    @IBOutlet weak var eventsNearbyLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Picture Review Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])

    }
    @IBAction func UploadPhotoButton(sender: AnyObject) {
        let tracker = GAI.sharedInstance().defaultTracker
        
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Upload Photo", action: "Photo Uploaded", label: "Upload Photo Taken", value: nil).build() as [NSObject : AnyObject])
    }
    
    @IBAction func BackButton(sender: AnyObject) {
        
        let tracker = GAI.sharedInstance().defaultTracker
        
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Back  Button", action: "Photo not uploaded", label: "Discard Photo Back Button", value: nil).build() as [NSObject : AnyObject])
    }
    @IBAction func goBack(sender: UIButton) {
        self.navigationController!.popViewControllerAnimated(false)
    }
    
    /* Clicked the '✓' send the image taken to the server, along with it's title.
     * Append the image to the event */
    @IBAction func sendToServer(sender: UIButton) {
        // self.navigationController!.popViewControllerAnimated(false)
        
        self.createLoadingView()
        
        // 'myImage' is the UI Image being viewed
        let selectedRow = eventPicker.selectedRowInComponent(0)
        let selectedEvent = nearbyEvents[selectedRow]
        
        // create title, exclude '#'
        let myImageTitle = selectedEvent.hashtag.substringFromIndex(selectedEvent.hashtag.startIndex.advancedBy(1)) + String(selectedEvent.media.count + 1) // TODO: consider hashtag + location + date for naming scheme
        selectedEvent.media.append(myImageTitle)
        
        print("Great, sending this \(myImageTitle) to the server for the event: \(selectedEvent.title)!")
        
        /* =========Server code to send picture to S3 ========= */
        // configure authentication with Cognito
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                                identityPoolId:"us-east-1:2a4b6f48-1ee2-4f53-8dd5-a9f55a7208b5")
        // let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,identityPoolId:"us-east-1:c917bfeb-c829-4eac-ad34-8e333208fafe")
        let configuration = AWSServiceConfiguration(region:.USWest2, credentialsProvider:credentialsProvider)
        // let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
        
        let S3BucketName = "samrisepics" //"risepics"
        
        // create a local image that we can use to upload to s3
        print("About to make path")
        let path:String = NSTemporaryDirectory().stringByAppendingPathComponent("newestImage.png")
        print("Made path")
        myImage = myImage!.normalizedImage() // correct the image's native orientation for sending to server
        let imageData:NSData = UIImagePNGRepresentation(myImage!)! // NSData(base64EncodedString: "aGVsbG8=", options: NSDataBase64DecodingOptions(rawValue: 0))!
        print("Converted image to data")
        imageData.writeToFile(path, atomically: true)
        print("Wrote image to file")
        
        // once the image is saved we can use the path to create a local fileurl
        let fileURL:NSURL = NSURL(fileURLWithPath: path)
        
        print("File URL: \(fileURL)") // theurl
        
        //create a TransferManager client
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        //construct a request object and then pass that request object the TransferManager client
        uploadRequest = AWSS3TransferManagerUploadRequest()
        //the key value will be the name of the object in the S3 bucket. The body property of the request takes an NSURL object
        uploadRequest!.bucket = S3BucketName
        uploadRequest!.ACL = AWSS3ObjectCannedACL.PublicRead
        uploadRequest!.key = myImageTitle + ".png" // "newestImage.png"
        uploadRequest!.contentType = "image/png"
        //uploadRequest.key = myImageTitle
        uploadRequest!.body = fileURL  // theurl
        // we will track progress through an AWSNetworkingUploadProgressBlock
        uploadRequest!.uploadProgress = {[unowned self](bytesSent:Int64, totalBytesSent:Int64, totalBytesExpectedToSend:Int64) in
            
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                self.amountUploaded = totalBytesSent
                self.filesize = totalBytesExpectedToSend;
                self.update()
                
            })
        }
        
        //pass the request to the upload method of the TransferManager client
        //The upload method returns a AWSTask object, so we’ll again use continueWithExecutor:withBlock: to handle the upload
        transferManager.upload(self.uploadRequest).continueWithExecutor(AWSExecutor.mainThreadExecutor(), withBlock: { [weak weakSelf = self]
            (task) -> AnyObject! in
            if let error = task.error {
                print("Upload failed ❌ (\(error))")
            }
            if let exception = task.exception {
                print("Upload failed ❌ (\(exception))")
            }
            if task.result != nil {
                let s3URL = NSURL(string: "https://s3-us-west-2.amazonaws.com/\(S3BucketName)/\(self.uploadRequest!.key!)")!
                // print(s3URL)
                
                /* =========  Update the event's image and send to the event db aka Firebase ========= */
                let myRootRef = Firebase(url:"https://radiant-torch-3623.firebaseio.com/events")
                let eventRef = myRootRef.childByAppendingPath(String(selectedEvent.title)) // TODO: error handling for event not present
                let mediaRef = eventRef.childByAppendingPath("media")
                let newmedia = [String(selectedEvent.media.count + 1) : myImageTitle + ".png"]
                mediaRef.updateChildValues(newmedia)
                
                
                // let image = UIImage(data: NSData(contentsOfURL: s3URL)!)
                // ^ use for downloading image
                print("✅ Uploaded to:\n\(s3URL)")
            }
            else {
                print("Unexpected empty result.")
            }
            weakSelf?.removeLoadingView()
            weakSelf?.navigationController!.popViewControllerAnimated(false)
            return nil
            })
        
    }
    
    func update(){
        let percentageUploaded:Float = Float(amountUploaded) / Float(filesize) * 100
        progressLabel?.text = String(format:"Uploading: %.0f%%", percentageUploaded)
    }
    
    // MARK: - Diagnosic Loading Module
    
    func createLoadingView(){
        loadingBg = UIView(frame: self.view.frame)
        loadingBg?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35)
        self.view.addSubview(loadingBg!)
        
        progressView = UIView(frame: CGRectMake(0, 0, 250, 50))
        progressView?.center = self.view.center
        progressView?.backgroundColor = UIColor.whiteColor()
        loadingBg?.addSubview(progressView!)
        
        progressLabel = UILabel(frame: CGRectMake(0, 0, 250, 50))
        progressLabel?.textAlignment = NSTextAlignment.Center
        progressView?.addSubview(progressLabel!)
        progressLabel?.text = "Uploading:";
    }
    
    func removeLoadingView(){
        loadingBg?.removeFromSuperview()
    }
    
    // MARK: - Model
    
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
        self.navigationController!.setNavigationBarHidden(true, animated: false)
        
        self.eventPicker.delegate = self
        self.eventPicker.dataSource = self
        
        takenImage.image = myImage
        
        // TODO: Think through passing vs. live fetching events array, implement
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // hide the bar containing the battery indicator and such
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
