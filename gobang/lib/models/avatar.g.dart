// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Avatar _$AvatarFromJson(Map<String, dynamic> json) =>
    Avatar(type: json['type'] as String, url: json['url'] as String);

Map<String, dynamic> _$AvatarToJson(Avatar instance) => <String, dynamic>{
  'type': instance.type,
  'url': instance.url,
};

SystemAvatar _$SystemAvatarFromJson(Map<String, dynamic> json) => SystemAvatar(
  id: json['id'] as String,
  url: json['url'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$SystemAvatarToJson(SystemAvatar instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'name': instance.name,
    };
