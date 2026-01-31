@echo off
:: VitalSync Flutter 启动脚本
:: 自动配置环境变量并运行 Flutter

echo ========================================
echo   VitalSync Flutter 环境配置
echo ========================================
echo.

:: 设置 Flutter PATH
set "PATH=%PATH%;D:\flutter_windows_3.16.0-stable\flutter\bin"

:: 设置国内镜像
set "FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn"
set "PUB_HOSTED_URL=https://pub.flutter-io.cn"

:: 进入项目目录
cd /d D:\cpolar\vital_sync

echo Flutter 环境已配置
echo.

:: 验证 Flutter
flutter --version
echo.

echo ========================================
echo 请选择操作:
echo ========================================
echo 1. flutter pub get (安装依赖)
echo 2. flutter pub run build_runner build (生成数据库代码)
echo 3. flutter run (运行项目)
echo 4. flutter doctor (检查环境)
echo 5. 打开 PowerShell (手动操作)
echo 0. 退出
echo.

choice /c 123450 /n /m "请输入数字: "

if errorlevel 6 goto :exit
if errorlevel 5 goto :shell
if errorlevel 4 goto :doctor
if errorlevel 3 goto :run
if errorlevel 2 goto :build
if errorlevel 1 goto :get

:get
echo.
echo 正在安装依赖...
flutter pub get
pause
goto :exit

:build
echo.
echo 正在生成数据库代码...
flutter pub run build_runner build --delete-conflicting-outputs
pause
goto :exit

:run
echo.
echo 正在运行项目...
echo 注意: 需要连接 Android 设备或模拟器
flutter run
pause
goto :exit

:doctor
echo.
echo 正在检查环境...
flutter doctor -v
pause
goto :exit

:shell
echo.
echo 打开 PowerShell，环境变量已配置
echo 当前目录: D:\cpolar\vital_sync
echo.
powershell -NoExit
goto :exit

:exit
echo.
echo 谢谢使用！
