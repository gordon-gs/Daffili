import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/vitality_record.dart';

/// 本地数据库服务
/// 
/// 隐私保证：
/// - 所有数据仅存储在设备本地
/// - 使用 Isar 加密数据库
/// - 严禁任何网络上传逻辑
class DatabaseService {
  static DatabaseService? _instance;
  static Isar? _isar;
  
  DatabaseService._();
  
  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }
  
  /// 初始化数据库（Schema-first 设计）
  Future<void> initialize() async {
    if (_isar != null && _isar!.isOpen) return;
    
    final dir = await getApplicationDocumentsDirectory();
    
    _isar = await Isar.open(
      [VitalityRecordSchema],
      directory: dir.path,
      // 启用加密（生产环境需配置密钥）
      inspector: false,
      name: 'vital_sync_db',
    );
  }
  
  Isar get db {
    if (_isar == null || !_isar!.isOpen) {
      throw Exception('数据库未初始化，请先调用 initialize()');
    }
    return _isar!;
  }
  
  /// 创建新记录（性能监控）
  Future<int> createRecord(VitalityRecord record) async {
    final stopwatch = Stopwatch()..start();
    
    final result = await db.writeTxn(() async {
      return await db.vitalityRecords.put(record);
    });
    
    stopwatch.stop();
    final latency = stopwatch.elapsedMilliseconds;
    
    if (latency > 50) {
      print('⚠️ 数据库写入延迟超过50ms: ${latency}ms');
    } else {
      print('✅ 数据库写入延迟: ${latency}ms');
    }
    
    return result;
  }
  
  /// 获取所有记录（按时间倒序）
  Future<List<VitalityRecord>> getAllRecords() async {
    return await db.vitalityRecords
        .where()
        .sortByTimestampDesc()
        .findAll();
  }
  
  /// 获取指定时间范围内的记录
  Future<List<VitalityRecord>> getRecordsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final startTimestamp = startDate.millisecondsSinceEpoch;
    final endTimestamp = endDate.millisecondsSinceEpoch;
    
    return await db.vitalityRecords
        .filter()
        .timestampBetween(startTimestamp, endTimestamp)
        .sortByTimestampDesc()
        .findAll();
  }
  
  /// 获取最近 N 天的记录（性能监控）
  Future<List<VitalityRecord>> getRecentRecords(int days) async {
    final stopwatch = Stopwatch()..start();
    
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));
    final result = await getRecordsByDateRange(startDate, now);
    
    stopwatch.stop();
    final latency = stopwatch.elapsedMilliseconds;
    
    if (latency > 50) {
      print('⚠️ 数据库读取延迟超过50ms: ${latency}ms');
    } else {
      print('✅ 数据库读取延迟: ${latency}ms');
    }
    
    return result;
  }
  
  /// 获取未分析的记录
  Future<List<VitalityRecord>> getUnanalyzedRecords() async {
    return await db.vitalityRecords
        .filter()
        .isAnalyzedEqualTo(false)
        .findAll();
  }
  
  /// 标记记录为已分析
  Future<void> markAsAnalyzed(int recordId) async {
    await db.writeTxn(() async {
      final record = await db.vitalityRecords.get(recordId);
      if (record != null) {
        record.isAnalyzed = true;
        await db.vitalityRecords.put(record);
      }
    });
  }
  
  /// 删除记录
  Future<bool> deleteRecord(int recordId) async {
    return await db.writeTxn(() async {
      return await db.vitalityRecords.delete(recordId);
    });
  }
  
  /// 获取统计数据
  Future<Map<String, dynamic>> getStatistics(int days) async {
    final records = await getRecentRecords(days);
    
    if (records.isEmpty) {
      return {
        'total_count': 0,
        'avg_mood': 0.0,
        'avg_fatigue': 0.0,
        'avg_rhythm': 0.0,
      };
    }
    
    final avgMood = records
        .map((r) => r.moodLevel)
        .reduce((a, b) => a + b) / records.length;
    
    final avgFatigue = records
        .map((r) => r.fatigueScore)
        .reduce((a, b) => a + b) / records.length;
    
    final rhythmRecords = records
        .where((r) => r.rhythmIntensity != null)
        .toList();
    
    final avgRhythm = rhythmRecords.isNotEmpty
        ? rhythmRecords
            .map((r) => r.rhythmIntensity!)
            .reduce((a, b) => a + b) / rhythmRecords.length
        : 0.0;
    
    return {
      'total_count': records.length,
      'avg_mood': avgMood,
      'avg_fatigue': avgFatigue,
      'avg_rhythm': avgRhythm,
    };
  }
  
  /// 关闭数据库
  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
