import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'paper_plane_particle.dart';

export 'paper_plane_particle.dart' show PaperPlanePainter;

/// 科技感粒子动画按钮
/// 
/// 特点：
/// - 触感反馈（Haptic Feedback）
/// - 粒子喷射动画（科技感而非性暗示）
/// - 类似 Apple Watch 活动圆环的视觉风格
class ParticleAnimationButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final Color primaryColor;
  final double size;
  final bool enablePaperPlanes; // 启用纸飞机特效
  
  const ParticleAnimationButton({
    Key? key,
    required this.onPressed,
    this.label = '记录活动',
    this.icon = Icons.add_circle_outline,
    this.primaryColor = const Color(0xFF3B82F6),
    this.size = 200,
    this.enablePaperPlanes = false,
  }) : super(key: key);

  @override
  State<ParticleAnimationButton> createState() => _ParticleAnimationButtonState();
}

class _ParticleAnimationButtonState extends State<ParticleAnimationButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _breathingController;
  late AnimationController _paperPlaneController; // 纸飞机动画控制器
  final List<Particle> _particles = [];
  final List<PaperPlaneParticle> _paperPlanes = []; // 纸飞机粒子
  bool _isPressed = false;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..addListener(() {
        setState(() {
          _updateParticles();
        });
      });
    
    // 呼吸动画控制器
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    // 纸飞机动画控制器
    _paperPlaneController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..addListener(() {
        setState(() {
          _updatePaperPlanes();
        });
      });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _breathingController.dispose();
    _paperPlaneController.dispose();
    super.dispose();
  }
  
  void _handleTap() {
    // 触发震动反馈
    HapticFeedback.mediumImpact();
    
    // 生成粒子
    _generateParticles();
    
    // 如果启用纸飞机特效，生成纸飞机
    if (widget.enablePaperPlanes) {
      _generatePaperPlanes();
      _paperPlaneController.forward(from: 0.0);
    }
    
    // 启动动画
    _controller.forward(from: 0.0);
    
    // 立即触发回调
    widget.onPressed();
    
    setState(() {
      _isPressed = true;
    });
    
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _isPressed = false;
        });
      }
    });
  }
  
  void _generatePaperPlanes() {
    _paperPlanes.clear();
    final random = math.Random();
    final center = Offset(widget.size / 2, widget.size / 2);
    
    // 生成 20 个纸飞机，主要向右上方喷射
    for (int i = 0; i < 20; i++) {
      double angle = -math.pi / 4 + (random.nextDouble() - 0.5) * math.pi / 2;
      double speed = random.nextDouble() * 15.0 + 5.0;
      
      _paperPlanes.add(PaperPlaneParticle(
        position: center,
        velocity: Offset(math.cos(angle) * speed, math.sin(angle) * speed),
        rotation: angle + math.pi / 2,
        scale: random.nextDouble() * 0.5 + 0.5,
        color: const Color(0xFF60A5FA).withOpacity(random.nextDouble() * 0.5 + 0.5),
      ));
    }
  }
  
  void _updatePaperPlanes() {
    for (var plane in _paperPlanes) {
      // 更新位置
      plane.position += plane.velocity;
      // 添加阻力效果
      plane.velocity *= 0.92;
      // 随时间变淡
      plane.opacity = (1.0 - _paperPlaneController.value).clamp(0.0, 1.0);
    }
  }
  
  void _generateParticles() {
    _particles.clear();
    final random = math.Random();
    
    // 生成 30 个粒子，呈环形爆发
    for (int i = 0; i < 30; i++) {
      final angle = (i / 30) * 2 * math.pi;
      final velocity = 100 + random.nextDouble() * 50; // 速度随机
      final size = 3 + random.nextDouble() * 4; // 大小随机
      
      _particles.add(Particle(
        angle: angle,
        velocity: velocity,
        size: size,
        color: widget.primaryColor.withOpacity(0.8),
      ));
    }
  }
  
  void _updateParticles() {
    for (var particle in _particles) {
      particle.update(_controller.value);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.lightImpact();
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        _handleTap();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: Listenable.merge([_breathingController, _paperPlaneController]),
          builder: (context, child) {
            return Stack(
              children: [
                // 主按钮和环形粒子
                CustomPaint(
                  painter: ParticlePainter(
                    particles: _particles,
                    progress: _controller.value,
                    breathingProgress: _breathingController.value,
                    isPressed: _isPressed,
                    primaryColor: widget.primaryColor,
                    size: widget.size,
                  ),
                  child: child,
                ),
                // 纸飞机粒子层
                if (widget.enablePaperPlanes && _paperPlanes.isNotEmpty)
                  CustomPaint(
                    painter: PaperPlanePainter(
                      _paperPlanes,
                      _paperPlaneController.value,
                    ),
                  ),
              ],
            );
          },
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  size: widget.size * 0.3,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 粒子对象
class Particle {
  final double angle;
  final double velocity;
  final double size;
  final Color color;
  double x = 0;
  double y = 0;
  double opacity = 1.0;
  
  Particle({
    required this.angle,
    required this.velocity,
    required this.size,
    required this.color,
  });
  
  void update(double progress) {
    // 计算位置（使用缓出函数）
    final easeProgress = _easeOut(progress);
    x = math.cos(angle) * velocity * easeProgress;
    y = math.sin(angle) * velocity * easeProgress;
    
    // 计算透明度（先快速上升，后缓慢下降）
    if (progress < 0.3) {
      opacity = progress / 0.3;
    } else {
      opacity = 1.0 - ((progress - 0.3) / 0.7);
    }
    opacity = opacity.clamp(0.0, 1.0);
  }
  
  double _easeOut(double t) {
    return (1 - math.pow(1 - t, 3)).toDouble();
  }
}

/// 粒子绘制器
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final double breathingProgress;
  final bool isPressed;
  final Color primaryColor;
  final double size;
  
  ParticlePainter({
    required this.particles,
    required this.progress,
    required this.breathingProgress,
    required this.isPressed,
    required this.primaryColor,
    required this.size,
  });
  
  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final radius = size / 2;
    
    // 呼吸动画效果（缩放 0.95 - 1.05）
    final breathingScale = 0.95 + (breathingProgress * 0.1);
    final breathingRadius = radius * 0.85 * breathingScale;
    
    // 渐变蓝色圆环
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF60A5FA),
          primaryColor,
        ],
      ).createShader(Rect.fromCircle(
        center: center,
        radius: breathingRadius,
      ))
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, breathingRadius, gradientPaint);
    
    // 呼吸光晕（外发光环）
    final glowPaint = Paint()
      ..color = primaryColor.withOpacity(0.2 + breathingProgress * 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8 + breathingProgress * 4
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        10 + breathingProgress * 15,
      );
    
    canvas.drawCircle(
      center, 
      breathingRadius + 10 + breathingProgress * 8,
      glowPaint,
    );
    
    // 绘制粒子
    for (var particle in particles) {
      final particlePaint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      
      final particlePos = Offset(
        center.dx + particle.x,
        center.dy + particle.y,
      );
      
      canvas.drawCircle(particlePos, particle.size, particlePaint);
    }
  }
  
  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress || 
           oldDelegate.isPressed != isPressed;
  }
}
