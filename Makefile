.PHONY: help install lint link-check validate fix test all clean

# デフォルトターゲット
.DEFAULT_GOAL := help

# 色付き出力用
CYAN := \033[36m
GREEN := \033[32m
YELLOW := \033[33m
RED := \033[31m
RESET := \033[0m

help: ## このヘルプメッセージを表示
	@echo "$(CYAN)Available commands:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(RESET) %s\n", $$1, $$2}'

install: ## 必要なツールをインストール
	@echo "$(CYAN)Installing required tools...$(RESET)"
	@if ! command -v npm &> /dev/null; then \
		echo "$(RED)Error: npm is not installed. Please install Node.js first.$(RESET)"; \
		exit 1; \
	fi
	npm install --save-dev markdownlint-cli2 markdown-link-check
	@echo "$(GREEN)✅ Tools installed successfully!$(RESET)"

lint: ## Markdownファイルのlintチェック（記事のみ）
	@echo "$(CYAN)Running markdown lint on articles...$(RESET)"
	@if command -v npx &> /dev/null; then \
		npx markdownlint-cli2 "**/*.md" || exit 1; \
		echo "$(GREEN)✅ Markdown lint passed!$(RESET)"; \
	else \
		echo "$(RED)Error: npx not found. Run 'make install' first.$(RESET)"; \
		exit 1; \
	fi

fix: ## Markdownファイルの自動修正（記事のみ）
	@echo "$(CYAN)Fixing markdown files...$(RESET)"
	@if command -v npx &> /dev/null; then \
		npx markdownlint-cli2 --fix "**/*.md" || true; \
		echo "$(GREEN)✅ Markdown files fixed!$(RESET)"; \
	else \
		echo "$(RED)Error: npx not found. Run 'make install' first.$(RESET)"; \
		exit 1; \
	fi

link-check: ## リンク切れチェック（記事のみ）
	@echo "$(CYAN)Checking links in articles...$(RESET)"
	@if command -v npx &> /dev/null; then \
		find . -name "*.md" \
			-not -path "./node_modules/*" \
			-not -path "./.git/*" \
			-not -path "./templates/*" \
			-not -name "README.md" | \
		xargs -I {} npx markdown-link-check {} --config .github/workflows/link-checker-config.json || true; \
		echo "$(GREEN)✅ Link check completed!$(RESET)"; \
	else \
		echo "$(RED)Error: npx not found. Run 'make install' first.$(RESET)"; \
		exit 1; \
	fi

validate: ## 記事フォーマットの検証
	@echo "$(CYAN)Validating article format...$(RESET)"
	@bash scripts/validate-articles.sh
	@echo "$(GREEN)✅ Article validation completed!$(RESET)"

test: lint validate ## 全てのチェックを実行（link-check除く）
	@echo "$(GREEN)✅ All tests passed!$(RESET)"

all: lint link-check validate ## 全てのチェックを実行（link-checkを含む）
	@echo "$(GREEN)✅ All checks passed!$(RESET)"

clean: ## 生成ファイルを削除
	@echo "$(CYAN)Cleaning up...$(RESET)"
	rm -rf node_modules package-lock.json
	@echo "$(GREEN)✅ Cleanup completed!$(RESET)"
