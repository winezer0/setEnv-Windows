::将当前路径加入path,需要管理员权限运行
@echo off
echo %~dp0
setenv.exe -g PATH
echo setenv.exe -a PATH %~dp0
setenv.exe -a  PATH  %~dp0

set path=test
echo %Path%

::pasue


