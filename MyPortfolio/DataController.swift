//
//  DataController.swift
//  MyPortfolio
//
//  Created by Taisei Shinoda on 2023/07/17.
//


import CoreData
import Foundation
import StoreKit
import SwiftUI


enum SortType: String {
    case dateCreated = "creationDate"
    case dateModified = "modificationDate"
}

enum Status {
    case all
    case open
    case closed
}


/// 保存処理、フェッチリクエストのカウント、アワードのトラッキング、サンプルデータの処理など
class DataController: ObservableObject {
    
    let container: NSPersistentCloudKitContainer
    
    /// Core Spotlight添字を保存し、CoreDataがデータへの変更をトラッキング可能にする
    var spotlightDelegate: NSCoreDataCoreSpotlightDelegate?
    
    
    /// Core Data がエンティティを登録する際の競合を防ぐため [1]
    /// マネージド オブジェクト モデル (Main.momd ファイル) を 1 回だけロードするように指示
    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }
        
        return managedObjectModel
    }()
    
    @Published var selectedFilter: Filter? = Filter.all
    @Published var selectedIssue: Issue?
    @Published var filterText = ""
    @Published var filterTokens = [Tag]()
    @Published var filterEnabled = false
    
    /// 特別な優先順位(あらゆる順位)として -1
    @Published var filterPriority = -1
    @Published var filterStatus = Status.all
    @Published var sortType = SortType.dateCreated
    
    @Published var sortNewestFirst = true
    /// StoreKitで読み込んだ商品
    @Published var products = [Product]()
    
    var suggestedFilterTokens: [Tag] {
        guard filterText.starts(with: "#") else {
            return []
        }
        
        let trimmedFilterText = String(filterText.dropFirst()).trimmingCharacters(in: .whitespaces)
        let request = Tag.fetchRequest()
        
        if trimmedFilterText.isEmpty == false {
            request.predicate = NSPredicate(format: "name CONTAINS[c] %@", trimmedFilterText)
        }
        
        return (try? container.viewContext.fetch(request).sorted()) ?? []
    }
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()
    
    private var saveTask: Task<Void, Error>?
    
    /// アプリ内課金におけるユーザー データを保存する UserDefaults スイート
    let defaults: UserDefaults
    
    /// アプリが起動したらすぐにmonitorTransactions()を呼び出すタスクを作成するので、情報を保存する為のスイート
    private var storeTask: Task<Void, Never>?
    
    
    /// データコントローラーを初期化する
    /// - Parameter inMemory: データを一時メモリに保存するかどうか
    /// - Parameter defaults: ユーザーデータを保存するUserDefaultsスイート
    init(inMemory: Bool = false, defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        /// Core Data がエンティティを登録する際の競合を防ぐため
        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)
        
        /// アプリが起動したらすぐにmonitorTransactions()を呼び出す
        storeTask = Task { await monitorTransactions() }
        
        
        // テストとプレビューの目的で、/dev/null に書き込むことによる一時的なメモリ内データベース
        // アプリの実行終了後にデータは破棄される
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        
        /// ユーザーがアプリを再起動するのを待つのではなく、変更があったときにUIを即座に更新させる。
        /// 1. 永続ストアに発生した変更をビューコンテキストに自動的に適用し、2つの同期を維持する。
        /// 2. ローカルデータとリモートデータのマージ処理方法をCore Dataに指示と処理の方法を教える。
        /// 3. コードの外部で発生した変更を検出し、UI を更新させる。
        /// たとえば、iPhone と Mac の両方でアプリを実行している場合、iPhone で問題を削除すると Mac で変更通知がトリガーされるため、2 つのアプリは完全に同期された状態が維持される。
        
        /// 1. 管理対象のビューコンテキストのBooleanプロパティを有効にすることで、Core Dataに処理を任せることができる
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        /// 2.メモリ内バージョンの間の競合を解決
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        /// 3. 最初のメソッドは、ストアが変更されたときに通知されるようにCore Dataに指示し、2番目のメソッドは、変更が発生するたびにメソッドを呼び出すようにシステムに指示
        container.persistentStoreDescriptions.first?.setOption(
            true as NSNumber,
            forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        NotificationCenter.default.addObserver(
            forName: .NSPersistentStoreRemoteChange,
            object: container.persistentStoreCoordinator,
            queue: .main,
            using: remoteStoreChanged)
        
        container.loadPersistentStores { [weak self] _, error in
            /// 成功または失敗にかかわらず、コア データ スタックの読み込みが完了したことを意味
            if let error {
                fatalError("ロードに失敗: \(error.localizedDescription)")
            }
            
            /// Spotlight でのトラッキングを可能にする
            if let description = self?.container.persistentStoreDescriptions.first {
                description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
                
                if let coordinator = self?.container.persistentStoreCoordinator {
                    self?.spotlightDelegate = NSCoreDataCoreSpotlightDelegate(
                        forStoreWith: description,
                        coordinator: coordinator
                    )
                    /// インデックス作成デリゲートを作成
                    self?.spotlightDelegate?.startSpotlightIndexing()
                }
            }
            
            /// UI テスト ターゲット用のデバッグ モード
            /// if let error = エラーコードが実行され、Core Dataスタックのロードが完了した場合テストのための白紙の状態にするためのエントリポイント
            /// アプリがテスト環境にあることを認識できるようにその起動引数を認識し、既存のデータを削除してその構成に応答するコードを追加
#if DEBUG
            if CommandLine.arguments.contains("enable-testing") {
                self?.deleteAll()
                /// アプリのすべてのアニメーションが無効になり、UI テストが大幅に高速化される
                UIView.setAnimationsEnabled(false)
            }
#endif
            
        }
    }
    
    /// 3. 変更通知が来たときに実行するメソッド
    func remoteStoreChanged(_ notification: Notification) {
        objectWillChange.send()
    }
    
    func queueSave() {
        saveTask?.cancel()
        
        saveTask = Task { @MainActor in
            try await Task.sleep(for: .seconds(3))
            save()
        }
    }
    
    func missingTags(from issue: Issue) -> [Tag] {
        let request = Tag.fetchRequest()
        let allTags = (try? container.viewContext.fetch(request)) ?? []
        
        let allTagsSet = Set(allTags)
        let difference = allTagsSet.symmetricDifference(issue.issueTags)
        
        return difference.sorted()
    }
    
    
    func createSampleData() {
        let viewContext = container.viewContext
        
        for tagCounter in 1...5 {
            let tag = Tag(context: viewContext)
            tag.id = UUID()
            tag.name = "Tag \(tagCounter)"
            
            for issueCounter in 1...10 {
                let issue = Issue(context: viewContext)
                issue.title = "Issue \(tagCounter)-\(issueCounter)"
                //                issue.content = "説明文"
                issue.creationDate = .now
                issue.completed = Bool.random()
                issue.priority = Int16.random(in: 0...2)
                tag.addToIssues(issue)
            }
        }
        
        try? viewContext.save()
    }
    
    func save() {
        saveTask?.cancel()
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
    
    func issuesForSelectedFilter() -> [Issue] {
        let filter = selectedFilter ?? .all
        var predicates = [NSPredicate]()
        
        if let tag = filter.tag {
            let tagPredicate = NSPredicate(format: "tags CONTAINS %@", tag)
            predicates.append(tagPredicate)
        } else {
            let datePredicate = NSPredicate(format: "modificationDate > %@", filter.minModificationDate as NSDate)
            predicates.append(datePredicate)
        }
        
        let trimmedFilterText = filterText.trimmingCharacters(in: .whitespaces)
        
        /// フィルタリングの述語
        if trimmedFilterText.isEmpty == false {
            let titlePredicate = NSPredicate(format: "title CONTAINS[c] %@", trimmedFilterText)
            let contentPredicate = NSPredicate(format: "content CONTAINS[c] %@", trimmedFilterText)
            
            let combinedPredicate = NSCompoundPredicate(
                orPredicateWithSubpredicates: [titlePredicate, contentPredicate]
            )
            
            predicates.append(combinedPredicate)
        }
        
        /// フィルタリングの述語
        if filterTokens.isEmpty == false {
            let tokenPredicate = NSPredicate(format: "ANY tags IN %@", filterTokens)
            predicates.append(tokenPredicate)
        }
        
        /// フィルタリングの述語
        if filterEnabled {
            if filterPriority >= 0 {
                let priorityFilter = NSPredicate(format: "priority = %d", filterPriority)
                predicates.append(priorityFilter)
            }
            
            if filterStatus != .all {
                let lookForClosed = filterStatus == .closed
                let statusFilter = NSPredicate(format: "completed = %@", NSNumber(value: lookForClosed))
                predicates.append(statusFilter)
            }
        }
        
        
        let request = Issue.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: sortType.rawValue, ascending: sortNewestFirst)]
        
        let allIssues = (try? container.viewContext.fetch(request)) ?? []
        return allIssues
    }
    
    func newIssue() {
        let issue = Issue(context: container.viewContext)
        issue.title = NSLocalizedString("New issue", comment: "Create a new issue")
        issue.creationDate = .now
        issue.priority = 1
        
        if let tag = selectedFilter?.tag {
            issue.addToTags(tag)
        }
        save()
        selectedIssue = issue
    }

    func newTag() -> Bool {
        var shouldCreate = fullVersionUnlocked

        if shouldCreate == false {
            // 現在のタグの数をチェック（ユーザーが無料でタグを 3 つまで作成できるように制限）
            shouldCreate = count(for: Tag.fetchRequest()) < 3
        }

        guard shouldCreate else {
            return false
        }
        
        let tag = Tag(context: container.viewContext)
        tag.id = UUID()
        tag.name = NSLocalizedString("New tag", comment: "Create a new tag")
        save()
        return true
    }
    
    
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    
    
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "issues":
            let fetchRequest = Issue.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
            
        case "closed":
            let fetchRequest = Issue.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
            
        case "tags":
            let fetchRequest = Tag.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
            
        default:
            return false
        }
    }
    
    /// Core Data 識別子URL オブジェクトに変換してオブジェクトを検索できるようにする
    /// その URL を使用して、オブジェクトのコア データ識別子を検索
    func issue(with uniqueIdentifier: String) -> Issue? {
        guard let url = URL(string: uniqueIdentifier) else { return nil }
        
        guard let id = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
            return nil
        }
        return try? container.viewContext.existingObject(with: id) as? Issue
    }
}
