import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../utils/constants.dart';

/// 重置密码页面（备用）
class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('重置密码'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 成功图标
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 40,
                    color: AppColors.success,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // 标题
                Text(
                  '密码重置成功',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // 描述
                Text(
                  '您的密码已成功重置，请使用新密码登录',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // 返回登录按钮
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        Constants.loginRoute,
                        (route) => false,
                      );
                    },
                    child: const Text('返回登录'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
