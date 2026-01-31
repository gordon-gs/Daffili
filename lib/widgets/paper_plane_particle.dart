import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 单个纸飞机粒子的模型
class PaperPlaneParticle {
  Offset position; // 当前位置
  Offset velocity; // 速度矢量
  double rotation; // 旋转角度
  double opacity;  // 透明度
  double scale;    // 大小缩放
  final Color color; // 颜色

  PaperPlaneParticle({
    required this.position,
    required this.velocity,
    this.rotation = 0,
    this.opacity = 1.0,
    this.scale = 1.0,
    required this.color,
  });
}

/// 主控件：包裹主按钮实现"起飞"特效
class TakeoffParticleButton extends StatefulWidget {
  final Widget child; // 原始按钮组件
  final VoidCallback onTap; // 点击回调

  const TakeoffParticleButton({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  State<TakeoffParticleButton> createState() => _TakeoffParticleButtonState();
}

class _TakeoffParticleButtonState extends State<TakeoffParticleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<PaperPlaneParticle> _particles = [];
  final Random _random = Random();

  // 配置项
  final int particleCount = 20; // 粒子数量
  final Color particleColor = const Color(0xFF60A5FA); // 品牌蓝
  final double explosionForce = 15.0; // 爆发力度

  @override
  void initState() {
    super.initState();
    // 动画持续 800ms
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _controller.addListener(() {
      setState(() {
        _updateParticles();
      });
    });
  }

  /// 点击触发动画
  void _handleTap() {
    // 触感反馈
    HapticFeedback.mediumImpact();
    
    widget.onTap(); // 执行原本的业务逻辑
    _spawnParticles(); // 生成粒子
    _controller.forward(from: 0); // 播放动画
  }
  
  /// 外部调用：直接触发粒子效果（不触发 onTap）
  void triggerParticles() {
    // 触感反馈
    HapticFeedback.mediumImpact();
    
    _spawnParticles(); // 生成粒子
    _controller.forward(from: 0); // 播放动画
  }

  /// 生成初始粒子群
  void _spawnParticles() {
    _particles.clear();
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    
    final center = renderBox.size.center(Offset.zero);

    for (int i = 0; i < particleCount; i++) {
      // 让粒子主要向右上方喷射（-45° 为中心，左右各±45°）
      double angle = -pi / 4 + (_random.nextDouble() - 0.5) * pi / 2;
      double speed = _random.nextDouble() * explosionForce + 5.0;

      _particles.add(PaperPlaneParticle(
        position: center,
        // 计算速度矢量
        velocity: Offset(cos(angle) * speed, sin(angle) * speed),
        rotation: angle + pi / 2, // 初始角度对齐速度方向
        scale: _random.nextDouble() * 0.5 + 0.5, // 随机大小
        color: particleColor.withOpacity(_random.nextDouble() * 0.5 + 0.5),
      ));
    }
  }

  /// 每一帧更新粒子状态（物理模拟）
  void _updateParticles() {
    for (var particle in _particles) {
      // 更新位置
      particle.position += particle.velocity;
      // 添加阻力/减速效果
      particle.velocity *= 0.92;
      // 随时间变淡
      particle.opacity = (1.0 - _controller.value).clamp(0.0, 1.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Stack(
        clipBehavior: Clip.none, // 允许粒子飞出按钮区域
        children: [
          widget.child, // 原始按钮
          Positioned.fill(
            child: IgnorePointer( // 确保粒子层不拦截点击事件
              child: CustomPaint(
                painter: PaperPlanePainter(_particles, _controller.value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 画布绘制器：负责绘制粒子
class PaperPlanePainter extends CustomPainter {
  final List<PaperPlaneParticle> particles;
  final double animationValue;

  PaperPlanePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    if (particles.isEmpty || animationValue == 1.0) return;

    final paint = Paint()..style = PaintingStyle.fill;

    // 定义极简的纸飞机形状 Path
    Path createPlanePath() {
      Path path = Path();
      path.moveTo(0, -10); // 机头
      path.lineTo(8, 10);  // 右翼尾
      path.lineTo(0, 6);   // 中间凹陷
      path.lineTo(-8, 10); // 左翼尾
      path.close();
      return path;
    }

    final planePath = createPlanePath();

    for (var particle in particles) {
      paint.color = particle.color.withOpacity(particle.opacity);

      canvas.save();
      // 移动画布到粒子位置
      canvas.translate(particle.position.dx, particle.position.dy);
      // 旋转画布
      canvas.rotate(particle.rotation);
      // 缩放画布
      canvas.scale(particle.scale);

      // 绘制纸飞机
      canvas.drawPath(planePath, paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant PaperPlanePainter oldDelegate) {
    return true; // 每一帧都要重绘
  }
}
