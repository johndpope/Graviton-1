//
//  StarTest.swift
//  Graviton
//
//  Created by Ben Lu on 2/4/17.
//  Copyright © 2017 Ben Lu. All rights reserved.
//

import XCTest
@testable import Orbits

class StarTest: XCTestCase {
    func testStarQuery() {
        let starQuery = DistantStar.magitudeLessThan(0)
        XCTAssertEqual(starQuery.count, 4)
        let s2Query = DistantStar.hip(69673)
        XCTAssertNotNil(s2Query)
        XCTAssertEqual(s2Query!.identity.properName, "Arcturus")
    }
    
    func testConstellationQuery() {
        let iauQuery = Constellation.iau("Tau")
        XCTAssertNotNil(iauQuery)
        let nameQuery = Constellation.named("Orion")
        XCTAssertNotNil(nameQuery)
    }
}