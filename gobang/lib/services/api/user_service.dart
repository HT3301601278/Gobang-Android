import '../../config/api_endpoints.dart';
import '../../models/user.dart';
import '../../models/user_stats.dart';
import '../../models/avatar.dart';
import 'api_client.dart';

/// 用户资料更新请求
class UpdateProfileRequest {
  final String? nickname;
  final Avatar? avatar;

  const UpdateProfileRequest({
    this.nickname,
    this.avatar,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (nickname != null) data['nickname'] = nickname;
    if (avatar != null) data['avatar'] = avatar!.toJson();
    return data;
  }
}

/// 用户服务
class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();
  
  final ApiClient _apiClient = ApiClient();
  
  /// 获取当前用户资料
  Future<ApiResponse<User>> getCurrentUserProfile() async {
    return await _apiClient.get<User>(
      ApiEndpoints.userProfile,
      includeAuth: true,
      parser: (json) => User.fromJson(json['user']),
    );
  }
  
  /// 更新用户资料
  Future<ApiResponse<User>> updateProfile(UpdateProfileRequest request) async {
    return await _apiClient.put<User>(
      ApiEndpoints.userProfile,
      body: request.toJson(),
      includeAuth: true,
      parser: (json) => User.fromJson(json['user']),
    );
  }
  
  /// 获取其他用户公开资料
  Future<ApiResponse<User>> getUserProfile(String userId) async {
    return await _apiClient.get<User>(
      ApiEndpoints.getUserProfile(userId),
      includeAuth: true,
      parser: (json) => User.fromJson(json['user']),
    );
  }
  
  /// 获取用户详细统计
  Future<ApiResponse<UserStats>> getUserStats() async {
    return await _apiClient.get<UserStats>(
      ApiEndpoints.userStats,
      includeAuth: true,
      parser: (json) => UserStats.fromJson(json['stats']),
    );
  }
}
