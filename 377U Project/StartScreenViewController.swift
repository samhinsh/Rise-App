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
    private var database: CaptureEventDatabase?
    
    /* Capture events being displayed currently */
    private var visibleCaptureEvents =  [CaptureEvent]() { // currently displayed in the captureEventsTable and on the mapView
        didSet {
            print("Displaying capture events: \(visibleCaptureEvents)")
            print("Displaying database: \(database!.allCaptureEvents)")
            
            // TODO - populate TableView
            // TODO
            // clear map
            // clear events table
            
            for event in visibleCaptureEvents {
                // pin event to map
                if event.mapPin == nil {
                    addMapPin(event)
                }
                mapView.addAnnotation(event.mapPin as! MKPointAnnotation)
                
                // TODO add event to events table
            }
        
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
    
    private func addMapPin(event: CaptureEvent) {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: event.location.latitude,
                                                longitude: event.location.longitude)
        pin.title = event.title
        print(pin.title)
        // pin.subtitle = event.about
        event.mapPin = pin
    }
    
    /* Selector showing 'nearest' or 'trending' CaptureEvents has changed
     * Display appropriate CaptureEvents in the table */
    @IBAction private func captureEventDisplayChanged(sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex {
        case 0: // 'nearest'
            print("Displaying events nearest to you")
            visibleCaptureEvents = getTrendingCaptureEvents()
            
        case 1: // 'trending'
            print("Displaying trending events")
            // TODO displayTrendingCaptureEvents()
            
        default: break;
        }
    }
    
    /* returns array of capture events happening nearby to user */
    private func getNearbyCaptureEvents() {
        // TODO
    }
    
    /* returns array of trending capture events */
    private func getTrendingCaptureEvents() -> [CaptureEvent] {
        return database!.allCaptureEvents
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
            database = CaptureEventDatabase()
            database!.fetchCaptureEvents(appURL!)
        } else {
            print("Improper server URL")
        }
        
        // display Map w/ user location
        
        // display available nearby CaptureEvents
        visibleCaptureEvents = getTrendingCaptureEvents() // TODO change
        
        // TODO: remove sample point
//        point.coordinate = CLLocationCoordinate2D(latitude: 37.429492,
//                                                  longitude: -122.169581)
//        point.title = "Who's Teaching Us Rally"
//        point.subtitle = "Garner equitable education"
//        mapView.addAnnotation(point)
    }
}

