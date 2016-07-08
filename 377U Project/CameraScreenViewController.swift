//
//  RegisterEventViewController.swift
//  377U Project
//
//  Created by Samuel Hinshelwood on 4/28/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable class CameraScreenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    private var nearbyEvents: [CaptureEvent] = [CaptureEvent]()
    
    private var captureSession : AVCaptureSession?
    private var stillImageOutput : AVCaptureStillImageOutput?
    private var previewLayer : AVCaptureVideoPreviewLayer?
    @IBOutlet private var cameraView: UIView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer?.frame = cameraView.bounds
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPreset1920x1080
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            if captureSession?.canAddInput(input) != nil {
                
                captureSession?.addInput(input)
                
                stillImageOutput = AVCaptureStillImageOutput()
                stillImageOutput?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
                
                if (captureSession?.canAddOutput(stillImageOutput) != nil){
                    captureSession?.addOutput(stillImageOutput)
                    
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
                    previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
                    cameraView.layer.addSublayer(previewLayer!)
                    captureSession?.startRunning()
                }
            }
            
        } catch {
            print("Camera error")
        }
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Camera Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])

        
    }
    
    /* If image was successfully taken, segue to review screen */
    private var takenImage: UIImage? {
        didSet {
            performSegueWithIdentifier(Storyboard.ImageTakenIdentifier, sender: self)
        }
    }
    
    /* Surface the raw user-taken camera image */
    private func didPressTakePhoto(){
        
        if let videoConnection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo){
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                (sampleBuffer, error) in
                
                if sampleBuffer != nil {
                    
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider  = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, .RenderingIntentDefault)
                    
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    
                    self.takenImage = image // TODO: change to imageTaken
                }
            })
        }
        
        
    }
    
    /* Camera button without Analytics listener
    @IBAction private func takePicture(sender: UIButton) {
        didPressTakePhoto()
    }
    */
    
    
    // MARK: - Set model
    func setModel(events: [CaptureEvent]) {
        nearbyEvents = events
    }
    
    
    // MARK: - Image Picker Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(animated: Bool) {
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - Navigation
    
    // Segue identifiers
    private struct Storyboard {
        static let ImageTakenIdentifier = "Show Taken Photo"
    }
     
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationvc = segue.destinationViewController as? PictureReviewScreenViewController {
            if let identifier = segue.identifier {
                
                switch identifier {
                case Storyboard.ImageTakenIdentifier:
                    destinationvc.setModel(nearbyEvents, image: takenImage)
                
                default: break
                }
            }
        }
     }
    
    // Camera button GAnalytics listener
    @IBAction func RiseTakePhoto(sender: AnyObject) {
        
        // surface photo
        didPressTakePhoto()
        
        // track camera button presses
        let tracker = GAI.sharedInstance().defaultTracker
        
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Rise Button ", action: "Photo Taken", label: "Rise Button", value: nil).build() as [NSObject : AnyObject])
    }
}
