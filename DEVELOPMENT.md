# VitalSync 开发与部署指南

## 📋 开发进度

### ✅ 已完成功能

#### 第一阶段：基础架构
- ✅ Flutter 项目结构搭建
- ✅ 依赖配置（Riverpod、Isar、fl_chart、local_auth）
- ✅ 应用主题配置（深空灰 + 极光蓝）

#### 第二阶段：数据层
- ✅ Isar 数据模型设计（VitalityRecord）
- ✅ 本地数据库服务（DatabaseService）
- ✅ 中性化术语体系实现

#### 第三阶段：业务逻辑
- ✅ 本地健康分析引擎（HealthAnalyzer）
- ✅ 规则驱动的建议生成系统
- ✅ 统计分析功能

#### 第四阶段：UI 组件
- ✅ 生物识别锁屏页面
- ✅ 主页屏幕
- ✅ 科技感粒子动画按钮（Haptic Feedback）
- ✅ 记录输入对话框

#### 第五阶段：配置文件
- ✅ Android 权限配置
- ✅ iOS 权限配置（FaceID）
- ✅ 项目文档

### ⏳ 待实现功能

- [ ] 数据可视化热力图（Heatmap）
- [ ] 趋势分析图表（折线图）
- [ ] 数据导出功能（CSV/PDF）
- [ ] 本地通知提醒
- [ ] 设置页面

---

## 🚀 快速开始

### 前置要求

