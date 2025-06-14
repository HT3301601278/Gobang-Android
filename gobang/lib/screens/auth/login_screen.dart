import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/auth/login_form.dart';

/// 登录页面
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              
              // 顶部Logo和标题
              Column(
                children: [
                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.grid_on,
                      size: 40,
                      color: AppColors.onPrimary,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 标题
                  Text(
                    '欢迎回来',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 副标题
                  Text(
                    '登录您的账号开始游戏',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 48),
              
              // 登录表单
              LoginForm(
                onLoginSuccess: () {
                  Navigator.of(context).pushReplacementNamed(Constants.homeRoute);
                },
                onForgotPassword: () {
                  Navigator.of(context).pushNamed(Constants.forgotPasswordRoute);
                },
                onRegister: () {
                  Navigator.of(context).pushReplacementNamed(Constants.registerRoute);
                },
              ),
              
              const SizedBox(height: 40),
              
              // 底部装饰
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '五子棋在线对战',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
