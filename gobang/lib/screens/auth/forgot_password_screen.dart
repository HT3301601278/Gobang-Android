import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/auth/password_reset_form.dart';

/// 忘记密码页面
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('忘记密码'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              // 顶部标题
              Column(
                children: [
                  // 图标
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.lock_reset,
                      size: 32,
                      color: AppColors.warning,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 标题
                  Text(
                    '重置密码',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 副标题
                  Text(
                    '输入您的邮箱地址，我们将发送验证码',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // 密码重置表单
              PasswordResetForm(
                onResetSuccess: () {
                  // 重置成功后返回登录页面
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    Constants.loginRoute,
                    (route) => false,
                  );
                },
                onBack: () {
                  Navigator.of(context).pop();
                },
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
