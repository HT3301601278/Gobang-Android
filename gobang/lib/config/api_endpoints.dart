/// API端点配置
class ApiEndpoints {
  // 基础URL - 根据实际后端地址修改
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  
  // 认证相关端点
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';
  
  // 获取完整URL
  static String getFullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
}
