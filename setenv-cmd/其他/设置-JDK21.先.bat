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
echo �½� "%Base_Path%\jdk21" Ŀ¼
if not exist "%Base_Path%\jdk21" mkdir "%Base_Path%\jdk21"
if exist "%Base_Path%\jdk21" echo �½� "%Base_Path%\jdk21" Ŀ¼���
echo ==============================
echo ����jdk21��������

echo ������java*.exe �������������
copy  %Base_Path%\jdk21\bin\java.exe  %Base_Path%\jdk21\bin\java21.exe  /Y
copy  %Base_Path%\jdk21\bin\javac.exe  %Base_Path%\jdk21\bin\javac21.exe  /Y
copy  %Base_Path%\jdk21\bin\javaw.exe  %Base_Path%\jdk21\bin\javaw21.exe  /Y

echo ׷��jdk21��Path ·��  ���ھ���·��  
setenv.exe -a "Path" "%Base_Path%\jdk21\bin"
echo ==============================
echo �鿴ϵͳע����еĵ�ǰ��������
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



