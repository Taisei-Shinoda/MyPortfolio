//
//  DevelopmentTests.swift
//  MyPortfolioTests
//
//  Created by Taisei Shinoda on 2023/07/24.
//

import CoreData
@testable import MyPortfolio
import XCTest

final class DevelopmentTests: BaseTestCase {

    
    func testSampleDataCreationWorks() {
        dataController.createSampleData()

        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 5, "タグ例は5個ある必要がある")
        XCTAssertEqual(dataController.count(for: Issue.fetchRequest()), 50, "Issue例は50個ある必要がある")
    }
    
    
    func testDeleteAllClearsEverything() {
        dataController.createSampleData()
        dataController.deleteAll()

        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 0, "0個のタグを残す必要がある")
        XCTAssertEqual(dataController.count(for: Issue.fetchRequest()), 0, "0個のIssueを残す必要がある")
    }
    
    
    func testExampleTagHasNoIssues() {
        let tag = Tag.example
        XCTAssertEqual(tag.issues?.count, 0, "タグ例に課題は無いはず")
    }

    func testExampleIssueIsHighPriority() {
        let issue = Issue.example
        XCTAssertEqual(issue.priority, 2, "Issue例は最優先される必要がある")
    }
}


/*
 サンプルコードが正しくロードされることを確認するためのテストを書く。
 deleteAll()メソッドが動作することを確認するテストを書く。
 TagクラスとIssueクラスの両方が適切なサンプル・データを持っていることを確認するテストを作成する。
 
 */
