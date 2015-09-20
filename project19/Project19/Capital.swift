//
//  Capital.swift
//  Project19
//
//  Created by Hudzilla on 16/09/2015.
//  Copyright © 2015 Paul Hudson. All rights reserved.
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