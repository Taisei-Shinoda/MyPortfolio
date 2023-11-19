//
//  IssueViewToolbar.swift
//  MyPortfolio
//
//  Created by Taisei Shinoda on 2023/07/22.
//
import CoreHaptics
import SwiftUI

struct IssueViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var issue: Issue
    /// 単一のプロパティを追加することでビュー内にCHHapticEngine のインスタンスを作成
    @State private var engine = try? CHHapticEngine()
    var openCloseButtonText: LocalizedStringKey {
        issue.completed ? "Re-open Issue" : "Close Issue" }
//    issue.completed ? "Re-open Issue" : "Close Issue" }
    
    var body: some View {
        Menu {
            Button {
                UIPasteboard.general.string = issue.title
            } label: {
                Label("Copy Issue Title", systemImage: "doc.on.doc")
            }
            
            Button(action: toggleCompleted) {
                Label(openCloseButtonText, systemImage: "bubble.left.and.exclamationmark.bubble.right")
            }
            
            Divider()
            
            Section("Tags") {
                TagsMenuView(issue: issue)
            }
        } label: {
            Label("Actions", systemImage: "ellipsis.circle")
        }
    }
    
    func toggleCompleted() {
        issue.completed.toggle()
        dataController.save()
        
        do {
            try engine?.start()

            /// 手触りのパラメータ（鋭さと強さ）
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            
            /// パラメータカーブを作成
            let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
            let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)
            
            /// パラメータカーブの使用と制御
            let parameter = CHHapticParameterCurve(
                parameterID: .hapticIntensityControl,
                controlPoints: [start, end],
                relativeTime: 0
            )
            
            /// 1
            let event1 = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: 0
            )
            
            /// 2
            let event2 = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [sharpness, intensity],
                relativeTime: 0.125,
                duration: 1
            )
            
            /// 1, 2をシーケンスとして配列にまとめる
            let pattern = try CHHapticPattern(events: [event1, event2], parameterCurves: [parameter])
            
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
            
        } catch {
            // playing haptics didn't work, but that's okay
        }
    }
}

struct IssueViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        IssueViewToolbar(issue: Issue.example)
    }
}
