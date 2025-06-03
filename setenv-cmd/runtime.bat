@echo off  
setlocal enabledelayedexpansion  

:: 输出当前时间
echo runtime start on %time%

:: 获取开始时间  
for /f "tokens=1-4 delims=:." %%a in ("%time%") do (  
    set "start_hour=%%a"  
    set /a "start_min=100%%b %% 100"  
    set /a "start_sec=100%%c %% 100"  
    set /a "start_ms=100%%d %% 100"  
)  
  
:: 调用自定义命令  
call %*
  
:: 获取结束时间  
for /f "tokens=1-4 delims=:." %%a in ("%time%") do (  
    set "end_hour=%%a"  
    set /a "end_min=100%%b %% 100"  
    set /a "end_sec=100%%c %% 100"  
    set /a "end_ms=100%%d %% 100"  
)  
  
:: 计算时间差  
set /a "elapsed_ms=(end_ms-start_ms)+(end_sec-start_sec)*1000+(end_min-start_min)*60000+(end_hour-start_hour)*3600000"  
set /a "elapsed_sec=elapsed_ms/1000"  

set /a "minutes=elapsed_sec / 60"  
set /a "remainingSeconds=elapsed_sec %% 60"  
:: 输出运行时间  
echo Command completed in !elapsed_sec! seconds.
echo Command completed in !minutes! min !remainingSeconds! s.

:: 输出当前时间
echo runtime end on %time%

endlocal