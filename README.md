# TechBlog

技術記事を管理するためのリポジトリです。

## ディレクトリ構成

```
techblog/
├── golang/          # Go言語に関する記事
├── cicd/            # CI/CDに関する記事
├── infrastructure/  # インフラに関する記事
├── ai/              # AI・機械学習に関する記事
├── images/          # 記事で使用する画像ファイル
└── templates/       # 記事作成用のテンプレート
```

## 記事の書き方

### 1. テンプレートをコピー

```bash
cp templates/article-template.md {category}/YYYY-MM-DD-title.md
```

### 2. ファイル名のルール

- 形式: `YYYY-MM-DD-title.md`
- 例: `2024-01-15-go-generics-tutorial.md`

### 3. 記事の構成

各記事には以下の要素を含めてください：

- **メタデータ** (Front Matter): タイトル、日付、タグ、カテゴリ
- **概要**: 記事の内容を簡潔に説明
- **本文**: セクションに分けて記載
- **コード例**: 実用的なコードスニペット
- **参考資料**: 参考にしたリンクや資料

### 4. カテゴリのREADME更新

記事を追加したら、該当カテゴリのREADME.mdに記事へのリンクを追加してください。

## カテゴリ

- [Golang](./golang/) - Go言語関連
- [CI/CD](./cicd/) - CI/CD関連
- [Infrastructure](./infrastructure/) - インフラ関連
- [AI](./ai/) - AI・機械学習関連

## 執筆ガイドライン

- コードは実際に動作するものを掲載する
- スクリーンショットや図を活用して分かりやすく説明する
- 参考資料は必ず記載する
- 技術的な正確性を重視する

## ローカル開発

### セットアップ

初回のみ、必要なツールをインストールします：

```bash
make install
```

または

```bash
npm install
```

### 利用可能なコマンド

#### Makeコマンド

```bash
make help          # 利用可能なコマンドを表示
make lint          # Markdownのlintチェック
make fix           # Markdownの自動修正
make link-check    # リンク切れチェック
make validate      # 記事フォーマットの検証
make test          # 全てのチェック実行（link-check除く）
make all           # 全てのチェック実行（link-checkを含む）
make clean         # 生成ファイルを削除
```

#### npmコマンド

```bash
npm run lint           # Markdownのlintチェック
npm run lint:fix       # Markdownの自動修正
npm run check:links    # リンク切れチェック
npm run validate       # 記事フォーマットの検証
npm test               # lintとvalidateを実行
```

### PRを作成する前に

PRを作成する前に、以下のコマンドでローカルチェックを実行してください：

```bash
make test
```

これにより、GitHub Actionsで実行されるチェックと同様の検証がローカルで実行されます。

## CI/CD

このリポジトリでは、以下のGitHub Actionsワークフローが設定されています：

### 自動チェック

#### 1. Markdown Lint
- **トリガー**: PR作成時、mainブランチへのpush
- **内容**: Markdownファイルの文法チェック
- **設定ファイル**: `.markdownlint.json`

#### 2. Link Checker
- **トリガー**: PR作成時、毎週月曜日0:00 UTC、手動実行
- **内容**: Markdownファイル内のリンク切れチェック
- **設定ファイル**: `.github/workflows/link-checker-config.json`

#### 3. PR Validation
- **トリガー**: PR作成時、更新時
- **チェック内容**:
  - ファイル名が `YYYY-MM-DD-title.md` 形式であること
  - Front Matterが存在すること
  - 基本的なセクション構成があること

### ワークフローの手動実行

Link Checkerは手動で実行することもできます：

1. GitHubリポジトリの「Actions」タブに移動
2. 「Link Checker」ワークフローを選択
3. 「Run workflow」をクリック
