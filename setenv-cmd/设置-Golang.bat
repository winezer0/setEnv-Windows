@echo off
echo ==============================
echo ǰ������:
set Base_Path=C:\Program_Base
echo ���ű�ʹ�ù̶�·�� %Base_Path% , ����������ֶ��޸�
echo ���ű���Ҫ����setenv.exe , �뽫setenv���ڵ�ǰĿ¼�����Path��������
echo ==============================
echo ���뵱ǰ�ű�����Ŀ¼ %~dp0
cd /D %~dp0

echo ==============================
echo �½� "%Base_Path%\go" Ŀ¼
if not exist "%Base_Path%\go" mkdir "%Base_Path%\go"
if exist "%Base_Path%\go" echo �½� "%Base_Path%\go" Ŀ¼���
echo ==============================
echo �½� "%Base_Path%\goPath" Ŀ¼
if not exist "%Base_Path%\goPath" mkdir "%Base_Path%\goPath"
if exist "%Base_Path%\goPath" echo �½� "%Base_Path%\goPath" Ŀ¼���
echo ==============================
echo ����golang��������
echo �½�GOROOT
setenv.exe -s "GOROOT"  "%Base_Path%\go" 
echo �½�GOPath 
setenv.exe -s "GOPath"   "%Base_Path%\goPath" 
echo ׷��GOROOT��GOPath��Path ·��  ���ھ���·��
setenv.exe -a "Path" "%Base_Path%\go\bin"
setenv.exe -a "Path" "%Base_Path%\goPath\bin"
echo ==============================
echo �鿴ϵͳע����еĵ�ǰ��������
setenv.exe -g GOROOT
setenv.exe -g GOPath
setenv.exe -g Path
echo ==============================
echo ˢ�µ�ǰPath�������� 
echo ���ϵͳע����еĻ�������
setenv.exe -g Path
echo �����ǰcmd�еĻ�������
echo %Path%
echo ��ʱ����������ֵ����Ϊ1
set Path=1
echo �����ǰcmd�еĻ�������
echo %Path%
echo ע��: ��������ˢ������ɣ������ʱ�رյ�ǰ�����д������´�
echo ע��: ����cmd�в��Գɹ�����cmder�еĻ�������δ���³ɹ��Ŀ��ܣ��������
echo ==============================
echo === �밴������˳�! 
pause



