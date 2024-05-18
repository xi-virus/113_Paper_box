import warnings
from cryptography.utils import CryptographyDeprecationWarning
warnings.simplefilter("ignore", CryptographyDeprecationWarning)

import pytest
import paramiko

# 指定參數
target_ip = "127.0.0.1"  # 使用本地主機 IP 地址
target_port = 2222  # SSH端口

@pytest.fixture(scope="module")
def ssh_client():
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    return client

# 測試個案1
def test_ssh_login_as_user(ssh_client):
    """測試個案-管理設定：以user登入，檢查是否為普通用戶。"""
    try:
        ssh_client.connect(target_ip, username='user', password='pzword', port=target_port)
        stdin, stdout, stderr = ssh_client.exec_command('whoami')
        user = stdout.read().decode().strip()
        assert user == 'user', "應該以 user 身份登入"
    finally:
        ssh_client.close()

# 測試個案2
def test_read_root_password(ssh_client):
    """測試個案-取得user權限後，使用sudo查看/root/root_password.txt，可以看到root密碼。"""
    try:
        ssh_client.connect(target_ip, username='user', password='pzword', port=target_port)
        stdin, stdout, stderr = ssh_client.exec_command('echo pzword | sudo -S cat /root/root_password.txt')
        root_password = stdout.read().decode().strip()
        assert root_password == 'root password: david3309', "應該能夠讀取 /root/root_password.txt 並獲取 root 密碼"
    finally:
        ssh_client.close()

# 測試個案3
def test_login_as_root_and_read_flag(ssh_client):
    """測試個案-使用root密碼登錄並閱讀/root/root_flag.txt。"""
    try:
        ssh_client.connect(target_ip, username='root', password='david3309', port=target_port)
        stdin, stdout, stderr = ssh_client.exec_command('cat /root/root_flag.txt')
        root_flag = stdout.read().decode().strip()
        assert root_flag == 'flag{take_the_own_:D}', "應該能夠讀取 /root/root_flag.txt"
    finally:
        ssh_client.close()
