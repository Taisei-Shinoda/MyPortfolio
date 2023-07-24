//
//  PerformanceTests.swift
//  MyPortfolioTests
//
//  Created by Taisei Shinoda on 2023/07/24.
//

import XCTest
@testable import MyPortfolio


/// このテスト全体が大量のデータをベンチマークし、時間が経過しても公平性が維持されること担保する
class PerformanceTests: BaseTestCase {
    
    /// Awardの配列で filter() を呼び出すと、各要素は選択した述語関数 (結果に含める必要がある場合は true を返すテスト関数) に渡される
    func testAwardCalculationPerformance() throws {
        // 大量のテストデータ
        for _ in 1...100 {
            dataController.createSampleData()
        }
        
        // 多数のAwardをチェック
        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count, 500, "これはデータの数が一定である事をチェックする。データを追加する場合は、値を増やす。")
        
        measure {
            _ = awards.filter(dataController.hasEarned).count
        }
    }
}
