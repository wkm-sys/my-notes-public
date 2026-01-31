@echo off
setlocal enabledelayedexpansion

:: --- 261.000.CCC_ 规范配置 ---
set "PREFIX=261.001.CCC_"

echo ======================================
echo    图像处理模式选择
echo ======================================
echo [1] 伪透明背景 (适合 Snipaste 贴图/PPT)
echo [2] 纯白背景   (适合打印/普通查看)
echo ======================================
choice /c 12 /m "请选择处理模式:"

set "MODE=%errorlevel%"

:LOOP
if "%~1"=="" goto :DONE

set "BASE_NAME=%PREFIX%Clean_%~n1"
set "EXT=.png"
set "FINAL_NAME=%BASE_NAME%%EXT%"

:: $Esc: 防止重名逻辑
set /a count=1
:CHECK_EXIST
if exist "!FINAL_NAME!" (
    set "FINAL_NAME=%BASE_NAME%(!count!)%EXT%"
    set /a count+=1
    goto :CHECK_EXIST
)

echo [正在处理] %~nx1 ...

:: --- 分叉逻辑 ---
if "%MODE%"=="1" (
    :: 模式 1: 伪透明
    magick "%~1" -colorspace gray -negate -lat 25x25+10%% -negate ^
    -fill "rgba(255,255,255,0.005)" -opaque white "!FINAL_NAME!"
) else (
    :: 模式 2: 纯白底 (不加透明处理)
    magick "%~1" -colorspace gray -negate -lat 25x25+10%% -negate "!FINAL_NAME!"
)

shift
goto :LOOP

:DONE
echo.
echo [Finished] 所有任务处理完毕！
pause
