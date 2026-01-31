import 'package:isar/isar.dart';

part 'vitality_record.g.dart';

/// VitalityRecord - 精力记录数据模型
/// 
/// 中性化术语映射：
/// - Event -> Vitality Record (精力记录)
/// - Ejaculation -> Peak Activity (峰值活动)
/// - Frequency -> Rhythm Intensity (节律强度)
@collection
class VitalityRecord {
  Id id = Isar.autoIncrement;
  
  /// 记录时间戳（毫秒）
  late int timestamp;
  
  /// 情绪水平 (1-5)
  /// 1=极差, 2=较差, 3=一般, 4=良好, 5=极佳
  @Index()
  late int moodLevel;
  
  /// 疲劳评分 (1-5)
  /// 1=极度疲劳, 2=较疲劳, 3=正常, 4=精力充沛, 5=巅峰状态
  @Index()
  late int fatigueScore;
  
  /// 记录类型（用于区分不同的生理周期点）
  /// 'peak_activity' = 峰值活动
  /// 'rest_cycle' = 休息周期
  /// 'energy_boost' = 能量提升
  @Index()
  late String activityType;
  
  /// 备注（可选，本地加密存储）
  String? notes;
  
  /// 节律强度评估 (1-10)
  int? rhythmIntensity;
  
  /// 是否已同步到本地分析引擎
  @Index()
  bool isAnalyzed = false;
  
  /// 创建时间（用于审计）
  late DateTime createdAt;
  
  VitalityRecord();
  
  factory VitalityRecord.create({
    required int timestamp,
    required int moodLevel,
    required int fatigueScore,
    required String activityType,
    String? notes,
    int? rhythmIntensity,
  }) {
    final record = VitalityRecord()
      ..timestamp = timestamp
      ..moodLevel = moodLevel
      ..fatigueScore = fatigueScore
      ..activityType = activityType
      ..notes = notes
      ..rhythmIntensity = rhythmIntensity
      ..createdAt = DateTime.now();
    return record;
  }
}
