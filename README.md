# customer-inventories

**私有 repo**：每個客戶一個資料夾，放主機清單、客戶差異設定，以及用 ansible-vault 加密過的密碼與憑證。
程式（roles、playbooks）在公開的 [`openfind-ts/openfind-ansible`](https://github.com/openfind-ts/openfind-ansible)，這裡不放任何程式。

## 使用方式

兩個 repo 放在同一層，在 openfind-ansible 根目錄用 `-i` 指定客戶：

```bash
cd openfind-ansible
ansible-playbook -i ../customer-inventories/<客戶> playbooks/renew_cert.yml \
  --limit mg --ask-vault-pass --check --diff
```

## 新增客戶

1. 從 `openfind-ansible/inventories/_template/` 複製一份成 `<客戶>/`（資料夾名稱用小寫英文與連字號，例如 `customer-a`）。
2. 改 `hosts.yml`：主機名稱用「產品代號＋流水號」（`mg01`），實際位址寫在 `ansible_host`；每台主機同時放進產品群組與環境群組。
3. 客戶沒有的產品，刪掉那個群組和對應的 `group_vars/<產品>.yml`。
4. 密碼：`ansible-vault create <客戶>/group_vars/all/vault.yml`，變數加 `vault_` 前綴。
5. 憑證：放 `<客戶>/files/`，私鑰先 `ansible-vault encrypt <客戶>/files/<產品>.key` 再 commit。
6. 只寫和產品標準值不同的設定；標準值在 openfind-ansible 各 role 的 `defaults/main.yml`。

## 規則

- `vault.yml` 和私鑰**一定要加密**才能 commit。push 時 GitHub Actions 會檢查，沒加密會失敗。
- vault 密碼不進任何 repo，由負責該客戶的同仁保管；不同客戶用不同的 vault 密碼。
- SSH 私鑰留在執行者的 `~/.ssh`，這裡只寫路徑（`ansible_ssh_private_key_file`）。
- 這個 repo 的內容不可貼給 AI；要請 AI 幫忙時，改用假資料（192.0.2.x、example.com）。

## 結構

```text
customer-inventories/
├── lab/                 # 公司內部測試環境（範例，IP 請換成實際 Lab 機）
│   ├── hosts.yml
│   ├── files/
│   ├── group_vars/
│   │   ├── all/main.yml
│   │   ├── mg.yml
│   │   └── m2k.yml
│   └── host_vars/
├── customer-a/          # 照 lab 的結構新增
└── scripts/check-encrypted.sh
```
