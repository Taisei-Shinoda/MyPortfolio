//
//  StoreView.swift
//  MyPortfolio
//
//  Created by Taisei Shinoda on 2023/12/12.
//

import StoreKit
import SwiftUI


struct StoreView: View {
    /// ストアにおける状態遷移を切り替え
    enum LoadState {
        case loading, loaded, error
    }
    /// アプリ内課金が可能かどうかのスイッチ
    @State private var showingPurchaseError = false
    /// アプリで購入できる商品の配列
    @State private var products = [Product]()
    @State private var loadState = LoadState.loading
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // ヘッダー
                VStack {
                    Image(decorative: "unlock")
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(.degrees(90))
                    
                    Text("Upgrade Today!")
                        .font(.title.bold())
                        .fontDesign(.rounded)
                        .foregroundStyle(.white)
                    
                    Text("Get the most out of the app")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(.blue.gradient)
                
                
                ScrollView {
                    VStack {
                        switch loadState {
                        case .loading:
                            Text("Loading...")
                                .font(.title2.bold())
                                .padding(.top, 50)
                            ProgressView()
                                .controlSize(.large)
                            
                        case .loaded:
                            ForEach(dataController.products) { product in
                                Button {
                                    purchase(product)
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(product.displayName)
                                                .font(.title2.bold())
                                            Text(product.description)
                                                .font(.callout)
                                                
                                        }

                                        Spacer()

                                        Text(product.displayPrice)
                                            .font(.title)
                                            .fontDesign(.rounded)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(.gray.opacity(0.2))
                                    .cornerRadius(.infinity)
                                }
                                .buttonStyle(.plain)
                            }
                            
                            
                        case .error:
                            Text("Sorry, there was an error loading our store.")
                                .padding(.top, 50)
                            Button("Try Again") {
                                Task {
                                    await load()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            
                        }
                    }
                    .padding(20)
                }
                // フッター
                Button("Restore Purchases", action: restore)
                
                Button("Cancel") {
                    dismiss()
                }
                .padding(.top, 20)
                
                
            }
        }
        .onChange(of: dataController.fullVersionUnlocked) { _ in
            checkForPurchase()
        }
        /// このload()はStoreViewが表示されるとすぐに呼び出される必要がある
        .task { await load() }
        .alert("In-app purchases are disabled", isPresented: $showingPurchaseError) {
        } message: {
            Text("""
            You can't purchase the premium unlock because in-app purchases are disabled on this device.Please ask whomever manages your device for assistance.
            """)
        }
    }
    /// すべての商品をロードするメソッド
    func checkForPurchase() {
        if dataController.fullVersionUnlocked {
            dismiss()
        }
    }
    
    /// 商品ボタンから呼び出される購入操作をトリガーするメソッド
    /// 非同期で実行できるようにする為、バックグラウンドタスクでラップするというステップを踏む
    func purchase(_ product: Product) {
        /// アプリ内課金が可能かどうかを確認する処理
        guard AppStore.canMakePayments else {
            showingPurchaseError.toggle()
            return
        }
        Task { @MainActor in
            try await dataController.purchase(product)
            
        }
    }
    
    /// すべての商品をロードするメソッド
    func load() async {
        loadState = .loading
        
        do {
            try await dataController.loadProducts()
            
            if dataController.products.isEmpty {
                loadState = .error
            } else {
                loadState = .loaded
            }
        } catch {
            loadState = .error
        }
    }
    
    func restore() {
        Task {
            try await AppStore.sync()
        }
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView()
    }
}
