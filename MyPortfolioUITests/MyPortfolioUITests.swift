//
//  MyPortfolioUITests.swift
//  MyPortfolioUITests
//
//  Created by Taisei Shinoda on 2023/08/21.
//

import XCTest

final class MyPortfolioUITests: XCTestCase {
    
    /// すぐに作成され、アサーションが行われる前に破棄されることがないため、暗黙的にラップを解除できる
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        /// これは、デフォルト・アプリケーションのインスタンス（1つしかないので、メイン・アプリケーション）を作成
        /// アプリがテスト環境にあることを認識できるようにその起動引数を設置
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
        
    }
    
    /// ナビゲーションバー要素は存在するか？
    func testAppStartsWithNavigationBar() throws {
        XCTAssertTrue(app.navigationBars.element.exists, "アプリの起動時にナビゲーションバーが表示される")
    }
    
    func testNoIssuesAtStart() {
        XCTAssertEqual(app.cells.count, 0, "最初のリストは0である")
    }
    
}

