import '../../config/api_endpoints.dart';
import '../../models/quick_phrase.dart';
import 'api_client.dart';

/// 添加快捷短语请求
class AddQuickPhraseRequest {
  final String content;

  const AddQuickPhraseRequest({
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
    };
  }
}

/// 更新快捷短语请求
class UpdateQuickPhraseRequest {
  final String content;

  const UpdateQuickPhraseRequest({
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
    };
  }
}

/// 快捷短语服务
class QuickPhraseService {
  static final QuickPhraseService _instance = QuickPhraseService._internal();
  factory QuickPhraseService() => _instance;
  QuickPhraseService._internal();
  
  final ApiClient _apiClient = ApiClient();
  
  /// 获取系统快捷短语
  Future<ApiResponse<List<SystemQuickPhrase>>> getSystemQuickPhrases() async {
    return await _apiClient.get<List<SystemQuickPhrase>>(
      ApiEndpoints.systemQuickPhrases,
      parser: (json) {
        final List<dynamic> phraseList = json['phrases'] as List<dynamic>;
        return phraseList.map((item) => SystemQuickPhrase.fromJson(item as Map<String, dynamic>)).toList();
      },
    );
  }
  
  /// 获取用户自定义快捷短语
  Future<ApiResponse<List<QuickPhrase>>> getUserQuickPhrases() async {
    return await _apiClient.get<List<QuickPhrase>>(
      ApiEndpoints.quickPhrases,
      includeAuth: true,
      parser: (json) {
        final List<dynamic> phraseList = json['phrases'] as List<dynamic>;
        return phraseList.map((item) => QuickPhrase.fromJson(item as Map<String, dynamic>)).toList();
      },
    );
  }
  
  /// 添加自定义快捷短语
  Future<ApiResponse<QuickPhrase>> addQuickPhrase(AddQuickPhraseRequest request) async {
    return await _apiClient.post<QuickPhrase>(
      ApiEndpoints.quickPhrases,
      body: request.toJson(),
      includeAuth: true,
      parser: (json) => QuickPhrase.fromJson(json['phrase']),
    );
  }
  
  /// 更新自定义快捷短语
  Future<ApiResponse<void>> updateQuickPhrase(String phraseId, UpdateQuickPhraseRequest request) async {
    return await _apiClient.put<void>(
      ApiEndpoints.getQuickPhrase(phraseId),
      body: request.toJson(),
      includeAuth: true,
    );
  }
  
  /// 删除自定义快捷短语
  Future<ApiResponse<void>> deleteQuickPhrase(String phraseId) async {
    return await _apiClient.delete<void>(
      ApiEndpoints.getQuickPhrase(phraseId),
      includeAuth: true,
    );
  }
}
