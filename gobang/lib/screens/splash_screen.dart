import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/common/loading_indicator.dart';

/// 启动页面
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // 初始化动画
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));
    
    // 开始动画
    _animationController.forward();
    
    // 初始化认证状态
    _initializeAuth();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _initializeAuth() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // 等待动画完成
    await Future.delayed(const Duration(milliseconds: 2000));
    
    // 初始化认证状态
    await authProvider.initialize();
    
    if (mounted) {
      // 根据认证状态导航
      if (authProvider.isAuthenticated) {
        Navigator.of(context).pushReplacementNamed(Constants.homeRoute);
      } else {
        Navigator.of(context).pushReplacementNamed(Constants.loginRoute);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo和标题
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        children: [
                          // Logo图标
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppColors.onPrimary,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.shadowLight,
                                  blurRadius: 16,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.grid_on,
                              size: 64,
                              color: AppColors.primary,
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // 应用标题
                          Text(
                            '五子棋',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // 副标题
                          Text(
                            '在线对战 · 语音聊天',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.onPrimary.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 80),
              
              // 加载指示器
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return Column(
                    children: [
                      const LoadingIndicator(
                        color: AppColors.onPrimary,
                        size: 32,
                        showMessage: false,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        authProvider.status == AuthStatus.initial
                            ? '正在启动...'
                            : '正在验证登录状态...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onPrimary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
