//
//  SidebarView.swift
//  MyPortfolio
//
//  Created by Taisei Shinoda on 2023/07/18.
//

import SwiftUI

struct SidebarView: View {
    @StateObject private var viewModel: ViewModel
    let smartFilters: [Filter] = [.all, .recent]
    
    /// ビュー モデルは DataController インスタンスにアクセスする必要があるが、環境からそれを読み取ることができない。
    /// ここで依存関係の注入が登場する。データ コントローラーを受け入れ、
    /// それを使用してビュー モデルを作成する新しいイニシャライザーを SidebarView に追加する必要がある。
    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        List(selection: $viewModel.dataController.selectedFilter) {
            Section("Smart Filters") {
                ForEach(smartFilters, content: SmartFilterRow.init)
            }
            
            Section("Tags") {
                ForEach(viewModel.tagFilters) { filter in
                    UserFilterRow(filter: filter, rename: viewModel.rename, delete: viewModel.delete)
                }
                .onDelete(perform: viewModel.delete)
            }
        }
        .toolbar(content: SidebarViewToolbar.init)
        .alert("Rename tag", isPresented: $viewModel.renamingTag) {
            Button("OK", action: viewModel.completeRename)
            Button("Cancel", role: .cancel) { }
            TextField("New name", text: $viewModel.tagName)
        }
        .navigationTitle("My Portfolio")
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(dataController: DataController.preview)
    }
}
