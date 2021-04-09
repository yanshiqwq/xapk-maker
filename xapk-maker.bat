@echo off
echo.
echo 	%~nx0 v1.0 By 延时qwq 
echo.
echo BiliBili:	https://space.bilibili.com/431304449
echo Github:		https://github.com/Yanshiqwq/xapk-maker
set CHDIR=%CD%
if "%1" == "" goto :HELP
echo [PID #0] 正在解析变量...
set APK_PATH="%~nx1"
pushd %~dp1 2>nul
for /f "tokens=2,4,6 delims='" %%i in ('aapt dump badging %APK_PATH% ^| findstr "package:"') do (
	set PACKAGE_NAME=%%i
	set VERSION_CODE=%%j
	set VERSION_NAME=%%k
)
rename %APK_PATH% %PACKAGE_NAME%.apk
for /f "tokens=2,4 delims='" %%i in ('aapt dump badging %APK_PATH% ^| findstr "application:"') do (
	set NAME=%%i
	set ICON_FILE=%%j
)
for /f "tokens=2 delims='" %%i in ('aapt dump badging %APK_PATH% ^| findstr "sdkVersion:"') do (
	set MIN_SDK_VERSION=%%i
)
for /f "tokens=2 delims='" %%i in ('aapt dump badging %APK_PATH% ^| findstr "targetSdkVersion:"') do (
	set TARGET_SDK_VERSION=%%i
)
for /f "tokens=3 delims= " %%i in ('dir /-c "Android\obb\%PACKAGE_NAME%" ^| findstr 个文件') do (
	set OBB_SIZE=%%i
)
for /f "tokens=3 delims= " %%i in ('dir /-c "%PACKAGE_NAME%.apk" ^| findstr 个文件') do (
	set APK_SIZE=%%i
)
set /a TOTAL_SIZE=%OBB_SIZE%+%APK_SIZE%

echo [PID #0] 正在解压APK图标...
if exist icon.png del /f /q icon.png
7z e %PACKAGE_NAME%.apk %ICON_FILE% >nul

echo [PID #0] 正在重命名APK图标...
for /f "tokens=3 delims=/" %%j in ('echo %ICON_FILE%') do (rename %%j icon.png)

echo [PID #0] 正在处理manifest文件...
print -en "{\n\t\"xapk_version\": 1,\n\t\"package_name\": \"%PACKAGE_NAME%\",\n\t\"name\": \"%NAME%\",\n\t\"version_code\": \"%VERSION_CODE%\",\n\t\"version\": \"%VERSION_NAME%\",\n\t\"min_sdk_version\": \"%MIN_SDK_VERSION%\",\n\t\"target_sdk_version\": \"%TARGET_SDK_VERSION%\",\n\t\"total_size\": \"%TOTAL_SIZE%\",\n\t\"expansions\": [\n\t\t{\n\t\t\t\"file\": \"Android/obb/%PACKAGE_NAME%/main.%VERSION_CODE%.%PACKAGE_NAME%.obb\",\n\t\t\t\"install_location\": \"EXTERNAL_STORAGE\",\n\t\t\t\"install_path\": \"Android/obb/%PACKAGE_NAME%/main.%VERSION_CODE%.%PACKAGE_NAME%.obb\"\n\t\t}\n\t]\n}" >manifest.json

echo [PID #0] 正在打包xapk文件...
7z a %NAME%_v%VERSION_NAME%_%VERSION_CODE%.xapk %PACKAGE_NAME%.apk Android icon.png manifest.json -mx0 -tzip >nul

for /f "tokens=3 delims= " %%i in ('dir /-c "%NAME%_v%VERSION_NAME%_%VERSION_CODE%.xapk" ^| findstr 个文件') do (
	set /a XAPK_SIZE=%%i/1048576
)

echo [PID #0] 正在清理文件...
if exist icon.png del /f /q icon.png >nul
if exist manifest.json del /f /q manifest.json >nul

echo [PID #0] 打包完毕! 文件名:%NAME%_v%VERSION_NAME%_%VERSION_CODE%.xapk, 文件大小:%XAPK_SIZE%MB.
cd %CHDIR%
goto :EOF

:HELP
echo [PID #0] 使用方法: %~nx0 [APK]
pause
cd %CHDIR%
goto :EOF