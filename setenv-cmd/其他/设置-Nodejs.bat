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
echo 新建 "%Base_Path%\nodejs" 目录
if not exist "%Base_Path%\nodejs" mkdir "%Base_Path%\nodejs"
if exist "%Base_Path%\nodejs" echo 新建 "%Base_Path%\nodejs" 目录完成
echo ==============================
echo 配置NODEJS 环境变量

echo 新建NODE_PATH  模块查找路径
setenv  -s "NODE_PATH"  "%Base_Path%\nodejs\node_global\node_modules" 

echo 追加nodejs到Path 路径  基于绝对路径  
setenv  -a  Path "%Base_Path%\nodejs\node_global" 
setenv  -a  Path "%Base_Path%\nodejs" 
echo ===============================
echo 查看系统注册表中的当前环境变量
setenv  -g NODE_PATH
setenv  -g Path
echo ==============================
echo 刷新当前Path环境变量 
echo 输出系统注册表中的环境变量
setenv.exe -g Path
echo 输出当前cmd中的环境变量
echo %Path%
echo 临时将环境变量值设置为1
set Path=1
echo 输出当前cmd中的环境变量
echo %Path%
echo 注意: 环境变量刷新已完成，请结束时关闭当前命令行窗口重新打开
echo 注意: 存在cmd中测试成功，但cmder中的环境变量未更新成功的可能，重启解决
echo ==============================
echo 修改npm的模块文件位置 
echo 注意 npm命令可能需要手动复制运行，原因可能是环境变量未刷新
echo 建议关闭当前cmd后再次运行

echo 创建node_global、node_cache目录
mkdir  %Base_Path%\nodejs\node_global
mkdir  %Base_Path%\nodejs\node_cache

echo 通过config配置指向node_global、node_cache目录
npm config set prefix "%Base_Path%\nodejs\node_global"
npm config set cache "%Base_Path%\nodejs\node_cache"

echo 通过config配置指向国内镜像源，命令如下
npm config -g set registry https://registry.npm.taobao.org

echo 查看是否配置成功
npm config get registry  
echo ==============================
echo === 请按任意键退出! 
pause





