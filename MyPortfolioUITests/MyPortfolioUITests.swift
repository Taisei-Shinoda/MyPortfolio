//
//  MyPortfolioUITests.swift
//  MyPortfolioUITests
//
//  Created by Taisei Shinoda on 2023/07/24.
//

import XCTest

final class MyPortfolioUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
        
    }


    func testAppHas4Tabs() throws {
        let app = XCUIApplication()
        /// 任意の文字列を渡して、任意の方法で使用できることを意味する
        app.launchArguments = ["enable-testing"]
        app.launch()

        /// タブバーのボタンの数を数える
        XCTAssertEqual(app.tabBars.buttons.count, 4, "アプリには4つのタブがあるはず")
    }
    
    func testOpenTabAddsProjects() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "最初にリスト行は無いはず")

        for tapCount in 1...5 {
            /// add は「追加」としてXcodeは認識
            app.buttons["add"].tap()
            XCTAssertEqual(app.tables.cells.count, tapCount, "リストには行が　\(tapCount) あるはず")
        }
    }

    func testAddingItemInsertsRows() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "最初はリスト行があってはいけない")

        app.buttons["add"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "プロジェクトを追加した後はリスト行が 1 つあるはず")

        app.buttons["Add New Item"].tap()
        XCTAssertEqual(app.tables.cells.count, 2, "項目を追加した後はリスト行が 2 つあるはず")
    }
    
    func testEditingProjectUpdatesCorrectly() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "最初はリスト行があってはいけない")

        app.buttons["add"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "プロジェクトを追加した後はリスト行が 1 つあるはず")

        app.buttons["NEW PROJECT"].tap()
        app.textFields["Project name"].tap()
        app.keys["space"].tap()
        app.keys["more"].tap()
        app.keys["2"].tap()
        app.buttons["Return"].tap()

        app.buttons["Open Projects"].tap()
        XCTAssertTrue(app.buttons["NEW PROJECT 2"].exists, "新しいプロジェクト名がリストに表示されるはず")
        
    }
    
    func testEditingItemUpdatesCorrectly() {
        /// この例では、すべてのテストが独立して実行されるため、あるテストが別のテストを呼び出すことについては問題ない
        /// 「プロジェクトを開く」に移動し、1 つのプロジェクトと 1 つの項目を追加
        testAddingItemInsertsRows()

        app.buttons["New Item"].tap()

        app.textFields["Item name"].tap()
        app.keys["space"].tap()
        app.keys["more"].tap()
        app.keys["2"].tap()
        app.buttons["Return"].tap()

        app.buttons["Open Projects"].tap()

        XCTAssertTrue(app.buttons["New Item 2"].exists, "新しい項目名がリストに表示されるはず")
    }
    
    func testAllAwardsShowLockedAlert() {
        app.buttons["Awards"].tap()

        for award in app.scrollViews.buttons.allElementsBoundByIndex {
            award.tap()
            XCTAssertTrue(app.alerts["Locked"].exists, "Awards にはロック済みアラートが表示されるはず")
            app.buttons["OK"].tap()
        }
    }
    
}
