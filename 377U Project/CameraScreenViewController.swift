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
        
    }
    
    private var takenImage: UIImage? {
        didSet {
            performSegueWithIdentifier(Storyboard.ImageTakenIdentifier, sender: self)
        }
    }
    
    
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
    
    private var didTakePhoto = Bool()
    
    private func didPressTakeAnother(){
        if didTakePhoto == true{
            // tempImageView.hidden = true
            didTakePhoto = false
            
        }
        else{
            captureSession?.startRunning()
            didTakePhoto = true
            didPressTakePhoto()
            
        }
        
    }
    
    @IBAction private func takePicture(sender: UIButton) {
        didPressTakeAnother()
    }
    
    
    /*
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    */
    
    /*
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
    */
    
    // MARK: - Set model
    func setModel(events: [CaptureEvent]) {
        nearbyEvents = events
    }
    
    
    // MARK: - Image Picker Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        // Do any additional setup after loading the view.
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
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    private struct Storyboard {
        static let ImageTakenIdentifier = "Show Taken Photo"
    }
    
     // MARK: - Navigation
     
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
    
}
