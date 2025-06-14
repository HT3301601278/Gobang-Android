import '../../config/api_endpoints.dart';
import '../../models/emoji.dart';
import 'api_client.dart';

/// 表情服务
class EmojiService {
  static final EmojiService _instance = EmojiService._internal();
  factory EmojiService() => _instance;
  EmojiService._internal();
  
  final ApiClient _apiClient = ApiClient();
  
  /// 获取系统表情包
  Future<ApiResponse<List<Emoji>>> getSystemEmojis() async {
    return await _apiClient.get<List<Emoji>>(
      ApiEndpoints.systemEmojis,
      parser: (json) {
        final List<dynamic> emojiList = json['emojis'] as List<dynamic>;
        return emojiList.map((item) => Emoji.fromJson(item as Map<String, dynamic>)).toList();
      },
    );
  }
}
