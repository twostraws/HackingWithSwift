//
//  Capital.swift
//  Project19
//
//  Created by TwoStraws on 18/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
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
