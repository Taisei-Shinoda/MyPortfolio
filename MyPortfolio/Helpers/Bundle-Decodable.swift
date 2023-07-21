//
//  Bundle-Decodable.swift
//  MyPortfolio
//
//  Created by Taisei Shinoda on 2023/07/20.
//

import Foundation


extension Bundle {
    func decode<T: Decodable>(_ file: String, as type: T.Type = T.self,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("バンドルにある \(file) が見つけられません。")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("バンドルにある \(file) ロードできません。")
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("キーが見つからない為、 \(file) からのデコードに失敗しました '\(key.stringValue)' – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("型と適合しない為 \(file) からのデコードに失敗しました – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("バンドル \(file) からデコード出来ませんでした。※ \(type) が見つからない – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("無効なJSONな為 \(file) からのデコードに失敗しました")
        } catch {
            fatalError("バンドルからの \(file) デコードに失敗しました: \(error.localizedDescription)")
        }
    }
    
}


