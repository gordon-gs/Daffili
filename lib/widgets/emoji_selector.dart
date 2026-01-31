import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// 三阶段表情选择器
/// 
/// 用于替代滑块，提供更直观的情绪/状态选择
class EmojiSelector extends StatelessWidget {
  final String label;
  final int selectedValue;
  final ValueChanged<int> onChanged;
  final List<EmojiOption> options;
  
  const EmojiSelector({
    Key? key,
    required this.label,
    required this.selectedValue,
    required this.onChanged,
    required this.options,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: options.map((option) {
            final isSelected = selectedValue == option.value;
            return _buildEmojiButton(
              emoji: option.emoji,
              label: option.label,
              value: option.value,
              color: option.color,
              isSelected: isSelected,
              onTap: () => onChanged(option.value),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  Widget _buildEmojiButton({
    required String emoji,
    required String label,
    required int value,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: isSelected 
              ? color.withOpacity(0.15) 
              : AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : AppTheme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                emoji,
                style: TextStyle(
                  fontSize: isSelected ? 36 : 32,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? color : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 表情选项配置
class EmojiOption {
  final String emoji;
  final String label;
  final int value;
  final Color color;
  
  const EmojiOption({
    required this.emoji,
    required this.label,
    required this.value,
    required this.color,
  });
}

/// 预定义的情绪选项
class MoodOptions {
  static const List<EmojiOption> options = [
    EmojiOption(
      emoji: '😩',
      label: '差',
      value: 1,
      color: AppTheme.errorRed,
    ),
    EmojiOption(
      emoji: '😐',
      label: '一般',
      value: 3,
      color: AppTheme.auroraBlue,
    ),
    EmojiOption(
      emoji: '🤩',
      label: '极佳',
      value: 5,
      color: AppTheme.successGreen,
    ),
  ];
}

/// 预定义的疲劳度选项
class FatigueOptions {
  static const List<EmojiOption> options = [
    EmojiOption(
      emoji: '😴',
      label: '疲劳',
      value: 1,
      color: AppTheme.errorRed,
    ),
    EmojiOption(
      emoji: '😌',
      label: '正常',
      value: 3,
      color: AppTheme.auroraBlue,
    ),
    EmojiOption(
      emoji: '💪',
      label: '充沛',
      value: 5,
      color: AppTheme.successGreen,
    ),
  ];
}

/// 预定义的强度选项
class IntensityOptions {
  static const List<EmojiOption> options = [
    EmojiOption(
      emoji: '🌙',
      label: '低',
      value: 3,
      color: Color(0xFF64748B), // 灰蓝色
    ),
    EmojiOption(
      emoji: '⚡',
      label: '中',
      value: 5,
      color: AppTheme.auroraBlue,
    ),
    EmojiOption(
      emoji: '🔥',
      label: '高',
      value: 10,
      color: AppTheme.warningOrange,
    ),
  ];
}
