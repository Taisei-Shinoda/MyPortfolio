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
    
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    TextField("Title", text: $issue.issueTitle, prompt: Text("ここにタイトルを入力"))
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
                
                Menu {
                    // 選択されたタグ
                    ForEach(issue.issueTags) { tag in
                        Button {
                            issue.removeFromTags(tag)
                        } label: {
                            Label(tag.tagName, systemImage: "checkmark")
                        }
                    }
                    
                    // 未選択のタグ
                    let otherTags = dataController.missingTags(from: issue)
                    
                    if otherTags.isEmpty == false {
                        Divider()
                        
                        Section("Add Tags") {
                            ForEach(otherTags) { tag in
                                Button(tag.tagName) {
                                    issue.addToTags(tag)
                                }
                            }
                        }
                    }
                } label: {
                    Text(issue.issueTagsList)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .animation(nil, value: issue.issueTagsList)
                }
                
                
            }
            
            
            Section {
                VStack(alignment: .leading) {
                    Text("Basic Information")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    TextField("説明", text: $issue.issueContent, prompt: Text("説明内容"), axis: .vertical)
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
            Menu {
                Button {
                    UIPasteboard.general.string = issue.title
                } label: {
                    Label("コピー", systemImage: "doc.on.doc")
                }

                Button {
                    issue.completed.toggle()
                    dataController.save()
                } label: {
                    Label(issue.completed ? "再度開く" : "閉じる", systemImage: "bubble.left.and.exclamationmark.bubble.right")
                }
            } label: {
                Label("アクション", systemImage: "ellipsis.circle")
            }
        }
    }
}

struct IssueView_Previews: PreviewProvider {
    static var previews: some View {
        IssueView(issue: .example)
    }
}
