//
//  Project39Tests.swift
//  Project39Tests
//
//  Created by TwoStraws on 26/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import XCTest
@testable import Project39

class Project39Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testAllWordsLoaded() {
		let playData = PlayData()
		XCTAssertEqual(playData.allWords.count, 18440, "allWords was not 18440")
	}

	func testWordCountsAreCorrect() {
		let playData = PlayData()
		XCTAssertEqual(playData.wordCounts.count(for: "home"), 174, "Home does not appear 174 times")
		XCTAssertEqual(playData.wordCounts.count(for: "fun"), 4, "Fun does not appear 4 times")
		XCTAssertEqual(playData.wordCounts.count(for: "mortal"), 41, "Mortal does not appear 41 times")
	}

	func testWordsLoadQuickly() {
		measure {
			_ = PlayData()
		}
	}

	func testUserFilterWorks() {
		let playData = PlayData()

		playData.applyUserFilter("100")
		XCTAssertEqual(playData.filteredWords.count, 495)

		playData.applyUserFilter("1000")
		XCTAssertEqual(playData.filteredWords.count, 55)

		playData.applyUserFilter("10000")
		XCTAssertEqual(playData.filteredWords.count, 1)

		playData.applyUserFilter("test")
		XCTAssertEqual(playData.filteredWords.count, 56)

		playData.applyUserFilter("swift")
		XCTAssertEqual(playData.filteredWords.count, 7)

		playData.applyUserFilter("objective-c")
		XCTAssertEqual(playData.filteredWords.count, 0)
	}
}
