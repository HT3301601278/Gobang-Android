import 'package:json_annotation/json_annotation.dart';

part 'avatar.g.dart';

/// 头像模型
@JsonSerializable()
class Avatar {
  @JsonKey(name: 'url')
  final String url;

  const Avatar({
    required this.url,
  });

  /// 从JSON创建Avatar对象
  factory Avatar.fromJson(Map<String, dynamic> json) => _$AvatarFromJson(json);

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$AvatarToJson(this);

  /// 复制并修改部分字段
  Avatar copyWith({
    String? url,
  }) {
    return Avatar(
      url: url ?? this.url,
    );
  }

  @override
  String toString() => 'Avatar(url: $url)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Avatar && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;
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
