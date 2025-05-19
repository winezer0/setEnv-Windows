@echo off
setlocal enabledelayedexpansion

REM ����˵����
REM %1 = Դ����·������� main ����Ŀ¼
REM %2 = �����������
REM %3 = GOOS �б����ַ��ָ����磺windows-linux-darwin����ѡ��
REM %4 = GOARCH �б����ַ��ָ����磺amd64-386����ѡ��
REM %5 = --cgo ��ʾ���� cgo����ѡ��

REM ����Ĭ��ֵ
set "DEFAULT_OS_LIST=windows-linux"
set "DEFAULT_ARCH_LIST=amd64"

REM ��鲢���ò���
if "%1" == "" (
    echo Usage: gobuild.bat ^<source_path^> ^<output_name^> [^<os_list^> ^<arch_list^>] [^--cgo^]
    echo Example: gobuild.bat . myapp windows-linux darwin amd64-386 --cgo
    exit /b 1
)

set "SOURCE=%~1"
set "OUTNAME=%~2"
set "OS_LIST=%~3"
set "ARCH_LIST=%~4"
set "CGO_ENABLED=0"

REM ���δ�ṩ OS �� ARCH ��������ʹ��Ĭ��ֵ
if "%OS_LIST%"=="" set "OS_LIST=%DEFAULT_OS_LIST%"
if "%ARCH_LIST%"=="" set "ARCH_LIST=%DEFAULT_ARCH_LIST%"

REM ���GOOS��GOARCH�б��Ƿ�Ϊ�գ������ϲ��ᴥ������Ϊ�����Ѿ�������Ĭ��ֵ��
if "%OS_LIST%"=="" (
    echo Error: Please specify a hyphen-separated list of target operating systems or use default.
    exit /b 1
)
if "%ARCH_LIST%"=="" (
    echo Error: Please specify a hyphen-separated list of target architectures or use default.
    exit /b 1
)

REM ���ָ���� --cgo ������������ CGO
if /i "%5"=="--cgo" set CGO_ENABLED=1

REM �����ַ��滻Ϊ�ո��Դ����ɵ����б�
set "OS_LIST=%OS_LIST:-= %"
set "ARCH_LIST=%ARCH_LIST:-= %"

echo Building with SOURCE="%SOURCE%"
echo Building with OUTNAME="%OUTNAME%"
echo Building with OS_LIST="%OS_LIST%"
echo Building with ARCH_LIST="%ARCH_LIST%"
echo Building with CGO_ENABLED=%CGO_ENABLED%

for %%o in (%OS_LIST%) do (
    for %%a in (%ARCH_LIST%) do (
        REM Darwin ��֧�� 386 �ܹ�
        if /i "%%o"=="darwin" if /i "%%a"=="386" (
            echo Skipping unsupported pair: %%o/%%a
            continue
        )

        set "EXT="
        if /i "%%o"=="windows" set EXT=.exe

        echo Building %%o-%%a ...
        set "OUTFILE=%OUTNAME%-%%o-%%a%EXT%"

        REM ���û�������
        set "GOOS=%%o"
        set "GOARCH=%%a"
        set "CGO_ENABLED=%CGO_ENABLED%"

        REM ִ�й�������
        go build -trimpath -ldflags="-w -s" -o "!OUTFILE!" "!SOURCE!"
        if errorlevel 1 (
            echo Build failed for %%o-%%a
            exit /b 1
        )
    )
)

echo.
echo All builds completed successfully.
exit /b 0