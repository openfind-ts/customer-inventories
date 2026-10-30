# customer-a（範例客戶）

**這是教學用的範例，所有資料都是假的**：IP 用 192.0.2.0/24，網域用 example.com，憑證是自簽的。
新增真實客戶時，照這個資料夾的結構複製一份再改。

## 範例 vault 密碼

`vault.yml` 和 `files/*.key` 已經用 ansible-vault 加密，範例密碼是 `customer-a-demo`。

> 這個密碼只給範例用。真實客戶的 vault 密碼**絕對不能**寫在 repo 裡，由負責該客戶的同仁保管。

## 裡面有什麼

| 檔案 | 內容 |
| --- | --- |
| `hosts.yml` | 2 台 MG、1 台 M2K；mg01、m2k01 在 prod，mg02 在 staging |
| `group_vars/all/main.yml` | 連線帳號、客戶專用金鑰路徑、NTP |
| `group_vars/all/vault.yml` | 密碼（已加密） |
| `group_vars/mg.yml` | 這個客戶的 MG 差異：版本、憑證檔 |
| `group_vars/m2k.yml` | 這個客戶的 M2K 差異 |
| `host_vars/mg01.yml` | 單台例外：mg01 的安裝路徑和標準值不同 |
| `files/` | 客戶憑證；私鑰已加密 |

## 試跑（在 openfind-ansible 根目錄）

```bash
# 看分組與變數，不會連主機
ansible-inventory -i ../customer-inventories/customer-a --graph
ansible-inventory -i ../customer-inventories/customer-a --host mg01 --ask-vault-pass

# 只挑 staging 的 MG
ansible -i ../customer-inventories/customer-a 'mg:&staging' --list-hosts

# 換憑證預演（主機是假的，會連不上，用來看指令怎麼下）
ansible-playbook -i ../customer-inventories/customer-a playbooks/renew_cert.yml \
  --limit mg --ask-vault-pass --check --diff
```
