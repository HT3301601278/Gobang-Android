import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../config/api_endpoints.dart';
import '../../config/app_config.dart';
import '../../utils/token_manager.dart';
import '../../utils/constants.dart';

/// API响应模型
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int statusCode;
  
  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    required this.statusCode,
  });
  
  factory ApiResponse.fromJson(Map<String, dynamic> json, T? data) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'],
      data: data,
      statusCode: 200,
    );
  }
}

/// 基础HTTP客户端
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();
  
  late http.Client _client;
  
  /// 初始化客户端
  void init() {
    _client = http.Client();
  }
  
  /// 获取默认请求头
  Future<Map<String, String>> _getHeaders({bool includeAuth = false}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (includeAuth) {
      final token = await TokenManager.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }
  
  /// 处理HTTP异常
  ApiResponse<T> _handleError<T>(dynamic error) {
    String message = Constants.unknownError;
    int statusCode = 500;
    
    if (error is SocketException) {
      message = Constants.networkError;
      statusCode = 0;
    } else if (error is HttpException) {
      message = Constants.serverError;
      statusCode = 500;
    } else if (error is FormatException) {
      message = '数据格式错误';
      statusCode = 400;
    }
    
    return ApiResponse<T>(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }
  
  /// 处理HTTP响应
  ApiResponse<T> _handleResponse<T>(http.Response response, T? Function(Map<String, dynamic>)? parser) {
    try {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        T? data;
        if (parser != null) {
          data = parser(jsonData);
        }
        
        return ApiResponse<T>(
          success: jsonData['success'] ?? true,
          message: jsonData['message'],
          data: data,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse<T>(
          success: false,
          message: jsonData['message'] ?? _getErrorMessage(response.statusCode),
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: '响应解析失败',
        statusCode: response.statusCode,
      );
    }
  }
  
  /// 根据状态码获取错误消息
  String _getErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return '请求参数错误';
      case 401:
        return Constants.tokenExpired;
      case 403:
        return '权限不足';
      case 404:
        return '请求的资源不存在';
      case 500:
        return Constants.serverError;
      default:
        return Constants.unknownError;
    }
  }
  
  /// GET请求
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParameters,
    bool includeAuth = false,
    T? Function(Map<String, dynamic>)? parser,
  }) async {
    try {
      final uri = Uri.parse(ApiEndpoints.getFullUrl(endpoint));
      final finalUri = queryParameters != null 
          ? uri.replace(queryParameters: queryParameters)
          : uri;
      
      final headers = await _getHeaders(includeAuth: includeAuth);
      
      final response = await _client
          .get(finalUri, headers: headers)
          .timeout(Duration(milliseconds: AppConfig.receiveTimeout));
      
      return _handleResponse<T>(response, parser);
    } catch (e) {
      return _handleError<T>(e);
    }
  }
  
  /// POST请求
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = false,
    T? Function(Map<String, dynamic>)? parser,
  }) async {
    try {
      final uri = Uri.parse(ApiEndpoints.getFullUrl(endpoint));
      final headers = await _getHeaders(includeAuth: includeAuth);
      
      final response = await _client
          .post(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(Duration(milliseconds: AppConfig.receiveTimeout));
      
      return _handleResponse<T>(response, parser);
    } catch (e) {
      return _handleError<T>(e);
    }
  }
  
  /// PUT请求
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = false,
    T? Function(Map<String, dynamic>)? parser,
  }) async {
    try {
      final uri = Uri.parse(ApiEndpoints.getFullUrl(endpoint));
      final headers = await _getHeaders(includeAuth: includeAuth);
      
      final response = await _client
          .put(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(Duration(milliseconds: AppConfig.receiveTimeout));
      
      return _handleResponse<T>(response, parser);
    } catch (e) {
      return _handleError<T>(e);
    }
  }
  
  /// DELETE请求
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    bool includeAuth = false,
    T? Function(Map<String, dynamic>)? parser,
  }) async {
    try {
      final uri = Uri.parse(ApiEndpoints.getFullUrl(endpoint));
      final headers = await _getHeaders(includeAuth: includeAuth);
      
      final response = await _client
          .delete(uri, headers: headers)
          .timeout(Duration(milliseconds: AppConfig.receiveTimeout));
      
      return _handleResponse<T>(response, parser);
    } catch (e) {
      return _handleError<T>(e);
    }
  }
  
  /// 关闭客户端
  void close() {
    _client.close();
  }
}
