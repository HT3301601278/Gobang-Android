/// 应用常量定义
class Constants {
  // 路由名称
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String forgotPasswordRoute = '/forgot-password';
  static const String resetPasswordRoute = '/reset-password';
  static const String homeRoute = '/home';
  
  // 错误消息
  static const String networkError = '网络连接失败，请检查网络设置';
  static const String serverError = '服务器错误，请稍后重试';
  static const String unknownError = '未知错误，请稍后重试';
  static const String tokenExpired = '登录已过期，请重新登录';
  static const String invalidCredentials = '用户名或密码错误';
  
  // 成功消息
  static const String registerSuccess = '注册成功';
  static const String loginSuccess = '登录成功';
  static const String logoutSuccess = '退出成功';
  static const String passwordResetSuccess = '密码重置成功';
  static const String passwordChangeSuccess = '密码修改成功';
  static const String verificationCodeSent = '验证码已发送';
  
  // 表单提示
  static const String usernameHint = '请输入用户名';
  static const String emailHint = '请输入邮箱地址';
  static const String passwordHint = '请输入密码';
  static const String confirmPasswordHint = '请确认密码';
  static const String nicknameHint = '请输入昵称';
  static const String verificationCodeHint = '请输入验证码';
  
  // 按钮文本
  static const String loginButton = '登录';
  static const String registerButton = '注册';
  static const String forgotPasswordButton = '忘记密码';
  static const String resetPasswordButton = '重置密码';
  static const String sendCodeButton = '发送验证码';
  static const String confirmButton = '确认';
  static const String cancelButton = '取消';
  static const String backButton = '返回';
  
  // 其他文本
  static const String rememberMe = '记住我';
  static const String noAccount = '还没有账号？';
  static const String hasAccount = '已有账号？';
  static const String goToRegister = '立即注册';
  static const String goToLogin = '立即登录';
}
