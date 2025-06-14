import 'package:json_annotation/json_annotation.dart';

part 'emoji.g.dart';

/// 表情模型
@JsonSerializable()
class Emoji {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'url')
  final String url;

  @JsonKey(name: 'name')
  final String name;

  const Emoji({
    required this.id,
    required this.url,
    required this.name,
  });

  /// 从JSON创建Emoji对象
  factory Emoji.fromJson(Map<String, dynamic> json) => _$EmojiFromJson(json);

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$EmojiToJson(this);

  @override
  String toString() => 'Emoji(id: $id, url: $url, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Emoji && 
           other.id == id && 
           other.url == url && 
           other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ url.hashCode ^ name.hashCode;
}
