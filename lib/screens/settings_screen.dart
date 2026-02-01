import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui';
import '../services/cloud_sync_service.dart';
import '../widgets/glass_card.dart';
import '../utils/app_theme.dart';
import 'package:intl/intl.dart';

/// 设置页面
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final CloudSyncService _cloudSync = CloudSyncService.instance;
  
  bool _isBackupEnabled = false;
  bool _isLoading = true;
  DateTime? _lastSyncTime;
  bool _isiCloudAvailable = false;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final enabled = await _cloudSync.isBackupEnabled();
      final lastSync = await _cloudSync.getLastSyncTime();
      
      bool iCloudAvailable = false;
      if (Platform.isIOS) {
        iCloudAvailable = await _cloudSync.isiCloudAvailable();
      }
      
      setState(() {
        _isBackupEnabled = enabled;
        _lastSyncTime = lastSync;
        _isiCloudAvailable = iCloudAvailable;
        _isLoading = false;
      });
    } catch (e) {
      print('加载设置失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _toggleBackup(bool value) async {
    if (Platform.isIOS && !_isiCloudAvailable && value) {
      _showErrorDialog(
        '无法启用 iCloud 同步',
        '请在系统设置中登录 iCloud，并确保已启用 iCloud Drive。',
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      await _cloudSync.setBackupEnabled(value);
      
      final lastSync = await _cloudSync.getLastSyncTime();
      
      setState(() {
        _isBackupEnabled = value;
        _lastSyncTime = lastSync;
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value ? '☁️ 云备份已启用' : '云备份已关闭'),
            backgroundColor: value ? AppTheme.successGreen : AppTheme.textSecondary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      _showErrorDialog(
        '操作失败',
        '无法${value ? "启用" : "关闭"}云备份：$e',
      );
    }
  }
  
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: AppTheme.errorRed,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('确定'),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '设置',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 云备份设置卡片
                  _buildCloudBackupCard(),
                  
                  const SizedBox(height: 16),
                  
                  // 关于应用
                  _buildAboutCard(),
                ],
              ),
            ),
    );
  }
  
  Widget _buildCloudBackupCard() {
    final platformName = Platform.isIOS ? 'iCloud' : '手机厂商云';
    
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Platform.isIOS ? Icons.cloud_outlined : Icons.backup,
                color: AppTheme.primaryBlue,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                '系统级云备份',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 开关
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '开启云备份',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '数据将加密存储至 $platformName',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _isBackupEnabled,
                onChanged: _toggleBackup,
                activeColor: AppTheme.primaryBlue,
              ),
            ],
          ),
          
          const Divider(height: 32),
          
          // 详细说明
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.primaryBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '备份说明',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '开启后，您的"起飞"与"闭关"记录将加密存储于您的私有 $platformName 空间。\n\n'
                  '• 数据仅存储在您的个人云空间\n'
                  '• 自动加密，保护隐私安全\n'
                  '• 更换设备时可自动恢复\n'
                  '${Platform.isIOS ? "• 需登录 iCloud 账户" : "• 需登录手机厂商账户"}',
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          // 最后同步时间
          if (_lastSyncTime != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppTheme.textTertiary,
                ),
                const SizedBox(width: 6),
                Text(
                  '最后同步：${DateFormat('yyyy-MM-dd HH:mm').format(_lastSyncTime!)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildAboutCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppTheme.auroraBlue,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                '关于 Daffili',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildInfoRow('版本', 'v3.2.3.3454'),
          _buildInfoRow('数据存储', '本地加密 + 云备份'),
          _buildInfoRow('隐私政策', '零数据上传，完全离线'),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
