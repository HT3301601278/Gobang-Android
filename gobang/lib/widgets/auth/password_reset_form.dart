import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/validators.dart';
import '../../utils/constants.dart';
import '../../theme/app_colors.dart';
import '../common/loading_indicator.dart';
import '../common/error_dialog.dart';

/// 密码重置表单组件
class PasswordResetForm extends StatefulWidget {
  final VoidCallback? onResetSuccess;
  final VoidCallback? onBack;
  
  const PasswordResetForm({
    super.key,
    this.onResetSuccess,
    this.onBack,
  });
  
  @override
  State<PasswordResetForm> createState() => _PasswordResetFormState();
}

class _PasswordResetFormState extends State<PasswordResetForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _codeSent = false;
  
  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  Future<void> _handleSendCode() async {
    if (_emailController.text.trim().isEmpty) {
      ErrorHandler.showError(context, '请输入邮箱地址');
      return;
    }
    
    final emailError = Validators.validateEmail(_emailController.text.trim());
    if (emailError != null) {
      ErrorHandler.showError(context, emailError);
      return;
    }
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.forgotPassword(_emailController.text.trim());
    
    if (mounted) {
      if (success) {
        setState(() {
          _codeSent = true;
        });
        ErrorHandler.showSuccess(context, Constants.verificationCodeSent);
      } else {
        ErrorHandler.showError(context, authProvider.errorMessage);
      }
    }
  }
  
  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.resetPassword(
      email: _emailController.text.trim(),
      code: _codeController.text.trim(),
      newPassword: _passwordController.text,
    );
    
    if (mounted) {
      if (success) {
        ErrorHandler.showSuccess(context, Constants.passwordResetSuccess);
        widget.onResetSuccess?.call();
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
              // 邮箱输入框
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: '邮箱',
                  hintText: Constants.emailHint,
                  prefixIcon: const Icon(Icons.email_outlined),
                  suffixIcon: _codeSent
                      ? const Icon(Icons.check_circle, color: AppColors.success)
                      : null,
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: Validators.validateEmail,
                enabled: !authProvider.isLoading && !_codeSent,
                readOnly: _codeSent,
              ),
              
              const SizedBox(height: 16),
              
              // 发送验证码按钮
              if (!_codeSent) ...[
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _handleSendCode,
                    child: authProvider.isLoading
                        ? const ButtonLoadingIndicator()
                        : const Text(Constants.sendCodeButton),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              // 验证码输入框
              if (_codeSent) ...[
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelText: '验证码',
                    hintText: Constants.verificationCodeHint,
                    prefixIcon: Icon(Icons.security),
                    helperText: '请输入邮箱收到的6位验证码',
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: Validators.validateVerificationCode,
                  enabled: !authProvider.isLoading,
                  maxLength: 6,
                ),
                
                const SizedBox(height: 16),
                
                // 新密码输入框
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: '新密码',
                    hintText: '请输入新密码',
                    prefixIcon: const Icon(Icons.lock_outline),
                    helperText: '6-20个字符',
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
                
                // 确认新密码输入框
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: '确认新密码',
                    hintText: '请再次输入新密码',
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
                  onFieldSubmitted: (_) => _handleResetPassword(),
                ),
                
                const SizedBox(height: 32),
                
                // 重置密码按钮
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _handleResetPassword,
                    child: authProvider.isLoading
                        ? const ButtonLoadingIndicator()
                        : const Text(Constants.resetPasswordButton),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // 重新发送验证码
                TextButton(
                  onPressed: authProvider.isLoading
                      ? null
                      : () {
                          setState(() {
                            _codeSent = false;
                            _codeController.clear();
                            _passwordController.clear();
                            _confirmPasswordController.clear();
                          });
                        },
                  child: const Text('重新发送验证码'),
                ),
              ],
              
              const SizedBox(height: 16),
              
              // 返回按钮
              TextButton(
                onPressed: authProvider.isLoading ? null : widget.onBack,
                child: const Text(Constants.backButton),
              ),
            ],
          ),
        );
      },
    );
  }
}
