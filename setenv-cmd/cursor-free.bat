@echo off
:: 检查是否已以管理员权限运行
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo 请求管理员权限...
    PowerShell Start-Process '%~f0' -Verb RunAs
    exit /b
)

:: 已获得管理员权限后执行的命令
PowerShell -Command "irm https://raw.githubusercontent.com/yeongpin/cursor-free-vip/main/scripts/install.ps1 | iex"

pause