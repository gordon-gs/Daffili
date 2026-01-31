import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// 闭关进度视图选择器
/// 
/// 支持三种视图：周/月/年
enum RhythmViewType { week, month, year }

class RhythmViewSelector extends StatelessWidget {
  final RhythmViewType selectedView;
  final ValueChanged<RhythmViewType> onViewChanged;
  
  const RhythmViewSelector({
    Key? key,
    required this.selectedView,
    required this.onViewChanged,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.dividerColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSegment(
            label: '周',
            viewType: RhythmViewType.week,
          ),
          const SizedBox(width: 4),
          _buildSegment(
            label: '月',
            viewType: RhythmViewType.month,
          ),
          const SizedBox(width: 4),
          _buildSegment(
            label: '年',
            viewType: RhythmViewType.year,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSegment({
    required String label,
    required RhythmViewType viewType,
  }) {
    final isSelected = selectedView == viewType;
    
    return GestureDetector(
      onTap: () => onViewChanged(viewType),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primaryBlue
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected 
                ? Colors.white
                : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}
