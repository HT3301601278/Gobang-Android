import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/user_stats.dart';
import '../models/avatar.dart';
import '../models/emoji.dart';
import '../models/quick_phrase.dart';
import '../services/api/user_service.dart';
import '../services/api/avatar_service.dart';
import '../services/api/emoji_service.dart';
import '../services/api/quick_phrase_service.dart';

/// 用户信息状态管理
class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  final AvatarService _avatarService = AvatarService();
  final EmojiService _emojiService = EmojiService();
  final QuickPhraseService _quickPhraseService = QuickPhraseService();
  
  User? _currentUser;
  UserStats? _userStats;
  List<SystemAvatar> _systemAvatars = [];
  List<Emoji> _systemEmojis = [];
  List<SystemQuickPhrase> _systemQuickPhrases = [];
  List<QuickPhrase> _userQuickPhrases = [];
  
  String? _errorMessage;
  bool _isLoading = false;
  bool _isUpdatingProfile = false;
  bool _isUploadingAvatar = false;
  
  // Getters
  User? get currentUser => _currentUser;
  UserStats? get userStats => _userStats;
  List<SystemAvatar> get systemAvatars => _systemAvatars;
  List<Emoji> get systemEmojis => _systemEmojis;
  List<SystemQuickPhrase> get systemQuickPhrases => _systemQuickPhrases;
  List<QuickPhrase> get userQuickPhrases => _userQuickPhrases;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isUpdatingProfile => _isUpdatingProfile;
  bool get isUploadingAvatar => _isUploadingAvatar;
  
  /// 设置当前用户
  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }
  
  /// 加载用户资料
  Future<bool> loadUserProfile() async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _userService.getCurrentUserProfile();
      
      if (response.success && response.data != null) {
        _currentUser = response.data;
        _clearError();
        return true;
      } else {
        _setError(response.message ?? '获取用户资料失败');
        return false;
      }
    } catch (e) {
      _setError('获取用户资料失败: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 更新用户资料
  Future<bool> updateProfile({
    String? nickname,
    Map<String, dynamic>? avatar,
  }) async {
    _setUpdatingProfile(true);
    _clearError();
    
    try {
      final request = UpdateProfileRequest(
        nickname: nickname,
        avatar: avatar,
      );
      
      final response = await _userService.updateProfile(request);
      
      if (response.success && response.data != null) {
        _currentUser = response.data;
        _clearError();
        return true;
      } else {
        _setError(response.message ?? '更新资料失败');
        return false;
      }
    } catch (e) {
      _setError('更新资料失败: ${e.toString()}');
      return false;
    } finally {
      _setUpdatingProfile(false);
    }
  }
  
  /// 加载用户统计
  Future<bool> loadUserStats() async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _userService.getUserStats();
      
      if (response.success && response.data != null) {
        _userStats = response.data;
        _clearError();
        return true;
      } else {
        _setError(response.message ?? '获取统计数据失败');
        return false;
      }
    } catch (e) {
      _setError('获取统计数据失败: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 加载系统头像
  Future<bool> loadSystemAvatars() async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _avatarService.getSystemAvatars();
      
      if (response.success && response.data != null) {
        _systemAvatars = response.data!;
        _clearError();
        return true;
      } else {
        _setError(response.message ?? '获取系统头像失败');
        return false;
      }
    } catch (e) {
      _setError('获取系统头像失败: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 上传自定义头像
  Future<String?> uploadAvatar(File avatarFile) async {
    _setUploadingAvatar(true);
    _clearError();
    
    try {
      final response = await _avatarService.uploadAvatar(avatarFile);
      
      if (response.success && response.data != null) {
        _clearError();
        return response.data!.avatarUrl;
      } else {
        _setError(response.message ?? '头像上传失败');
        return null;
      }
    } catch (e) {
      _setError('头像上传失败: ${e.toString()}');
      return null;
    } finally {
      _setUploadingAvatar(false);
    }
  }
  
  /// 加载系统表情
  Future<bool> loadSystemEmojis() async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _emojiService.getSystemEmojis();
      
      if (response.success && response.data != null) {
        _systemEmojis = response.data!;
        _clearError();
        return true;
      } else {
        _setError(response.message ?? '获取系统表情失败');
        return false;
      }
    } catch (e) {
      _setError('获取系统表情失败: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 加载系统快捷短语
  Future<bool> loadSystemQuickPhrases() async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _quickPhraseService.getSystemQuickPhrases();
      
      if (response.success && response.data != null) {
        _systemQuickPhrases = response.data!;
        _clearError();
        return true;
      } else {
        _setError(response.message ?? '获取系统快捷短语失败');
        return false;
      }
    } catch (e) {
      _setError('获取系统快捷短语失败: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 加载用户快捷短语
  Future<bool> loadUserQuickPhrases() async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _quickPhraseService.getUserQuickPhrases();
      
      if (response.success && response.data != null) {
        _userQuickPhrases = response.data!;
        _clearError();
        return true;
      } else {
        _setError(response.message ?? '获取用户快捷短语失败');
        return false;
      }
    } catch (e) {
      _setError('获取用户快捷短语失败: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 添加快捷短语
  Future<bool> addQuickPhrase(String content) async {
    _setLoading(true);
    _clearError();
    
    try {
      final request = AddQuickPhraseRequest(content: content);
      final response = await _quickPhraseService.addQuickPhrase(request);
      
      if (response.success && response.data != null) {
        _userQuickPhrases.add(response.data!);
        _clearError();
        return true;
      } else {
        _setError(response.message ?? '添加快捷短语失败');
        return false;
      }
    } catch (e) {
      _setError('添加快捷短语失败: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 更新快捷短语
  Future<bool> updateQuickPhrase(String phraseId, String content) async {
    _setLoading(true);
    _clearError();
    
    try {
      final request = UpdateQuickPhraseRequest(content: content);
      final response = await _quickPhraseService.updateQuickPhrase(phraseId, request);
      
      if (response.success) {
        // 更新本地数据
        final index = _userQuickPhrases.indexWhere((phrase) => phrase.id == phraseId);
        if (index != -1) {
          _userQuickPhrases[index] = _userQuickPhrases[index].copyWith(content: content);
        }
        _clearError();
        return true;
      } else {
        _setError(response.message ?? '更新快捷短语失败');
        return false;
      }
    } catch (e) {
      _setError('更新快捷短语失败: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 删除快捷短语
  Future<bool> deleteQuickPhrase(String phraseId) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _quickPhraseService.deleteQuickPhrase(phraseId);
      
      if (response.success) {
        _userQuickPhrases.removeWhere((phrase) => phrase.id == phraseId);
        _clearError();
        return true;
      } else {
        _setError(response.message ?? '删除快捷短语失败');
        return false;
      }
    } catch (e) {
      _setError('删除快捷短语失败: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// 设置加载状态
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  /// 设置更新资料状态
  void _setUpdatingProfile(bool updating) {
    _isUpdatingProfile = updating;
    notifyListeners();
  }
  
  /// 设置上传头像状态
  void _setUploadingAvatar(bool uploading) {
    _isUploadingAvatar = uploading;
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
  }
}
