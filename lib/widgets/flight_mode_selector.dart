import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// 飞行模式选择器
/// 
/// 区分"单机飞行"和"协同作业"两种模式
class FlightModeSelector extends StatelessWidget {
  final String selectedMode;
  final ValueChanged<String> onModeChanged;
  
  const FlightModeSelector({
    Key? key,
    required this.selectedMode,
    required this.onModeChanged,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildModeButton(
            icon: '👤',
            label: '单机飞行',
            mode: 'solo_flight',
            isSelected: selectedMode == 'solo_flight',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildModeButton(
            icon: '👥',
            label: '协同作业',
            mode: 'coop_mission',
            isSelected: selectedMode == 'coop_mission',
          ),
        ),
      ],
    );
  }
  
  Widget _buildModeButton({
    required String icon,
    required String label,
    required String mode,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onModeChanged(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryBlue.withOpacity(0.15)
              : AppTheme.dividerColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryBlue
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              icon,
              style: TextStyle(
                fontSize: 32,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? AppTheme.primaryBlue
                    : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
