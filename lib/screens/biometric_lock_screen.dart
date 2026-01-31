import 'package:flutter/material.dart';
import 'dart:ui';
import '../services/biometric_auth_service.dart';
import '../utils/app_theme.dart';

/// 生物识别锁屏页面
/// 
/// 功能：
/// - App 启动时自动触发
/// - FaceID/TouchID 认证
/// - 认证失败显示模糊背景
class BiometricLockScreen extends StatefulWidget {
  final Widget child;
  
  const BiometricLockScreen({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen>
    with WidgetsBindingObserver {
  final BiometricAuthService _authService = BiometricAuthService();
  bool _isAuthenticated = false;
  bool _isAuthenticating = false;
  String _errorMessage = '';
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _authenticate();
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 当应用从后台返回时，重新认证
    if (state == AppLifecycleState.resumed && !_isAuthenticated) {
      _authenticate();
    } else if (state == AppLifecycleState.paused) {
      setState(() {
        _isAuthenticated = false;
      });
    }
  }
  
  Future<void> _authenticate() async {
    if (_isAuthenticating) return;
    
    setState(() {
      _isAuthenticating = true;
      _errorMessage = '';
    });
    
    try {
      final isSupported = await _authService.isDeviceSupported();
      
      if (!isSupported) {
        // 设备不支持生物识别，直接通过
        setState(() {
          _isAuthenticated = true;
          _isAuthenticating = false;
        });
        return;
      }
      
      final success = await _authService.authenticate(
        reason: '验证身份以访问您的健康数据',
      );
      
      setState(() {
        _isAuthenticated = success;
        _isAuthenticating = false;
        if (!success) {
          _errorMessage = '认证失败，请重试';
        }
      });
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
        _errorMessage = '认证出错: ${e.toString()}';
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      return widget.child;
    }
    
    // 显示模糊锁屏
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Stack(
        children: [
          // 模糊背景
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: AppTheme.backgroundLight.withOpacity(0.9),
            ),
          ),
          
          // 锁屏内容
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo 图标
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.auroraBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 60,
                    color: AppTheme.auroraBlue,
                  ),
                ),
                const SizedBox(height: 32),
                
                // 应用名称
                const Text(
                  'VitalSync',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                
                // 说明文字
                const Text(
                  '您的健康数据受到保护',
                  style: TextStyle(
                    fontSize: 17,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 48),
                
                // 认证按钮
                if (!_isAuthenticating)
                  ElevatedButton.icon(
                    onPressed: _authenticate,
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('验证身份'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  )
                else
                  const CircularProgressIndicator(
                    color: AppTheme.auroraBlue,
                  ),
                
                // 错误消息
                if (_errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: AppTheme.errorRed,
                      fontSize: 15,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
