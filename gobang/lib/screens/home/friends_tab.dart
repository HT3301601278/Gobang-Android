import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/common/loading_indicator.dart';

/// 好友列表页面
class FriendsTab extends StatefulWidget {
  const FriendsTab({Key? key}) : super(key: key);

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  @override
  void initState() {
    super.initState();
    // TODO: 在这里加载好友列表数据
    // final friendProvider = Provider.of<FriendProvider>(context, listen: false);
    // friendProvider.loadFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的好友'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              // TODO: 导航到添加好友页面
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              '好友列表页面待开发',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: 导航到添加好友页面
              },
              child: const Text('添加好友'),
            ),
          ],
        ),
      ),
    );
  }
} 