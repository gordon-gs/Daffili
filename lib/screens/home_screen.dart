import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import '../models/vitality_record.dart';
import '../services/database_service.dart';
import '../services/health_analyzer.dart';
import '../services/cloud_sync_service.dart';
import '../widgets/particle_animation_button.dart';
import '../widgets/emoji_selector.dart';
import '../widgets/glass_card.dart';
import '../widgets/weekly_rhythm_card.dart';
import '../widgets/paper_plane_particle.dart';
import '../widgets/flight_mode_selector.dart';
import '../utils/app_theme.dart';
import 'settings_screen.dart';
import 'package:intl/intl.dart';

/// 主页屏幕
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final DatabaseService _db = DatabaseService.instance;
  final HealthAnalyzer _analyzer = HealthAnalyzer();
  final ScrollController _scrollController = ScrollController();
  
  List<VitalityRecord> _recentRecords = [];
  HealthAnalysisResult? _analysisResult;
  bool _isLoading = true;
  DateTime? _highlightedDate;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final records = await _db.getRecentRecords(7);
      final analysis = await _analyzer.analyze();
      
      setState(() {
        _recentRecords = records;
        _analysisResult = analysis;
        _isLoading = false;
      });
    } catch (e) {
      print('加载数据失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  /// 处理能量球点击事件
  void _handleDateTap(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(date.year, date.month, date.day);
    
    // 如果选择的是过去30天内的日期，弹出补录对话框
    final daysDiff = today.difference(selectedDate).inDays;
    if (daysDiff >= 0 && daysDiff <= 30) {
      // 检查是否已有记录
      final hasRecord = _recentRecords.any((record) {
        final recordDate = DateTime.fromMillisecondsSinceEpoch(record.timestamp);
        final recordDay = DateTime(recordDate.year, recordDate.month, recordDate.day);
        return recordDay.isAtSameMomentAs(selectedDate);
      });
      
      if (!hasRecord) {
        // 弹出补录对话框
        _showRetroactiveRecordDialog(selectedDate);
      } else {
        // 已有记录，高亮显示
        _highlightAndScroll(date);
      }
    } else {
      _highlightAndScroll(date);
    }
  }
  
  /// 高亮显示日期并滚动
  void _highlightAndScroll(DateTime date) {
    setState(() {
      _highlightedDate = date;
    });
    
    // 清除高亮（3秒后）
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _highlightedDate = null;
        });
      }
    });
    
    // 平滑滚动到最近记录卡片
    // 延迟一帧以确保布局完成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        // 计算目标位置（大约在健康分析 + 周度节律卡片之后）
        _scrollController.animateTo(
          400.0, // 预估位置
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }
  
  /// 补交作业对话框
  Future<void> _showRetroactiveRecordDialog(DateTime selectedDate) async {
    int moodLevel = 3;
    int fatigueScore = 3;
    int rhythmIntensity = 5;
    String flightMode = 'solo_flight';
    TimeOfDay selectedTime = TimeOfDay.now();
    
    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Row(
              children: [
                const Icon(
                  Icons.history_edu,
                  color: AppTheme.primaryBlue,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('补录记录'),
                    Text(
                      DateFormat('yyyy年MM月dd日').format(selectedDate),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 时间选择
                  _buildSectionTitle('记录时间'),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (time != null) {
                        setDialogState(() {
                          selectedTime = time;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: AppTheme.primaryBlue,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            selectedTime.format(context),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // 飞行模式选择
                  _buildSectionTitle('飞行模式'),
                  const SizedBox(height: 12),
                  FlightModeSelector(
                    selectedMode: flightMode,
                    onModeChanged: (mode) {
                      setDialogState(() {
                        flightMode = mode;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // 其余字段与正常记录相同
                  _buildSectionTitle('心情评分'),
                  Slider(
                    value: moodLevel.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    activeColor: AppTheme.primaryBlue,
                    label: moodLevel.toString(),
                    onChanged: (value) {
                      setDialogState(() {
                        moodLevel = value.toInt();
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  _buildSectionTitle('疲劳分数'),
                  Slider(
                    value: fatigueScore.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    activeColor: AppTheme.primaryBlue,
                    label: fatigueScore.toString(),
                    onChanged: (value) {
                      setDialogState(() {
                        fatigueScore = value.toInt();
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  _buildSectionTitle('节律强度'),
                  Slider(
                    value: rhythmIntensity.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    activeColor: AppTheme.primaryBlue,
                    label: rhythmIntensity.toString(),
                    onChanged: (value) {
                      setDialogState(() {
                        rhythmIntensity = value.toInt();
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  '取消',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('保存'),
              ),
            ],
          ),
        ),
      ),
    );
    
    if (result == true) {
      // 构建指定日期和时间的时间戳
      final recordDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      
      final record = VitalityRecord.create(
        timestamp: recordDateTime.millisecondsSinceEpoch,
        moodLevel: moodLevel,
        fatigueScore: fatigueScore,
        activityType: flightMode,
        rhythmIntensity: rhythmIntensity,
      );
      
      try {
        await _db.createRecord(record);
        
        // 异步触发云同步
        CloudSyncService.instance.syncToCloud().catchError((e) {
          print('☁️ 云同步失败: $e');
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('补录成功！${DateFormat('MM月dd日').format(selectedDate)}'),
              backgroundColor: AppTheme.primaryBlue,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          _loadData();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('补录失败: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
  
  Future<void> _showRecordDialog() async {
    int moodLevel = 3;
    int fatigueScore = 3;
    int rhythmIntensity = 5;
    String flightMode = 'solo_flight'; // 默认单机飞行
    
    await showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 0,
            title: const Text(
              '新增记录',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 飞行模式选择
                const Text(
                  '飞行模式',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                FlightModeSelector(
                  selectedMode: flightMode,
                  onModeChanged: (mode) {
                    setDialogState(() {
                      flightMode = mode;
                    });
                  },
                ),
                const SizedBox(height: 24),
                
                // 情绪水平（表情选择器）
                EmojiSelector(
                  label: flightMode == 'coop_mission' ? '默契程度' : '情绪水平',
                  selectedValue: moodLevel,
                  onChanged: (value) {
                    setDialogState(() {
                      moodLevel = value;
                    });
                  },
                  options: flightMode == 'coop_mission'
                      ? CoopMoodOptions.options
                      : MoodOptions.options,
                ),
                const SizedBox(height: 24),
                
                // 疲劳评分（表情选择器）
                EmojiSelector(
                  label: '精力状态',
                  selectedValue: fatigueScore,
                  onChanged: (value) {
                    setDialogState(() {
                      fatigueScore = value;
                    });
                  },
                  options: FatigueOptions.options,
                ),
                const SizedBox(height: 24),
                
                // 节律强度（表情选择器）
                EmojiSelector(
                  label: '节律强度',
                  selectedValue: rhythmIntensity,
                  onChanged: (value) {
                    setDialogState(() {
                      rhythmIntensity = value;
                    });
                  },
                  options: IntensityOptions.options,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () async {
                final record = VitalityRecord.create(
                  timestamp: DateTime.now().millisecondsSinceEpoch,
                  moodLevel: moodLevel,
                  fatigueScore: fatigueScore,
                  activityType: flightMode,
                  rhythmIntensity: rhythmIntensity,
                );
                
                await _db.createRecord(record);
                
                // 异步触发云同步
                CloudSyncService.instance.syncToCloud().catchError((e) {
                  print('☁️ 云同步失败: $e');
                });
                
                Navigator.of(context).pop();
                _loadData();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('记录已保存'),
                    backgroundColor: AppTheme.successGreen,
                  ),
                );
              },
              child: const Text('保存'),
            ),
          ],
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.auroraBlue,
          ),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Daffili',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.textTertiary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'v3.2.3.3454',
                style: TextStyle(
                  fontSize: 9,
                  color: AppTheme.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            tooltip: '设置',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: '刷新',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          children: [
            // 核心打卡按钮
            Center(
              child: ParticleAnimationButton(
                onPressed: _showRecordDialog,
                label: '起飞',
                icon: Icons.flight_takeoff,
                primaryColor: AppTheme.auroraBlue,
                enablePaperPlanes: true, // 启用纸飞机特效
              ),
            ),
            const SizedBox(height: 32),
            
            // 分析结果卡片
            if (_analysisResult != null) ...[
              _buildAnalysisCard(),
              const SizedBox(height: 16),
              
              // 毒舌健身教练警告卡片
              if (_analysisResult!.personalizedSuggestion != null)
                _buildToxicCoachCard(),
              if (_analysisResult!.personalizedSuggestion != null)
                const SizedBox(height: 16),
            ],
            
            // 周度节律卡片
            WeeklyRhythmCard(
              allRecords: _recentRecords,
              onDateTap: _handleDateTap,
            ),
            const SizedBox(height: 16),
            
            // 最近记录
            _buildRecentRecordsCard(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAnalysisCard() {
    final analysis = _analysisResult!;
    
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Row(
              children: [
                const Icon(
                  Icons.analytics_outlined,
                  color: AppTheme.auroraBlue,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  '健康分析',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _buildWarningBadge(analysis.warningLevel),
              ],
            ),
            const SizedBox(height: 20),
            
            // 频率分析
            _buildMetricRow(
              '节律频率',
              '${analysis.frequency.count} 次 / ${analysis.frequency.period} 天',
              analysis.frequency.description,
              AppTheme.getStatusColor(analysis.frequency.status),
            ),
            const Divider(height: 24),
            
            // 精力分析
            _buildMetricRow(
              '精力水平',
              '${analysis.energyLevel.avgFatigue.toStringAsFixed(1)} / 5.0',
              analysis.energyLevel.description,
              AppTheme.getStatusColor(analysis.energyLevel.trend),
            ),
            const Divider(height: 24),
            
            // 情绪分析
            _buildMetricRow(
              '情绪稳定性',
              analysis.moodPattern.stability,
              analysis.moodPattern.description,
              AppTheme.getStatusColor(analysis.moodPattern.stability),
            ),
            
            // 建议
            if (analysis.recommendations.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                '个性化建议',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...analysis.recommendations.map((rec) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.arrow_right,
                          color: AppTheme.auroraBlue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            rec,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
    );
  }
  
  Widget _buildMetricRow(
    String title,
    String value,
    String description,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
      ),
    );
  }
  
  Widget _buildWarningBadge(int level) {
    if (level == 0) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: level == 2 ? AppTheme.errorRed : AppTheme.warningOrange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        level == 2 ? '警告' : '注意',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
  
  /// 毒舌健身教练警告卡片
  Widget _buildToxicCoachCard() {
    final analysis = _analysisResult!;
    final isHighFrequency = analysis.isHighFrequencyWarning;
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (value * 0.05),
          child: child,
        );
      },
      child: GlassCard(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isHighFrequency
                  ? const Color(0xFFF43F5E) // 红色边框
                  : const Color(0xFFF59E0B), // 橙色边框
              width: isHighFrequency ? 3 : 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 动态图标
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 600),
                    builder: (context, value, child) {
                      return Transform.rotate(
                        angle: value * 0.1 * (isHighFrequency ? 2 : 1),
                        child: Icon(
                          isHighFrequency
                              ? Icons.warning_amber_rounded
                              : Icons.info_outline,
                          color: isHighFrequency
                              ? const Color(0xFFF43F5E)
                              : const Color(0xFFF59E0B),
                          size: 28,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isHighFrequency ? '🚨 紧急警告' : '⚠️ 友情提示',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isHighFrequency
                            ? const Color(0xFFF43F5E)
                            : const Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isHighFrequency
                          ? const Color(0xFFF43F5E).withOpacity(0.15)
                          : const Color(0xFFF59E0B).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '今日 ${analysis.dailyCount}次',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isHighFrequency
                            ? const Color(0xFFF43F5E)
                            : const Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // 毒舌文案
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isHighFrequency
                      ? const Color(0xFFF43F5E).withOpacity(0.08)
                      : const Color(0xFFF59E0B).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  analysis.personalizedSuggestion!,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                    color: isHighFrequency
                        ? const Color(0xFF991B1B)
                        : const Color(0xFF92400E),
                  ),
                ),
              ),
              
              // 震动效果（高频时）
              if (isHighFrequency) ...[
                const SizedBox(height: 12),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    final shake = (value < 0.5
                        ? value * 4
                        : (1 - value) * 4) * 3;
                    return Transform.translate(
                      offset: Offset(shake, 0),
                      child: child,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 16,
                        color: const Color(0xFFF43F5E).withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '你的肌肉在哭泣...',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFF43F5E).withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildRecentRecordsCard() {
    return GlassCard(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.history,
                  color: AppTheme.auroraBlue,
                  size: 28,
                ),
                SizedBox(width: 12),
                Text(
                  '最近记录',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (_recentRecords.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    '暂无记录\n点击上方按钮开始记录',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              )
            else
              ..._recentRecords.take(5).map((record) {
                final date = DateTime.fromMillisecondsSinceEpoch(record.timestamp);
                final recordDay = DateTime(date.year, date.month, date.day);
                final dateStr = DateFormat('MM/dd HH:mm').format(date);
                
                // 检查是否需要高亮
                final isHighlighted = _highlightedDate != null && 
                    recordDay.isAtSameMomentAs(_highlightedDate!);
                
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: isHighlighted 
                        ? AppTheme.primaryBlue.withOpacity(0.08)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: isHighlighted
                        ? Border.all(
                            color: AppTheme.primaryBlue.withOpacity(0.3),
                            width: 2,
                          )
                        : null,
                  ),
                  child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.getMoodColor(record.moodLevel).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      record.activityType == 'coop_mission'
                          ? Icons.people
                          : Icons.person,
                      color: AppTheme.getMoodColor(record.moodLevel),
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        '已交作业',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      if (record.activityType == 'coop_mission') ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEC4899).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFFEC4899),
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            'CO-OP',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFEC4899),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Text(
                    dateStr,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '情绪 ${record.moodLevel}/5',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.getMoodColor(record.moodLevel),
                        ),
                      ),
                      Text(
                        '精力 ${record.fatigueScore}/5',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.getFatigueColor(record.fatigueScore),
                        ),
                      ),
                    ],
                  ),
                  ),
                );  
              }),
          ],
        ),
    );
  }
}
