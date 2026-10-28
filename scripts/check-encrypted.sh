#!/usr/bin/env bash
# 檢查所有 vault.yml 與 files/ 底下的私鑰都已用 ansible-vault 加密
set -euo pipefail
fail=0
while IFS= read -r -d '' f; do
  if ! head -n1 "$f" | grep -q '^\$ANSIBLE_VAULT;'; then
    echo "未加密：$f"
    fail=1
  fi
done < <(find . -path ./.git -prune -o -type f \( -name 'vault.yml' -o -name 'vault.yaml' -o -path '*/files/*.key' -o -path '*/files/*.pem' \) -print0)
if [ "$fail" -ne 0 ]; then
  echo "請先執行 ansible-vault encrypt <檔案> 再 commit"
  exit 1
fi
echo "所有機密檔都已加密"
