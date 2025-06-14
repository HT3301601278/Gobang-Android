import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/loading_indicator.dart';

/// 战绩统计页面
class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUserStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('战绩统计'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(child: LoadingIndicator());
          }

          final stats = userProvider.userStats;

          if (stats == null) {
            return const Center(
              child: Text('暂无统计数据'),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadStats,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildOverviewCard(stats),
                  const SizedBox(height: 16),
                  _buildDetailedStatsCard(stats),
                  const SizedBox(height: 16),
                  _buildWinRateChart(stats),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 构建概览卡片
  Widget _buildOverviewCard(stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              '游戏概览',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    '总对局',
                    stats.totalGames.toString(),
                    Icons.games,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    '胜率',
                    '${stats.calculatedWinRate.toStringAsFixed(1)}%',
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建详细统计卡片
  Widget _buildDetailedStatsCard(stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '详细统计',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    '胜利',
                    stats.wins.toString(),
                    Icons.emoji_events,
                    Colors.amber,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    '失败',
                    stats.losses.toString(),
                    Icons.close,
                    Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    '平局',
                    stats.draws.toString(),
                    Icons.remove,
                    Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建胜率图表
  Widget _buildWinRateChart(stats) {
    final winRate = stats.calculatedWinRate / 100;
    final lossRate = stats.totalGames > 0 ? stats.losses / stats.totalGames : 0.0;
    final drawRate = stats.totalGames > 0 ? stats.draws / stats.totalGames : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '胜负比例',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (stats.totalGames > 0) ...[
              _buildProgressBar('胜利', winRate, Colors.green, stats.wins),
              const SizedBox(height: 8),
              _buildProgressBar('失败', lossRate, Colors.red, stats.losses),
              const SizedBox(height: 8),
              _buildProgressBar('平局', drawRate, Colors.grey, stats.draws),
            ] else ...[
              const Center(
                child: Text(
                  '暂无对局数据',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建统计项
  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// 构建进度条
  Widget _buildProgressBar(String label, double progress, Color color, int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$count (${(progress * 100).toStringAsFixed(1)}%)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
        ),
      ],
    );
  }
}
