import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../utils/constants.dart';

/// 错误对话框
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;
  
  const ErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.error,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
          child: Text(buttonText ?? Constants.confirmButton),
        ),
      ],
    );
  }
  
  /// 显示错误对话框
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
      ),
    );
  }
}

/// 网络错误对话框
class NetworkErrorDialog extends StatelessWidget {
  final VoidCallback? onRetry;
  
  const NetworkErrorDialog({
    super.key,
    this.onRetry,
  });
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(
            Icons.wifi_off,
            color: AppColors.error,
            size: 24,
          ),
          SizedBox(width: 8),
          Text('网络错误'),
        ],
      ),
      content: const Text(Constants.networkError),
      actions: [
        if (onRetry != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry!();
            },
            child: const Text('重试'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(Constants.confirmButton),
        ),
      ],
    );
  }
  
  /// 显示网络错误对话框
  static Future<void> show(
    BuildContext context, {
    VoidCallback? onRetry,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => NetworkErrorDialog(onRetry: onRetry),
    );
  }
}

/// 服务器错误对话框
class ServerErrorDialog extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  
  const ServerErrorDialog({
    super.key,
    this.message,
    this.onRetry,
  });
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 24,
          ),
          SizedBox(width: 8),
          Text('服务器错误'),
        ],
      ),
      content: Text(message ?? Constants.serverError),
      actions: [
        if (onRetry != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry!();
            },
            child: const Text('重试'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(Constants.confirmButton),
        ),
      ],
    );
  }
  
  /// 显示服务器错误对话框
  static Future<void> show(
    BuildContext context, {
    String? message,
    VoidCallback? onRetry,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ServerErrorDialog(
        message: message,
        onRetry: onRetry,
      ),
    );
  }
}

/// 通用错误处理工具
class ErrorHandler {
  /// 显示错误信息
  static void showError(
    BuildContext context,
    String? error, {
    VoidCallback? onRetry,
  }) {
    if (error == null || error.isEmpty) return;
    
    if (error.contains('网络') || error.contains('连接')) {
      NetworkErrorDialog.show(context, onRetry: onRetry);
    } else if (error.contains('服务器')) {
      ServerErrorDialog.show(context, message: error, onRetry: onRetry);
    } else {
      ErrorDialog.show(
        context,
        title: '错误',
        message: error,
      );
    }
  }
  
  /// 显示成功消息
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  /// 显示警告消息
  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.warning,
              color: AppColors.warning,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.warning,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
