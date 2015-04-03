//
//  Capital.swift
//  Project19
//
//  Created by Hudzilla on 23/11/2014.
//  Copyright (c) 2014 Hudzilla. All rights reserved.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
	var title: String
	var coordinate: CLLocationCoordinate2D
	var info: String

	init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
		self.title = title
		self.coordinate = coordinate
		self.info = info
	}
}
