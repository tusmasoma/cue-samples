# cue-gen-samples

CUEを使ったデータベーススキーマの自動生成サンプルプロジェクト

## 概要

このプロジェクトは、[CUE](https://cuelang.org/)を使用してデータベーススキーマを定義し、以下のファイルを自動生成するサンプルです：

- DDL（Data Definition Language）ファイル - Google Cloud Spanner用のSQL
- ER図（PlantUML形式）
- Go言語のモデル・インフラストラクチャコード

CUEによるスキーマ定義から複数の成果物を一元的に生成することで、スキーマの一貫性を保ち、手作業によるミスを削減できます。

## 特徴

- **型安全なスキーマ定義**: CUEの型システムを活用した堅牢なスキーマ定義
- **単一の真実の情報源**: スキーマ定義から複数の成果物を自動生成
- **拡張性**: 新しいテーブルや関連を簡単に追加可能
- **Google Cloud Spanner対応**: Spannerの特性（インターリーブテーブルなど）に対応

## ディレクトリ構造

```
.
├── schema/              # CUEスキーマ定義
│   └── db/
│       ├── main.cue     # メインエントリポイント
│       ├── def/         # スキーマ型定義
│       │   └── spanner/ # Spanner用の型定義
│       └── user/        # ユーザー関連のテーブル定義
├── templates/           # 生成用テンプレート
│   └── db_gen/
│       └── db/
│           ├── ddl/     # DDL生成テンプレート
│           └── er/      # ER図生成テンプレート
├── tools/               # 生成ツール
│   └── db_gen/
│       ├── ddl/         # DDL生成ツール
│       ├── er/          # ER図生成ツール
│       └── infra/       # インフラコード生成ツール
├── db/                  # 生成されたファイル
│   ├── ddl/             # 生成されたDDL
│   └── er/              # 生成されたER図
└── pkg/                 # 共通パッケージ
    ├── entity/          # エンティティ定義
    └── util/            # ユーティリティ
```

## 前提条件

- Go 1.21以上
- CUE CLI（オプション、スキーマのフォーマット用）
- Docker（ER図のSVG生成用）

## セットアップ

```bash
# リポジトリのクローン
git clone https://github.com/tusmasoma/cue-gen-samples.git
cd cue-gen-samples

# 依存関係のインストール
go mod download
```

## 使い方

### DDLの生成

```bash
make generate_ddl
```

生成されたDDLは `db/ddl/user_db_gen.sql` に出力されます。

### ER図の生成

```bash
# PlantUML形式の生成
make generate_er_puml

# SVG形式のER図生成（Docker必須）
make generate_er_svg
```

生成されたER図は以下に出力されます：
- PlantUML: `db/er/er_user_db_gen.puml`
- SVG: `db/er/image/er_user_db_gen.svg`

### インフラストラクチャコードの生成

```bash
make generate_infra
```

### すべて生成

```bash
make generate
```

### CUEスキーマのフォーマット

```bash
make fmt
```

## スキーマの定義方法

### テーブルの追加

新しいテーブルを追加する場合は、`schema/db/user/` ディレクトリに新しい `.cue` ファイルを作成します。

例: `schema/db/user/post.cue`

```cue
package user

data: post: {
	description: "投稿"
	columns: {
		post_id: {pk: 1, type: "string", size: 36, description: "投稿ID"}
		user_id: {type: "string", size: 36, description: "ユーザーID"}
		title: {type: "string", size: 200, description: "タイトル"}
		content: {type: "string", is_max_size: true, description: "本文"}
	}
}

// リレーションの定義
i_relations: post_relations: [
	{
		source: {table_name: data.user.name, column: data.user.columns.user_id.name}
		target: {table_name: data.post.name, column: data.post.columns.user_id.name, zero: false}
	},
]
```

### リレーションの定義

テーブル間の関連は `i_relations` フィールドで定義します：

- `source`: 参照元テーブルとカラム
- `target`: 参照先テーブルとカラム
- `zero`: NULL許可（false = NOT NULL）

## 技術スタック

- **CUE**: スキーマ定義言語
- **Go**: コード生成ツール
- **Google Cloud Spanner**: ターゲットデータベース
- **PlantUML**: ER図生成
- **Docker**: PlantUML実行環境

## ライセンス

MIT

## 参考リンク

- [CUE Language](https://cuelang.org/)
- [Google Cloud Spanner](https://cloud.google.com/spanner)
- [PlantUML](https://plantuml.com/)
