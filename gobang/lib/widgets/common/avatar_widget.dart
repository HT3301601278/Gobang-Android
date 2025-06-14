import 'package:flutter/material.dart';
import '../../models/avatar.dart';
import '../../config/api_endpoints.dart';

/// 头像组件
class AvatarWidget extends StatelessWidget {
  final Avatar? avatar;
  final double size;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;
  final String? placeholder;

  const AvatarWidget({
    Key? key,
    this.avatar,
    this.size = 50.0,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 2.0,
    this.onTap,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: showBorder
              ? Border.all(
                  color: borderColor ?? Theme.of(context).primaryColor,
                  width: borderWidth,
                )
              : null,
        ),
        child: ClipOval(
          child: _buildAvatarContent(context),
        ),
      ),
    );
  }

  Widget _buildAvatarContent(BuildContext context) {
    // 如果有头像URL，显示网络图片
    if (avatar?.url != null && avatar!.url.isNotEmpty) {
      // 处理URL路径
      String imageUrl = avatar!.url;
      if (imageUrl.startsWith('/') && !imageUrl.startsWith('http')) {
        final serverRoot = ApiEndpoints.baseUrl.replaceAll('/api', '');
        imageUrl = '$serverRoot$imageUrl';
      }
      
      return Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultAvatar(context);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingAvatar(context);
        },
      );
    }

    // 如果有占位符文字，显示文字头像
    if (placeholder != null && placeholder!.isNotEmpty) {
      return _buildTextAvatar(context, placeholder!);
    }

    // 默认头像
    return _buildDefaultAvatar(context);
  }

  /// 构建默认头像
  Widget _buildDefaultAvatar(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Icon(
        Icons.person,
        size: size * 0.6,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  /// 构建加载中头像
  Widget _buildLoadingAvatar(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[200],
      child: Center(
        child: SizedBox(
          width: size * 0.3,
          height: size * 0.3,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建文字头像
  Widget _buildTextAvatar(BuildContext context, String text) {
    // 取第一个字符作为头像
    final displayText = text.isNotEmpty ? text[0].toUpperCase() : '?';
    
    return Container(
      width: size,
      height: size,
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Text(
          displayText,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// 可选择的头像组件
class SelectableAvatarWidget extends StatelessWidget {
  final Avatar? avatar;
  final double size;
  final bool isSelected;
  final VoidCallback? onTap;
  final String? placeholder;

  const SelectableAvatarWidget({
    Key? key,
    this.avatar,
    this.size = 60.0,
    this.isSelected = false,
    this.onTap,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size + 8,
        height: size + 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).primaryColor 
                : Colors.transparent,
            width: 3.0,
          ),
        ),
        child: Center(
          child: AvatarWidget(
            avatar: avatar,
            size: size,
            placeholder: placeholder,
          ),
        ),
      ),
    );
  }
}
