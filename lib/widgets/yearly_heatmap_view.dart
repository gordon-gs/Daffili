import 'package:flutter/material.dart';
import '../models/vitality_record.dart';
import '../utils/app_theme.dart';

/// 年度热力图组件
/// 
/// 参考 GitHub Contribution Graph，使用流体蓝系列
class YearlyHeatmapView extends StatelessWidget {
  final List<VitalityRecord> allRecords;
  final int year;
  final Function(DateTime) onDateTap;
  
  const YearlyHeatmapView({
    Key? key,
    required this.allRecords,
    required this.year,
    required this.onDateTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // 计算每天的强度
    final intensityMap = _calculateIntensityMap();
    
    // 获取一年的所有周
    final weeks = _getWeeksOfYear(year);
    
    return Column(
      children: [
        // 月份标签
        _buildMonthLabels(),
        const SizedBox(height: 12),
        
        // 热力图网格
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 星期标签
              _buildWeekdayLabels(),
              const SizedBox(width: 8),
              
              // 热力图格子
              ...weeks.map((week) => _buildWeekColumn(week, intensityMap)),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 图例
        _buildLegend(),
      ],
    );
  }
  
  /// 构建月份标签
  Widget _buildMonthLabels() {
    return Row(
      children: [
        const SizedBox(width: 32), // 对齐星期标签
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['1月', '2月', '3月', '4月', '5月', '6月', 
                       '7月', '8月', '9月', '10月', '11月', '12月']
                .map((month) => Text(
                      month,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textTertiary,
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
  
  /// 构建星期标签
  Widget _buildWeekdayLabels() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: ['一', '三', '五', '日'].asMap().entries.map((entry) {
        final index = entry.key;
        final label = entry.value;
        return Container(
          height: 14,
          margin: EdgeInsets.only(bottom: index < 3 ? 4 : 0),
          alignment: Alignment.centerRight,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.textTertiary,
            ),
          ),
        );
      }).toList(),
    );
  }
  
  /// 构建一周的列
  Widget _buildWeekColumn(
    List<DateTime> week,
    Map<DateTime, int> intensityMap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Column(
        children: week.map((date) {
          final intensity = intensityMap[date] ?? 0;
          return _buildDayCell(date, intensity);
        }).toList(),
      ),
    );
  }
  
  /// 构建单个日期格子
  Widget _buildDayCell(DateTime date, int intensity) {
    final color = _getIntensityColor(intensity);
    
    return GestureDetector(
      onTap: () => onDateTap(date),
      child: Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
  
  /// 根据强度获取颜色
  Color _getIntensityColor(int intensity) {
    switch (intensity) {
      case 0:
        return const Color(0xFFE5E7EB); // 灰色（无记录）
      case 1:
        return const Color(0xFFBAE6FD); // 浅蓝（低强度）
      case 2:
        return const Color(0xFF7DD3FC); // 中蓝（中强度）
      case 3:
        return const Color(0xFF38BDF8); // 深蓝（高强度）
      default:
        return const Color(0xFF0EA5E9); // 最深蓝（极高强度）
    }
  }
  
  /// 构建图例
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '强度：',
          style: TextStyle(
            fontSize: 11,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        ...List.generate(5, (index) {
          return Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getIntensityColor(index),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
        const SizedBox(width: 8),
        const Text(
          '高',
          style: TextStyle(
            fontSize: 11,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
  
  /// 计算每天的强度映射
  Map<DateTime, int> _calculateIntensityMap() {
    final map = <DateTime, int>{};
    
    for (var record in allRecords) {
      final date = DateTime.fromMillisecondsSinceEpoch(record.timestamp);
      final dateKey = DateTime(date.year, date.month, date.day);
      
      // 根据节律强度计算（简化版本）
      final intensity = record.rhythmIntensity != null
          ? ((record.rhythmIntensity! / 2).ceil().clamp(1, 4))
          : 1;
      
      // 累加同一天的记录
      map[dateKey] = (map[dateKey] ?? 0) + intensity;
    }
    
    // 限制最大强度为4
    map.forEach((key, value) {
      map[key] = value.clamp(0, 4);
    });
    
    return map;
  }
  
  /// 获取一年的所有周
  List<List<DateTime>> _getWeeksOfYear(int year) {
    final firstDayOfYear = DateTime(year, 1, 1);
    final lastDayOfYear = DateTime(year, 12, 31);
    
    final weeks = <List<DateTime>>[];
    var currentWeek = <DateTime>[];
    
    var currentDate = firstDayOfYear;
    
    // 填充第一周前面的空白
    final firstWeekday = firstDayOfYear.weekday;
    for (var i = 1; i < firstWeekday; i++) {
      currentWeek.add(DateTime(1900, 1, 1)); // 占位日期
    }
    
    while (currentDate.isBefore(lastDayOfYear) || 
           currentDate.isAtSameMomentAs(lastDayOfYear)) {
      currentWeek.add(currentDate);
      
      if (currentDate.weekday == 7) {
        weeks.add(currentWeek);
        currentWeek = <DateTime>[];
      }
      
      currentDate = currentDate.add(const Duration(days: 1));
    }
    
    // 添加最后一周
    if (currentWeek.isNotEmpty) {
      // 填充最后一周后面的空白
      while (currentWeek.length < 7) {
        currentWeek.add(DateTime(1900, 1, 1)); // 占位日期
      }
      weeks.add(currentWeek);
    }
    
    return weeks;
  }
}
