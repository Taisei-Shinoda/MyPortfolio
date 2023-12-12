//
//  StoreView.swift
//  MyPortfolio
//
//  Created by Taisei Shinoda on 2023/12/12.
//

import StoreKit
import SwiftUI


struct StoreView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss
    /// アプリで購入できる商品の配列
    @State private var products = [Product]()
    
    var body: some View {
        NavigationStack {
            if let product = products.first {
                VStack(alignment: .leading) {
                    Text(product.displayName)
                        .font(.title)
                    Text(product.description)

                    Button("Buy Now") {
                        purchase(product)
                    }
                }
            }
        }
        .onChange(of: dataController.fullVersionUnlocked) { _ in
            checkForPurchase()
        }
        /// このload()はStoreViewが表示されるとすぐに呼び出される必要がある
        .task { await load() }
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
        Task { @MainActor in
            try await dataController.purchase(product)
        }
    }
    
    /// すべての商品をロードするメソッド
    func load() async {
        do {
            products = try await Product.products(for: [DataController.unlockPremiumProductID])
        } catch {
            print("読み込みエラー: \(error.localizedDescription)")
        }
    }
    
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView()
    }
}
