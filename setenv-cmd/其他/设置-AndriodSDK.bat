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
echo �½� "%Base_Path%\Andriod_SDK" Ŀ¼
if not exist "%Base_Path%\Andriod_SDK" mkdir "%Base_Path%\Andriod_SDK"
if exist "%Base_Path%\Andriod_SDK" echo �½� "%Base_Path%\Andriod_SDK" Ŀ¼���
echo ==============================
echo �½�ANDROID_HOME
setenv.exe -s "ANDROID_HOME" "%Base_Path%\Andriod_SDK" 

echo ׷��SDKִ���ļ���Path ·��  ���ھ���·��  
setenv.exe -a "Path" "%Base_Path%\Andriod_SDK\tools"
setenv.exe -a "Path" "%Base_Path%\Andriod_SDK\platform-tools"
setenv.exe -a "Path" "%Base_Path%\Andriod_SDK\build-tools\27.0.1"
echo ==============================
echo �鿴ϵͳע����еĵ�ǰ��������
setenv.exe -g ANDROID_HOME
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



