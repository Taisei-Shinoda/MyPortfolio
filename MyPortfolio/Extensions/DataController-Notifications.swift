//
//  DataController-Notifications.swift
//  MyPortfolio
//
//  Created by Taisei Shinoda on 2023/10/27.
//

import Foundation
import UserNotifications

/// 呼び出されるメソッドを4つに分割して追加
/// 特定の問題に対して通知を追加し、ユーザーがトグルをオフにした場合は通知を削除できるようにする
extension DataController {
    
    /// 条件（通知許可）に応じてIssueオブジェクトを操作するメソッドを呼び出す
    func addReminder(for issue: Issue) async -> Bool {
        do {
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()
            
            switch settings.authorizationStatus {
                /// 通知不許可
            case .notDetermined:
                let success = try await requestNotifications()
                
                if success {
                    try await placeReminders(for: issue)
                } else {
                    return false
                }
                
                /// 通知許可
            case .authorized:
                try await placeReminders(for: issue)
                
            default:
                return false
            }
            
            return true
        } catch {
            return false
        }
    }
    
    /// 特定のIssueに対して設定された通知を削除します
    /// CoreData は Issue を一意に識別する（オブジェクトが一度保存されれば、このURLは常に一意であり指定されたオブジェクトの導線を提供する）
    func removeReminders(for issue: Issue) {
        let center = UNUserNotificationCenter.current()
        let id = issue.objectID.uriRepresentation().absoluteString
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    /// このメソッドはiOSに通知の認可を要求し、システムから返ってきたもの（この場合は認可が許可されたかどうか）を返す
    /// 通知の許可のリクエストは必ず非同期タスク
    private func requestNotifications() async throws -> Bool {
        let center = UNUserNotificationCenter.current()
        return try await center.requestAuthorization(options: [.alert, .sound])
    }
    
    /// Issue に対して 1 つの通知を配置する作業を実行
    /// 通知の許可のリクエストは必ず非同期タスク
    private func placeReminders(for issue: Issue) async throws {
        /// 課題のタイトルと、通知用のデフォルトのシステムサウンド
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = issue.issueTitle
        
        if let issueContent = issue.content {
            content.subtitle = issueContent
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let id = issue.objectID.uriRepresentation().absoluteString
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        return try await UNUserNotificationCenter.current().add(request)
    }
}
