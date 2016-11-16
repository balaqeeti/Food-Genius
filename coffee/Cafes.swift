//
//  Cafes.swift
//  coffee
//
//  Created by admin on 10/27/16.
//  Copyright © 2016 Jett Raines. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Cafes: NSObject {
    
    let name: String
    let location: CLLocation
    let cafeDescription: String
    
    init(name: String, latitude: Double, longitude: Double, cafeDescription: String){
        self.name = name
        self.location = CLLocation(latitude: latitude, longitude: longitude)
        self.cafeDescription = cafeDescription
    }
    
}

extension Cafes: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        get {
            return location.coordinate
        }
    }
    
    var title: String? {
        get {
            return name
        }
    }
    var subtitle: String? {
        get {
            return ""
        }
    }

}
