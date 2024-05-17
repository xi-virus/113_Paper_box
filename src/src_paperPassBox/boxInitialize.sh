#!/bin/bash

# 使用說明
# 1. 將此腳本複製到靶機上，檔案名為"boxInitialize.sh"
# 2. 打開終端
# 3. 導航至腳本所在的目錄
# 4. 給腳本執行許可權: chmod +x boxInitialize.sh
# 5. 執行腳本: ./boxInitialize.sh

echo "==========================================="
echo "電力公司遠端作業系統建置規劃"
echo "==========================================="

echo ""
echo "正在初始化環境..."
# 刪除先前的網站目錄及其內容（如果存在）
rm -rf /var/www/html/*

echo ""
echo "步驟1：準備階段"
echo "----------------"

echo "作業系統選擇：選擇 kali 作為作業系統"
echo "已選擇 kali 作為作業系統"

echo "必要軟體安裝：安裝 OpenSSH 服務、Apache2、PHP、libapache2-mod-php 和 sudo"
apt update
apt install -y openssh-server apache2 php libapache2-mod-php sudo

echo "OpenSSH 服務、Apache2、PHP 和 sudo 安裝完成"

echo ""
echo "步驟2：網站建設與隱藏目錄設置"
echo "-------------------------"

# 創建網站結構
mkdir -p /var/www/html/public
mkdir -p /var/www/html/private
mkdir -p /var/www/html/.hidden_login_page
mkdir -p /var/www/html/login_success

# 設置初始頁面
tee /var/www/html/index.php > /dev/null <<EOF
<?php
echo "<h1>Welcome to the Power Company Website</h1>";
echo "<p>This is the public website for the Power Company.</p>";
?>
EOF

# 登錄頁面處理
tee /var/www/html/.hidden_login_page/login.php > /dev/null <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
<h1>Login</h1>
<form method="post">
    Username: <input type="text" name="username"><br>
    Password: <input type="password" name="password"><br>
    <input type="submit" value="Login">
</form>
<?php
if (!empty($_POST['username']) && !empty($_POST['password'])) {
    if ($_POST['username'] == 'admin' && $_POST['password'] == 'password') {
        session_start();
        $_SESSION['logged_in'] = true;
        header('Location: /login_success/login_success.php');
        exit;
    } else {
        echo "Login failed!";
    }
}
?>
</body>
</html>
EOF

# 成功登錄頁面
tee /var/www/html/login_success/login_success.php > /dev/null <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Success</title>
</head>
<body>
<?php
    session_start();
    if (empty($_SESSION['logged_in'])) {
        // If not logged in, redirect to the homepage or login page
        header('Location: /');
        exit;
    }
?>
<!DOCTYPE html>
<html>
<head>
    <title>Success</title>
</head>
<body>
<h1>Login Successful</h1>
<p>You have successfully logged into the hidden section.</p>
<p>The user password is: pzword</p>
</body>
</html>
EOF

# Apache 配置
tee /etc/apache2/sites-available/000-default.conf > /dev/null <<'EOF'
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    DirectoryIndex index.php

    <Directory /var/www/html>
        Options -FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    <Directory /var/www/html/public>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    <Directory /var/www/html/private>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    <Directory /var/www/html/.hidden_login_page>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    <Directory /var/www/html/login_success>
        Options -Indexes
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# 重新啟動 Apache 以確保所有配置生效
service apache2 restart

echo "步驟3：創建普通用戶帳戶"
echo "----------------------"
useradd -m -p $(openssl passwd -1 "pzword") -s /bin/bash user
usermod -aG sudo user
echo "使用者帳號和弱密碼已創建。用戶名：user, 密碼：pzword"

echo ""
echo "步驟4：配置敏感檔訪問和管理"
echo "----------------------"

# 創建一個檔，包含root密碼，設置為user和root都可讀
tee /root/root_password.txt > /dev/null <<EOF
root password: david3309
EOF
chmod 644 /root/root_password.txt

echo "創建一個標誌檔，僅root可訪問"
tee /root/root_flag.txt > /dev/null <<EOF
flag{take_the_own_:D}
EOF
chmod 600 /root/root_flag.txt

# 設置 root 用戶密碼
echo "root:david3309" | chpasswd

# 配置 sshd_config 以允許 root 登錄
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
service ssh restart

# 驗證配置
grep PermitRootLogin /etc/ssh/sshd_config
grep root /etc/shadow

echo ""
echo "靶機建設完成！"
echo "靶機已成功建設，請小心使用。"
echo "訪問 http://127.0.0.1 查看網站。"
echo "記得使用admin/password登錄隱藏目錄以測試登錄和存取控制。"
