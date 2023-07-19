//
//  DataController.swift
//  MyPortfolio
//
//  Created by Taisei Shinoda on 2023/07/17.
//


import CoreData
import Foundation


class DataController: ObservableObject {
    
    let container: NSPersistentCloudKitContainer
    
    
    @Published var selectedFilter: Filter? = Filter.all
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        
        /*
         ユーザーがアプリを再起動するのを待つのではなく、変更があったときにUIを即座に更新させる。
         1. 永続ストアに発生した変更をビューコンテキストに自動的に適用し、2つの同期を維持する。
         2. ローカルデータとリモートデータのマージ処理方法をCore Dataに指示と処理の方法を教える。
         3. コードの外部で発生した変更を検出し、UI を更新させる。
         　　たとえば、iPhone と Mac の両方でアプリを実行している場合、iPhone で問題を削除すると Mac で変更通知がトリガーされるため、2 つのアプリは完全に同期された状態が維持される。
         
         */
        /// 1. 管理対象のビューコンテキストのBooleanプロパティを有効にすることで、Core Dataに処理を任せることができる
        container.viewContext.automaticallyMergesChangesFromParent = true

        /// 2.
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

        /// 3. 最初のメソッドは、ストアが変更されたときに通知されるようにCore Dataに指示し、2番目のメソッドは、変更が発生するたびにメソッドを呼び出すようにシステムに指示
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        NotificationCenter.default.addObserver(forName: .NSPersistentStoreRemoteChange, object: container.persistentStoreCoordinator, queue: .main, using: remoteStoreChanged)
        
        container.loadPersistentStores { storeDescription, error in
            if let error {
                fatalError("ロードに失敗: \(error.localizedDescription)")
            }
        }
    }
    
    /// 3. 変更通知が来たときに実行するメソッド
    func remoteStoreChanged(_ notification: Notification) {
        objectWillChange.send()
    }
    
    
    
    func createSampleData() {
        let viewContext = container.viewContext

        for i in 1...5 {
            let tag = Tag(context: viewContext)
            tag.id = UUID()
            tag.name = "Tag \(i)"

            for j in 1...10 {
                let issue = Issue(context: viewContext)
                issue.title = "Issue \(i)-\(j)"
                issue.content = "説明文"
                issue.creationDate = .now
                issue.completed = Bool.random()
                issue.priority = Int16.random(in: 0...2)
                tag.addToIssues(issue)
            }
        }

        try? viewContext.save()
    }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }
    
    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs

        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }
    
    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        delete(request1)

        let request2: NSFetchRequest<NSFetchRequestResult> = Issue.fetchRequest()
        delete(request2)

        save()
    }
    
    
    
}
