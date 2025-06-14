import 'package:json_annotation/json_annotation.dart';

part 'avatar.g.dart';

/// 头像模型
@JsonSerializable()
class Avatar {
  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'url')
  final String url;

  const Avatar({
    required this.type,
    required this.url,
  });

  /// 从JSON创建Avatar对象
  factory Avatar.fromJson(Map<String, dynamic> json) => _$AvatarFromJson(json);

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$AvatarToJson(this);

  /// 复制并修改部分字段
  Avatar copyWith({
    String? type,
    String? url,
  }) {
    return Avatar(
      type: type ?? this.type,
      url: url ?? this.url,
    );
  }

  @override
  String toString() => 'Avatar(type: $type, url: $url)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Avatar && other.type == type && other.url == url;
  }

  @override
  int get hashCode => type.hashCode ^ url.hashCode;
}

/// 系统头像模型
@JsonSerializable()
class SystemAvatar {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'url')
  final String url;

  @JsonKey(name: 'name')
  final String name;

  const SystemAvatar({
    required this.id,
    required this.url,
    required this.name,
  });

  /// 从JSON创建SystemAvatar对象
  factory SystemAvatar.fromJson(Map<String, dynamic> json) => _$SystemAvatarFromJson(json);

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$SystemAvatarToJson(this);

  @override
  String toString() => 'SystemAvatar(id: $id, url: $url, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SystemAvatar && 
           other.id == id && 
           other.url == url && 
           other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ url.hashCode ^ name.hashCode;
}
