import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 动态流体渐变背景
/// 
/// 特性：
/// - 米灰色基底 (#F8FAFC)
/// - 两个缓慢移动的柔光球
/// - 天蓝色球 (#E0F2FE, 30% 透明度)
/// - 薄荷绿球 (#D1FAE5, 20% 透明度)
class FluidGradientBackground extends StatefulWidget {
  final Widget child;
  
  const FluidGradientBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<FluidGradientBackground> createState() => _FluidGradientBackgroundState();
}

class _FluidGradientBackgroundState extends State<FluidGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    // 优化：延长动画周期以降低CPU占用
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // 从20秒增加到30秒
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 基底颜色
        Container(
          color: const Color(0xFFF8FAFC),
        ),
        
        // 动态渐变层
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: FluidBlobPainter(
                progress: _controller.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        
        // 内容层
        widget.child,
      ],
    );
  }
}

/// 柔光球绘制器
class FluidBlobPainter extends CustomPainter {
  final double progress;
  
  FluidBlobPainter({required this.progress});
  
  @override
  void paint(Canvas canvas, Size size) {
    // 天蓝色柔光球
    final skyBlobPaint = Paint()
      ..color = const Color(0xFFE0F2FE).withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);
    
    // 计算天蓝色球的位置（椭圆运动）
    final skyX = size.width * 0.3 + 
        math.cos(progress * 2 * math.pi) * size.width * 0.15;
    final skyY = size.height * 0.25 + 
        math.sin(progress * 2 * math.pi) * size.height * 0.1;
    
    canvas.drawCircle(
      Offset(skyX, skyY),
      size.width * 0.4,
      skyBlobPaint,
    );
    
    // 薄荷绿柔光球
    final mintBlobPaint = Paint()
      ..color = const Color(0xFFD1FAE5).withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 120);
    
    // 计算薄荷绿球的位置（反向椭圆运动）
    final mintX = size.width * 0.7 - 
        math.cos(progress * 2 * math.pi) * size.width * 0.2;
    final mintY = size.height * 0.65 - 
        math.sin(progress * 2 * math.pi) * size.height * 0.15;
    
    canvas.drawCircle(
      Offset(mintX, mintY),
      size.width * 0.45,
      mintBlobPaint,
    );
  }
  
  @override
  bool shouldRepaint(FluidBlobPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
