import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api/auth_service.dart';
import '../utils/token_manager.dart';
import '../utils/constants.dart';

/// 认证状态枚举
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
}

/// 认证状态管理
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;
  
  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  
  /// 初始化认证状态
  Future<void> initialize() async {
    _setLoading(true);
    
    try {
      // 检查是否有有效的Token
      final hasValidToken = await TokenManager.isTokenValid();
      
      if (hasValidToken) {
        // 从本地存储获取用户信息
        final userInfo = await TokenManager.getUserInfo();
        if (userInfo != null) {
          _user = User.fromJson(userInfo);
          _setStatus(AuthStatus.authenticated);
        } else {
          _setStatus(AuthStatus.unauthenticated);
        }
      } else {
        _setStatus(AuthStatus.unauthenticated);
      }
    } catch (e) {
      _setStatus(AuthStatus.unauthenticated);
      _setError('初始化失败: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  /// 用户注册
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String nickname,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final request = RegisterRequest(
        username: username,
        email: email,
        password: password,
        nickname: nickname,
      );
      
      final response = await _authService.register(request);
      
      if (response.success) {
        _setError(null);
        return true;
      } else {
        _setError(response.message ?? '注册失败');
        return false;
      }
    } catch (e) {
      _setError('注册失败: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 用户登录
  Future<bool> login({
    required String username,
    required String password,
    bool rememberMe = false,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final request = LoginRequest(
        username: username,
        password: password,
      );
      
      final response = await _authService.login(request);
      
      if (response.success && response.data != null) {
        final loginResponse = response.data!;
        
        // 保存Token和用户信息
        await TokenManager.saveToken(loginResponse.token);
        await TokenManager.saveUserInfo(loginResponse.user.toJson());
        await TokenManager.saveRememberMe(rememberMe);
        
        _user = loginResponse.user;
        _setStatus(AuthStatus.authenticated);
        _setError(null);
        return true;
      } else {
        _setError(response.message ?? Constants.invalidCredentials);
        return false;
      }
    } catch (e) {
      _setError('登录失败: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 用户登出
  Future<void> logout() async {
    _setLoading(true);
    
    try {
      // 调用服务器登出接口
      await _authService.logout();
    } catch (e) {
      // 即使服务器登出失败，也要清除本地数据
      debugPrint('服务器登出失败: ${e.toString()}');
    }
    
    // 清除本地存储
    await TokenManager.clearAll();
    
    _user = null;
    _setStatus(AuthStatus.unauthenticated);
    _clearError();
    _setLoading(false);
  }
  
  /// 忘记密码
  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    _clearError();
    
    try {
      final request = ForgotPasswordRequest(email: email);
      final response = await _authService.forgotPassword(request);
      
      if (response.success) {
        _setError(null);
        return true;
      } else {
        _setError(response.message ?? '发送验证码失败');
        return false;
      }
    } catch (e) {
      _setError('发送验证码失败: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 重置密码
  Future<bool> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final request = ResetPasswordRequest(
        email: email,
        code: code,
        newPassword: newPassword,
      );
      
      final response = await _authService.resetPassword(request);
      
      if (response.success) {
        _setError(null);
        return true;
      } else {
        _setError(response.message ?? '重置密码失败');
        return false;
      }
    } catch (e) {
      _setError('重置密码失败: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 请求修改密码验证码
  Future<bool> requestChangePassword(String email) async {
    _setLoading(true);
    _clearError();
    
    try {
      final request = ChangePasswordRequest(email: email);
      final response = await _authService.requestChangePassword(request);
      
      if (response.success) {
        _setError(null);
        return true;
      } else {
        _setError(response.message ?? '发送验证码失败');
        return false;
      }
    } catch (e) {
      _setError('发送验证码失败: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 确认修改密码
  Future<bool> confirmChangePassword({
    required String code,
    required String newPassword,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final request = ChangePasswordRequest(
        code: code,
        newPassword: newPassword,
      );
      
      final response = await _authService.confirmChangePassword(request);
      
      if (response.success) {
        _setError(null);
        return true;
      } else {
        _setError(response.message ?? '修改密码失败');
        return false;
      }
    } catch (e) {
      _setError('修改密码失败: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 更新用户信息
  void updateUser(User user) {
    _user = user;
    TokenManager.saveUserInfo(user.toJson());
    notifyListeners();
  }
  
  /// 设置状态
  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }
  
  /// 设置加载状态
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  /// 设置错误信息
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }
  
  /// 清除错误信息
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
