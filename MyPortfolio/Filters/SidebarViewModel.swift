//
//  SidebarViewModel.swift
//  MyPortfolio
//
//  Created by Taisei Shinoda on 2023/09/20.
//

import CoreData
import Foundation


/// ビュー モデルは、基になるデータが変更されたときに UI を自動的に更新できる必要がある
/// ObservableObject プロトコルを使用することを意味する。これは、UI の更新を通知するタイプ
/// ViewModel という名前が SidebarView 内にネストされているため、自由に使用できる
extension SidebarView {
    class ViewModel: ObservableObject {

    }
}

