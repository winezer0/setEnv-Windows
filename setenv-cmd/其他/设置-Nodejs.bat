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
echo �½� "%Base_Path%\nodejs" Ŀ¼
if not exist "%Base_Path%\nodejs" mkdir "%Base_Path%\nodejs"
if exist "%Base_Path%\nodejs" echo �½� "%Base_Path%\nodejs" Ŀ¼���
echo ==============================
echo ����NODEJS ��������

echo �½�NODE_PATH  ģ�����·��
setenv  -s "NODE_PATH"  "%Base_Path%\nodejs\node_global\node_modules" 

echo ׷��nodejs��Path ·��  ���ھ���·��  
setenv  -a  Path "%Base_Path%\nodejs\node_global" 
setenv  -a  Path "%Base_Path%\nodejs" 
echo ===============================
echo �鿴ϵͳע����еĵ�ǰ��������
setenv  -g NODE_PATH
setenv  -g Path
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
echo �޸�npm��ģ���ļ�λ�� 
echo ע�� npm���������Ҫ�ֶ��������У�ԭ������ǻ�������δˢ��
echo ����رյ�ǰcmd���ٴ�����

echo ����node_global��node_cacheĿ¼
mkdir  %Base_Path%\nodejs\node_global
mkdir  %Base_Path%\nodejs\node_cache

echo ͨ��config����ָ��node_global��node_cacheĿ¼
npm config set prefix "%Base_Path%\nodejs\node_global"
npm config set cache "%Base_Path%\nodejs\node_cache"

echo ͨ��config����ָ����ھ���Դ����������
npm config -g set registry https://registry.npm.taobao.org

echo �鿴�Ƿ����óɹ�
npm config get registry  
echo ==============================
echo === �밴������˳�! 
pause





