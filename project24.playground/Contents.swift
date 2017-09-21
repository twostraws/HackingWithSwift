//: Playground - noun: a place where people can play

import UIKit

extension Int {
	mutating func plusOne() {
		self += 1
	}
}

var myInt = 0
myInt.plusOne()
myInt


// THIS EXTENDS ONLY INT
//extension Int {
//	func squared() -> Int {
//		return self * self
//	}
//}

// THIS EXTENDS ALL INTEGER TYPES
extension BinaryInteger {
	func squared() -> Self {
		return self * self
	}
}

let i: Int = 8
print(i.squared())


var str = "  Hello  "
str = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
