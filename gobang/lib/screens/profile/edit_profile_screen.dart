import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/avatar_widget.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../utils/validators.dart';
import 'avatar_selection_screen.dart';

/// 编辑资料页面
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    final user = userProvider.currentUser ?? authProvider.user;
    if (user != null) {
      _nicknameController.text = user.nickname;
    }
    
    _nicknameController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    final user = userProvider.currentUser ?? authProvider.user;
    if (user != null) {
      final hasChanges = _nicknameController.text.trim() != user.nickname;
      if (hasChanges != _hasChanges) {
        setState(() {
          _hasChanges = hasChanges;
        });
      }
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑资料'),
        actions: [
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return TextButton(
                onPressed: (_hasChanges && !userProvider.isUpdatingProfile) 
                    ? _saveProfile 
                    : null,
                child: userProvider.isUpdatingProfile
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
      body: Consumer2<AuthProvider, UserProvider>(
        builder: (context, authProvider, userProvider, child) {
          final user = userProvider.currentUser ?? authProvider.user;
          
          if (user == null) {
            return const Center(
              child: Text('用户信息加载失败'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildAvatarSection(user),
                  const SizedBox(height: 32),
                  _buildBasicInfoSection(user),
                  const SizedBox(height: 24),
                  if (userProvider.errorMessage != null)
                    _buildErrorMessage(userProvider.errorMessage!),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 构建头像部分
  Widget _buildAvatarSection(user) {
    return Column(
      children: [
        const Text(
          '头像',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _selectAvatar,
          child: Stack(
            children: [
              AvatarWidget(
                avatar: user.avatar,
                size: 100.0,
                placeholder: user.nickname,
                showBorder: true,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: _selectAvatar,
          child: const Text('更换头像'),
        ),
      ],
    );
  }

  /// 构建基本信息部分
  Widget _buildBasicInfoSection(user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '基本信息',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nicknameController,
          decoration: const InputDecoration(
            labelText: '昵称',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          validator: Validators.validateNickname,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: user.username,
          decoration: const InputDecoration(
            labelText: '用户名',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.account_circle),
          ),
          enabled: false,
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: user.email,
          decoration: const InputDecoration(
            labelText: '邮箱',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          enabled: false,
        ),
      ],
    );
  }

  /// 构建错误信息
  Widget _buildErrorMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
        ],
      ),
    );
  }

  /// 选择头像
  void _selectAvatar() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AvatarSelectionScreen(),
      ),
    ).then((result) {
      if (result == true) {
        // 头像已更新，刷新页面
        setState(() {});
      }
    });
  }

  /// 保存资料
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await userProvider.updateProfile(
      nickname: _nicknameController.text.trim(),
    );

    if (success) {
      // 更新AuthProvider中的用户信息
      if (userProvider.currentUser != null) {
        authProvider.updateUser(userProvider.currentUser!);
      }
      
      setState(() {
        _hasChanges = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('资料更新成功'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}
