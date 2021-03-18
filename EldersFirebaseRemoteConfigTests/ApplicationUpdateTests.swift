//
//  ApplicationUpdateTests.swift
//  DMOTests
//
//  Created by Milen Halachev on 15.03.21.
//

import Foundation
import XCTest
@testable import EldersFirebaseRemoteConfig

class ApplicationUpdateTests: XCTestCase {
    
    //Version raw value must exactly match 'X.Y.Z.a' where
    //- X is the major number (required)
    //- Y is the minor number (required)
    //- Z is the patch number (required)
    //- a is the build number (optional)
    
    func testInvalidVersionInitialization() {
        
            
            XCTAssertNil(ApplicationUpdate.Version(rawValue: "1"))
            XCTAssertNil(ApplicationUpdate.Version(rawValue: "1.2"))
            XCTAssertNil(ApplicationUpdate.Version(rawValue: "1.2.3.4.5"))
    }
    
    func testVersionInitializationWithBuild() throws {
        
        let version = try XCTUnwrap(ApplicationUpdate.Version(rawValue: "1.2.3"))
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 3)
        XCTAssertNil(version.build)
    }
    
    func testVersionInitializationWithoutBuild() throws {
        
        let version = try XCTUnwrap(ApplicationUpdate.Version(rawValue: "1.2.3.4"))
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 3)
        XCTAssertEqual(version.build, 4)
    }
    
    func testVersionComparisonWithBuild() {
        
        XCTAssertLessThan(ApplicationUpdate.Version(rawValue: "1.2.3.4")!, ApplicationUpdate.Version(rawValue: "2.2.3.4")!)
        XCTAssertLessThan(ApplicationUpdate.Version(rawValue: "1.2.3.4")!, ApplicationUpdate.Version(rawValue: "1.3.3.4")!)
        XCTAssertLessThan(ApplicationUpdate.Version(rawValue: "1.2.3.4")!, ApplicationUpdate.Version(rawValue: "1.2.4.4")!)
        XCTAssertLessThan(ApplicationUpdate.Version(rawValue: "1.2.3.4")!, ApplicationUpdate.Version(rawValue: "1.2.3.5")!)
        
        XCTAssertEqual(ApplicationUpdate.Version(rawValue: "1.2.3.4")!, ApplicationUpdate.Version(rawValue: "1.2.3.4")!)
    }
    
    func testVersionComparisonWithoutBuild() {
        
        XCTAssertLessThan(ApplicationUpdate.Version(rawValue: "1.2.3")!, ApplicationUpdate.Version(rawValue: "2.2.3")!)
        XCTAssertLessThan(ApplicationUpdate.Version(rawValue: "1.2.3")!, ApplicationUpdate.Version(rawValue: "1.3.3")!)
        XCTAssertLessThan(ApplicationUpdate.Version(rawValue: "1.2.3")!, ApplicationUpdate.Version(rawValue: "1.2.4")!)
        
        XCTAssertEqual(ApplicationUpdate.Version(rawValue: "1.2.3")!, ApplicationUpdate.Version(rawValue: "1.2.3")!)
    }
    
    func testVersionComparisonMixed() {
        
        XCTAssertLessThan(ApplicationUpdate.Version(rawValue: "1.2.3")!, ApplicationUpdate.Version(rawValue: "1.2.3.4")!)
        XCTAssertLessThan(ApplicationUpdate.Version(rawValue: "1.2.3")!, ApplicationUpdate.Version(rawValue: "2.2.3.4")!)
        XCTAssertLessThan(ApplicationUpdate.Version(rawValue: "1.2.3")!, ApplicationUpdate.Version(rawValue: "1.3.3.4")!)
        XCTAssertLessThan(ApplicationUpdate.Version(rawValue: "1.2.3")!, ApplicationUpdate.Version(rawValue: "1.2.4.4")!)
        
        XCTAssertNotEqual(ApplicationUpdate.Version(rawValue: "1.2.3")!, ApplicationUpdate.Version(rawValue: "1.2.3.4")!)
    }
}
