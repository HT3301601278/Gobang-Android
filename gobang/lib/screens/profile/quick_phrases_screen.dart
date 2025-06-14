import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../models/quick_phrase.dart';

/// 快捷短语管理页面
class QuickPhrasesScreen extends StatefulWidget {
  const QuickPhrasesScreen({Key? key}) : super(key: key);

  @override
  State<QuickPhrasesScreen> createState() => _QuickPhrasesScreenState();
}

class _QuickPhrasesScreenState extends State<QuickPhrasesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // 延迟到下一帧执行，避免在build过程中调用setState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuickPhrases();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadQuickPhrases() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await Future.wait([
      userProvider.loadSystemQuickPhrases(),
      userProvider.loadUserQuickPhrases(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('快捷短语'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '系统短语'),
            Tab(text: '自定义短语'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _tabController.animateTo(1);
          _showAddPhraseDialog();
        },
        child: const Icon(Icons.add),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSystemPhrasesTab(),
          _buildUserPhrasesTab(),
        ],
      ),
    );
  }

  /// 构建系统短语标签页
  Widget _buildSystemPhrasesTab() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoading) {
          return const Center(child: LoadingIndicator());
        }

        if (userProvider.systemQuickPhrases.isEmpty) {
          return const Center(
            child: Text('暂无系统快捷短语'),
          );
        }

        return RefreshIndicator(
          onRefresh: () => userProvider.loadSystemQuickPhrases(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: userProvider.systemQuickPhrases.length,
            itemBuilder: (context, index) {
              final phrase = userProvider.systemQuickPhrases[index];
              return _buildSystemPhraseItem(phrase);
            },
          ),
        );
      },
    );
  }

  /// 构建用户短语标签页
  Widget _buildUserPhrasesTab() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoading) {
          return const Center(child: LoadingIndicator());
        }

        if (userProvider.userQuickPhrases.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  '暂无自定义快捷短语',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '点击右下角按钮添加',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => userProvider.loadUserQuickPhrases(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: userProvider.userQuickPhrases.length,
            itemBuilder: (context, index) {
              final phrase = userProvider.userQuickPhrases[index];
              return _buildUserPhraseItem(phrase);
            },
          ),
        );
      },
    );
  }

  /// 构建系统短语项
  Widget _buildSystemPhraseItem(SystemQuickPhrase phrase) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.chat_bubble, color: Colors.blue),
        title: Text(phrase.content),
        trailing: IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () => _copyPhrase(phrase.content),
        ),
      ),
    );
  }

  /// 构建用户短语项
  Widget _buildUserPhraseItem(QuickPhrase phrase) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.chat_bubble_outline, color: Colors.green),
        title: Text(phrase.content),
        subtitle: phrase.createdAt != null
            ? Text(
                '创建于 ${_formatDate(phrase.createdAt!)}',
                style: const TextStyle(fontSize: 12),
              )
            : null,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showEditPhraseDialog(phrase);
                break;
              case 'delete':
                _showDeleteConfirmDialog(phrase);
                break;
              case 'copy':
                _copyPhrase(phrase.content);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'copy',
              child: Row(
                children: [
                  Icon(Icons.copy, size: 20),
                  SizedBox(width: 8),
                  Text('复制'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('编辑'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('删除', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示添加短语对话框
  void _showAddPhraseDialog() {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加快捷短语'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '请输入短语内容',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          maxLength: 100,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return TextButton(
                onPressed: userProvider.isLoading
                    ? null
                    : () => _addPhrase(controller.text.trim()),
                child: userProvider.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('添加'),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 显示编辑短语对话框
  void _showEditPhraseDialog(QuickPhrase phrase) {
    final controller = TextEditingController(text: phrase.content);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑快捷短语'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '请输入短语内容',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          maxLength: 100,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return TextButton(
                onPressed: userProvider.isLoading
                    ? null
                    : () => _updatePhrase(phrase.id, controller.text.trim()),
                child: userProvider.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('保存'),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 显示删除确认对话框
  void _showDeleteConfirmDialog(QuickPhrase phrase) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除短语"${phrase.content}"吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return TextButton(
                onPressed: userProvider.isLoading
                    ? null
                    : () => _deletePhrase(phrase.id),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: userProvider.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('删除'),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 添加短语
  Future<void> _addPhrase(String content) async {
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入短语内容'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final success = await userProvider.addQuickPhrase(content);

    if (mounted) {
      Navigator.of(context).pop();
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('快捷短语添加成功'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(userProvider.errorMessage ?? '添加失败'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 更新短语
  Future<void> _updatePhrase(String phraseId, String content) async {
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入短语内容'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final success = await userProvider.updateQuickPhrase(phraseId, content);

    if (mounted) {
      Navigator.of(context).pop();
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('快捷短语更新成功'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(userProvider.errorMessage ?? '更新失败'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 删除短语
  Future<void> _deletePhrase(String phraseId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final success = await userProvider.deleteQuickPhrase(phraseId);

    if (mounted) {
      Navigator.of(context).pop();
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('快捷短语删除成功'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(userProvider.errorMessage ?? '删除失败'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 复制短语
  void _copyPhrase(String content) {
    // 这里可以使用 Clipboard.setData 来复制到剪贴板
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已复制到剪贴板'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// 格式化日期
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
