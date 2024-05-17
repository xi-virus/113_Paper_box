---

# 電力公司遠端作業系統建置規劃

## 系統建置：

### 1. 準備階段：

- **作業系統選擇**：
  - 選擇 Kali Linux 作為作業系統，以支援電力公司運營所需的應用程式和服務。Kali Linux 提供了廣泛的安全測試工具，非常適合構建高互動性的靶機環境。

- **必要軟體安裝**：
  - 安裝 OpenSSH 服務、Apache2、PHP 和 libapache2-mod-php。這些軟體確保了靶機可以遠端存取和管理，並支援網站及應用程式的運行。特別是 Apache2 和 PHP 的安裝，為後續網站建設與隱藏目錄設置提供了基礎。

### 2. 網站建設與隱藏目錄設置：

- **建站階段**：
  - 創建網站結構，包括公開目錄和私密目錄。特別設置了一個 `.hidden_login_page` 隱藏登錄頁面，用於類比敏感操作的登錄驗證，以及一個成功登錄後跳轉的頁面。

- **登錄頁面處理**：
  - 配置隱藏的登錄頁面，允許使用者通過輸入預設的用戶名和密碼（admin/password）進行登錄。此設置模擬了一個基礎的認證機制，用於測試攻擊者的登錄嘗試。

- **成功登錄頁面**：
  - 設置成功登錄後使用者將看到的頁面，提示登錄成功，並顯示特定資訊。此頁面還設計了對未經認證的訪問的重定向處理，增加了網站的安全性。

- **Apache 配置調整**：
  - 對 Apache 伺服器的配置進行調整，確保所有目錄均正確設置存取權限，特別是隱藏目錄，以防止未授權訪問。

### 3. 創建普通用戶帳戶：

- **使用者配置**：
  - 創建一個普通使用者“user”，密碼為“pzword”。這一步驟提供了一個具有普通許可權的用戶帳戶，用於測試許可權提升等安全操作。

### 4. 配置敏感檔訪問和管理：

- **敏感文件處理**：
  - 在 root 目錄下創建包含 root 密碼的檔，並且設置檔許可權為僅 root 用戶可讀。此外，創建一個包含特定標誌的檔，同樣設置為僅 root 可讀，用於模擬敏感性資料的處理。

## 結語：

- **完成通告**：
  - 腳本執行完畢後，終端會顯示完成建設的通告，並提示用戶訪問設置好的網站以及使用 admin/password 登錄測試。
