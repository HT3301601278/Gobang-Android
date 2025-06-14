import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/avatar_widget.dart';
import '../../widgets/common/loading_indicator.dart';
import '../profile/edit_profile_screen.dart';
import '../profile/stats_screen.dart';
import '../profile/quick_phrases_screen.dart';

/// 个人资料页面
class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUserProfile();
    await userProvider.loadUserStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人资料'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditProfile(),
          ),
        ],
      ),
      body: Consumer2<AuthProvider, UserProvider>(
        builder: (context, authProvider, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(child: LoadingIndicator());
          }

          final user = userProvider.currentUser ?? authProvider.user;
          final stats = userProvider.userStats;

          if (user == null) {
            return const Center(
              child: Text('用户信息加载失败'),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadUserData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildUserHeader(user),
                  const SizedBox(height: 24),
                  _buildStatsCard(stats),
                  const SizedBox(height: 16),
                  _buildMenuItems(),
                  const SizedBox(height: 16),
                  _buildLogoutButton(authProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 构建用户头部信息
  Widget _buildUserHeader(user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            AvatarWidget(
              avatar: user.avatar,
              size: 80.0,
              placeholder: user.nickname,
              showBorder: true,
            ),
            const SizedBox(height: 16),
            Text(
              user.nickname,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '@${user.username}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建统计卡片
  Widget _buildStatsCard(stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '游戏统计',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => _navigateToStats(),
                  child: const Text('查看详情'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (stats != null) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem('总对局', stats.totalGames.toString()),
                  ),
                  Expanded(
                    child: _buildStatItem('胜利', stats.wins.toString()),
                  ),
                  Expanded(
                    child: _buildStatItem('失败', stats.losses.toString()),
                  ),
                  Expanded(
                    child: _buildStatItem('平局', stats.draws.toString()),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  '胜率: ${stats.calculatedWinRate.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ] else ...[
              const Center(
                child: Text(
                  '暂无游戏数据',
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
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// 构建菜单项
  Widget _buildMenuItems() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('编辑资料'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _navigateToEditProfile(),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('战绩统计'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _navigateToStats(),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.chat_bubble_outline),
            title: const Text('快捷短语'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _navigateToQuickPhrases(),
          ),
        ],
      ),
    );
  }

  /// 构建登出按钮
  Widget _buildLogoutButton(AuthProvider authProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: authProvider.isLoading ? null : () => _showLogoutDialog(authProvider),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: authProvider.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text('退出登录'),
      ),
    );
  }

  /// 显示登出确认对话框
  void _showLogoutDialog(AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认退出'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              authProvider.logout();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 导航到编辑资料页面
  void _navigateToEditProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      ),
    );
  }

  /// 导航到统计页面
  void _navigateToStats() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const StatsScreen(),
      ),
    );
  }

  /// 导航到快捷短语页面
  void _navigateToQuickPhrases() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QuickPhrasesScreen(),
      ),
    );
  }
}
