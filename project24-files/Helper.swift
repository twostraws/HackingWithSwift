//
//  Helper.swift
//  Project24
//
//  Created by Hudzilla on 25/11/2014.
//  Copyright (c) 2014 Hudzilla. All rights reserved.
//

import UIKit

func RandomInt(#min: Int, #max: Int) -> Int {
	if max < min { return min }
	return Int(arc4random_uniform((max - min) + 1)) + min
}

extension Int {
	mutating func plusOne() {
		++self
	}

	static func random(#min: Int, max: Int) -> Int {
		if max < min { return min }
		return Int(arc4random_uniform((max - min) + 1)) + min
	}
}

extension String {
	mutating func trim() {
		self = stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
	}
}

extension UIColor {
	class func chartreuseColor() -> UIColor {
		return UIColor(red: 0.875, green: 1, blue: 0, alpha: 1)
	}
}

extension UIView {
	func fadeOut(duration: NSTimeInterval) {
		UIView.animateWithDuration(duration) { [unowned self] in
			self.alpha = 0
		}
	}
}