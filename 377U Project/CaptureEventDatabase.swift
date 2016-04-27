//
//  CaptureEventDatabase.swift
//  377U Project
//
//  Created by Samuel Hinshelwood on 4/26/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import Foundation

class CaptureEventDatabase {
    
    /* CaptureEvents */
    var allCaptureEvents: [CaptureEvent]?
    
    var activeCaptureEvents: [CaptureEvent]? // TODO
    var expiredCaptureEvents: [CaptureEvent]? // TODO
    
    /* CaptureEvent specific JSON interpreting */
    func readJSONObject(dictionary: [String: AnyObject]) {
        
    }
    
    /* private JSON parsing */
    private func parseJSONDataIntoCaptureEvents(data: NSData?) -> [CaptureEvent] {
        do {
            let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) // serialize JSON
            if let dictionary = object as? [String: AnyObject] { // cast as Dictionary<String, AnyObject>
                print("Successfully received JSON dictionary: \(dictionary)")
                readJSONObject(dictionary)
            }
            // TODO
            return [CaptureEvent]()
            
        } catch {
            print("Could not parse JSON object")
        }
        
        return [CaptureEvent]()
    }
    
    /* public method */
    func fetchCaptureEvents(contentsOfURL: NSURL) {
        let data = NSData(contentsOfURL: contentsOfURL)
        allCaptureEvents = parseJSONDataIntoCaptureEvents(data)
    }
}