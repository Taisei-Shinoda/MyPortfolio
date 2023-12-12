//
//  SidebarViewToolbar.swift
//  MyPortfolio
//
//  Created by Taisei Shinoda on 2023/07/22.
//

import SwiftUI

struct SidebarViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    @State private var showingAwards = false
    
    // 新しいタグの追加に失敗したときにストアを表示するための追跡
    @State private var showingStore = false
    
    var body: some View {
        
            Button(action: tryNewTag) {
                Label("Add tag", systemImage: "plus")
            }
            .sheet(isPresented: $showingStore, content: StoreView.init)
            
            Button {
                showingAwards.toggle()
            } label: {
                Label("Show awards", systemImage: "rosette")
            }
            .sheet(isPresented: $showingAwards, content: AwardsView.init)
            
            #if DEBUG
            Button {
                dataController.deleteAll()
                dataController.createSampleData()
            } label: {
                Label("ADD SAMPLES", systemImage: "flame")
            }
            #endif
    }
    
    func tryNewTag() {
        if dataController.newTag() == false {
            showingStore = true
        }
    }
}

struct SidebarViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        SidebarViewToolbar()
    }
}
