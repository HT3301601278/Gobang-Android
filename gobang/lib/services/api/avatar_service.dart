import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config/api_endpoints.dart';
import '../../models/avatar.dart';
import '../../utils/token_manager.dart';
import 'api_client.dart';

/// 头像上传响应
class AvatarUploadResponse {
  final String avatarUrl;

  const AvatarUploadResponse({
    required this.avatarUrl,
  });

  factory AvatarUploadResponse.fromJson(Map<String, dynamic> json) {
    return AvatarUploadResponse(
      avatarUrl: json['avatarUrl'] as String,
    );
  }
}

/// 头像服务
class AvatarService {
  static final AvatarService _instance = AvatarService._internal();
  factory AvatarService() => _instance;
  AvatarService._internal();
  
  final ApiClient _apiClient = ApiClient();
  
  /// 获取系统头像库
  Future<ApiResponse<List<SystemAvatar>>> getSystemAvatars() async {
    return await _apiClient.get<List<SystemAvatar>>(
      ApiEndpoints.systemAvatars,
      parser: (json) {
        final List<dynamic> avatarList = json['avatars'] as List<dynamic>;
        return avatarList.map((item) => SystemAvatar.fromJson(item as Map<String, dynamic>)).toList();
      },
    );
  }
  
  /// 上传自定义头像
  Future<ApiResponse<AvatarUploadResponse>> uploadAvatar(File avatarFile) async {
    try {
      final uri = Uri.parse(ApiEndpoints.getFullUrl(ApiEndpoints.avatarUpload));
      final request = http.MultipartRequest('POST', uri);
      
      // 添加认证头
      final token = await TokenManager.getToken();
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      
      // 添加文件
      final multipartFile = await http.MultipartFile.fromPath(
        'avatar',
        avatarFile.path,
      );
      request.files.add(multipartFile);
      
      // 发送请求
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      // 处理响应
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final uploadResponse = AvatarUploadResponse.fromJson(jsonData);
        return ApiResponse<AvatarUploadResponse>(
          success: jsonData['success'] ?? true,
          message: jsonData['message'],
          data: uploadResponse,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse<AvatarUploadResponse>(
          success: false,
          message: jsonData['message'] ?? '头像上传失败',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse<AvatarUploadResponse>(
        success: false,
        message: '头像上传失败: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
