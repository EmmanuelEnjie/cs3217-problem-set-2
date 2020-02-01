//
//  PeggleTests.swift
//  PeggleTests
//
//  Created by Shawn Koh on 27/1/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import XCTest
@testable import Peggle

class BiMapTests: XCTestCase {
    var bimap: BiMap<String, Int>!
    override func setUp() {
        super.setUp()
        bimap = BiMap()
    }

    override func tearDown() {
        bimap = nil
        super.tearDown()
    }

    func testConstruct() {
        XCTAssertEqual(bimap.count, 0)
        XCTAssertTrue(bimap.isEmpty)
    }

    func testSetValueForKey() {
        bimap[key: "A"] = 3

        XCTAssertEqual(bimap[key: "A"], 3)
        XCTAssertEqual(bimap[value: 3], "A")
        XCTAssertEqual(bimap.count, 1)
        XCTAssertFalse(bimap.isEmpty)
    }

    func testSetKeyForValue() {
        bimap[value: 3] = "A"

        XCTAssertEqual(bimap[key: "A"], 3)
        XCTAssertEqual(bimap[value: 3], "A")
        XCTAssertEqual(bimap.count, 1)
        XCTAssertFalse(bimap.isEmpty)
    }
}
