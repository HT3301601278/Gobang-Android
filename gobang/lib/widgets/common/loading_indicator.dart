import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// 加载指示器组件
class LoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;
  final bool showMessage;
  
  const LoadingIndicator({
    super.key,
    this.message,
    this.size = 24.0,
    this.color,
    this.showMessage = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            color: color ?? AppColors.primary,
            strokeWidth: 2.0,
          ),
        ),
        if (showMessage && message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// 全屏加载指示器
class FullScreenLoadingIndicator extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;
  
  const FullScreenLoadingIndicator({
    super.key,
    this.message,
    this.backgroundColor,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? AppColors.overlay,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: LoadingIndicator(
            message: message ?? '加载中...',
            size: 32,
          ),
        ),
      ),
    );
  }
}

/// 按钮加载指示器
class ButtonLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;
  
  const ButtonLoadingIndicator({
    super.key,
    this.color,
    this.size = 16.0,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color ?? AppColors.onPrimary,
        strokeWidth: 2.0,
      ),
    );
  }
}

/// 列表加载指示器
class ListLoadingIndicator extends StatelessWidget {
  final String? message;
  final EdgeInsetsGeometry? padding;
  
  const ListLoadingIndicator({
    super.key,
    this.message,
    this.padding,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      child: Center(
        child: LoadingIndicator(
          message: message ?? '加载中...',
        ),
      ),
    );
  }
}

/// 刷新加载指示器
class RefreshLoadingIndicator extends StatelessWidget {
  final String? message;
  
  const RefreshLoadingIndicator({
    super.key,
    this.message,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: LoadingIndicator(
          message: message ?? '刷新中...',
          size: 20,
        ),
      ),
    );
  }
}
