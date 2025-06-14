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

  // 用户资料相关端点
  static const String userProfile = '/user/profile';
  static const String userStats = '/user/stats';
  static String getUserProfile(String userId) => '/user/profile/$userId';

  // 头像相关端点
  static const String avatarUpload = '/user/avatar/upload';
  static const String systemAvatars = '/user/avatar/system';

  // 表情相关端点
  static const String systemEmojis = '/user/emoji/system';

  // 快捷短语相关端点
  static const String quickPhrases = '/user/quick-phrases';
  static const String systemQuickPhrases = '/user/quick-phrases/system';
  static String getQuickPhrase(String phraseId) => '/user/quick-phrases/$phraseId';

  // 获取完整URL
  static String getFullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
}
