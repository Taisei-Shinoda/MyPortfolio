//
//  DataController-StoreKit.swift
//  MyPortfolio
//
//  Created by Taisei Shinoda on 2023/12/11.
//

import Foundation
import StoreKit


extension DataController {
    /// アプリ内課金プロダクトID
    static let unlockPremiumProductID = "com.taiseishinoda.MyPortfolio.premiumUnlock"

    /// アプリ内課金がされているかをロードして、保存
    var fullVersionUnlocked: Bool {
        get {
            defaults.bool(forKey: "fullVersionUnlocked")
        }

        set {
            defaults.set(newValue, forKey: "fullVersionUnlocked")
        }
    }
    
    /// 重要な UI 側のプロパティを変更するため、バックグラウンド タスクでの変更を避ける必要があるため @MainActor を付与
    @MainActor
    func finalize(_ transaction: Transaction) async {
        /// 作業しているトランザクションがプロダクト ID に関するものである場合は、unlockPremiumProductID プロパティを変更しようとしていることを通知
        if transaction.productID == Self.unlockPremiumProductID {
            objectWillChange.send()
            /// revocationDate には有効な日付が含まれるため、それが nil の場合はアップグレードのロックを解除できることを意味
            fullVersionUnlocked = transaction.revocationDate == nil
            /// コンテンツへのアクセスを許可したため、トランザクションで安全にfinish()を呼び出すことができます。
            await transaction.finish()
        }
    }
    
    /// products 配列に既に製品がある場合は、すぐに終了します。
    /// 0.2秒の小さな待機を追加して、アプリがロードしようとしていることをユーザーが視覚的に確認できるようにします。
    @MainActor
    func loadProducts() async throws {
        // 製品を複数回ロードしない
        guard products.isEmpty else { return }

        try await Task.sleep(for: .seconds(0.2))
        products = try await Product.products(for: [Self.unlockPremiumProductID])
    }
    
    // 既存のエンタイトルメントに関する処理
    func monitorTransactions() async {
        /// 過去の購入履歴を確認する
        for await entitlement in Transaction.currentEntitlements {
            if case let .verified(transaction) = entitlement {
                await finalize(transaction)
            }
        }

        /// 今後の取引に注目
        for await update in Transaction.updates {
            if let transaction = try? update.payloadValue {
                await finalize(transaction)
            }
        }
    }
    
    // 購入フロー全体をトリガーする処理
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()

        // 製品の購入が成功した場合、トランザクションを読み取って処理
        if case let .success(validation) = result {
            try await finalize(validation.payloadValue)
        }
    }
    
    
    
    
    
    

}
