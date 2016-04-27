//
//  CaptureEventDatabase.swift
//  377U Project
//
//  Created by Samuel Hinshelwood on 4/26/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import Foundation

class CaptureEventDatabase {
    
    // CaptureEvents
    var allCreatedCaptureEvents: [CaptureEvent]? // TODO: priority queue based on distance from location
    
    private func parseJSONIntoCaptureEvents() -> [CaptureEvent] {
        do {
            //let json = try NSJ
            // TODO
            return [CaptureEvent]()
        } catch {
            
        }
    }
    
    func fetchCaptureEvents() {
        allCreatedCaptureEvents = parseJSONIntoCaptureEvents()
    }
}