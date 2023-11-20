
![ヘッダー画像](https://user-images.githubusercontent.com/92074465/284128998-cbe612ac-ae31-472e-ba47-ac6a3db4b472.png)
<br />


# ISSUES
iPhoneで自分の課題を追加・確認・削除していくiOSアプリです。
<br />


## アプリケーションのイメージ
![アプリケーションのイメージ](https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/b3e0951b-dfd7-4e57-89a3-64c6a8c04e55)
<br />


## 機能一覧
| トップ画面 |　新規課題作成画面|
| ---- | ---- |
| ![Top画面](https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/cce2f62f-c7ea-488c-9754-a4eed5f98825) | ![新規課題作成画面](https://user-images.githubusercontent.com/92074465/284142996-73c7a09a-5539-4754-ab8c-b1616f556c26.png) |
| アプリを立ち上げた時のTop画面です。 | 新しい課題を作成するときの画面です。|

| タグ付け画面 |　タグ名変更画面 |
| ---- | ---- |
| ![タグ付け画面]((https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/077d8dc4-b3a2-440e-8b94-8ef8f2212484)) |　![タグ名変更画面](https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/237c254b-5173-464d-a693-6b2044ab5868) | 
| 課題に対してタグを付与・削除したい時は編集出来ます。 | タグの名称を変えたい時に長押しで編集出来ます。 |

| フィルタリング画面① |フィルタリング画面② |
| ---- | ---- |
| ![優先度(高)のフィルタリング画面](https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/670e8570-25ee-49e9-95a6-7eb8217b3cd6) | ![　解決"済み"のフィルタリング](https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/60af328c-aadb-4a1f-8022-ce24457b3966) |
| 優先度(高)でフィルタリングした時の画面です。 | 　解決"済み"の課題でフィルタリングした時の画面です。 |

| 通知許可画面 |　受賞画面 |
| ---- | ---- |
| ![通知許可画面](https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/49dc2f08-1621-45af-b958-0ab103e02b71)　 | ![　受賞画面](https://github.com/Taisei-Shinoda/MyPortfolio/assets/92074465/6a90fa70-3aba-4b8d-8f53-52125dadffe7)|
| 通知を許可していない時はアラートが出ます。 | 課題の解決状況に応じて受賞（スタンプ）を用意しました。 |

<br />











## フレームワーク
以下のフレームワークが使用されています。

- SwiftUI
- CoreData 
- CoreSpotlight
- UserNotifications
- XCTest

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
"System Language" で実行することにより、自動的に日本語にローカライゼーションされます。

## 改善事項・実装予定
- Tagsの中のTag名を長押しすると、編集できるがそれが即時的にUI上に反映されない。
- 詳細ビューの"状態（Open/ Closed)"がUI上に反映されない。
- UIテストのカバレッジが35％程度だったので、段階的に上げていきます。
- ※1をする場合、アラートを出す予定。


## 画面遷移図
![画面遷移図 drawio](https://user-images.githubusercontent.com/92074465/282289040-2bcf2900-71cb-4d1c-a7e3-28464bb88712.png)


## 開発環境・言語
- 開発環境
Xcode 14.3.1
- 言語
Swift 5.8.1


