//
//  CaptureEvent.swift
//  377U Project
//
//  Created by Samuel Hinshelwood on 4/26/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import Foundation

/* ============================================================================================
 * A Capture Event is considered to be a specific location where a big or important event is
 * is happening in the world, and visual media can/should/has been collected to document it.
 * ============================================================================================*/

class CaptureEvent {
    var title: String = String() // event title
    var about: String = String() // event description
    var location: (latitude: Double, longitude: Double) = (Double(), Double()) // event location
    var media: [String] = [String]() // event images and videos
    var hashtag: String = String() // associated hashtag
    var mapPin: AnyObject? // Map annotation pin (set and used in controller)
    
    convenience init(title: String,
                     about: String,
                     location: (latitude: Double, longitude: Double),
                     media: [String],
                     hashtag: String
        
        ) {
        self.init()
        self.title = title
        self.about = about
        self.location = location
        self.media = media
        self.hashtag = hashtag
    }
}
