//
//  SidebarViewModel.swift
//  MyPortfolio
//
//  Created by Taisei Shinoda on 2023/09/20.
//

import CoreData
import Foundation
import SwiftUI

/// ビュー モデルは、基になるデータが変更されたときに UI を自動的に更新できる必要がある
/// ObservableObject プロトコルを使用することを意味する。これは、UI の更新を通知するタイプ
/// ViewModel という名前が SidebarView 内にネストされているため、自由に使用できる
extension SidebarView {
    class ViewModel: ObservableObject {

        @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var tags: FetchedResults<Tag>
        @Published var tagToRename: Tag?
        @Published var renamingTag = false
        @Published var tagName = ""
        @Published var showingAwards = false
        
        var tagFilters: [Filter] {
            tags.map { tag in
                Filter(id: tag.tagID, name: tag.tagName, icon: "tag", tag: tag)
            }
        }
        
        
        var dataController: DataController
        
        init(dataController: DataController) {
            self.dataController = dataController
        }
        
        func delete(_ offsets: IndexSet) {
            for offset in offsets {
                let item = tags[offset]
                dataController.delete(item)
            }
        }
        
        func rename(_ filter: Filter) {
            tagToRename = filter.tag
            tagName = filter.name
            renamingTag = true
        }
        
        func completeRename() {
            tagToRename?.name = tagName
            dataController.save()
        }
        
        func delete(_ filter: Filter) {
            guard let tag = filter.tag else { return }
            dataController.delete(tag)
            dataController.save()
        }
    }
}

