import '../../config/api_endpoints.dart';
import '../../models/user.dart';
import 'api_client.dart';

/// 认证服务
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
  
  final ApiClient _apiClient = ApiClient();
  
  /// 用户注册
  Future<ApiResponse<String>> register(RegisterRequest request) async {
    return await _apiClient.post<String>(
      ApiEndpoints.register,
      body: request.toJson(),
      parser: (json) => json['userId']?.toString(),
    );
  }
  
  /// 用户登录
  Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    return await _apiClient.post<LoginResponse>(
      ApiEndpoints.login,
      body: request.toJson(),
      parser: (json) => LoginResponse.fromJson(json),
    );
  }
  
  /// 用户登出
  Future<ApiResponse<void>> logout() async {
    return await _apiClient.post<void>(
      ApiEndpoints.logout,
      includeAuth: true,
    );
  }
  
  /// 忘记密码 - 发送验证码
  Future<ApiResponse<void>> forgotPassword(ForgotPasswordRequest request) async {
    return await _apiClient.post<void>(
      ApiEndpoints.forgotPassword,
      body: request.toJson(),
    );
  }
  
  /// 重置密码
  Future<ApiResponse<void>> resetPassword(ResetPasswordRequest request) async {
    return await _apiClient.post<void>(
      ApiEndpoints.resetPassword,
      body: request.toJson(),
    );
  }
  
  /// 修改密码 - 发送验证码
  Future<ApiResponse<void>> requestChangePassword(ChangePasswordRequest request) async {
    return await _apiClient.post<void>(
      ApiEndpoints.changePassword,
      body: request.toJson(),
      includeAuth: true,
    );
  }
  
  /// 确认修改密码
  Future<ApiResponse<void>> confirmChangePassword(ChangePasswordRequest request) async {
    return await _apiClient.put<void>(
      ApiEndpoints.changePassword,
      body: request.toJson(),
      includeAuth: true,
    );
  }
}

/// 登录响应模型
class LoginResponse {
  final bool success;
  final String token;
  final User user;
  
  const LoginResponse({
    required this.success,
    required this.token,
    required this.user,
  });
  
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      token: json['token'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'token': token,
      'user': user.toJson(),
    };
  }
}
