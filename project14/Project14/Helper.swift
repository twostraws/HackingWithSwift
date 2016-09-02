//
//  Helper.swift
//  Project11
//
//  Created by Hudzilla on 22/11/2014.
//  Copyright (c) 2014 Hudzilla. All rights reserved.
//

import Foundation
import UIKit

func RandomInt(min: Int, max: Int) -> Int {
	if max < min { return min }
	return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
}

func RandomFloat() -> Float {
	return Float(arc4random()) /  Float(UInt32.max)
}

func RandomFloat(min: Float, max: Float) -> Float {
	return (Float(arc4random()) / Float(UInt32.max)) * (max - min) + min
}

func RandomDouble(min: Double, max: Double) -> Double {
	return (Double(arc4random()) / Double(UInt32.max)) * (max - min) + min
}

func RandomCGFloat() -> CGFloat {
	return CGFloat(RandomFloat())
}

func RandomCGFloat(min: Float, max: Float) -> CGFloat {
	return CGFloat(RandomFloat(min: min, max: max))
}

func RandomColor() -> UIColor {
	return UIColor(red: RandomCGFloat(), green: RandomCGFloat(), blue: RandomCGFloat(), alpha: 1)
}
