//
//  Note.swift
//  Notes
//
//  Created by Gagan on 2018-04-04.
//  Copyright © 2018 My Org. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Note : NSObject, NSCopying, NSCoding {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Note(text: "")
        copy.categoryId = categoryId
        copy.categoryName = categoryName
        copy.title = title
        copy.text = text
        copy.timeUpdated = timeUpdated
        copy.image = image
        copy.imageValid = imageValid
        copy.locationCoordinatesLat = locationCoordinatesLat
        copy.locationCoordinatesLng = locationCoordinatesLng
        return copy
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(categoryId, forKey: "categoryId")
        aCoder.encode(categoryName, forKey: "categoryName")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(text, forKey: "text")
        aCoder.encode(timeUpdated, forKey: "timeUpdated")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(imageValid, forKey: "imageValid")
        aCoder.encode(locationCoordinatesLat, forKey: "locationCoordinatesLat")
        aCoder.encode(locationCoordinatesLng, forKey: "locationCoordinatesLng")
    }
    
    required init?(coder aDecoder: NSCoder) {
        categoryId = aDecoder.decodeObject(forKey: "categoryId") as? Int
        categoryName = aDecoder.decodeObject(forKey: "categoryName") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        text = aDecoder.decodeObject(forKey: "text") as? String
        timeUpdated = aDecoder.decodeObject(forKey: "timeUpdated") as? NSDate
        image = aDecoder.decodeObject(forKey: "image") as? UIImage
        imageValid = aDecoder.decodeObject(forKey: "imageValid") as? Bool ?? false
        locationCoordinatesLat = aDecoder.decodeObject(forKey: "locationCoordinatesLat") as? Double
        locationCoordinatesLng = aDecoder.decodeObject(forKey: "locationCoordinatesLng") as? Double
    }
    
//    var id: Int?
    var categoryId: Int?
    var categoryName: String?
    var title: String?
    var text: String?
    var timeUpdated: NSDate?
    var image: UIImage?
    var locationCoordinatesLat: Double?
    var locationCoordinatesLng: Double?
    var imageValid: Bool?
    
    init(text: String) {
        self.text = text
        self.timeUpdated = NSDate()
    }
}
