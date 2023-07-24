//
//  AwardTests.swift
//  MyPortfolioTests
//
//  Created by Taisei Shinoda on 2023/07/23.
//

import CoreData
import XCTest
@testable import MyPortfolio


final class AwardTests: BaseTestCase {

    let awards = Award.allAwards
    
    /// AwardID と名前が一致しているか確認するテストメソッド
    func testAwardIDMatchesName() {
        for award in awards {
            XCTAssertEqual(award.id, award.name, "AwardIDは常にその名前と一致する必要がある")
        }
    }
    
    /// 新規ユーザーとAward の関係性を評価するテストメソッド
    func testNewUserHasUnlockedNoAwards() {
        for award in awards {
            XCTAssertFalse(dataController.hasEarned(award: award), "新規ユーザーはアワードを獲得していない必要がある")
        }
    }
    
    /// ユーザーが様々な数の課題を追加した場合、課題アワードのロックを解除するか評価するテストメソッド
    func testCreatingIssuesUnlocksAwards() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]

        for (count, value) in values.enumerated() {
            var issues = [Issue]()

            for _ in 0..<value {
                let issue = Issue(context: managedObjectContext)
                issues.append(issue)
            }

            let matches = awards.filter { award in
                award.criterion == "issues" && dataController.hasEarned(award: award)
            }

            XCTAssertEqual(matches.count, count + 1, "値である \(value) を追加すると、\(count + 1) のAwardがロック解除される必要がある")

            dataController.deleteAll()
        }
    }
    
    /// ユーザーがさまざまな数のissueをクローズしたら、完了アワードのロックを解除するか評価するテストメソッド
    func testClosedAwards() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]

        for (count, value) in values.enumerated() {
            var issues = [Issue]()

            for _ in 0..<value {
                let issue = Issue(context: managedObjectContext)
                issue.completed = true
                issues.append(issue)
            }

            let matches = awards.filter { award in
                award.criterion == "closed" && dataController.hasEarned(award: award)
            }

            XCTAssertEqual(matches.count, count + 1, "値である \(value) を解決すると、 \(count + 1) のAwardがロック解除される必要がある")

            for issue in issues {
                dataController.delete(issue)
            }
        }
    }
}
