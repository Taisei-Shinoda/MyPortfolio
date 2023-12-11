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

}
