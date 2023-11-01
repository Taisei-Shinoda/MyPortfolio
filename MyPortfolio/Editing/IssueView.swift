//
//  IssueView.swift
//  MyPortfolio
//
//  Created by Taisei Shinoda on 2023/07/19.
//

import SwiftUI

struct IssueView: View {
    @ObservedObject var issue: Issue
    @EnvironmentObject var dataController: DataController
    
    /// リマインダーを設定しようとして失敗した場合の為のトラッキングプロパティ
    @State private var showingNotificationsError = false
    /// 通知の設定に失敗した時、ユーザーをアプリの設定にリンクさせ、そこで通知設定を確認して修正できるようにする
    @Environment(\.openURL) var openURL
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    TextField("Title", text: $issue.issueTitle, prompt: Text("Enter the issue title here"))
                        .font(.title)
                    
                    /// マークダウン ( ** -- **)
                    Text("**Modified:** \(issue.issueModificationDate.formatted(date: .long, time: .shortened))")
                        .foregroundStyle(.secondary)
                    
                    Text("**Status:** \(issue.issueStatus)")
                        .foregroundStyle(.secondary)
                    
                }
                
                Picker("Priority", selection: $issue.priority) {
                    Text("Low").tag(Int16(0))
                    Text("Medium").tag(Int16(1))
                    Text("High").tag(Int16(2))
                }
                
                TagsMenuView(issue: issue)
            }
            
            Section {
                VStack(alignment: .leading) {
                    Text("Basic Information")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    TextField(
                        "Description",
                        text: $issue.issueContent,
                        prompt: Text("Enter the issue description here"),
                        axis: .vertical
                    )
                }
            }
            
            /// リマンダーの追加
            Section("Reminders") {
                Toggle("Show reminders", isOn: $issue.reminderEnabled.animation())

                if issue.reminderEnabled {
                   DatePicker(
                       "Reminder time",
                       selection: $issue.issueReminderTime,
                       displayedComponents: .hourAndMinute
                   )
                }
            }
        }
        .disabled(issue.isDeleted)
        .onChange(of: issue) { _ in
            dataController.queueSave()
        }
        .onReceive(issue.objectWillChange) { _ in
            dataController.queueSave()
        }
        .onSubmit(dataController.save)
        .toolbar {
            IssueViewToolbar(issue: issue)
        }
        .alert("おっと！", isPresented: $showingNotificationsError) {
            Button("設定を確認", action: showAppSettings)
            Button("キャンセル", role: .cancel) { }
        } message: {
            Text("通知の設定に問題がありました。通知が有効になっているか確認してください。")
        }
        .onChange(of: issue.reminderEnabled) { _ in updateReminder() }
        .onChange(of: issue.reminderTime) { _ in updateReminder() }
        
        
    }
    
    /// 通知設定へのアクセス許可へのスタブ
    func showAppSettings() {
        /// openNotificationSettingsURLString は設定へのディープリンクに使用するURL文字列
        guard let settingsURL = URL(string: UIApplication.openNotificationSettingsURLString) else {
            return
        }
        openURL(settingsURL)
    }
    
    /// 🚨IssueオブジェクトのreminderEnabledの値が更新された時、トラッキングプロパティを更新
    func updateReminder() {
        dataController.removeReminders(for: issue)

        
        Task {
            
        }
        
        
    }
}

struct IssueView_Previews: PreviewProvider {
    static var previews: some View {
        IssueView(issue: .example)
    }
}
