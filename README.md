https://github.com/xi-virus
Paper Pass Box
====
> 

* Static Info:
  ![Bash使用](https://img.shields.io/badge/Bash_Script-2A2Ba2)
  ![Docker使用](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
  ![Python使用](https://img.shields.io/badge/Python-14354C.svg?logo=python&logoColor=white)
* Development:
  ![版權宣告](https://img.shields.io/github/license/TwMoonBear-Arsenal/Box_PaperPass)
  [![可維護度](https://api.codeclimate.com/v1/badges/da0c547d8c6236d10e0e/maintainability)](https://codeclimate.com/github/TwMoonBear-Arsenal/Box_PaperPass/maintainability)
  ![GitHub repo size](https://img.shields.io/github/repo-size/TwMoonBear-Arsenal/Box_PaperPass)
  ![GitHub Tag](https://img.shields.io/github/v/tag/TwMoonBear-Arsenal/Box_PaperPass)
  ![釋出版本](https://img.shields.io/github/v/release/TwMoonBear-Arsenal/Box_PaperPass)
  ![釋出日期](https://img.shields.io/github/release-date/TwMoonBear-Arsenal/Box_PaperPass)

# 1. 功能簡介

* 提供一組Docker相關腳本，運行腳本後可建立簡單紅隊靶機，作為示範教學使用。

# 2. 項目介紹

## 2.1. Release Asset

- **data資料夾**：配合dockerfile設定所需檔案
- **dockerfile檔案**：容器創建文件
- **LICENSE檔案**：版權宣告
- **README.md檔案**：說明文件

## 2.2. 外部依賴

- **Kali Image**：執行dockerfile組建所需，可為遠端dockerhub或本地提供

# 3. 作業運用

## 3.1 Repo構管

* 此Repo為public，設定保護main branch。
* 主要更新於develop branch執行後，pull request回main branch。

## 3.2. 模組設計

* 於README.md及/doc/design.vpp說明。
* 主要規格為：
  * 可組建靶機容器映像檔
  * 靶機具備外部滲透弱點：80port隱藏目錄、ssh弱密碼
  * 靶機具備內部提權弱點：linux 讀寫漏洞

## 3.3. 模組發展

### 3.3.1. 功能開發

* 主要編寫bash腳本用以初始化靶機，可下載Repo後使用VScode編寫。

### 3.3.2. 模組測試

* 使用Python的Pipenv虛擬環境+Pytest模組。
* 測試時：
  1. 安裝pipenv ```pip install pipenv```
  2. 回復pipenv ```pipenv install```
  3. 執行測試 ```pipenv run pytest```
* 省略未做單元測試，僅做黑箱模組測試。
* 測試個案為：
  1. 個案：**BoxAdmin**可遠端連線**BoxContainer**並具備管理權。
  2. 個案：**BoxUser**可遠端連線**BoxContainer**並以弱密碼(password)登入後，讀取user.flag。
  3. 個案：**BoxUser**可遠端連線**BoxContainer**登入後，操作cp提權讀取root.flag。

### 3.3.3. 模組發佈

* 檢核後手動發佈
