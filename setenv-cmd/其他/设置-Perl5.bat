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
echo �½� "%Base_Path%\Perl5" Ŀ¼
if not exist "%Base_Path%\Perl5" mkdir "%Base_Path%\Perl5"
if exist "%Base_Path%\Perl5" echo �½� "%Base_Path%\Perl5" Ŀ¼���
echo ==============================
echo ����Perl5��������

echo \c\bin;����ģ����Ҫ�õ��� GCC bin Ŀ¼
echo \perl\bin; Perl �������������� �Լ�һЩĬ��ģ��ĸ�������
echo \perl\site\bin;�û���װģ��ĸ������ߵ�·��

echo ׷��Perl5��Path ·��  ���ھ���·��  
setenv  -a  path %Base_Path%\Perl5\perl\site\bin
setenv  -a  path %Base_Path%\Perl5\perl\bin
setenv  -a  path %Base_Path%\Perl5\c\bin
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





