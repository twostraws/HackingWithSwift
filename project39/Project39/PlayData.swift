//
//  PlayData.swift
//  Project39
//
//  Created by Hudzilla on 04/03/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Foundation

class PlayData {
	var allWords = [String]()
	private(set) var filteredWords = [String]()

	var wordCounts: NSCountedSet!

	init() {
		if let path = NSBundle.mainBundle().pathForResource("plays", ofType: "txt") {
			if let plays = try? String(contentsOfFile: path, usedEncoding: nil) {
				allWords = plays.componentsSeparatedByCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)

				allWords = allWords.filter { $0 != "" }

				wordCounts = NSCountedSet(array: allWords)
				let sorted = wordCounts.allObjects.sort { wordCounts.countForObject($0) > wordCounts.countForObject($1) }
				allWords = sorted as! [String]
			}
		}

		applyUserFilter("swift")
	}

	func applyFilter(filter: (String) -> Bool) {
		filteredWords = allWords.filter(filter)
	}

	func applyUserFilter(input: String) {
		if let userNumber = Int(input) {
			applyFilter { self.wordCounts.countForObject($0) >= userNumber }
		} else {
			applyFilter { $0.rangeOfString(input, options: .CaseInsensitiveSearch) != nil }
		}
	}	
}