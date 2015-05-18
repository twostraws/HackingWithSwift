//
//  Person.swift
//  Project10
//
//  Created by Hudzilla on 21/11/2014.
//  Copyright (c) 2014 Hudzilla. All rights reserved.
//

import Foundation

class Person: NSObject, NSCoding {
	var name: String
	var image: String

	init(name: String, image: String) {
		self.name = name
		self.image = image
	}

	required init(coder aDecoder: NSCoder) {
		name = aDecoder.decodeObjectForKey("name") as! String
		image = aDecoder.decodeObjectForKey("image") as! String
	}

	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(self.name, forKey: "name")
		aCoder.encodeObject(self.image, forKey: "image")
	}
}