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
echo �½� "%Base_Path%\gradle" Ŀ¼
if not exist "%Base_Path%\gradle" mkdir "%Base_Path%\gradle"
if exist "%Base_Path%\gradle" echo �½� "%Base_Path%\gradle" Ŀ¼���
echo ==============================
echo ����gradle��������

echo �½�GRADLE_HOME
setenv.exe -s "GRADLE_HOME"  	"%Base_Path%\gradle" 

::echo ׷��GRADLE_HOME��Path ·�� ���ڻ������� 
setenv.exe -a "Path" "%%GRADLE_HOME%%\bin"

echo ׷��GRADLE_HOME��Path ·��  ���ھ���·��  
setenv.exe -a "Path" %Base_Path%\gradle"
echo ==============================
echo �鿴ϵͳע����еĵ�ǰ��������
setenv.exe -g GRADLE_HOME
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
