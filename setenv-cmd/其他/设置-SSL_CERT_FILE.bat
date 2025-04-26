@echo off
echo ==============================
echo 前置条件:
set Base_Path=C:\Program_Base
echo 本脚本使用固定路径 %Base_Path% , 如需更改请手动修改
echo 本脚本需要调用setenv.exe , 请将setenv置于当前目录或加入Path环境变量
echo ==============================
echo 进入当前脚本所在目录 %~dp0
cd /D %~dp0
echo ==============================
echo 新建 "%Base_Path%\cacert" 目录
if not exist "%Base_Path%\cacert" mkdir "%Base_Path%\cacert"
if exist "%Base_Path%\cacert" echo 新建 "%Base_Path%\cacert" 目录完成
echo ==============================
echo 配置SSL_CERT_FILE环境变量

echo 新建%Base_Path%\cacert目录用于存放SSL证书文件
mkdir %Base_Path%\cacert

echo 新建SSL_CERT_FILE
setenv.exe -s "SSL_CERT_FILE" "%Base_Path%\cacert\cacert.pem"
echo ==============================
echo 查看系统注册表中的当前环境变量
setenv.exe -g SSL_CERT_FILE
echo ==============================
echo 刷新当前SSL_CERT_FILE环境变量 
echo 输出系统注册表中的环境变量
setenv.exe -g SSL_CERT_FILE
echo 输出当前cmd中的环境变量
echo %SSL_CERT_FILE%
echo 临时将环境变量值设置为1
set SSL_CERT_FILE=1
echo 输出当前cmd中的环境变量
echo %SSL_CERT_FILE%
echo 注意: 环境变量刷新已完成，请结束时关闭当前命令行窗口重新打开
echo 注意: 存在cmd中测试成功，但cmder中的环境变量未更新成功的可能，重启解决
echo ==============================
echo === 请按任意键退出! 
pause




