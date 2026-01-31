import '../models/vitality_record.dart';
import 'database_service.dart';

/// 本地健康分析引擎
/// 
/// 特点：
/// - 纯本地规则引擎，无任何外部 API 调用
/// - 基于硬编码的生理学规则
/// - 零网络依赖，零隐私泄漏风险
class HealthAnalyzer {
  final DatabaseService _db = DatabaseService.instance;
  
  /// 分析最近的健康状态并返回建议
  Future<HealthAnalysisResult> analyze() async {
    final recentRecords = await _db.getRecentRecords(7);
    final allRecords = await _db.getRecentRecords(30);
    
    return HealthAnalysisResult(
      frequency: _analyzeFrequency(recentRecords),
      energyLevel: _analyzeEnergyLevel(recentRecords),
      moodPattern: _analyzeMoodPattern(recentRecords),
      recommendations: _generateRecommendations(recentRecords, allRecords),
      warningLevel: _calculateWarningLevel(recentRecords),
    );
  }
  
  /// 分析频率
  FrequencyAnalysis _analyzeFrequency(List<VitalityRecord> records) {
    final count = records.length;
    final days = 7;
    
    String status;
    String description;
    
    if (count == 0) {
      status = 'stable';
      description = '身体机能处于平稳期';
    } else if (count > 5) {
      status = 'high';
      description = '系统检测到您近期体能消耗较大';
    } else if (count < 2) {
      status = 'low';
      description = '活动频率较低，建议适度增加运动';
    } else {
      status = 'normal';
      description = '节律强度正常，保持当前状态';
    }
    
    return FrequencyAnalysis(
      count: count,
      period: days,
      status: status,
      description: description,
    );
  }
  
  /// 分析精力水平
  EnergyAnalysis _analyzeEnergyLevel(List<VitalityRecord> records) {
    if (records.isEmpty) {
      return EnergyAnalysis(
        avgFatigue: 3.0,
        trend: 'stable',
        description: '暂无数据',
      );
    }
    
    final avgFatigue = records
        .map((r) => r.fatigueScore)
        .reduce((a, b) => a + b) / records.length;
    
    String trend;
    String description;
    
    if (avgFatigue < 2.5) {
      trend = 'declining';
      description = '疲劳度较高，建议增加休息时间';
    } else if (avgFatigue > 4.0) {
      trend = 'rising';
      description = '精力充沛，状态良好';
    } else {
      trend = 'stable';
      description = '精力水平稳定';
    }
    
    return EnergyAnalysis(
      avgFatigue: avgFatigue,
      trend: trend,
      description: description,
    );
  }
  
  /// 分析情绪模式
  MoodAnalysis _analyzeMoodPattern(List<VitalityRecord> records) {
    if (records.isEmpty) {
      return MoodAnalysis(
        avgMood: 3.0,
        stability: 'unknown',
        description: '暂无数据',
      );
    }
    
    final avgMood = records
        .map((r) => r.moodLevel)
        .reduce((a, b) => a + b) / records.length;
    
    // 计算情绪波动（标准差）
    final variance = records
        .map((r) => (r.moodLevel - avgMood) * (r.moodLevel - avgMood))
        .reduce((a, b) => a + b) / records.length;
    
    final stdDev = variance > 0 ? variance : 0;
    
    String stability;
    String description;
    
    if (stdDev > 1.5) {
      stability = 'unstable';
      description = '情绪波动较大，建议关注心理健康';
    } else if (stdDev < 0.5) {
      stability = 'very_stable';
      description = '情绪稳定，心态良好';
    } else {
      stability = 'stable';
      description = '情绪正常波动范围内';
    }
    
    return MoodAnalysis(
      avgMood: avgMood,
      stability: stability,
      description: description,
    );
  }
  
  /// 生成个性化建议
  List<String> _generateRecommendations(
    List<VitalityRecord> recentRecords,
    List<VitalityRecord> allRecords,
  ) {
    final recommendations = <String>[];
    
    // 规则 1: 高频率警告
    if (recentRecords.length > 5) {
      recommendations.add('系统检测到您近期体能消耗较大，建议增加深层睡眠并补充微量元素锌');
      recommendations.add('建议每日补充蛋白质 1.5-2.0g/kg 体重，支持肌肉恢复');
    }
    
    // 规则 2: 低频率建议
    if (recentRecords.isEmpty) {
      recommendations.add('身体机能处于平稳期，建议进行有氧训练增强循环');
      recommendations.add('推荐运动：游泳、慢跑、骑行（30-45 分钟/次）');
    }
    
    // 规则 3: 疲劳评分低
    final avgFatigue = recentRecords.isNotEmpty
        ? recentRecords.map((r) => r.fatigueScore).reduce((a, b) => a + b) / recentRecords.length
        : 3.0;
    
    if (avgFatigue < 2.5) {
      recommendations.add('疲劳度偏高，建议调整作息：确保每日 7-8 小时睡眠');
      recommendations.add('考虑补充 B 族维生素和镁元素，改善神经系统功能');
    }
    
    // 规则 4: 情绪低落
    final avgMood = recentRecords.isNotEmpty
        ? recentRecords.map((r) => r.moodLevel).reduce((a, b) => a + b) / recentRecords.length
        : 3.0;
    
    if (avgMood < 2.5) {
      recommendations.add('情绪评分较低，建议增加户外活动，接触自然光线');
      recommendations.add('推荐放松技巧：冥想、深呼吸、渐进式肌肉放松');
    }
    
    // 规则 5: 节律优化
    if (recentRecords.length >= 2 && recentRecords.length <= 4) {
      recommendations.add('当前节律强度适中，建议保持规律作息');
      recommendations.add('最佳状态维持策略：均衡饮食 + 适度运动 + 充足睡眠');
    }
    
    // 默认建议
    if (recommendations.isEmpty) {
      recommendations.add('继续保持良好的生活习惯');
      recommendations.add('建议每周进行 3-4 次中等强度运动');
    }
    
    return recommendations;
  }
  
  /// 计算警告级别
  int _calculateWarningLevel(List<VitalityRecord> records) {
    if (records.isEmpty) return 0;
    
    // 0 = 正常, 1 = 注意, 2 = 警告
    
    final count = records.length;
    final avgFatigue = records
        .map((r) => r.fatigueScore)
        .reduce((a, b) => a + b) / records.length;
    
    if (count > 7 || avgFatigue < 2.0) {
      return 2; // 警告
    } else if (count > 5 || avgFatigue < 2.5) {
      return 1; // 注意
    }
    
    return 0; // 正常
  }
}

/// 健康分析结果
class HealthAnalysisResult {
  final FrequencyAnalysis frequency;
  final EnergyAnalysis energyLevel;
  final MoodAnalysis moodPattern;
  final List<String> recommendations;
  final int warningLevel;
  
  HealthAnalysisResult({
    required this.frequency,
    required this.energyLevel,
    required this.moodPattern,
    required this.recommendations,
    required this.warningLevel,
  });
}

/// 频率分析结果
class FrequencyAnalysis {
  final int count;
  final int period;
  final String status;
  final String description;
  
  FrequencyAnalysis({
    required this.count,
    required this.period,
    required this.status,
    required this.description,
  });
}

/// 精力分析结果
class EnergyAnalysis {
  final double avgFatigue;
  final String trend;
  final String description;
  
  EnergyAnalysis({
    required this.avgFatigue,
    required this.trend,
    required this.description,
  });
}

/// 情绪分析结果
class MoodAnalysis {
  final double avgMood;
  final String stability;
  final String description;
  
  MoodAnalysis({
    required this.avgMood,
    required this.stability,
    required this.description,
  });
}
