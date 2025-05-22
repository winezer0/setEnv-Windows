@echo off
setlocal enabledelayedexpansion

REM ����˵����
REM %1 = Դ����·������� main ����Ŀ¼
REM %2 = �����������
REM %3 = GOOS �б����ַ��ָ����磺windows-linux-darwin����ѡ��
REM %4 = GOARCH �б����ַ��ָ����磺amd64-386����ѡ��
REM %5/%6 = ��ѡ��־��--cgo �� --zip��˳���޹أ�

REM ����Ĭ��ֵ
set "DEFAULT_OS_LIST=windows-linux"
set "DEFAULT_ARCH_LIST=amd64"

REM ��鲢���ò���
if "%1" == "" (
    echo Usage: gobuild.bat ^<source_path^> ^<output_name^> [^<os_list^> ^<arch_list^>] [^--cgo^] [^--zip^]
    echo Example: gobuild.bat . myapp windows-linux-darwin amd64-386 --cgo --zip
    exit /b 1
)

set "SOURCE=%~1"
set "OUTNAME=%~2"
set "OS_LIST=%~3"
set "ARCH_LIST=%~4"
set "CGO_ENABLED=0"
set "CREATE_ZIP=0"

REM ����5�͵�6�������Ƿ�Ϊ --cgo �� --zip
for %%a in (%5 %6) do (
    if /i "%%a"=="--cgo" set CGO_ENABLED=1
    if /i "%%a"=="--zip" set CREATE_ZIP=1
)

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

REM �����ַ��滻Ϊ�ո��Դ����ɵ����б�
set "OS_LIST=%OS_LIST:-= %"
set "ARCH_LIST=%ARCH_LIST:-= %"

REM �������Ŀ¼
set "OUTPUT_DIR=%OUTNAME%"
if exist "%OUTPUT_DIR%" rd /s /q "%OUTPUT_DIR%"
md "%OUTPUT_DIR%"

echo Building with SOURCE="%SOURCE%"
echo Building with OUTNAME="%OUTNAME%"
echo Building with OS_LIST="%OS_LIST%"
echo Building with ARCH_LIST="%ARCH_LIST%"
echo Building with CGO_ENABLED=%CGO_ENABLED%
echo Create ZIP: %CREATE_ZIP%

for %%o in (%OS_LIST%) do (
    for %%a in (%ARCH_LIST%) do (

        set "EXT="
        if /i "%%o"=="windows" set EXT=.exe

        echo Building %%o-%%a ...
        set "OUTFILE=%OUTPUT_DIR%\%OUTNAME%-%%o-%%a%EXT%"

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

REM ��ѡ�����Ϊ ZIP �ļ�������ָ���� --zip ʱִ�У�
if "%CREATE_ZIP%"=="1" (
    echo Packing to %OUTNAME%.zip ...
    if exist "%OUTNAME%.zip" del "%OUTNAME%.zip"
    powershell.exe Compress-Archive -Path "%OUTPUT_DIR%" -DestinationPath "%OUTNAME%.zip" -Force
    echo Archive created: %cd%\%OUTNAME%.zip
) else (
    echo Skip creating ZIP file. Use --zip to enable it.
)

echo.
echo Output files saved in folder: %cd%\%OUTPUT_DIR%

exit /b 0