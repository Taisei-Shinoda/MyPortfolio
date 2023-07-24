//
//  AssetTests.swift
//  MyPortfolioTests
//
//  Created by Taisei Shinoda on 2023/07/23.
//

import XCTest
@testable import MyPortfolio


final class AssetTests: XCTestCase {

    /// アセットカタログにコードが期待する色がすべて含まれていることを確認するテストメソッド
    func testColorsExist() {
        let allColors = ["Dark Blue", "Dark Gray", "Gold", "Gray", "Green",
                         "Light Blue", "Midnight", "Orange", "Pink", "Purple", "Red", "Teal"]

        for color in allColors {
            XCTAssertNotNil(UIColor(named: color), "アセットカタログから'\(color)' 色をロード出来ませんでした")
        }
    }
    
    /// Award.allAwardsプロパティが空かどうか? (バンドルからAwards.jsonをロードしてデコード出来たか)を確認するテストメソッド
    func testAwardsLoadCorrectly() {
        XCTAssertTrue(Award.allAwards.isEmpty == false, "JSONからAwardsの読み込みを失敗しました")
    }

}
