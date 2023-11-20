![ヘッダー画像](https://user-images.githubusercontent.com/92074465/284128998-cbe612ac-ae31-472e-ba47-ac6a3db4b472.png)
<br />


# ISSUES
iPhoneで自分の課題を追加・確認・削除していくiOSアプリです。<br />
<br />

## 機能紹介
| TOP画面 |　新規課題作成画面|
| ----- | ----- |
| ![Top画面](https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/cce2f62f-c7ea-488c-9754-a4eed5f98825) | ![新規課題作成画面](https://user-images.githubusercontent.com/92074465/284142996-73c7a09a-5539-4754-ab8c-b1616f556c26.png) |
| アプリを立ち上げた時のTOP画面です。「フィルター機能」に応じて「全ての課題」・「最近の課題」の並び替え表示が自動でされています。 | 新しい「課題」を作成するときの画面（詳細画面）です。自分が考える「課題」を追加していきます。|

| タグ付け画面 |　タグ名変更画面 |
| ----- | ----- |
| ![タグ付け画面](https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/077d8dc4-b3a2-440e-8b94-8ef8f2212484) |　![タグ名変更画面](https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/237c254b-5173-464d-a693-6b2044ab5868) | 
| 「課題」に対してタグを付与・削除したい時は、詳細画面の右上にあるボタンをタップして編集出来ます。 | TOP画面から名称を変えたいタグを選択（長押し）し、タグ名を編集出来ます。 |

| 「優先度(高)」でフィルタリングした時の画面 | 「解決済み」でフィルタリングした時の画面 |
| ----- | ----- |
| ![優先度(高)のフィルタリング画面](https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/670e8570-25ee-49e9-95a6-7eb8217b3cd6) | ![　解決"済み"のフィルタリング](https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/60af328c-aadb-4a1f-8022-ce24457b3966) |
| 課題の左に付与されている❕は、優先度（高）の課題です。詳細画面の「優先度」で低・中・高の中から選択出来ます。|　課題の詳細画面の右上にあるボタンをタップし、「未解決」・「解決」を選択出来ます。 |

| 通知設定画面① |　通知設定画面② |
| ----- | ----- |
| ![通知設定画面①](https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/49dc2f08-1621-45af-b958-0ab103e02b71)　 | ![　通知設定画面②](https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/4348efdc-8bd3-4822-b9d0-05a651e59dbd) |
| 通知を許可していない時はアラートが出ます。「設定を確認」を押すと直接iOSの設定画面に遷移します。| 通知が許可されている場合の設定画面です。課題を忘れたくない時に活用出来ます。|

<br />


### 基本的なアプリの使い方
####　![アプリの操作](https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/b3e0951b-dfd7-4e57-89a3-64c6a8c04e55)
####　![フィルターの操作](https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/58bce4c1-26aa-450a-a6f5-b0444658acf9)
####　![タグの追加と初期化の操作](https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/f92a5ba8-457f-468f-b2a0-d11051a06b4d)


## 基本的なアプリの使い方
- 課題のタイトルを変更できます。
- 課題の変更日が即時的に反映されます。
- 課題の優先度(低・中・高）を変更できます。
- 課題にタグ付けできます。
- 課題の詳細・仮説テキストフィールドにテキストを記述できます。
- 課題を忘れたくない場合、リマンダー設定で好きな時刻に通知を設定できます。
![アプリの操作](https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/b3e0951b-dfd7-4e57-89a3-64c6a8c04e55)
<br />

## フィルター機能について
- 「#」でタグ検索が出来ます。
- 「作成日・変更日・古い・新規」などの順番で並び順を変更出来ます。
- フィルターオンにすると「解決済み・未解決・低〜高」で「課題」をフィルタリング出来ます。
![フィルターの操作](https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/58bce4c1-26aa-450a-a6f5-b0444658acf9)
<br />

## タグの追加と初期化の操作
- 「+」ボタンは新しいタグを追加出来ます。
- 「🔥」ボタンはタグを初期化します。
- 「🏅（メダル）」ボタンは課題解決・編集・アクセス頻度に応じてスタンプを付与予定。
※1： 現在、スタンプ付与のロジックは未実装
![タグの追加と初期化の操作](https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/f92a5ba8-457f-468f-b2a0-d11051a06b4d)
<br />


## 使用技術
| Category          | Technology Stack                                             |
| ----------------- | --------------------------------------------------           |
| Language          | Swift                                                        |
| Frameworks        | SwiftUI, CoreData, CoreSpotlight, UserNotifications, XCTest  | 
| Localize          | Japan, English                                               |
| etc.              | SwiftLint, Git, GitHub                                       |

<br />

### 静的解析ツールについて
SwiftLint が導入されており、独自のスタイル及び検出対象を指定しました。<br />
既に Xcode 上の Build Phases へ自動的に SwiftLint が動作する様にスクリプトを埋め込みました。<br />
スクリプトはGitHubのSwiftLint READMEから直接取得<br />
<br />

## 改善事項・実装予定
- Tagsの中のTag名を長押しすると、編集できるがそれが即時的にUI上に反映されない。
- UIテストのカバレッジが30％程度だったので、段階的に上げていきます。
- スタンプ付与のロジックを実装していきます。

## 開発環境・言語
- 開発環境
Xcode 14.3.1
- 言語
Swift 5.8.1


