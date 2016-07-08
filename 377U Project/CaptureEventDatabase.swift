//
//  CaptureEventDatabase.swift
//  377U Project
//
//  Created by Samuel Hinshelwood on 4/26/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import Foundation
import Firebase

class CaptureEventDatabase
{
    
    /* CaptureEvents */
    var allCaptureEvents: [CaptureEvent] = [CaptureEvent]()
    
    /* JSON parse helper #2
     * CaptureEvent specific JSON interpreting
     *
     * Expected dictionary format:
     * "title" : "Who's Teaching Us",
     * "about" : "Who’s Teaching Us? raises awareness on the need for faculty diversity and support for marginalized studies and community centers on campus.",
     * "coordinates" : "37.429492,-122.169581",
     * "media" : "wtu1.jpg,wtu2.jpg,wtu3.jpg,wtu4.jpg,wtu5.jpg,wtu6.jpg,wtu7.jpg,wtu8.jpg",
     * "hashtag" : "#wtu"
     *
     * Read all dictionary objects and create & store them in allCaptureEventsArray */
    private func readObjectsIntoCaptureEventArray(dictionary: [String: AnyObject])
    {
        guard let captureEvents = dictionary["events"] as? [[String: AnyObject]]
            else {
                return
        }
        
        // attempts to read CaptureEvents from each dictionary acquired from server
        for event in captureEvents {
            guard let title = event["title"] as? String,
                let about = event["about"] as? String,
                let coordinates = event["coordinates"] as? String,
                let media = event["media"] as? String,
                let hashtag = event["hashtag"] as? String
                else {
                    print("Could not read dictionary")
                    return
            }
            
            let location = coordinates.componentsSeparatedByString(",").map{ Double($0) } // parse coords
            let lat = location[0]
            let long = location[1]
            
            if lat != nil && long != nil {
                let mediaFileNames = media.componentsSeparatedByString(",") // parse array picture titles
                print(media)
                // create new capture event
                let newCaptureEvent = CaptureEvent(title: title,
                                                   about: about,
                                                   location: (location[0]!, location[1]!),
                                                   media: mediaFileNames,
                                                   hashtag: hashtag
                )
                
                // append capture event to list
                print("Adding event to database")
                allCaptureEvents.append(newCaptureEvent) // append capture event
                
            } else {
                print("Location could not be extracted from JSON object")
            }
        }
        
        print("Capture Events received: \(allCaptureEvents)")
    }
    
    /* JSON parse helper #1 */
    private func parseJSONDataIntoCaptureEvents(data: NSData?)
    {
        do {
            let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) // serialize JSON
            if let dictionary = object as? [String: AnyObject] { // cast as Dictionary<String, AnyObject>
                print("Successfully received JSON dictionary: \(dictionary)")
                readObjectsIntoCaptureEventArray(dictionary)
            }
            
        } catch {
            print("Could not parse JSON object")
        }
    }
    
    // MARK: - Public API
    
    /* Read and load all capture events from generic JSON file or server */
    func fetchAllCaptureEventsFromJSONFileOrServer(contentsOfURL: NSURL)
    {
        let data = NSData(contentsOfURL: contentsOfURL)
        parseJSONDataIntoCaptureEvents(data)
        
    }
    
    /* Read and load all capture events from Firebase */
    func fetchAllCaptureEventsFromFirebase(url: NSURL, viewController: StartScreenViewController) {
        
        let ref = Firebase(url:"https://radiant-torch-3623.firebaseio.com/events")
        
        // read firebase event into empty capture event and append to list
        ref.queryOrderedByChild("title").observeEventType(.ChildAdded, withBlock: { snapshot in
            let title = snapshot.value["title"] as? String
            let coords = snapshot.value["coordinates"] as? String
            let location = coords!.componentsSeparatedByString(",").map{ Double($0) } // parse coords
            let lat = location[0]
            let long = location[1]
            print("Media value to be read looks like: \(snapshot.value["media"])")
            
            // read & store event media items (images) into array
            var lamedia = [String]()
            for mediaItem in snapshot.value["media"] as! NSArray {
                if let item = mediaItem as? String {
                    lamedia.append(item)
                } else {
                    print("This media object for this event is null")
                }
            }
            
            // create new capture event
            if lat != nil && long != nil {
                let newCaptureEvent = CaptureEvent(
                    title: title!,
                    about: snapshot.value["about"] as! String,
                    location: (location[0]!, location[1]!),
                    media: lamedia,
                    hashtag: snapshot.value["hashtag"] as! String
                )
                // append capture event to list
                print("Adding event to database from Firebase. Current db as below")
                print(self.allCaptureEvents)
                self.allCaptureEvents.append(newCaptureEvent) // append capture event
                viewController.visibleCaptureEvents = self.allCaptureEvents
                
            }else {
                print("Location could not be extracted from JSON object")
            }
        })
        
        print("all done")
        print(allCaptureEvents)
        
    }
}