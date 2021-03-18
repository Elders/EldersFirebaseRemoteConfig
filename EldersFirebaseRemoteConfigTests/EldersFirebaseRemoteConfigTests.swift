//
//  EldersFirebaseRemoteConfigTests.swift
//  EldersFirebaseRemoteConfigTests
//
//  Created by Milen Halachev on 17.03.21.
//

import XCTest
import FirebaseRemoteConfig
@testable import EldersFirebaseRemoteConfig

class EldersFirebaseRemoteConfigTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRemoteConfigPreviewDefaultValuesInjection() throws {
        
        let remoteConfig = RemoteConfig.preview(withDefaults: ["asd": NSNumber(5), "eldersDefaultsTestValue2": NSNumber(3)])
        
        //this value is supplied from library defaults - it shold be present
        XCTAssertEqual(remoteConfig.configValue(for: "eldersDefaultsTestValue1").stringValue, "da ve")
        
        //this value is supplied from library defaults and is overriden by user - it shold be present with user's value
        XCTAssertEqual(remoteConfig.configValue(for: "eldersDefaultsTestValue2").numberValue.intValue, 3)
        
        //this value is suppluied by the user - it should be present
        XCTAssertEqual(remoteConfig.configValue(for: "asd").numberValue.intValue, 5)
    }
}


