@echo off
:: ����Ƿ����Թ���ԱȨ������
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo �������ԱȨ��...
    PowerShell Start-Process '%~f0' -Verb RunAs
    exit /b
)

:: �ѻ�ù���ԱȨ�޺�ִ�е�����
PowerShell -Command "irm https://raw.githubusercontent.com/yeongpin/cursor-free-vip/main/scripts/install.ps1 | iex"

pause