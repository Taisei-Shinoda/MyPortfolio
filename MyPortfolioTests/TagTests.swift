//
//  TagTests.swift
//  MyPortfolioTests
//
//  Created by Taisei Shinoda on 2023/07/23.
//

import CoreData
import XCTest
@testable import MyPortfolio


final class TagTests: BaseTestCase {
    
    /// 大量のタグを作成し、それらのタグに対する多くのIssueを作成し、コア データ コンテキストへのフェッチ リクエストがそれらすべてを返すか確認するテストメソッド
    func testCreatingTagsAndIssues() {
        let count = 10
        let issueCount = count * count

        for _ in 0..<count {
            let tag = Tag(context: managedObjectContext)

            for _ in 0..<count {
                let issue = Issue(context: managedObjectContext)
                tag.addToIssues(issue)
            }
        }

        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), count, "期待されるタグの数： \(count) tags.")
        XCTAssertEqual(dataController.count(for: Issue.fetchRequest()), issueCount, "期待されるIssueの数：\(issueCount) issues.")
    }
    
    /// サンプル データの標準セットを作成し、すべてのタグをフェッチする。
    /// それらの最初の 1 つを削除して、タグが 4 つと問題が 50 個残っていることをアサートするテストメソッド
    func testDeletingTagDoesNotDeleteIssues() throws {
        dataController.createSampleData()

        let request = NSFetchRequest<Tag>(entityName: "Tag")
        let tags = try managedObjectContext.fetch(request)

        dataController.delete(tags[0])

        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 4, "1 を削除した後、4 つのタグを期待")
        XCTAssertEqual(dataController.count(for: Issue.fetchRequest()), 50, "タグを1つ削除すると、50件の問題が発生すると予想される")
    }
}
