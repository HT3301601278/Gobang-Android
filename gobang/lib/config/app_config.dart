/// 应用配置
class AppConfig {
  // 应用信息
  static const String appName = '五子棋';
  static const String appVersion = '1.0.0';
  
  // 网络配置
  static const int connectTimeout = 30000; // 30秒
  static const int receiveTimeout = 30000; // 30秒
  
  // 存储键名
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_info';
  static const String rememberMeKey = 'remember_me';
  
  // 验证规则
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
  static const int maxNicknameLength = 30;
  
  // 正则表达式
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String usernameRegex = r'^[a-zA-Z0-9_]{3,20}$';
}
