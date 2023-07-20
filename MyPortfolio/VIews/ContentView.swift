//
//  ContentView.swift
//  MyPortfolio
//
//  Created by Taisei Shinoda on 2023/07/17.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        List(selection: $dataController.selectedIssue) {
            ForEach(dataController.issuesForSelectedFilter()) { issue in
                IssueRow(issue: issue)
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Issues")
        .searchable(text: $dataController.filterText, tokens: $dataController.filterTokens, suggestedTokens: .constant(dataController.suggestedFilterTokens), prompt: "フィルタリング,または # を入力してタグを追加") { tag in
            Text(tag.tagName)
        }
        .toolbar {
            Menu {
                Button(dataController.filterEnabled ? "オフ" : "オン") {
                    dataController.filterEnabled.toggle()
                }
                
                Divider()
                
                Menu("並び替え") {
                    Picker("並び替え", selection: $dataController.sortType) {
                        Text("作成日").tag(SortType.dateCreated)
                        Text("変更日").tag(SortType.dateModified)
                    }
                    
                    Divider()
                    
                    Picker("並べ替え順", selection: $dataController.sortNewestFirst) {
                        Text("新規").tag(true)
                        Text("古い").tag(false)
                    }
                }
                
                Picker("ステータス", selection: $dataController.filterStatus) {
                    Text("全て").tag(Status.all)
                    Text("開く").tag(Status.open)
                    Text("閉じる").tag(Status.closed)
                }
                .disabled(dataController.filterEnabled == false)
                
                Picker("優先順位", selection: $dataController.filterPriority) {
                    Text("全て").tag(-1)
                    Text("低").tag(0)
                    Text("中").tag(1)
                    Text("高").tag(2)
                }
                .disabled(dataController.filterEnabled == false)
                
            } label: {
                Label("フィルター", systemImage: "line.3.horizontal.decrease.circle")
                    .symbolVariant(dataController.filterEnabled ? .fill : .none)
            }
            
            Button(action: dataController.newIssue) {
                Label("New issue", systemImage: "square.and.pencil")
            }
        }
    }
    
    
    
    func delete(_ offsets: IndexSet) {
        let issues = dataController.issuesForSelectedFilter()
        
        for offset in offsets {
            let item = issues[offset]
            dataController.delete(item)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
