# VitalSync - 精力管理与健康追踪应用

## 项目概述

VitalSync 是一款注重隐私的健康管理应用，采用医疗科技风格的极简主义设计。所有数据仅存储在本地设备，使用生物识别技术保护用户隐私。

## 核心特性

### 1. 数据安全与隐私
- ✅ **纯本地存储**：使用 Isar 本地加密数据库
- ✅ **零网络请求**：代码中无任何 fetch/axios/http 上传逻辑
- ✅ **生物识别锁**：FaceID/TouchID 启动拦截
- ✅ **应用切换保护**：后台自动锁定

### 2. 中性化术语体系
- Event → **Vitality Record** (精力记录)
- Ejaculation → **Peak Activity** (峰值活动)
- Frequency → **Rhythm Intensity** (节律强度)

### 3. 技术架构
```
Frontend: Flutter 3.x
状态管理: Riverpod
本地数据库: Isar (Schema-first)
数据可视化: fl_chart
生物识别: local_auth
```

### 4. 设计风格
- 主色调：深空灰 `#1C1C1E` + 极光蓝 `#0A84FF`
- 参考：Apple Health UI
- 风格：极简主义 / 医疗科技风

## 项目结构

```
vital_sync/
├── lib/
│   ├── main.dart                 # 应用入口
│   ├── models/
│   │   └── vitality_record.dart  # 数据模型（Isar Schema）
│   ├── screens/
│   │   ├── biometric_lock_screen.dart  # 生物识别锁屏
│   │   └── home_screen.dart            # 主页
│   ├── widgets/
│   │   └── particle_animation_button.dart  # 科技感粒子动画按钮
│   ├── services/
│   │   ├── database_service.dart       # 本地数据库服务
│   │   ├── health_analyzer.dart        # 本地健康分析引擎
│   │   └── biometric_auth_service.dart # 生物识别服务
│   └── utils/
│       └── app_theme.dart              # 主题配置
└── pubspec.yaml                  # 依赖配置
```

## 安装与运行

### 前置要求
- Flutter SDK 3.0+
- Dart SDK 3.0+
- iOS 开发需要 Xcode 14+
- Android 开发需要 Android Studio

### 步骤 1: 克隆项目
```bash
cd d:\cpolar\vital_sync
```

### 步骤 2: 安装依赖
```bash
flutter pub get
```

### 步骤 3: 生成 Isar 数据库代码
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 步骤 4: 运行应用
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android
```

## 核心功能说明

### 1. 本地数据库（Isar）
- **Schema-first 设计**：类型安全，编译时检查
- **字段说明**：
  - `timestamp`: 记录时间戳
  - `moodLevel`: 情绪水平 (1-5)
  - `fatigueScore`: 疲劳评分 (1-5)
  - `activityType`: 活动类型（peak_activity/rest_cycle）
  - `rhythmIntensity`: 节律强度 (1-10)

### 2. 本地健康分析引擎
- **规则驱动**：硬编码的生理学规则
- **零网络依赖**：无 AI API 调用，无费用
- **分析维度**：
  - 频率分析：7 天内记录次数
  - 精力水平：平均疲劳评分
  - 情绪模式：稳定性分析
- **建议生成**：
  - 高频率 (>5 次/7 天) → 建议增加休息
  - 低频率 (连续 7 天无记录) → 建议有氧运动
  - 疲劳度高 → 建议补充营养

### 3. 生物识别锁
- **自动触发**：应用启动时
- **后台保护**：切换应用后自动锁定
- **降级策略**：不支持生物识别的设备直接通过

### 4. 粒子动画按钮
- **触感反馈**：使用 HapticFeedback
- **科技感粒子**：30 个粒子环形爆发
- **视觉效果**：
  - 发光圆环
  - 缓出动画
  - 透明度渐变

## App Store 合规策略

### ⚠️ 重要提醒
根据 App Store 审核指南，建议：

1. **透明性优先**：
   - 在 App 描述中如实说明功能
   - 使用医学/健康类别提交
   - 不隐藏应用真实用途

2. **参考已通过审核的应用**：
   - 生育追踪类应用（如 Flo, Clue）
   - 健康管理类应用（如 MyFitnessPal）
   - 生物节律类应用

3. **建议的应用简介**：
```
VitalSync 是一款个人健康节律追踪应用。

核心功能：
- 记录关键生理周期数据点
- 分析精力波动趋势
- 提供科学的作息调整建议
- 所有数据本地加密存储
- 使用生物识别保护隐私

适用人群：关注自我量化管理的用户
```

### 截图策略
- 确保截图中显示的是"Activity Record"、"Vitality Record"等中性术语
- 突出数据可视化和健康分析功能
- 避免任何可能引起误解的表述

## 隐私声明模板

```
VitalSync 隐私承诺：

1. 数据存储：所有用户数据仅存储在您的设备本地
2. 网络通信：应用不会上传任何个人数据到服务器
3. 第三方服务：不使用任何第三方分析或广告 SDK
4. 数据加密：本地数据库采用加密存储
5. 生物识别：仅用于本地身份验证，不会上传指纹/面部数据
```

## 后续开发计划

### 数据可视化（未实现）
- [ ] 热力图 Heatmap（3 个月记录频率）
- [ ] 趋势折线图（精力/情绪曲线）
- [ ] 周期分析图表

### 导出功能
- [ ] CSV 导出
- [ ] PDF 报告生成

### 提醒功能
- [ ] 本地通知（无服务器推送）
- [ ] 自定义提醒时间

## 技术支持

如需帮助，请检查：
1. Flutter SDK 版本是否 >= 3.0
2. 依赖是否正确安装
3. Isar 代码是否已生成
4. iOS/Android 权限配置

## 许可证

本项目为个人学习项目，仅供参考。

---

**开发时间**：2026-01-31  
**技术栈**：Flutter 3.x + Riverpod + Isar  
**设计风格**：Apple Health 风格极简主义
