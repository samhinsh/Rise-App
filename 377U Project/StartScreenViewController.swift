//
//  ViewController.swift
//  377U Project
//
//  Created by Samuel Hinshelwood on 4/23/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit
import MapKit

@IBDesignable class StartScreenViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate
{
    
    // MARK - Controller
    
    // CaptureEvent server location content
    private let appServerURL = NSBundle.mainBundle().URLForResource("data", withExtension: "json")
    
    // database that holds and fetches capture events from server
    private var database: CaptureEventDatabase?
    
    /* Capture events being displayed currently */
    private var visibleCaptureEvents =  [CaptureEvent]() { // currently displayed in the captureEventsTable and on the mapView
        didSet {
            print("Displaying capture events: \(visibleCaptureEvents)")
            print("Displaying database: \(database!.allCaptureEvents)")
            
            // TODO: clear map
            // TODO: clear events table
            for event in visibleCaptureEvents {
                plotPinOnMap(event)
                // TODO add event to events table
                captureEventsTable.reloadData()
                    // calls table view sections below
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
    
    private func addMapPin(event: CaptureEvent)
    {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: event.location.latitude,
                                                longitude: event.location.longitude)
        // set the attributes for this Map pin
        pin.title = event.title
        print(pin.title)
        pin.subtitle = event.hashtag
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
            visibleCaptureEvents = getNearbyCaptureEvents()
            
        default: break;
        }
    }
    
    /* plots an event on the map */
    private func plotPinOnMap(event: CaptureEvent)
    {
        print("Pinning this event's mapPin: \(event)")
        if event.mapPin == nil {
            addMapPin(event)
        }
        
        mapView.addAnnotation(event.mapPin as! MKPointAnnotation)
    }
    
    /* returns array of capture events happening nearby to user */
    private func getNearbyCaptureEvents() -> [CaptureEvent]
    {
        // TODO: get events from database
        // TODO: sort/filter them for nearby
        // return them
        
        return [CaptureEvent]()
    }
    
    /* returns array of trending capture events */
    private func getTrendingCaptureEvents() -> [CaptureEvent]
    {
        return database!.allCaptureEvents
        
        // TODO: develop scheme for trending
        // get/sort from database
        // return "trending" events
    }
    
    // MARK: - UITableViewDataSource
    
    /* next 3 methods are the heart of a dynamic table, get called on tableview.reloadData */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return visibleCaptureEvents.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        // configure the cell...
        
        return cell
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Model
    
    /* ask CaptureEventDatabase to setup an internal db
     * and download capture events from the specified server */
    private func setDatabase(url: NSURL)
    {
        database = CaptureEventDatabase()
        database!.fetchCaptureEvents(url)
        
    }
    
    
    // MARK: - View
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        captureEventsTable.delegate = self // init table view
        captureEventsTable.dataSource = self
        
        setDatabase(appServerURL!)
        
        // display Map w/ user location
        
        // display available nearby CaptureEvents
        visibleCaptureEvents = getTrendingCaptureEvents() // TODO change
    }
}

