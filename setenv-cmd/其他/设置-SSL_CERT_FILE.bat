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
echo �½� "%Base_Path%\cacert" Ŀ¼
if not exist "%Base_Path%\cacert" mkdir "%Base_Path%\cacert"
if exist "%Base_Path%\cacert" echo �½� "%Base_Path%\cacert" Ŀ¼���
echo ==============================
echo ����SSL_CERT_FILE��������

echo �½�%Base_Path%\cacertĿ¼���ڴ��SSL֤���ļ�
mkdir %Base_Path%\cacert

echo �½�SSL_CERT_FILE
setenv.exe -s "SSL_CERT_FILE" "%Base_Path%\cacert\cacert.pem"
echo ==============================
echo �鿴ϵͳע����еĵ�ǰ��������
setenv.exe -g SSL_CERT_FILE
echo ==============================
echo ˢ�µ�ǰSSL_CERT_FILE�������� 
echo ���ϵͳע����еĻ�������
setenv.exe -g SSL_CERT_FILE
echo �����ǰcmd�еĻ�������
echo %SSL_CERT_FILE%
echo ��ʱ����������ֵ����Ϊ1
set SSL_CERT_FILE=1
echo �����ǰcmd�еĻ�������
echo %SSL_CERT_FILE%
echo ע��: ��������ˢ������ɣ������ʱ�رյ�ǰ�����д������´�
echo ע��: ����cmd�в��Գɹ�����cmder�еĻ�������δ���³ɹ��Ŀ��ܣ��������
echo ==============================
echo === �밴������˳�! 
pause




