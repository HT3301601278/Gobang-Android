import 'package:json_annotation/json_annotation.dart';
import 'avatar.dart';
import 'user_stats.dart';

part 'user.g.dart';

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

  @JsonKey(name: 'stats')
  final UserStats? stats;

  @JsonKey(name: 'online')
  final bool? online;

  const User({
    required this.userId,
    required this.username,
    required this.nickname,
    required this.email,
    this.avatar,
    this.createdAt,
    this.updatedAt,
    this.stats,
    this.online,
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
    UserStats? stats,
    bool? online,
  }) {
    return User(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      stats: stats ?? this.stats,
      online: online ?? this.online,
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
        other.updatedAt == updatedAt &&
        other.stats == stats &&
        other.online == online;
  }
  
  @override
  int get hashCode {
    return userId.hashCode ^
        username.hashCode ^
        nickname.hashCode ^
        email.hashCode ^
        avatar.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        stats.hashCode ^
        online.hashCode;
  }
  
  @override
  String toString() {
    return 'User(userId: $userId, username: $username, nickname: $nickname, email: $email, avatar: $avatar, createdAt: $createdAt, updatedAt: $updatedAt, stats: $stats, online: $online)';
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
