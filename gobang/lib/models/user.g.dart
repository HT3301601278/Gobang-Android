// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  userId: json['userId'] as String,
  username: json['username'] as String,
  nickname: json['nickname'] as String,
  email: json['email'] as String,
  avatar:
      json['avatar'] == null
          ? null
          : Avatar.fromJson(json['avatar'] as Map<String, dynamic>),
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  stats:
      json['stats'] == null
          ? null
          : UserStats.fromJson(json['stats'] as Map<String, dynamic>),
  online: json['online'] as bool?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'userId': instance.userId,
  'username': instance.username,
  'nickname': instance.nickname,
  'email': instance.email,
  'avatar': instance.avatar,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'stats': instance.stats,
  'online': instance.online,
};

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
  username: json['username'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      nickname: json['nickname'] as String,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'nickname': instance.nickname,
    };

ForgotPasswordRequest _$ForgotPasswordRequestFromJson(
  Map<String, dynamic> json,
) => ForgotPasswordRequest(email: json['email'] as String);

Map<String, dynamic> _$ForgotPasswordRequestToJson(
  ForgotPasswordRequest instance,
) => <String, dynamic>{'email': instance.email};

ResetPasswordRequest _$ResetPasswordRequestFromJson(
  Map<String, dynamic> json,
) => ResetPasswordRequest(
  email: json['email'] as String,
  code: json['code'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$ResetPasswordRequestToJson(
  ResetPasswordRequest instance,
) => <String, dynamic>{
  'email': instance.email,
  'code': instance.code,
  'newPassword': instance.newPassword,
};

ChangePasswordRequest _$ChangePasswordRequestFromJson(
  Map<String, dynamic> json,
) => ChangePasswordRequest(
  email: json['email'] as String?,
  code: json['code'] as String?,
  newPassword: json['newPassword'] as String?,
);

Map<String, dynamic> _$ChangePasswordRequestToJson(
  ChangePasswordRequest instance,
) => <String, dynamic>{
  'email': instance.email,
  'code': instance.code,
  'newPassword': instance.newPassword,
};
