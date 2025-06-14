import '../config/app_config.dart';

/// 表单验证工具类
class Validators {
  /// 验证用户名
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return '用户名不能为空';
    }

    if (value.length > AppConfig.maxUsernameLength) {
      return '用户名不能超过${AppConfig.maxUsernameLength}个字符';
    }

    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return '用户名只能包含字母、数字和下划线';
    }

    return null;
  }
  
  /// 验证邮箱
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '邮箱不能为空';
    }
    
    if (!RegExp(AppConfig.emailRegex).hasMatch(value)) {
      return '请输入有效的邮箱地址';
    }
    
    return null;
  }
  
  /// 验证密码
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '密码不能为空';
    }

    if (value.length > AppConfig.maxPasswordLength) {
      return '密码不能超过${AppConfig.maxPasswordLength}个字符';
    }

    return null;
  }
  
  /// 验证确认密码
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return '请确认密码';
    }
    
    if (value != password) {
      return '两次输入的密码不一致';
    }
    
    return null;
  }
  
  /// 验证昵称
  static String? validateNickname(String? value) {
    if (value == null || value.isEmpty) {
      return '昵称不能为空';
    }
    
    if (value.length > AppConfig.maxNicknameLength) {
      return '昵称不能超过${AppConfig.maxNicknameLength}个字符';
    }
    
    return null;
  }
  
  /// 验证验证码
  static String? validateVerificationCode(String? value) {
    if (value == null || value.isEmpty) {
      return '验证码不能为空';
    }
    
    if (value.length != 6) {
      return '验证码应为6位数字';
    }
    
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return '验证码只能包含数字';
    }
    
    return null;
  }
}
