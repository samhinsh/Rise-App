//
//  CaptureEventDatabase.swift
//  377U Project
//
//  Created by Samuel Hinshelwood on 4/26/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import Foundation

/* Expected JSON Format:
 * "title" : "Who's Teaching Us",
    "about" : "Who’s Teaching Us? raises awareness on the need for faculty diversity and support for marginalized studies and community centers on campus.",
    "coordinates" : "37.429492, -122.169581",
    "media" : "wtu1.jpg,wtu2.jpg,wtu3.jpg,wtu4.jpg,wtu5.jpg,wtu6.jpg,wtu7.jpg,wtu8.jpg",
    "hashtag" : "#wtu"
 */

class CaptureEventDatabase {
    
    /* CaptureEvents */
    var allCaptureEvents: [CaptureEvent] = [CaptureEvent]()
    var activeCaptureEvents: [CaptureEvent]? // TODO
    var expiredCaptureEvents: [CaptureEvent]? // TODO
    
    /* CaptureEvent specific JSON interpreting */
    func readJSONObject(dictionary: [String: AnyObject]) {
        guard let captureEvents = dictionary["events"] as? [[String: AnyObject]]
            else
        {
            return
        }
        
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
    
    /* private JSON parsing */
    private func parseJSONDataIntoCaptureEvents(data: NSData?){
        do {
            let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) // serialize JSON
            if let dictionary = object as? [String: AnyObject] { // cast as Dictionary<String, AnyObject>
                print("Successfully received JSON dictionary: \(dictionary)")
                readJSONObject(dictionary)
            }
            
        } catch {
            print("Could not parse JSON object")
        }
    }
    
    /* public method */
    func fetchCaptureEvents(contentsOfURL: NSURL) {
        let data = NSData(contentsOfURL: contentsOfURL)
        parseJSONDataIntoCaptureEvents(data)
    }
}