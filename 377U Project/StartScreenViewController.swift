//
//  ViewController.swift
//  377U Project
//
//  Created by Samuel Hinshelwood on 4/23/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit
import MapKit
import Firebase

@IBDesignable class StartScreenViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate
{
    
    // Firebase event server
    private let appServerURL =  NSURL (string:"https://radiant-torch-3623.firebaseio.com/events")
    
    /* For the local database file:
     private let appServerURL = NSBundle.mainBundle().URLForResource("data", withExtension: "json")
     */
    
    // database that holds and fetches capture events from server
    private var database: CaptureEventDatabase?
    
    // User location manager
    private let locationManager = CLLocationManager()
    
    // map zoom factor
    private let mapZoom = 0.02
    
    // zoom to country
    private var defaultZoom = MKCoordinateRegion()
    
    /* expose event and user locations */
    @IBOutlet private weak var mapView: MKMapView!
    
    /* expose relevant events */
    @IBOutlet private weak var captureEventsTable: UITableView!
    
    /* Segmented control displaying 'nearby' and 'trending' */
    @IBOutlet private weak var captureEventDisplayTab: UISegmentedControl!
    
    private var tabDisplay: String {
        get {
            switch captureEventDisplayTab.selectedSegmentIndex {
            case 0: return "nearby"
            case 1: return "trending"
            default: return "undefined"
            }
        }
    }
    
    /* Capture events being displayed currently */
    var visibleCaptureEvents =  [CaptureEvent]()
        {
        didSet {
            print("Displaying visible capture events: \(visibleCaptureEvents)")
            print("CaptureEvent Database: \(database!.allCaptureEvents)")
            
            clearPinsFromMap(true)
            
            for event in visibleCaptureEvents {
                plotPinOnMap(event)
            }
            
            captureEventsTable.reloadData() // TODO add event to events table
        }
    }
    
    private func addMapPin(event: CaptureEvent)
    {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: event.location.latitude,
                                                longitude: event.location.longitude)
        // set the attributes for this Map pin, including distance from user
        pin.title = event.title + " " + getDistanceFromHereOrEmptyString(locationManager,
                                                                         latitude: event.location.latitude,
                                                                         longitude: event.location.longitude
        )
        print(pin.title)
        pin.subtitle = event.hashtag + ": " + event.about // event.hashtag
        event.mapPin = pin
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
    
    /* Remove pins from map */
    private func clearPinsFromMap(removeUserLocation: Bool) {
        if removeUserLocation {
            let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
            mapView.removeAnnotations( annotationsToRemove )
        } else {
            mapView.removeAnnotations(mapView.annotations)
        }
    }
    
    /* returns array of capture events happening nearby to user */
    private func getNearbyCaptureEvents() -> [CaptureEvent]
    {
        return database!.allCaptureEvents
        
        // TODO: get events from database
        // TODO: sort/filter them for nearby
        // consider CoreData
        // return them
    }
    
    /* returns array of trending capture events */
    private func getTrendingCaptureEvents() -> [CaptureEvent]
    {
        return Array(database!.allCaptureEvents[0...1])
        
        // TODO: develop scheme for trending
        // get/sort from database
        // consider CoreData
        // return "trending" events
    }
    
    /* Selector showing 'nearby' or 'trending' CaptureEvents has changed
     * Display appropriate CaptureEvents in the table */
    @IBAction private func captureEventDisplayChanged(sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex {
        case 0: // 'nearby'
            print("Displaying events nearest to you")
            visibleCaptureEvents = getNearbyCaptureEvents()
            zoomToUserLocation(locationManager)
            
            
        case 1: // 'trending'
            print("Displaying trending events")
            visibleCaptureEvents = getTrendingCaptureEvents()
            zoomToCountry()
            
        default: break;
        }
    }
    
    // MARK: - UITableViewDataSource
    // Next 3 methods are the heart of a dynamic table, get called on tableview.reloadData */
    
    /* Capture event board cell identifier(s) */
    private struct CaptureBoard {
        
        // identifier of cells in CaptureBoard (captureEventsTable)
        static let CaptureEventCellIdentifier = "CaptureEvent"
    }
    
