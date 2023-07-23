//
//  TagsMenuView.swift
//  MyPortfolio
//
//  Created by Taisei Shinoda on 2023/07/22.
//

import SwiftUI

struct TagsMenuView: View {
    @ObservedObject var issue: Issue
    @EnvironmentObject var dataController: DataController
    var body: some View {
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
}

struct TagsMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TagsMenuView(issue: Issue.example)
    }
}
