@echo off
echo ==============================
echo ǰ������:
set Base_Path=C:\Program_Base
echo ���ű�ʹ�ù̶�·�� "%Base_Path%" , ����������ֶ��޸�
echo ���ű���Ҫ���� setenv.exe , �뽫�������ڵ�ǰĿ¼�����Path����
echo ==============================
echo ���뵱ǰ�ű�����Ŀ¼ %~dp0
cd /D %~dp0
echo ==============================
echo �½� "%Base_Path%" Ŀ¼
if not exist "%Base_Path%" mkdir "%Base_Path%"
if exist "%Base_Path%" echo �½� "%Base_Path%" Ŀ¼���
echo ==============================
echo === �밴������˳�! 
pause




