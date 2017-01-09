//
//  SiderealTimeTest.swift
//  Graviton
//
//  Created by Sihao Lu on 1/3/17.
//  Copyright © 2017 Ben Lu. All rights reserved.
//

import XCTest
import CoreLocation
@testable import SpaceTime

class SiderealTimeTest: XCTestCase {
    
    var locationTime: ObserverInfo!
    var date: Date {
        return locationTime.time
    }
    
    override func setUp() {
        super.setUp()
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let components = DateComponents(calendar: calendar, timeZone: TimeZone(secondsFromGMT: 0), year: 2017, month: 1, day: 3, hour: 3, minute: 29)
        let date = calendar.date(from: components)!
        // coordinate of my hometown
        let coord = CLLocationCoordinate2D(latitude: 32.0603, longitude: 118.7969)
        locationTime = ObserverInfo(location: coord, time: date)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSiderealTime() {
        XCTAssertEqualWithAccuracy(JulianDate(date: date).value, 2457756.645138889, accuracy: 1e-5)
        XCTAssertEqualWithAccuracy(date.greenwichMeanSiderealTime, 10 + 20 / 60.0 + 47.358 / 3600.0, accuracy: 1e-3)
        let angle: Float = (18 + 15 / 60.0 + 58.614 / 3600.0) / 12 * Float(M_PI)
        XCTAssertEqualWithAccuracy(locationTime.localSiderealTimeAngle, angle, accuracy: 1e-3)
    }
    
}