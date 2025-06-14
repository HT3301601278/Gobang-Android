import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../config/app_config.dart';

/// JWT Token管理工具
class TokenManager {
  static SharedPreferences? _prefs;
  
  /// 初始化SharedPreferences
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  
  /// 保存Token
  static Future<bool> saveToken(String token) async {
    await init();
    return await _prefs!.setString(AppConfig.tokenKey, token);
  }
  
  /// 获取Token
  static Future<String?> getToken() async {
    await init();
    return _prefs!.getString(AppConfig.tokenKey);
  }
  
  /// 删除Token
  static Future<bool> removeToken() async {
    await init();
    return await _prefs!.remove(AppConfig.tokenKey);
  }
  
  /// 检查Token是否存在
  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
  
  /// 检查Token是否有效（未过期）
  static Future<bool> isTokenValid() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return false;
      }
      
      // 检查Token是否过期
      return !JwtDecoder.isExpired(token);
    } catch (e) {
      return false;
    }
  }
  
  /// 获取Token中的用户ID
  static Future<String?> getUserIdFromToken() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return null;
      }
      
      final decodedToken = JwtDecoder.decode(token);
      return decodedToken['userId']?.toString();
    } catch (e) {
      return null;
    }
  }
  
  /// 获取Token的过期时间
  static Future<DateTime?> getTokenExpirationDate() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return null;
      }
      
      return JwtDecoder.getExpirationDate(token);
    } catch (e) {
      return null;
    }
  }
  
  /// 保存用户信息
  static Future<bool> saveUserInfo(Map<String, dynamic> userInfo) async {
    await init();
    final userJson = jsonEncode(userInfo);
    return await _prefs!.setString(AppConfig.userKey, userJson);
  }
  
  /// 获取用户信息
  static Future<Map<String, dynamic>?> getUserInfo() async {
    await init();
    final userJson = _prefs!.getString(AppConfig.userKey);
    if (userJson == null || userJson.isEmpty) {
      return null;
    }
    
    try {
      return jsonDecode(userJson) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
  
  /// 删除用户信息
  static Future<bool> removeUserInfo() async {
    await init();
    return await _prefs!.remove(AppConfig.userKey);
  }
  
  /// 保存记住我状态
  static Future<bool> saveRememberMe(bool remember) async {
    await init();
    return await _prefs!.setBool(AppConfig.rememberMeKey, remember);
  }
  
  /// 获取记住我状态
  static Future<bool> getRememberMe() async {
    await init();
    return _prefs!.getBool(AppConfig.rememberMeKey) ?? false;
  }
  
  /// 清除所有认证相关数据
  static Future<void> clearAll() async {
    await init();
    await _prefs!.remove(AppConfig.tokenKey);
    await _prefs!.remove(AppConfig.userKey);
    await _prefs!.remove(AppConfig.rememberMeKey);
  }
}
