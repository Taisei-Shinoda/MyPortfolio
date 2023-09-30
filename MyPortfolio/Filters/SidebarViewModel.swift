//
//  SidebarViewModel.swift
//  MyPortfolio
//
//  Created by Taisei Shinoda on 2023/09/20.
//

import CoreData
import Foundation

/// ビュー モデルは、基になるデータが変更されたときに UI を自動的に更新できる必要がある
/// ObservableObject プロトコルを使用することを意味する。これは、UI の更新を通知するタイプ
/// ViewModel という名前が SidebarView 内にネストされているため、自由に使用できる
extension SidebarView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {

//        @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var tags: FetchedResults<Tag>
        private let tagsController: NSFetchedResultsController<Tag>
        @Published var tags = [Tag]()
        
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
            
            /// データをロードする NSFetchRequest を作成する
            /// これを直接実行するのではなく、取得した結果コントローラーに渡して更新を維持できるようにする
            let request = Tag.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Tag.name, ascending: true)]
            /// NSFetchRequest を NSFetchedResultsController でラップする
            tagsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            /// ビュー モデル クラスをNSFetchedResultsControllerのデリゲートとして設定
            /// NSObjectを継承しているため、NSObjectのクラス自身を作成する機会を与える必要がある = super.init()の追加
            super.init()
            tagsController.delegate = self
            
            do {
                try tagsController.performFetch()
                tags = tagsController.fetchedObjects ?? []
            } catch {
                print("タグのフェッチ：失敗")
            }
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
       
        /// データが変更されたときに通知を受け取ることができる
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newTags = controller.fetchedObjects as? [Tag] {
                tags = newTags
            }
        }
    }
}