**必须安装：**
- Flutter SDK 3.0+ ([安装指南](https://flutter.dev/docs/get-started/install))
- Dart SDK 3.0+
- 代码编辑器（推荐 VS Code 或 Android Studio）

**可选（取决于目标平台）：**
- iOS 开发：macOS + Xcode 14+
- Android 开发：Android Studio + Android SDK

### 第一步：验证 Flutter 环境

```bash
flutter doctor
```

确保输出中显示：
```
✓ Flutter (Channel stable, 3.x.x)
✓ Android toolchain (如果开发 Android)
✓ Xcode (如果开发 iOS)
```

### 第二步：安装依赖

```bash
cd d:\cpolar\vital_sync
flutter pub get
```

### 第三步：生成 Isar 数据库代码

**重要：** 必须执行此步骤，否则会报错 `vitality_record.g.dart` 文件不存在。

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

预期输出：
```
[INFO] Generating build script completed, took 450ms
[INFO] Building new asset graph completed, took 650ms
[INFO] Checking for unexpected pre-existing outputs completed, took 1ms
[INFO] Running build completed, took 4.5s
[INFO] Caching finalized dependency graph completed, took 35ms
[INFO] Succeeded after 4.6s with 2 outputs
```

### 第四步：运行应用

**方式 1：使用命令行**

```bash
# 查看可用设备
flutter devices

# 在 iOS 模拟器运行
flutter run -d ios

# 在 Android 模拟器/真机运行
flutter run -d android

# 在 Windows 运行（仅用于 UI 预览，生物识别功能不可用）
flutter run -d windows
```

**方式 2：使用 VS Code**
1. 打开 `d:\cpolar\vital_sync`
2. 按 `F5` 或点击"运行和调试"
3. 选择目标设备

**方式 3：使用 Android Studio**
1. 打开项目
2. 选择设备
3. 点击运行按钮 ▶️

---

## 🔧 常见问题排查

### 问题 1：找不到 `vitality_record.g.dart` 文件

**错误信息：**
```
Error: Could not resolve the package 'vitality_record' in 'package:vital_sync/models/vitality_record.dart'.
```

**解决方案：**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 问题 2：生物识别功能不工作

**Android：**
- 确保 `AndroidManifest.xml` 包含以下权限：
  ```xml
  <uses-permission android:name="android.permission.USE_BIOMETRIC"/>
  ```
- Android 模拟器需要在设置中配置指纹

**iOS：**
- 确保 `Info.plist` 包含：
  ```xml
  <key>NSFaceIDUsageDescription</key>
  <string>VitalSync 使用 Face ID 保护您的健康数据隐私</string>
  ```
- iOS 模拟器：Features → Face ID/Touch ID → Enrolled

### 问题 3：依赖安装失败

**错误信息：**
```
version solving failed
```

**解决方案：**
```bash
# 清除缓存
flutter clean
flutter pub cache repair

# 重新安装
flutter pub get
```

### 问题 4：Build Runner 卡住

**解决方案：**
```bash
# 停止后台进程
pkill -f dart

# 删除缓存
rm -rf .dart_tool/build

# 重新生成
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📱 真机测试

### iOS 真机测试

1. **连接设备**：用数据线连接 iPhone
2. **信任设备**：在 iPhone 上点击"信任此电脑"
3. **配置签名**：
   ```bash
   # 打开 Xcode
   open ios/Runner.xcworkspace
   ```
   - 选择 Runner → Signing & Capabilities
   - 选择你的 Apple ID 开发者账号
   - 修改 Bundle Identifier 为唯一值（如 `com.yourname.vitalsync`）

4. **运行**：
   ```bash
   flutter run -d <设备ID>
   ```

### Android 真机测试

1. **开启开发者模式**：
   - 设置 → 关于手机 → 连续点击"版本号" 7 次
2. **开启 USB 调试**：
   - 设置 → 开发者选项 → 启用"USB 调试"
3. **连接设备**并运行：
   ```bash
   flutter run
   ```

---

## 🏗️ 构建发布版本

### Android APK

```bash
# 构建 APK
flutter build apk --release

# 构建 App Bundle（用于 Google Play）
flutter build appbundle --release
```

输出位置：`build/app/outputs/flutter-apk/app-release.apk`

### iOS IPA

```bash
# 构建
flutter build ipa --release
```

然后使用 Xcode 或 Transporter 上传到 App Store Connect。

---

## 📝 代码说明

### 核心文件说明

| 文件 | 功能 | 说明 |
|------|------|------|
| `lib/main.dart` | 应用入口 | 初始化数据库、设置主题、启动应用 |
| `lib/models/vitality_record.dart` | 数据模型 | Isar Schema 定义，包含所有字段 |
| `lib/services/database_service.dart` | 数据库服务 | CRUD 操作、统计查询 |
| `lib/services/health_analyzer.dart` | 分析引擎 | 规则驱动的健康建议生成 |
| `lib/services/biometric_auth_service.dart` | 生物识别 | FaceID/TouchID 封装 |
| `lib/screens/biometric_lock_screen.dart` | 锁屏页面 | 启动拦截器 |
| `lib/screens/home_screen.dart` | 主页 | 记录列表、分析结果展示 |
| `lib/widgets/particle_animation_button.dart` | 动画按钮 | 粒子效果 + 触感反馈 |
| `lib/utils/app_theme.dart` | 主题配置 | 颜色、字体、组件样式 |

### 隐私保证验证

**验证方法：** 在整个代码库中搜索网络请求关键词

```bash
# 搜索可能的网络请求
grep -r "http\." lib/
grep -r "fetch" lib/
grep -r "axios" lib/
grep -r "dio" lib/
```

**预期结果：** 所有搜索结果为空（无任何网络请求代码）

---

## 🎨 UI 定制

### 修改主色调

编辑 `lib/utils/app_theme.dart`：

```dart
static const Color deepSpaceGray = Color(0xFF1C1C1E);  // 主背景色
static const Color auroraBlue = Color(0xFF0A84FF);     // 强调色
```

### 修改中性化术语

编辑以下文件中的字符串：
- `lib/screens/home_screen.dart`：UI 显示文本
- `lib/models/vitality_record.dart`：注释说明

---

## 🔐 安全性检查清单

- [x] 所有数据存储在本地（Isar 数据库）
- [x] 无任何 HTTP 请求代码
- [x] 无第三方分析 SDK
- [x] 无广告 SDK
- [x] 生物识别仅用于本地验证
- [x] 应用切换时自动锁定
- [x] 数据库加密配置（需在生产环境设置密钥）

---

## 📖 学习资源

- [Flutter 官方文档](https://flutter.dev/docs)
- [Isar 数据库文档](https://isar.dev)
- [Riverpod 状态管理](https://riverpod.dev)
- [fl_chart 图表库](https://pub.dev/packages/fl_chart)

---

## 🆘 获取帮助

如果遇到问题：

1. 检查本文档的"常见问题排查"部分
2. 运行 `flutter doctor -v` 查看环境问题
3. 查看 Flutter 官方文档

---

**更新时间**：2026-01-31  
**Flutter 版本**：3.0+  
**最低 iOS 版本**：iOS 12.0  
**最低 Android 版本**：Android 6.0 (API 23)
