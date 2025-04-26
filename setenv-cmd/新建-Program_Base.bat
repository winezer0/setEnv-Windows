@echo off
echo ==============================
echo 前置条件:
set Base_Path=C:\Program_Base
echo 本脚本使用固定路径 "%Base_Path%" , 如需更改请手动修改
echo 本脚本需要调用 setenv.exe , 请将程序置于当前目录或加入Path环境
echo ==============================
echo 进入当前脚本所在目录 %~dp0
cd /D %~dp0
echo ==============================
echo 新建 "%Base_Path%" 目录
if not exist "%Base_Path%" mkdir "%Base_Path%"
if exist "%Base_Path%" echo 新建 "%Base_Path%" 目录完成
echo ==============================
echo === 请按任意键退出! 
pause




