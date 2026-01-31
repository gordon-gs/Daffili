import 'package:flutter/material.dart';

/// 能量球组件
/// 
/// 特性：
/// - 有记录：渐变蓝 + 扩散阴影
/// - 无记录：浅灰底 + 绿色呼吸点
class EnergyOrb extends StatefulWidget {
  final DateTime date;
  final bool hasRecord;
  final bool isToday;
  final VoidCallback onTap;
  
  const EnergyOrb({
    Key? key,
    required this.date,
    required this.hasRecord,
    required this.isToday,
    required this.onTap,
  }) : super(key: key);

  @override
  State<EnergyOrb> createState() => _EnergyOrbState();
}

class _EnergyOrbState extends State<EnergyOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  
  @override
  void initState() {
    super.initState();
    // 呼吸动画（仅无记录时使用）
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 星期标签
          Text(
            _getWeekdayLabel(widget.date.weekday),
            style: TextStyle(
              fontSize: 12,
              color: widget.isToday 
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFF999999),
              fontWeight: widget.isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8),
          
          // 能量球
          widget.hasRecord 
              ? _buildActiveOrb()
              : _buildInactiveOrb(),
          
          const SizedBox(height: 6),
          
          // 日期
          Text(
            '${widget.date.day}',
            style: TextStyle(
              fontSize: 11,
              color: widget.isToday 
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFF666666),
              fontWeight: widget.isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
  
  /// 有记录的能量球（渐变蓝 + 阴影）
  Widget _buildActiveOrb() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [
            Color(0xFF60A5FA),
            Color(0xFF3B82F6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: widget.isToday
          ? const Center(
              child: Icon(
                Icons.circle,
                size: 8,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
  
  /// 无记录的能量球（浅灰 + 呼吸绿点）
  Widget _buildInactiveOrb() {
    return AnimatedBuilder(
      animation: _breathingController,
      builder: (context, child) {
        final breathingScale = 0.6 + (_breathingController.value * 0.4);
        final breathingOpacity = 0.3 + (_breathingController.value * 0.4);
        
        return Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF1F5F9),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Transform.scale(
              scale: breathingScale,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF10B981).withOpacity(breathingOpacity),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(breathingOpacity * 0.5),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  String _getWeekdayLabel(int weekday) {
    const weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    return weekdays[weekday - 1];
  }
}
