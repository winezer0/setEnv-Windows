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
echo �½� "%Base_Path%\rust" Ŀ¼
if not exist "%Base_Path%\rust" mkdir "%Base_Path%\rust"
if exist "%Base_Path%\rust" echo �½� "%Base_Path%\rust" Ŀ¼���
echo ==============================
echo ����RUST��������
echo ע�⣺��Ҫ��init֮ǰ����

echo �½�RUSTUP_HOME
setenv  -s  "RUSTUP_HOME"  "%Base_Path%\rust" 
echo �½�CARGO_HOME
setenv  -s "CARGO_HOME"   "%Base_Path%\rust\CARGO_HOME" 

echo ׷��CARGO��Path ·��  ���ھ���·��  
setenv  -a Path "%Base_Path%\rust\CARGO_HOME\bin"

echo ==============================
echo �鿴ϵͳע����еĵ�ǰ��������
setenv.exe -g  RUSTUP_HOME
setenv.exe -g  CARGO_HOME
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



