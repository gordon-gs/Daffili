import 'package:flutter/material.dart';

/// VitalSync 主题配置
/// 
/// 设计风格：浅色流体 (Light & Fluid)
/// 主色调：渐变蓝 (#3B82F6 - #60A5FA) + 薄荷绿 (#D1FAE5)
/// 背景：米灰色 (#F8FAFC) + 动态柔光球
class AppTheme {
  // 主色调（浅色模式）
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryBlueLight = Color(0xFF60A5FA);
  static const Color accentMint = Color(0xFFD1FAE5);
  static const Color accentSky = Color(0xFFE0F2FE);
  
  // 背景颜色
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color dividerColor = Color(0xFFE5E7EB);
  
  // 旧的暗色主题颜色（保留兼容）
  static const Color deepSpaceGray = Color(0xFF1C1C1E);
  static const Color auroraBlue = Color(0xFF3B82F6); // 更新为新的蓝色
  
  // 语义颜色
  static const Color successGreen = Color(0xFF30D158);
  static const Color warningOrange = Color(0xFFFF9F0A);
  static const Color errorRed = Color(0xFFFF453A);
  
  // 文字颜色（浅色模式）
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  
  /// 浅色流体主题（默认）
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // 主色配置
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundLight,
      
      // 配色方案
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: primaryBlueLight,
        surface: cardBackground,
        background: backgroundLight,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: textPrimary,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: Colors.white,
      ),
      
      // 卡片主题
      cardTheme: CardTheme(
        color: cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // 应用栏主题
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 34,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      // 文本主题
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          color: textTertiary,
        ),
      ),
      
      // 分隔线主题
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 0.5,
      ),
      
      // 浮动按钮主题
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: CircleBorder(),
      ),
      
      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: auroraBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryBlue.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
  
  /// 获取状态颜色
  static Color getStatusColor(String status) {
    switch (status) {
      case 'success':
      case 'good':
      case 'stable':
        return successGreen;
      case 'warning':
      case 'attention':
      case 'high':
        return warningOrange;
      case 'error':
      case 'danger':
      case 'critical':
        return errorRed;
      default:
        return auroraBlue;
    }
  }
  
  /// 获取心情颜色
  static Color getMoodColor(int moodLevel) {
    if (moodLevel >= 4) return successGreen;
    if (moodLevel >= 3) return auroraBlue;
    if (moodLevel >= 2) return warningOrange;
    return errorRed;
  }
  
  /// 获取疲劳度颜色
  static Color getFatigueColor(int fatigueScore) {
    if (fatigueScore >= 4) return successGreen;
    if (fatigueScore >= 3) return auroraBlue;
    if (fatigueScore >= 2) return warningOrange;
    return errorRed;
  }
}
