//
//  IssueRow.swift
//  MyPortfolio
//
//  Created by Taisei Shinoda on 2023/07/19.
//

import SwiftUI

struct IssueRow: View {
    
    @EnvironmentObject var dataController: DataController
    @StateObject var viewModel: ViewModel
    
    init(issue: Issue) {
        let viewModel = ViewModel(issue: issue)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationLink(value: viewModel.issue) {
            HStack {
                Image(systemName: "exclamationmark.circle")
                    .imageScale(.large)
                    .opacity(viewModel.iconOpacity)
                    .accessibilityIdentifier(viewModel.iconIdentifier)

                VStack(alignment: .leading) {
                    Text(viewModel.issue.issueTitle)
                        .font(.headline)
                        .lineLimit(1)

                    Text(viewModel.issue.issueTagsList)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text(viewModel.creationDate)
                        .accessibilityLabel(viewModel.accessibilityCreationDate)
                        .font(.subheadline)

                    if viewModel.issue.completed {
                        Text("CLOSED")
                            .font(.body.smallCaps())
                    }
                }
                .foregroundStyle(.secondary)
            }
        }
        .accessibilityHint(viewModel.accessibilityHint)
        .accessibilityIdentifier(viewModel.issue.issueTitle) // UIテスト用
    }
}

struct IssueRow_Previews: PreviewProvider {
    static var previews: some View {
        IssueRow(issue: .example)
    }
}
