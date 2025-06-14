import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/loading_indicator.dart';

/// 房间列表页面
class RoomsTab extends StatefulWidget {
  const RoomsTab({Key? key}) : super(key: key);

  @override
  State<RoomsTab> createState() => _RoomsTabState();
}

class _RoomsTabState extends State<RoomsTab> {
  final TextEditingController _roomIdController = TextEditingController();

  @override
  void dispose() {
    _roomIdController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // TODO: 在这里加载房间列表数据
    // final roomProvider = Provider.of<RoomProvider>(context, listen: false);
    // roomProvider.loadRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('对局大厅'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: 刷新房间列表
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: 创建房间
          _showCreateRoomDialog();
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _buildRoomSearchWidget(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.meeting_room_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '房间列表页面待开发',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      _showCreateRoomDialog();
                    },
                    child: const Text('创建房间'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 房间搜索组件
  Widget _buildRoomSearchWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _roomIdController,
              decoration: const InputDecoration(
                labelText: '输入房间ID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              // TODO: 加入房间
              if (_roomIdController.text.isNotEmpty) {
                // 加入房间的逻辑
              }
            },
            child: const Text('加入'),
          ),
        ],
      ),
    );
  }

  // 显示创建房间对话框
  void _showCreateRoomDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('创建房间'),
        content: const Text('房间创建功能待实现'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              // TODO: 实现创建房间功能
              Navigator.of(context).pop();
            },
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }
} 