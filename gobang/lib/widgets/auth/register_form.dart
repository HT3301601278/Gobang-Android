import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/validators.dart';
import '../../utils/constants.dart';
import '../../theme/app_colors.dart';
import '../common/loading_indicator.dart';
import '../common/error_dialog.dart';

/// 注册表单组件
class RegisterForm extends StatefulWidget {
  final VoidCallback? onRegisterSuccess;
  final VoidCallback? onLogin;
  
  const RegisterForm({
    super.key,
    this.onRegisterSuccess,
    this.onLogin,
  });
  
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _nicknameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.register(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      nickname: _nicknameController.text.trim(),
    );
    
    if (mounted) {
      if (success) {
        ErrorHandler.showSuccess(context, Constants.registerSuccess);
        widget.onRegisterSuccess?.call();
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
                  helperText: '只能包含字母、数字和下划线',
                ),
                textInputAction: TextInputAction.next,
                validator: Validators.validateUsername,
                enabled: !authProvider.isLoading,
              ),
              
              const SizedBox(height: 16),
              
              // 邮箱输入框
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: '邮箱',
                  hintText: Constants.emailHint,
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: Validators.validateEmail,
                enabled: !authProvider.isLoading,
              ),
              
              const SizedBox(height: 16),
              
              // 昵称输入框
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: '昵称',
                  hintText: Constants.nicknameHint,
                  prefixIcon: Icon(Icons.badge_outlined),
                  helperText: '最多30个字符',
                ),
                textInputAction: TextInputAction.next,
                validator: Validators.validateNickname,
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
                textInputAction: TextInputAction.next,
                validator: Validators.validatePassword,
                enabled: !authProvider.isLoading,
              ),
              
              const SizedBox(height: 16),
              
              // 确认密码输入框
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: '确认密码',
                  hintText: Constants.confirmPasswordHint,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscureConfirmPassword,
                textInputAction: TextInputAction.done,
                validator: (value) => Validators.validateConfirmPassword(
                  value,
                  _passwordController.text,
                ),
                enabled: !authProvider.isLoading,
                onFieldSubmitted: (_) => _handleRegister(),
              ),
              
              const SizedBox(height: 32),
              
              // 注册按钮
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: authProvider.isLoading ? null : _handleRegister,
                  child: authProvider.isLoading
                      ? const ButtonLoadingIndicator()
                      : const Text(Constants.registerButton),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 登录链接
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Constants.hasAccount,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: authProvider.isLoading ? null : widget.onLogin,
                    child: const Text(Constants.goToLogin),
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