    /* Number of desired table sections */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    /* Number of desired table rows */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return visibleCaptureEvents.count
    }
    
    /* Action to perform for each cell in the specified table */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(CaptureBoard.CaptureEventCellIdentifier, forIndexPath: indexPath)
        
        // configure the cell...
        let captureEvent = visibleCaptureEvents[indexPath.row]
        cell.textLabel?.text = captureEvent.title
        cell.detailTextLabel?.text = captureEvent.about
        
        return cell
    }
    
    // MARK: - Location Delegate methods
    
    /* zoom button on map */
    @IBAction func snapToLocation(sender: UIButton) {
        
        zoomToUserLocation(locationManager)
    }
    
    /* Zoom to worldview */
    private func zoomToCountry()
    {
        self.mapView.setRegion(defaultZoom, animated: true)
    }
    
    /* Zoom to user location given manager */
    private func zoomToUserLocation(manager: CLLocationManager)
    {
        guard manager.location != nil else { return }
        
        let lastLocation = manager.location
        
        let center = CLLocationCoordinate2D(latitude: lastLocation!.coordinate.latitude, longitude: lastLocation!.coordinate.longitude)
        
        // create circle for map to zoom to (1, 1)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: mapZoom, longitudeDelta: mapZoom))
        
        // bring map to the desired region
        self.mapView.setRegion(region, animated: true)
    }
    
    /* For formatting, get the user distance, or an empty string */
    func getDistanceFromHereOrEmptyString(manager: CLLocationManager, latitude: CLLocationDegrees, longitude: CLLocationDegrees ) -> String {
        let distance = distanceFromHereToLocation(locationManager, latitude: latitude, longitude: longitude)
        if distance != nil {
            return distance!
        }
        
        return ""
    }
    
    /* Calculate user current distance to specified coordinate */
    func distanceFromHereToLocation(manager: CLLocationManager, latitude: CLLocationDegrees, longitude: CLLocationDegrees ) -> String? {
        
        // get the distance in meters
        let distanceToHereFromCurrentLocation = manager.location?.distanceFromLocation(CLLocation(
            latitude: latitude,
            longitude: longitude
            )
        )
        
        guard distanceToHereFromCurrentLocation != nil else { return nil }
        
        // convert to miles
        let distanceInMiles = Double(distanceToHereFromCurrentLocation! * 0.000621371)
        return "(" + String(format:"%.1f", distanceInMiles) + " mi)"
    }
    
    /* zoom the mapView to the user's current location */
    func zoomToUserLocation(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        
        guard location != nil else { return }
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        // create circle for map to zoom to (1, 1)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: mapZoom, longitudeDelta: mapZoom))
        
        // bring map to the desired region
        self.mapView.setRegion(region, animated: true)
    }
    
    /* Actions to perform for each update to user location */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        /* Fix zoom on user's current location
         // zoom to user location only if 'nearby' tab selected
         if tabDisplay == "nearby" {
         zoomToUserLocation(manager, didUpdateLocations: locations)
         }
         self.locationManager.stopUpdatingLocation()
         */
    }
    
    /* Errors on getting/updating user location */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location errors: \(error.localizedDescription)")
    }
    
    /* App lifecycle method, actions to perform on memory overusage */
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Model
    
    /* ask CaptureEventDatabase to setup an internal db
     * and download capture events from the specified server */
    private func setDatabase(url: NSURL, viewController: StartScreenViewController)
    {
        database = CaptureEventDatabase()
        database!.fetchAllCaptureEventsFromFirebase(url, viewController: viewController)
        
    }
    
    // MARK: - View
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setDatabase(appServerURL!, viewController: self)
        
        defaultZoom = mapView.region // save map general zoom
        
        self.captureEventsTable.delegate = self // init table view
        self.captureEventsTable.dataSource = self
        
        self.locationManager.delegate = self // init location
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true // display user location
        
        // display available nearby CaptureEvents
        if tabDisplay == "nearby" {
            visibleCaptureEvents = getNearbyCaptureEvents()
            zoomToUserLocation(locationManager)
        } else {
            visibleCaptureEvents = getTrendingCaptureEvents()
        }
        
    }
    
    @IBOutlet var RiseButton: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        print("Main screen will appear!")
        setDatabase(appServerURL!, viewController: self)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false) // hide navbar
        
        let selectedRow = captureEventsTable.indexPathForSelectedRow
        if selectedRow != nil { // deselect selected row
            captureEventsTable.deselectRowAtIndexPath(selectedRow!, animated: true)
        }
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Start Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    // MARK: - Google Analytics Methods
    
    @IBAction func AddEventButton(sender: AnyObject) {
        let tracker = GAI.sharedInstance().defaultTracker
        
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Event Create", action: "New Event Pressed", label: " Screen Change", value: nil).build() as [NSObject : AnyObject])
    }
    
    @IBAction func NearestButton(sender: AnyObject) {
        let tracker = GAI.sharedInstance().defaultTracker
        
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Nearest Tab", action: "Nearest Tab Selected", label: "Tab Change", value: nil).build() as [NSObject : AnyObject])
    }
    
    @IBAction func TrendingTab(sender: AnyObject) {
        let tracker = GAI.sharedInstance().defaultTracker
        
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Trending Tab", action: "Trending Tab Selected", label: "Tab Change", value: nil).build() as [NSObject : AnyObject])
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController
        
        // segue to Event Detail/Image Collection MVC, transfer selected event
        if let showEventVC = destinationVC as? CaptureDetailViewController {
            if let identifier = segue.identifier {
                
                switch identifier {
                case "Show Event":
                    if captureEventsTable.indexPathForSelectedRow != nil {
                        let selectedCaptureEvent = visibleCaptureEvents[captureEventsTable.indexPathForSelectedRow!.row] // get selected captureEvent from table
                        showEventVC.setModel(selectedCaptureEvent)
                        showEventVC.navigationItem.title = selectedCaptureEvent.title
                    }
                default: break
                }
            }
            
            // segue to Camera MVC, transfer relevant events
        } else if let addToEventVC = destinationVC as? CameraScreenViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "Add to Event" :
                    addToEventVC.setModel(visibleCaptureEvents)
                default: break
                }
            }
            
            // segue to New Event MVC, transfer user location
        } else if let newEventVC = destinationVC as? NewEventViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "Create New Event":
                    guard let latitude = (locationManager.location?.coordinate.latitude),
                        let longitude = (locationManager.location?.coordinate.longitude) else { break }
                    newEventVC.location = (Double(latitude), Double(longitude))
                    print("The coordinates sent to the new event screen were: \(locationManager.location?.coordinate.latitude),\(locationManager.location?.coordinate.longitude)")
                default:
                    break
                }
            }
        }
        
    }
    
}

