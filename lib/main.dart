import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/biometric_lock_screen.dart';
import 'screens/home_screen.dart';
import 'services/database_service.dart';
import 'widgets/fluid_background.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 设置系统 UI 样式（浅色模式）
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // 浅色背景用深色图标
      systemNavigationBarColor: AppTheme.backgroundLight,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // 初始化数据库
  await DatabaseService.instance.initialize();
  
  runApp(
    const ProviderScope(
      child: VitalSyncApp(),
    ),
  );
}

class VitalSyncApp extends StatelessWidget {
  const VitalSyncApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daffili',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: FluidGradientBackground(
        child: BiometricLockScreen(
          child: HomeScreen(),
        ),
      ),
    );
  }
}
