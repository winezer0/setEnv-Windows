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
echo �½� "%Base_Path%\python27" Ŀ¼
if not exist "%Base_Path%\python27" mkdir "%Base_Path%\python27"
if exist "%Base_Path%\python27" echo �½� "%Base_Path%\python27" Ŀ¼���
echo ==============================
echo ����python27��������

echo ���python27����������
copy  %Base_Path%\python27\python.exe  %Base_Path%\python27\python2.exe /Y
copy  %Base_Path%\python27\python.exe  %Base_Path%\python27\python27.exe /Y

echo ׷��Python27��Path ·��  ���ھ���·��  
setenv.exe -a "Path" "%Base_Path%\Python27\Scripts"
setenv.exe -a "Path" "%Base_Path%\Python27"

echo �½�PYTHONDONTWRITEBYTECODE������python�ű�����ʱ������pycache
setenv.exe -s "PYTHONDONTWRITEBYTECODE"  1 
echo ==============================
echo �鿴ϵͳע����еĵ�ǰ��������
setenv.exe -g Path
setenv.exe -g PYTHONDONTWRITEBYTECODE
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



