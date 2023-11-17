# My Portfolio
iPhoneで自分の課題を追加・確認・削除していくiOSアプリです。

## アプリの概要
自分の中で思い浮かぶ疑問や改善点、忘れない様にしたい事柄などを保管します。
それをこのアプリでは「課題」と呼びます。

## フレームワーク
以下のフレームワークが使用されています。

- SwiftUI
- CoreData 
- CoreSpotlight
- UserNotifications
- XCTest

## デザインパターン
- MVVM

## 利用方法
### 基本的な操作
#### 
「Issue」行をタップして、その詳細ビューに入ります。
- 課題のタイトルを変更できます。
- 課題の変更日が即時的に反映されます。
- 課題の優先度(低・中・高）を変更できます。
- 課題にタグ付けできます。
- 課題の詳細・仮説テキストフィールドにテキストを記述できます。
- 課題を忘れたくない場合、リマンダー設定で好きな時刻に通知を設定できます。

### タグの追加
#### 
最上右の🔥ボタンを押すと、Tag1~5までのタグ行が自動的に追加されますが、
元々存在した「Tag」は上書きされてしまいます。(※1)
もし一つずつ追加したい場合、最上左の➕ボタンを押すと一つずつ追加されます。

### フィルター機能
#### 
「タグ名」・「作成日」・「変更日」でフィルターをかけられます。
また「課題ビュー」で下にスクロールすると、上部に検索フィールドが出現します。
そこで"#"を押すと、「タグ名」で検索がかけられます。

### 通知（リマインダー）の設定
#### 
もしiOSの設定画面で通知を許可しておらず、リマンダーを設定したい場合はアラートから自動的にiOSの設定画面へ遷移します。


## 静的解析ツール
SwiftLint が導入されており、独自のスタイル及び検出対象を指定しました。
既に Xcode 上の Build Phases へ、自動的に SwiftLint が動作する様にスクリプト(※1)を埋め込みました。
※1: スクリプトはGitHubのSwiftLint READMEから直接取得

## ローカライズ
英語と日本語のローカライズが設定されています。
"System Language" で実行することにより、自動的に日本語にローカライズされます。

## 改善事項・実装予定
- Tagsの中のTag名を長押しすると、編集できるがそれが即時的にUI上に反映されない。
- 詳細ビューの"状態（Open/ Closed)"がUI上に反映されない。
- UIテストのカバレッジが35％程度だったので、段階的に上げていきます。
- ※1をする場合、アラートを出す予定。

## 開発環境・言語
- 開発環境
Xcode 14.3.1
- 言語
Swift 5.8.1


