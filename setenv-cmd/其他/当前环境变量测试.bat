@echo off
echo ==============================
echo ���뵱ǰ�ű�����Ŀ¼ %~dp0
cd /D %~dp0
echo =======================
echo Python ��������
python -V
python2 -V
python3 -V
python38 -V
python37 -V
pip -V
pip2 -V
pip3 -V

echo =======================
echo Java ��������
java -version
javac -version
java11 -version
javac11 -version

echo =======================
echo gradle ��������
:: gradle -v

echo =======================
echo Maven ��������
:: mvn -v  

echo =======================
echo Go ��������
go  version


echo =======================
echo Ruby ��������
ruby -v

echo =======================
echo GCC ��������
gcc -v

echo =======================
echo Perl ��������
perl -v

echo =======================
echo NodeJs ��������
node -v
npm -v

echo =======================
echo Php ��������
php -v
php7 -v

echo =======================
echo Path ��������
echo %JAVA_HOME%
echo %CLASSPATH%
echo %GOROOT%
echo %GOPATH%
echo %MAVEN_HOME%
echo %GRADLE_HOME%
::echo %NODE_PATH%

echo =======================
echo Setenv -g  Path ��������
setenv.exe -g Path

echo =======================
pause
