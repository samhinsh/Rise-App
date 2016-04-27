//
//  ViewController.swift
//  377U Project
//
//  Created by Samuel Hinshelwood on 4/23/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit
import MapKit

@IBDesignable class StartScreenViewController: UIViewController, MKMapViewDelegate {
    
    // MARK - Controller
    
    // CaptureEvent server location content
    private let appURL = NSBundle.mainBundle().URLForResource("data", withExtension: "json")
    
    // database that holds and fetches capture events from server
    private let database: CaptureEventDatabase = CaptureEventDatabase()
    
    /* Capture events being displayed currently */
    private var visibleCaptureEvents: [CaptureEvent]? { // currently displayed in the captureEventsTable and on the mapView
        didSet {
            // TODO - populate TableView
        }
    }
    
    /* expose revelant location */
    @IBOutlet private weak var mapView: MKMapView!
    
    /* expose relevant capture events */
    @IBOutlet private weak var captureEventsTable: UITableView!
    
    /* Camera button for IU */
    @IBOutlet private weak var cameraButton: CameraView!
    
    // TODO: remove this test map annotation
    var point: MKPointAnnotation = MKPointAnnotation()
    
    /* Selector showing 'nearest' or 'trending' CaptureEvents has changed
     * Display appropriate CaptureEvents in the table */
    @IBAction private func captureEventDisplayChanged(sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex {
        case 0: // 'nearest'
            print("Displaying events nearest to you")
            // displayNearbyCaptureEvents()
            
        case 1: // 'trending'
            print("Displaying trending events")
            // displayTrendingCaptureEvents()
            
        default: break;
        }
    }
    
    /* returns array of capture events happening nearby to user */
    private func getNearbyCaptureEvents() {
        // TODO
    }
    
    /* returns array of trending capture events */
    private func getTrendingCaptureEvents() {
        // TODO
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set model database
        if appURL != nil {
            database.fetchCaptureEvents(appURL!)
        } else {
            print("Improper server URL")
        }
        
        // display Map w/ user location
        
        // display available nearby CaptureEvents
        
        // TODO: remove sample point
        point.coordinate = CLLocationCoordinate2D(latitude: 37.429492,
                                                  longitude: -122.169581)
        point.title = "Who's Teaching Us Rally"
        point.subtitle = "Garner equitable education"
        mapView.addAnnotation(point)
    }
}

