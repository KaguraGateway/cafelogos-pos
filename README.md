# cafelogos-pos (LogoREGI)

cafelogos-posは、カフェや飲食店向けに設計された包括的な販売時点情報管理（POS）システムです。このアプリケーションは、注文管理、決済処理、キャッシュドロワー操作、レシート印刷などの機能を提供します。iPadデバイスのランドスケープ（横向き）モードで動作し、迅速なサービス運用に最適化されたクリーンなUIを特徴としています。

## ビジョン

cafelogos-posは、カフェや飲食店の日々の運営をシンプルかつ効率的にすることを目指しています。現代のハンドドリップカフェ運営に欠かせない以下の機能を統合することで、スタッフがお客様へのサービスに集中できる環境を提供します：

- シンプルで直感的なユーザーインターフェース
- 迅速な注文入力と決済処理
- 様々な決済方法のサポート（現金、クレジットカード、電子マネー）
- バックエンドシステムとのシームレスな連携
- カスタマーディスプレイによる顧客体験の向上
- 柔軟な商品管理と割引適用

将来的には、分析機能の強化、在庫管理の自動化、より多様な決済方法への対応などを計画しています。

このシステムは、[金沢工業大学の法人格を持つ学生団体「CirKit」のカフェ事業](https://cirkit.jp/activity/logos)で利用するために開発しました。

## 主な機能

システムは以下の機能を提供します：

### 注文管理
- カテゴリ別に整理された商品一覧表示
- コーヒー注文のための異なる抽出方法のカスタマイズ
- 注文への割引適用
- 座席/テーブル管理

### 決済処理
- 現金決済対応
- Square連携によるカード決済・電子マネー決済
- レシート印刷
- 呼び出し番号の発行

### キャッシュドロワー管理
- ドロワー開閉操作
- 釣銭準備金の設定
- 金種別の在高管理
- レジ点検・精算処理

### システム設定
- ハードウェア接続設定
- プリンター設定
- カスタマーディスプレイ設定
- サーバー接続設定

## アーキテクチャ

このプロジェクトは以下のようなアーキテクチャを採用しています：

### The Composable Architecture (TCA)

アプリケーション全体で「The Composable Architecture」（TCA）パターンを採用しており、状態、アクション、リデューサーを明確に分離しています。このアーキテクチャにより、以下のメリットが得られます：

- 予測可能な一方向データフロー
- 分離された関心事
- 高いテスト可能性
- 再利用可能なコンポーネント

### 主要システム

1. **ナビゲーションシステム**: `AppFeature`がメインコーディネーターとして機能し、異なる機能間のナビゲーションを管理します。

2. **注文入力システム**: 
   - `OrderEntryFeature`が商品選択、カート管理、割引適用を処理
   - `ProductStackFeature`がカテゴリ別の商品表示を担当
   - `OrderBottomBarFeature`が注文の取得と決済画面へのナビゲーションを提供

3. **決済システム**:
   - `PaymentFeature`が現金またはSquare連携による決済を処理
   - `PaymentSuccessFeature`が決済完了後の確認を表示
   - `NewPayment`サービスがレシート印刷と連動した決済処理を調整

4. **キャッシュドロワーシステム**:
   - `CashDrawerOperationsFeature`がドロワーの設定、点検、締め処理を管理
   - `DenominationFormListFeature`が金種入力を処理
   - `Settle`サービスが精算プロセスを管理

5. **設定システム**:
   - `SettingsFeature`がアプリケーション設定を管理
   - `Config`がプリンター使用、Square連携、サーバー接続などの設定を保存

### ディレクトリ構造

```
cafelogos-pos/
├── App/                  # メインアプリケーションのエントリーポイント
├── LogoREGICore/         # コアドメインモデルとビジネスロジック
│   ├── Sources/
│       ├── Application/  # アプリケーションサービスとユースケース
│       ├── Domain/       # ドメインモデルとインターフェース
│       ├── Infra/        # インフラストラクチャの実装
│       └── DI.swift      # 依存性注入コンテナ
└── LogoREGIUI/           # UIコンポーネントと機能実装
    ├── Sources/
        ├── Features/     # TCA機能モジュール
        ├── Presentation/ # UIコンポーネント
        └── SharedComponents/ # 再利用可能なUI要素
```

## 技術スタック

### フレームワークとライブラリ

- **SwiftUI**: すべてのUIコンポーネントに使用
- **Swift**: ビジネスロジックとドメインモデル用
- **The Composable Architecture**: 状態管理と機能モジュール化
- **Dependencies**: 依存性注入
- **Realm**: 注文と決済データの永続化
- **SwiftData**: 金種データの保存
- **Connect-Swift**: バックエンドとのgRPC通信
- **StarXpand-SDK-iOS**: Star Micronicsプリンターと金庫との連携

### デザインパターン

1. **依存性注入パターン**: `DI.swift`を通じてリポジトリとサービスを提供
2. **リポジトリパターン**: データアクセス用
   - `ConfigAppStorage`: AppStorageでの設定保存
   - `OrderRealm`と`PaymentRealm`: Realmでのオーダーとペイメントのストレージ
   - `DenominationSwiftData`: SwiftDataでの金種保存
3. **ハードウェア統合**: アダプターを通じたハードウェア通信の抽象化
   - `CashierAdapter`: プリンターとキャッシュドロワー操作のインターフェース
   - `StarXCashierAdapter`: Star Micronicsハードウェア用の実装
4. **バックエンド通信**: `ProtocolClient`を通じたgRPCによるバックエンドサービスとの通信

## 開発環境の構築

### 必要な環境
- macOS 15.0以上
- Xcode 16.0以上
- iOS 17.0以上のシミュレータ
   - 推奨：iPad Pro 11inch

### セットアップ手順

1. リポジトリのクローン:
```bash
git clone https://github.com/KaguraGateway/cafelogos-pos.git
cd cafelogos-pos
```

2. 署名設定ファイルのセットアップ:
```bash
cp Signing.xcconfig.example Signing.xcconfig
```

3. Xcodeワークスペースを開く:
```bash
open cafelogos-pos.xcworkspace
```

4. 依存関係の解決とビルド:
Xcodeを使用して依存関係を解決し、プロジェクトをビルドします。


## 貢献ガイドライン_WIP

プルリクエストを作成する前に、以下の項目をローカルで実行してください：

1. SwiftLintによるコードスタイルチェック
   - 全てのソースファイルがSwiftLintのルールに準拠していることを確認
   - 警告やエラーが出た場合は、コミット前に修正が必要

2. ユニットテストの実行
   - LogoREGICore/Testsの全テストを実行
   ```bash
   cd LogoREGICore && swift test
   ```
   - 特にドメインロジックの変更を行った場合は、関連するテストが全て成功することを確認
