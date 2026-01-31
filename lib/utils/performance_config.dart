/// Daffili 性能配置
/// 
/// 确保应用性能指标符合 MVP 要求
class PerformanceConfig {
  // 数据库性能要求
  static const int maxDatabaseLatencyMs = 50;
  
  // 动画性能配置
  static const Duration fluidBackgroundDuration = Duration(seconds: 30);
  static const Duration breathingAnimationDuration = Duration(milliseconds: 2000);
  
  // UI 性能优化
  static const bool enableRepaintBoundary = true;
  static const bool enableCacheExtent = true;
  
  // 调试模式下的性能监控
  static bool enablePerformanceLogging = true;
  
  /// 记录性能指标
  static void logPerformance(String operation, int latencyMs) {
    if (!enablePerformanceLogging) return;
    
    if (latencyMs > maxDatabaseLatencyMs) {
      print('⚠️ [$operation] 延迟超标: ${latencyMs}ms (目标: <${maxDatabaseLatencyMs}ms)');
    } else {
      print('✅ [$operation] 延迟: ${latencyMs}ms');
    }
  }
}
