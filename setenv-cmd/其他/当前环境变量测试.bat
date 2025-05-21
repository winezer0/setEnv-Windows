@echo off
echo ==============================
echo 进入当前脚本所在目录 %~dp0
cd /D %~dp0
echo =======================
echo Python 环境测试
python -V
python2 -V
python3 -V
python38 -V
python37 -V
pip -V
pip2 -V
pip3 -V

echo =======================
echo Java 环境测试
java -version
javac -version
java11 -version
javac11 -version

echo =======================
echo gradle 环境测试
:: gradle -v

echo =======================
echo Maven 环境测试
:: mvn -v  

echo =======================
echo Go 环境测试
go  version


echo =======================
echo Ruby 环境测试
ruby -v

echo =======================
echo GCC 环境测试
gcc -v

echo =======================
echo Perl 环境测试
perl -v

echo =======================
echo NodeJs 环境测试
node -v
npm -v

echo =======================
echo Php 环境测试
php -v
php7 -v

echo =======================
echo Path 环境测试
echo %JAVA_HOME%
echo %CLASSPATH%
echo %GOROOT%
echo %GOPATH%
echo %MAVEN_HOME%
echo %GRADLE_HOME%
::echo %NODE_PATH%

echo =======================
echo Setenv -g  Path 环境测试
setenv.exe -g Path

echo =======================
pause
