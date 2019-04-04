//
//  Capital.swift
//  Project16
//
//  Created by Paul Hudson on 31/03/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String

    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
