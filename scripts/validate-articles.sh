#!/bin/bash

set -e

# 色付き出力用
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

error_count=0
warning_count=0

echo -e "${CYAN}Validating articles...${RESET}"

# カテゴリディレクトリ
categories=("golang" "cicd" "infrastructure" "ai")

for category in "${categories[@]}"; do
    if [ ! -d "$category" ]; then
        continue
    fi

    # カテゴリ内の.mdファイルを検索（README.mdとテンプレートを除く）
    while IFS= read -r -d '' file; do
        filename=$(basename "$file")

        # README.mdはスキップ
        if [[ "$filename" == "README.md" ]]; then
            continue
        fi

        echo -e "${CYAN}Checking: ${file}${RESET}"

        # ファイル名形式のチェック
        if [[ ! "$filename" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}-.*\.md$ ]]; then
            echo -e "${RED}  ❌ Error: Filename must follow YYYY-MM-DD-title.md format${RESET}"
            ((error_count++))
        else
            echo -e "${GREEN}  ✅ Filename format is valid${RESET}"
        fi

        # Front Matterのチェック
        if ! grep -q "^---" "$file"; then
            echo -e "${YELLOW}  ⚠️  Warning: Article should have front matter (---)${RESET}"
            ((warning_count++))
        else
            echo -e "${GREEN}  ✅ Front matter exists${RESET}"
        fi

        # セクションのチェック
        if ! grep -q "^## " "$file"; then
            echo -e "${YELLOW}  ⚠️  Warning: Article should have sections (##)${RESET}"
            ((warning_count++))
        else
            echo -e "${GREEN}  ✅ Sections found${RESET}"
        fi

        # タイトルのチェック
        if ! grep -q "^# " "$file"; then
            echo -e "${YELLOW}  ⚠️  Warning: Article should have a title (#)${RESET}"
            ((warning_count++))
        else
            echo -e "${GREEN}  ✅ Title found${RESET}"
        fi

    done < <(find "$category" -maxdepth 1 -name "*.md" -type f -print0)
done

echo ""
echo -e "${CYAN}Validation summary:${RESET}"
echo -e "  Errors: ${error_count}"
echo -e "  Warnings: ${warning_count}"

if [ $error_count -gt 0 ]; then
    echo -e "${RED}❌ Validation failed with ${error_count} error(s)${RESET}"
    exit 1
else
    echo -e "${GREEN}✅ Validation passed!${RESET}"
    if [ $warning_count -gt 0 ]; then
        echo -e "${YELLOW}⚠️  ${warning_count} warning(s) found${RESET}"
    fi
    exit 0
fi
