import 'package:json_annotation/json_annotation.dart';

part 'quick_phrase.g.dart';

/// 快捷短语模型
@JsonSerializable()
class QuickPhrase {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'content')
  final String content;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  const QuickPhrase({
    required this.id,
    required this.content,
    this.createdAt,
  });

  /// 从JSON创建QuickPhrase对象
  factory QuickPhrase.fromJson(Map<String, dynamic> json) => _$QuickPhraseFromJson(json);

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$QuickPhraseToJson(this);

  /// 复制并修改部分字段
  QuickPhrase copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
  }) {
    return QuickPhrase(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'QuickPhrase(id: $id, content: $content, createdAt: $createdAt)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuickPhrase && 
           other.id == id && 
           other.content == content && 
           other.createdAt == createdAt;
  }

  @override
  int get hashCode => id.hashCode ^ content.hashCode ^ createdAt.hashCode;
}

/// 系统快捷短语模型
@JsonSerializable()
class SystemQuickPhrase {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'content')
  final String content;

  const SystemQuickPhrase({
    required this.id,
    required this.content,
  });

  /// 从JSON创建SystemQuickPhrase对象
  factory SystemQuickPhrase.fromJson(Map<String, dynamic> json) => _$SystemQuickPhraseFromJson(json);

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$SystemQuickPhraseToJson(this);

  @override
  String toString() => 'SystemQuickPhrase(id: $id, content: $content)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SystemQuickPhrase && 
           other.id == id && 
           other.content == content;
  }

  @override
  int get hashCode => id.hashCode ^ content.hashCode;
}
