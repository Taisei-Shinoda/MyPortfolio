//
//  MyPortfolioTests.swift
//  MyPortfolioTests
//
//  Created by Taisei Shinoda on 2023/07/23.
//

import CoreData
import XCTest
@testable import MyPortfolio

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
