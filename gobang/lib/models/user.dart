import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

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

/// 用户模型
@JsonSerializable()
class User {
  @JsonKey(name: 'userId')
  final String userId;

  @JsonKey(name: 'username')
  final String username;

  @JsonKey(name: 'nickname')
  final String nickname;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'avatar')
  final Avatar? avatar;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;
  
  const User({
    required this.userId,
    required this.username,
    required this.nickname,
    required this.email,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  /// 从JSON创建User对象
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// 复制并修改部分字段
  User copyWith({
    String? userId,
    String? username,
    String? nickname,
    String? email,
    Avatar? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is User &&
        other.userId == userId &&
        other.username == username &&
        other.nickname == nickname &&
        other.email == email &&
        other.avatar == avatar &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }
  
  @override
  int get hashCode {
    return userId.hashCode ^
        username.hashCode ^
        nickname.hashCode ^
        email.hashCode ^
        avatar.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
  
  @override
  String toString() {
    return 'User(userId: $userId, username: $username, nickname: $nickname, email: $email, avatar: $avatar, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// 登录请求模型
@JsonSerializable()
class LoginRequest {
  @JsonKey(name: 'username')
  final String username;
  
  @JsonKey(name: 'password')
  final String password;
  
  const LoginRequest({
    required this.username,
    required this.password,
  });
  
  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

/// 注册请求模型
@JsonSerializable()
class RegisterRequest {
  @JsonKey(name: 'username')
  final String username;
  
  @JsonKey(name: 'email')
  final String email;
  
  @JsonKey(name: 'password')
  final String password;
  
  @JsonKey(name: 'nickname')
  final String nickname;
  
  const RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.nickname,
  });
  
  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

/// 忘记密码请求模型
@JsonSerializable()
class ForgotPasswordRequest {
  @JsonKey(name: 'email')
  final String email;
  
  const ForgotPasswordRequest({
    required this.email,
  });
  
  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) => _$ForgotPasswordRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
}

/// 重置密码请求模型
@JsonSerializable()
class ResetPasswordRequest {
  @JsonKey(name: 'email')
  final String email;
  
  @JsonKey(name: 'code')
  final String code;
  
  @JsonKey(name: 'newPassword')
  final String newPassword;
  
  const ResetPasswordRequest({
    required this.email,
    required this.code,
    required this.newPassword,
  });
  
  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) => _$ResetPasswordRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}

/// 修改密码请求模型
@JsonSerializable()
class ChangePasswordRequest {
  @JsonKey(name: 'email')
  final String? email;
  
  @JsonKey(name: 'code')
  final String? code;
  
  @JsonKey(name: 'newPassword')
  final String? newPassword;
  
  const ChangePasswordRequest({
    this.email,
    this.code,
    this.newPassword,
  });
  
  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) => _$ChangePasswordRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);
}
