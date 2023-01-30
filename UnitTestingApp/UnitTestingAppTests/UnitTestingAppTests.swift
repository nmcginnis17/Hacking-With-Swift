//
//  UnitTestingAppTests.swift
//  UnitTestingAppTests
//
//  Created by Nicholas McGinnis on 1/28/23.
//

import XCTest
@testable import UnitTestingApp

final class UnitTestingAppTests: XCTestCase {

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
        XCTAssertEqual(playData.wordCounts["guard"], 19, "word does not appear 19 times")
        XCTAssertEqual(playData.wordCounts["fox"], 20, "word does not appear 20 times")
        XCTAssertEqual(playData.wordCounts["attend"], 43, "word does not appear 43 times")
    }

}
