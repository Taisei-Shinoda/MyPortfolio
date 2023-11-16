//
//  MyPortfolioUITestsLaunchTests.swift
//  MyPortfolioUITests
//
//  Created by Taisei Shinoda on 2023/08/21.
//

import XCTest

final class MyPortfolioUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
