//
//  ContentViewModel.swift
//  MyPortfolio
//
//  Created by Taisei Shinoda on 2023/10/21.
//

import Foundation


extension ContentView {
    @dynamicMemberLookup
    class ViewModel: ObservableObject {
        var dataController: DataController

        init(dataController: DataController) {
            self.dataController = dataController
        }
        
        
        
        func delete(_ offsets: IndexSet) {
            let issues = dataController.issuesForSelectedFilter()
            
            for offset in offsets {
                let item = issues[offset]
                dataController.delete(item)
            }
        }
        /// 読み書き可能なストアドプロパティ用
        subscript<Value>(dynamicMember keyPath: KeyPath<DataController, Value>) -> Value {
            dataController[keyPath: keyPath]
        }

        /// 読み取り専用プロパティ用
        /// クラス( ReferenceWritableKeyPath )を介して値の取得と設定を処理する
        subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<DataController, Value>) -> Value {
            get { dataController[keyPath: keyPath] }
            set { dataController[keyPath: keyPath] = newValue }
        }
    }
    
}
