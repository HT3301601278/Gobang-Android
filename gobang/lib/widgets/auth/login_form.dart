import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/validators.dart';
import '../../utils/constants.dart';
import '../../theme/app_colors.dart';
import '../common/loading_indicator.dart';
import '../common/error_dialog.dart';

/// 登录表单组件
class LoginForm extends StatefulWidget {
  final VoidCallback? onLoginSuccess;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onRegister;
  
  const LoginForm({
    super.key,
    this.onLoginSuccess,
    this.onForgotPassword,
    this.onRegister,
  });
  
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _rememberMe = false;
  
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.login(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      rememberMe: _rememberMe,
    );
    
    if (mounted) {
      if (success) {
        ErrorHandler.showSuccess(context, Constants.loginSuccess);
        widget.onLoginSuccess?.call();
      } else {
        ErrorHandler.showError(context, authProvider.errorMessage);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 用户名输入框
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: '用户名',
                  hintText: Constants.usernameHint,
                  prefixIcon: Icon(Icons.person_outline),
                ),
                textInputAction: TextInputAction.next,
                validator: Validators.validateUsername,
                enabled: !authProvider.isLoading,
              ),
              
              const SizedBox(height: 16),
              
              // 密码输入框
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: '密码',
                  hintText: Constants.passwordHint,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                validator: Validators.validatePassword,
                enabled: !authProvider.isLoading,
                onFieldSubmitted: (_) => _handleLogin(),
              ),
              
              const SizedBox(height: 8),
              
              // 记住我和忘记密码
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: authProvider.isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                  ),
                  const Text(Constants.rememberMe),
                  const Spacer(),
                  TextButton(
                    onPressed: authProvider.isLoading ? null : widget.onForgotPassword,
                    child: const Text(Constants.forgotPasswordButton),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // 登录按钮
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: authProvider.isLoading ? null : _handleLogin,
                  child: authProvider.isLoading
                      ? const ButtonLoadingIndicator()
                      : const Text(Constants.loginButton),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 注册链接
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Constants.noAccount,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: authProvider.isLoading ? null : widget.onRegister,
                    child: const Text(Constants.goToRegister),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
