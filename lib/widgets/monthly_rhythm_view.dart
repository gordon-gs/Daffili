import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/vitality_record.dart';
import '../utils/app_theme.dart';

/// 月视图组件
/// 
/// 显示完整月历，毛玻璃效果 + 蓝色填充标记有记录的日期
class MonthlyRhythmView extends StatelessWidget {
  final List<VitalityRecord> allRecords;
  final DateTime currentMonth;
  final Function(DateTime) onDateTap;
  
  const MonthlyRhythmView({
    Key? key,
    required this.allRecords,
    required this.currentMonth,
    required this.onDateTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final startWeekday = firstDayOfMonth.weekday; // 1=Monday, 7=Sunday
    final daysInMonth = lastDayOfMonth.day;
    
    // 构建记录映射
    final recordDates = <DateTime, bool>{};
    for (var record in allRecords) {
      final date = DateTime.fromMillisecondsSinceEpoch(record.timestamp);
      final dateKey = DateTime(date.year, date.month, date.day);
      recordDates[dateKey] = true;
    }
    
    return Column(
      children: [
        // 星期标题
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['一', '二', '三', '四', '五', '六', '日']
                .map((day) => SizedBox(
                      width: 40,
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        
        // 日历网格
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.0,
          ),
          itemCount: startWeekday - 1 + daysInMonth,
          itemBuilder: (context, index) {
            // 前面的空白
            if (index < startWeekday - 1) {
              return const SizedBox.shrink();
            }
            
            final day = index - startWeekday + 2;
            final date = DateTime(currentMonth.year, currentMonth.month, day);
            final hasRecord = recordDates[date] ?? false;
            final isToday = _isToday(date);
            
            return _buildDayCell(
              day: day,
              hasRecord: hasRecord,
              isToday: isToday,
              onTap: () => onDateTap(date),
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildDayCell({
    required int day,
    required bool hasRecord,
    required bool isToday,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: hasRecord
                  ? const Color(0xFF60A5FA).withOpacity(0.2)
                  : Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isToday
                    ? AppTheme.primaryBlue
                    : Colors.white.withOpacity(0.3),
                width: isToday ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  color: isToday
                      ? AppTheme.primaryBlue
                      : AppTheme.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
