import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import '../models/vitality_record.dart';
import '../services/database_service.dart';
import '../services/health_analyzer.dart';
import '../widgets/particle_animation_button.dart';
import '../widgets/emoji_selector.dart';
import '../widgets/glass_card.dart';
import '../widgets/weekly_rhythm_card.dart';
import '../widgets/paper_plane_particle.dart';
import '../utils/app_theme.dart';
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
  
  Future<void> _showRecordDialog() async {
    int moodLevel = 3;
    int fatigueScore = 3;
    int rhythmIntensity = 5;
    String activityType = 'peak_activity';
    
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
              '新建作业记录',
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
                // 活动类型选择
                const Text('活动类型', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'peak_activity',
                      label: Text('峰值活动'),
                    ),
                    ButtonSegment(
                      value: 'rest_cycle',
                      label: Text('休息周期'),
                    ),
                  ],
                  selected: {activityType},
                  onSelectionChanged: (Set<String> selected) {
                    setDialogState(() {
                      activityType = selected.first;
                    });
                  },
                ),
                const SizedBox(height: 24),
                
                // 情绪水平（表情选择器）
                EmojiSelector(
                  label: '情绪水平',
                  selectedValue: moodLevel,
                  onChanged: (value) {
                    setDialogState(() {
                      moodLevel = value;
                    });
                  },
                  options: MoodOptions.options,
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
                  activityType: activityType,
                  rhythmIntensity: rhythmIntensity,
                );
                
                await _db.createRecord(record);
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
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
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
                      record.activityType == 'peak_activity'
                          ? Icons.trending_up
                          : Icons.bedtime,
                      color: AppTheme.getMoodColor(record.moodLevel),
                    ),
                  ),
                  title: Text(
                    record.activityType == 'peak_activity' ? '已交作业' : '闭关中',
                    style: const TextStyle(fontWeight: FontWeight.w600),
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
