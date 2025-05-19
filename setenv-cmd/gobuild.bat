@echo off
setlocal enabledelayedexpansion

REM 参数说明：
REM %1 = 源代码路径或包含 main 包的目录
REM %2 = 输出基础名称
REM %3 = GOOS 列表，连字符分隔，如：windows-linux-darwin（可选）
REM %4 = GOARCH 列表，连字符分隔，如：amd64-386（可选）
REM %5 = --cgo 表示启用 cgo（可选）

REM 设置默认值
set "DEFAULT_OS_LIST=windows-linux"
set "DEFAULT_ARCH_LIST=amd64"

REM 检查并设置参数
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

REM 如果未提供 OS 和 ARCH 参数，则使用默认值
if "%OS_LIST%"=="" set "OS_LIST=%DEFAULT_OS_LIST%"
if "%ARCH_LIST%"=="" set "ARCH_LIST=%DEFAULT_ARCH_LIST%"

REM 检查GOOS和GOARCH列表是否为空（理论上不会触发，因为我们已经设置了默认值）
if "%OS_LIST%"=="" (
    echo Error: Please specify a hyphen-separated list of target operating systems or use default.
    exit /b 1
)
if "%ARCH_LIST%"=="" (
    echo Error: Please specify a hyphen-separated list of target architectures or use default.
    exit /b 1
)

REM 如果指定了 --cgo 参数，则启用 CGO
if /i "%5"=="--cgo" set CGO_ENABLED=1

REM 将连字符替换为空格以创建可迭代列表
set "OS_LIST=%OS_LIST:-= %"
set "ARCH_LIST=%ARCH_LIST:-= %"

REM 创建输出目录
set "OUTPUT_DIR=%OUTNAME%"
if exist "%OUTPUT_DIR%" rd /s /q "%OUTPUT_DIR%"
md "%OUTPUT_DIR%"

echo Building with SOURCE="%SOURCE%"
echo Building with OUTNAME="%OUTNAME%"
echo Building with OS_LIST="%OS_LIST%"
echo Building with ARCH_LIST="%ARCH_LIST%"
echo Building with CGO_ENABLED=%CGO_ENABLED%

for %%o in (%OS_LIST%) do (
    for %%a in (%ARCH_LIST%) do (

        set "EXT="
        if /i "%%o"=="windows" set EXT=.exe

        echo Building %%o-%%a ...
        set "OUTFILE=%OUTPUT_DIR%\%OUTNAME%-%%o-%%a%EXT%"

        REM 设置环境变量
        set "GOOS=%%o"
        set "GOARCH=%%a"
        set "CGO_ENABLED=%CGO_ENABLED%"

        REM 执行构建命令
        go build -trimpath -ldflags="-w -s" -o "!OUTFILE!" "!SOURCE!"
        if errorlevel 1 (
            echo Build failed for %%o-%%a
            exit /b 1
        )
    )
)

echo.
echo All builds completed successfully.

REM 打包为 ZIP 文件（使用 Windows 自带的 PowerShell）
echo Packing to %OUTNAME%.zip ...
if exist "%OUTNAME%.zip" del "%OUTNAME%.zip"
powershell.exe Compress-Archive -Path "%OUTPUT_DIR%" -DestinationPath "%OUTNAME%.zip" -Force

echo.
echo Output files saved in folder: %cd%\%OUTPUT_DIR%
echo Archive created: %cd%\%OUTNAME%.zip

exit /b 0