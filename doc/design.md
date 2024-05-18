Paper Pass Box 設計說明
====
> github.com/carlton0521

# 摘要說明

* 提供一組Docker相關腳本，運行腳本後可建立簡單紅隊靶機，作為示範教學使

# 項目架構

* Release Assets
  - **BoxSetting.sh**：將Kali設定80port隱藏目錄與弱密碼、讀寫設定提權弱點，可做為簡單滲透提權使用。
  - **DockerFile**：可初始化一個Kali容器，並將上述**BashScript**複製進去後執行。
* Entities
  - **vulnerable_kali**：執行**DockerFile**後，會在本地端DockerHub自動產生的Docker映像檔。
  - **BoxContainer**：執行**BoxImage**後，實際運作的Box服務。
  - **/.hidden_login_page**: 為使用弱密碼之登錄介面
  - **root_flag.txt**：置於 /root 內之root flag，為提權之證明。

# 運作流程

* How it works
  1. **BoxAdmin**執行**DockerFile**，完成**BoxImage**製作。
  2. **BoxAdmin**將**BoxImage**依Docker運用方式執行**BoxContainer**。
  3. **BoxUser**可遠端連線練習破密及提權靶機。
