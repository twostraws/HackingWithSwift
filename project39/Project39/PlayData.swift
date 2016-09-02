//
//  PlayData.swift
//  Project39
//
//  Created by TwoStraws on 26/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Foundation

class PlayData {
	var allWords = [String]()
	private(set) var filteredWords = [String]()
	var wordCounts: NSCountedSet!

	init() {
		if let path = Bundle.main.path(forResource: "plays", ofType: "txt") {
			if let plays = try? String(contentsOfFile: path) {
				allWords = plays.components(separatedBy: CharacterSet.alphanumerics.inverted)
				allWords = allWords.filter { $0 != "" }

				wordCounts = NSCountedSet(array: allWords)
				let sorted = wordCounts.allObjects.sorted { wordCounts.count(for: $0) > wordCounts.count(for: $1) }
				allWords = sorted as! [String]
			}
		}

		applyUserFilter("swift")
	}

	func applyUserFilter(_ input: String) {
		if let userNumber = Int(input) {
			applyFilter { self.wordCounts.count(for: $0) >= userNumber }
		} else {
			applyFilter { $0.range(of: input, options: .caseInsensitive) != nil }
		}
	}

	func applyFilter(_ filter: (String) -> Bool) {
		filteredWords = allWords.filter(filter)
	}
}
