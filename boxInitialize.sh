#!/bin/bash

# 使用说明
# 1. 将此脚本复制到靶机上，文件名为"boxInitialize.sh"
# 2. 打开终端
# 3. 导航至脚本所在的目录
# 4. 给脚本执行权限: chmod +x boxInitialize.sh
# 5. 执行脚本: ./boxInitialize.sh

echo "==========================================="
echo "电力公司远程操作系统建置规划"
echo "==========================================="

echo ""
echo "正在初始化环境..."
# 删除先前的网站目录及其内容（如果存在）
sudo rm -rf /var/www/html/*

echo ""
echo "步骤1：准备阶段"
echo "----------------"

echo "操作系统选择：选择 kali 作为操作系统"
echo "已选择 kali 作为操作系统"

echo "必要软件安装：安装 OpenSSH 服务、Apache2、PHP、libapache2-mod-php"
sudo apt update
sudo apt install -y openssh-server apache2 php libapache2-mod-php

echo "OpenSSH 服务、Apache2、PHP 等安装完成"

echo ""
echo "步骤2：网站建设与隐藏目录设置"
echo "-------------------------"

# 创建网站结构
sudo mkdir -p /var/www/html/public
sudo mkdir -p /var/www/html/private
sudo mkdir -p /var/www/html/.hidden_login_page
sudo mkdir -p /var/www/html/login_success

# 设置初始页面
sudo tee /var/www/html/index.php > /dev/null <<EOF
<?php
echo "<h1>Welcome to the Power Company Website</h1>";
echo "<p>This is the public website for the Power Company.</p>";
?>
EOF

# 登录页面处理
sudo tee /var/www/html/.hidden_login_page/login.php > /dev/null <<'EOF'
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

# 成功登录页面
sudo tee /var/www/html/login_success/login_success.php > /dev/null <<EOF
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
sudo tee /etc/apache2/sites-available/000-default.conf > /dev/null <<'EOF'
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

# 重新启动 Apache 以确保所有配置生效
sudo systemctl restart apache2

echo "步骤3：创建普通用户账户"
echo "----------------------"
sudo useradd -m -p $(openssl passwd -1 "pzword") -s /bin/bash user
echo "用户账号和弱密码已创建。用户名：user, 密码：pzword"

echo ""
echo "步骤4：配置敏感文件访问和管理"
echo "----------------------"

# 创建一个文件，包含root密码，但是设置为仅root可访问
sudo tee /root/root_password.txt > /dev/null <<EOF
root password: david3309
EOF
sudo chmod 600 /root/root_password.txt

echo "创建一个标志文件，仅root可访问"
sudo tee /root/root_flag.txt > /dev/null <<EOF
flag{take_the_own_:D}
EOF
sudo chmod 600 /root/root_flag.txt

echo ""
echo "靶机建设完成！"
echo "靶机已成功建设，请小心使用。"
echo "访问 http://127.0.0.1 查看网站。"
echo "记得使用admin/password登录隐藏目录以测试登录和访问控制。"
