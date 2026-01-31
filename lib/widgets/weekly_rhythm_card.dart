import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../widgets/energy_orb.dart';
import '../widgets/rhythm_view_selector.dart';
import '../widgets/monthly_rhythm_view.dart';
import '../widgets/yearly_heatmap_view.dart';
import '../models/vitality_record.dart';
import '../utils/app_theme.dart';

/// 周度节律卡片
/// 
/// 显示最近7天的活动状态，用能量球可视化
/// 支持周/月/年三种视图切换
class WeeklyRhythmCard extends StatefulWidget {
  final List<VitalityRecord> allRecords;
  final Function(DateTime) onDateTap;
  
  const WeeklyRhythmCard({
    Key? key,
    required this.allRecords,
    required this.onDateTap,
  }) : super(key: key);

  @override
  State<WeeklyRhythmCard> createState() => _WeeklyRhythmCardState();
}

class _WeeklyRhythmCardState extends State<WeeklyRhythmCard> {
  RhythmViewType _selectedView = RhythmViewType.week;
  DateTime _currentMonth = DateTime.now();
  int _currentYear = DateTime.now().year;
  
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // 计算最近7天的日期（从今天往前推6天）
    final weekDates = List.generate(7, (index) {
      return today.subtract(Duration(days: 6 - index));
    });
    
    // 统计每天是否有记录
    final recordsByDate = <DateTime, bool>{};
    for (var date in weekDates) {
      final hasRecord = widget.allRecords.any((record) {
        final recordDate = DateTime.fromMillisecondsSinceEpoch(record.timestamp);
        final recordDay = DateTime(recordDate.year, recordDate.month, recordDate.day);
        return recordDay.isAtSameMomentAs(date);
      });
      recordsByDate[date] = hasRecord;
    }
    
    // 统计本周完成天数
    final completedDays = recordsByDate.values.where((hasRecord) => hasRecord).length;
    
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.waves,
                color: AppTheme.primaryBlue,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                '闭关进度',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Spacer(),
              // 视图切换器
              RhythmViewSelector(
                selectedView: _selectedView,
                onViewChanged: (view) {
                  setState(() {
                    _selectedView = view;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // 动态视图内容
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _buildViewContent(weekDates, recordsByDate, completedDays),
          ),
        ],
      ),
    );
  }
  
  /// 根据选择的视图类型构建内容
  Widget _buildViewContent(
    List<DateTime> weekDates,
    Map<DateTime, bool> recordsByDate,
    int completedDays,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    switch (_selectedView) {
      case RhythmViewType.week:
        return _buildWeekView(weekDates, recordsByDate, completedDays, today);
      case RhythmViewType.month:
        return MonthlyRhythmView(
          allRecords: widget.allRecords,
          currentMonth: _currentMonth,
          onDateTap: widget.onDateTap,
        );
      case RhythmViewType.year:
        return YearlyHeatmapView(
          allRecords: widget.allRecords,
          year: _currentYear,
          onDateTap: widget.onDateTap,
        );
    }
  }
  
  /// 周视图
  Widget _buildWeekView(
    List<DateTime> weekDates,
    Map<DateTime, bool> recordsByDate,
    int completedDays,
    DateTime today,
  ) {
    return Column(
      children: [
        // 完成进度指示器
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$completedDays/7',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // 7日能量球视图
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekDates.map((date) {
            final hasRecord = recordsByDate[date] ?? false;
            final isToday = date.isAtSameMomentAs(today);
            
            return EnergyOrb(
              date: date,
              hasRecord: hasRecord,
              isToday: isToday,
              onTap: () => widget.onDateTap(date),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 16),
        
        // 底部说明
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(
              color: const Color(0xFF3B82F6),
              label: '已交作业',
            ),
            const SizedBox(width: 24),
            _buildLegendItem(
              color: const Color(0xFF10B981),
              label: '闭关中',
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
