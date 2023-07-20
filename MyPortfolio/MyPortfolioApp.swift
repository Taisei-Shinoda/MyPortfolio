//
//  MyPortfolioApp.swift
//  MyPortfolio
//
//  Created by Taisei Shinoda on 2023/07/17.
//

import SwiftUI

@main
struct MyPortfolioApp: App {
    
    @StateObject var dataController = DataController()
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                SidebarView()
            } content: {
                ContentView()
            } detail: {
                DetailView()
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .onChange(of: scenePhase) { phase in
                if phase != .active {
                    dataController.save()
                }
            }
        }
    }
}
