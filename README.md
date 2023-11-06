# My Portfolio

iPhoneで自分の課題を追加・確認・削除していくiOSアプリです。
Xcode 14.3.1 と Swift 5.8.1 を使用して作成されています。
また、SwiftUIを使って記述されているので実行するにはmacOS BigSurが必要です。


# 静的解析ツール

SwiftLint が導入されており、独自のスタイル及び検出対象を指定しました。
すでに Build Phases にて Xcode 上で自動的に SwiftLint が動作する様に、スクリプト(※1)を埋め込みました。

※1: このスクリプトはGitHubのSwiftLint READMEから直接取得


# ローカライズ

英語と日本語のローカライズが設定されています。
"System Language" で実行することにより、自動的に日本語にローカライゼーションされます。
 
