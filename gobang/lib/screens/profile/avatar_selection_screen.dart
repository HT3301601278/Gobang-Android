import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/user_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/avatar.dart';
import '../../widgets/common/avatar_widget.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../config/api_endpoints.dart';

/// 头像选择页面
class AvatarSelectionScreen extends StatefulWidget {
  const AvatarSelectionScreen({Key? key}) : super(key: key);

  @override
  State<AvatarSelectionScreen> createState() => _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends State<AvatarSelectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ImagePicker _imagePicker = ImagePicker();
  
  String? _selectedSystemAvatarId;
  File? _selectedCustomAvatar;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // 延迟到下一帧执行，避免在build过程中调用setState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSystemAvatars();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSystemAvatars() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadSystemAvatars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择头像'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '系统头像'),
            Tab(text: '自定义头像'),
          ],
        ),
        actions: [
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              final hasSelection = _selectedSystemAvatarId != null || 
                                 _selectedCustomAvatar != null;
              
              return TextButton(
                onPressed: (hasSelection && !userProvider.isUpdatingProfile) 
                    ? _saveAvatar 
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSystemAvatarsTab(),
          _buildCustomAvatarTab(),
        ],
      ),
    );
  }

  /// 构建系统头像标签页
  Widget _buildSystemAvatarsTab() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoading) {
          return const Center(child: LoadingIndicator());
        }

        if (userProvider.systemAvatars.isEmpty) {
          return const Center(
            child: Text('暂无系统头像'),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: userProvider.systemAvatars.length,
          itemBuilder: (context, index) {
            final systemAvatar = userProvider.systemAvatars[index];
            final isSelected = _selectedSystemAvatarId == systemAvatar.id;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSystemAvatarId = systemAvatar.id;
                  _selectedCustomAvatar = null;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected 
                        ? Theme.of(context).primaryColor 
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    ApiEndpoints.buildImageUrl(systemAvatar.url),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.error),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// 构建自定义头像标签页
  Widget _buildCustomAvatarTab() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (_selectedCustomAvatar != null) ...[
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.file(
                      _selectedCustomAvatar!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text('拍照'),
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('从相册选择'),
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                  ],
                ),
              ),
              
              if (userProvider.isUploadingAvatar) ...[
                const SizedBox(height: 24),
                const LoadingIndicator(),
                const SizedBox(height: 8),
                const Text('正在上传头像...'),
              ],
              
              if (userProvider.errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
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
                          userProvider.errorMessage!,
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// 选择图片
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _selectedCustomAvatar = File(image.path);
          _selectedSystemAvatarId = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('选择图片失败: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 保存头像
  Future<void> _saveAvatar() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    bool success = false;
    Avatar? avatarData;

    if (_selectedSystemAvatarId != null) {
      // 使用系统头像
      final systemAvatar = userProvider.systemAvatars
          .firstWhere((avatar) => avatar.id == _selectedSystemAvatarId);
      
      avatarData = Avatar(
        url: systemAvatar.url,
      );
      
      success = await userProvider.updateProfile(avatar: avatarData);
    } else if (_selectedCustomAvatar != null) {
      // 上传自定义头像
      final avatarUrl = await userProvider.uploadAvatar(_selectedCustomAvatar!);
      
      if (avatarUrl != null) {
        avatarData = Avatar(
          url: avatarUrl,
        );
        
        success = await userProvider.updateProfile(avatar: avatarData);
      }
    }

    if (success) {
      // 更新AuthProvider中的用户信息
      if (userProvider.currentUser != null) {
        authProvider.updateUser(userProvider.currentUser!);
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('头像更新成功'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    }
  }
}
