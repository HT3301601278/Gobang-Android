import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_config.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'theme/app_theme.dart';
import 'utils/constants.dart';
import 'services/api/api_client.dart';

/// 应用主类
class GobangApp extends StatelessWidget {
  const GobangApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        
        // 初始路由
        initialRoute: Constants.splashRoute,
        
        // 路由配置
        routes: {
          Constants.splashRoute: (context) => const SplashScreen(),
          Constants.loginRoute: (context) => const LoginScreen(),
          Constants.registerRoute: (context) => const RegisterScreen(),
          Constants.forgotPasswordRoute: (context) => const ForgotPasswordScreen(),
          Constants.resetPasswordRoute: (context) => const ResetPasswordScreen(),
          Constants.homeRoute: (context) => const HomeScreen(),
        },
        
        // 路由生成器（用于处理未定义的路由）
        onGenerateRoute: (settings) {
          switch (settings.name) {
            default:
              return MaterialPageRoute(
                builder: (context) => const _NotFoundScreen(),
              );
          }
        },
        
        // 应用构建器（用于初始化）
        builder: (context, child) {
          // 初始化API客户端
          ApiClient().init();
          
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}

/// 404页面
class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('页面未找到'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '404',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '页面未找到',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
