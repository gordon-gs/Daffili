import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

/// 生物识别认证服务
/// 
/// 支持：
/// - FaceID (iOS)
/// - TouchID (iOS)
/// - Fingerprint (Android)
class BiometricAuthService {
  final LocalAuthentication _auth = LocalAuthentication();
  
  /// 检查设备是否支持生物识别
  Future<bool> isDeviceSupported() async {
    try {
      return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } on PlatformException {
      return false;
    }
  }
  
  /// 获取可用的生物识别类型
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }
  
  /// 执行生物识别认证
  /// 
  /// [reason] 认证原因说明，将显示给用户
  Future<bool> authenticate({
    String reason = '验证身份以访问 VitalSync',
  }) async {
    try {
      // Windows/Desktop 平台直接返回 true（跳过生物识别）
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        return true;
      }
      
      final isSupported = await isDeviceSupported();
      if (!isSupported) {
        return true; // 不支持生物识别的设备直接通过
      }
      
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true, // 即使应用进入后台也保持认证
          biometricOnly: true, // 仅使用生物识别，不允许密码
        ),
      );
    } on PlatformException catch (e) {
      print('生物识别认证失败: ${e.message}');
      return true; // 认证失败也让用户进入（仅用于开发测试）
    }
  }
  
  /// 取消认证
  Future<void> stopAuthentication() async {
    await _auth.stopAuthentication();
  }
}
