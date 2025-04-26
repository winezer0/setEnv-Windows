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
echo 新建 "%Base_Path%\jdk8" 目录
if not exist "%Base_Path%\jdk8" mkdir "%Base_Path%\jdk8"
if exist "%Base_Path%\jdk8" echo 新建 "%Base_Path%\jdk8" 目录完成
echo ==============================
echo 配置Jdk8环境变量
echo 重命名java*.exe 解决兼容性问题
copy  %Base_Path%\jdk8\bin\java.exe  %Base_Path%\jdk8\bin\java8.exe  /Y
copy  %Base_Path%\jdk8\bin\javac.exe  %Base_Path%\jdk8\bin\javac8.exe  /Y
copy  %Base_Path%\jdk8\bin\javaw.exe  %Base_Path%\jdk8\bin\javaw8.exe  /Y

echo 新建JAVA_HOME
setenv.exe -s "JAVA_HOME" "%Base_Path%\jdk8" 

echo 新建ClassPath
setenv.exe -s "CLASSPath" ".;%%JAVA_HOME%%\lib\tools.jar;%%JAVA_HOME%%\lib\dt.jar"

echo 追加jdk8到Path 路径  基于绝对路径  
setenv.exe -a "Path" "%Base_Path%\jdk8\bin"
echo ==============================
echo 查看系统注册表中的当前环境变量
setenv.exe -g JAVA_HOME
setenv.exe -g CLASSPath
setenv.exe -g Path
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
echo === 请按任意键退出! 
pause



