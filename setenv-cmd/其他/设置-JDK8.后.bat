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
echo �½� "%Base_Path%\jdk8" Ŀ¼
if not exist "%Base_Path%\jdk8" mkdir "%Base_Path%\jdk8"
if exist "%Base_Path%\jdk8" echo �½� "%Base_Path%\jdk8" Ŀ¼���
echo ==============================
echo ����Jdk8��������
echo ������java*.exe �������������
copy  %Base_Path%\jdk8\bin\java.exe  %Base_Path%\jdk8\bin\java8.exe  /Y
copy  %Base_Path%\jdk8\bin\javac.exe  %Base_Path%\jdk8\bin\javac8.exe  /Y
copy  %Base_Path%\jdk8\bin\javaw.exe  %Base_Path%\jdk8\bin\javaw8.exe  /Y

echo �½�JAVA_HOME
setenv.exe -s "JAVA_HOME" "%Base_Path%\jdk8" 

echo �½�ClassPath
setenv.exe -s "CLASSPath" ".;%%JAVA_HOME%%\lib\tools.jar;%%JAVA_HOME%%\lib\dt.jar"

echo ׷��jdk8��Path ·��  ���ھ���·��  
setenv.exe -a "Path" "%Base_Path%\jdk8\bin"
echo ==============================
echo �鿴ϵͳע����еĵ�ǰ��������
setenv.exe -g JAVA_HOME
setenv.exe -g CLASSPath
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



