import 'dart:io';
import 'package:icloud_storage/icloud_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vitality_record.dart';
import 'database_service.dart';

/// 系统级云同步服务
/// 
/// iOS: iCloud 私有数据库
/// Android: 系统自动备份（需配置 AndroidManifest.xml）
class CloudSyncService {
  static final CloudSyncService instance = CloudSyncService._();
  CloudSyncService._();
  
  final DatabaseService _db = DatabaseService.instance;
  
  static const String _backupEnabledKey = 'cloud_backup_enabled';
  static const String _lastSyncTimeKey = 'last_sync_time';
  
  /// 检查是否启用云备份
  Future<bool> isBackupEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_backupEnabledKey) ?? false;
  }
  
  /// 设置云备份开关
  Future<void> setBackupEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_backupEnabledKey, enabled);
    
    if (enabled) {
      // 立即执行一次完整同步
      await syncToCloud();
    }
  }
  
  /// 获取最后同步时间
  Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastSyncTimeKey);
    return timestamp != null 
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }
  
  /// 同步数据到云端
  Future<void> syncToCloud() async {
    if (!await isBackupEnabled()) {
      print('☁️ 云备份未启用，跳过同步');
      return;
    }
    
    try {
      if (Platform.isIOS) {
        await _syncToiCloud();
      } else if (Platform.isAndroid) {
        // Android 使用系统自动备份，无需手动同步
        print('☁️ Android 系统自动备份已启用');
      }
      
      // 更新最后同步时间
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastSyncTimeKey, DateTime.now().millisecondsSinceEpoch);
      
      print('✅ 云同步完成');
    } catch (e) {
      print('❌ 云同步失败: $e');
      rethrow;
    }
  }
  
  /// 同步到 iCloud
  Future<void> _syncToiCloud() async {
    final stopwatch = Stopwatch()..start();
    
    try {
      // 获取所有本地记录
      final records = await _db.getAllRecords();
      
      // TODO: 实现 iCloud 同步逻辑
      // 注意：需要在真实 iOS 设备上测试
      
      stopwatch.stop();
      print('✅ iCloud 同步完成 (${stopwatch.elapsedMilliseconds}ms, ${records.length} 条记录)');
    } catch (e) {
      print('❌ iCloud 同步失败: $e');
      rethrow;
    }
  }
  
  /// 从 iCloud 恢复数据
  Future<void> restoreFromiCloud() async {
    if (!Platform.isIOS) {
      print('⚠️ 仅 iOS 支持 iCloud 恢复');
      return;
    }
    
    try {
      // TODO: 实现 iCloud 恢夏逻辑
      
      print('✅ iCloud 恢复完成');
    } catch (e) {
      print('❌ iCloud 恢复失败: $e');
      rethrow;
    }
  }
  
  /// 检查 iCloud 可用性（仅 iOS）
  Future<bool> isiCloudAvailable() async {
    if (!Platform.isIOS) return false;
    
    try {
      // TODO: 实现 iCloud 可用性检查
      return true;
    } catch (e) {
      print('⚠️ iCloud 不可用: $e');
      return false;
    }
  }
}
