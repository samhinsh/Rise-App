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

/* Expected format:
    "title" : "Who's Teaching Us",
    "about" : "Who’s Teaching Us? raises awareness on the need for faculty diversity and support for marginalized studies and community centers on campus.",
    "coordinates" : "37.429492, -122.169581",
    "media" : "wtu1.jpg,wtu2.jpg,wtu3.jpg,wtu4.jpg,wtu5.jpg,wtu6.jpg,wtu7.jpg,wtu8.jpg",
    "hashtag" : "#wtu"
 */

class CaptureEvent {
    var title: String = String()
    var about: String = String()
    var location: (latitude: Double, longitude: Double) = (Double(), Double())
    var media: [String] = [String]()
    var hashtag: String = String()
    var mapPin: AnyObject?
    
    convenience init(title: String,
                     about: String,
                     location: (latitude: Double, longitude: Double),
                     media: [String],
                     hashtag: String
        
        ) {
        self.init()
        self.about = about
        self.location = location
        self.media = media
        self.hashtag = hashtag
    }
}
