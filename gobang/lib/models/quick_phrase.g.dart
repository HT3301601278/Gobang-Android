// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_phrase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuickPhrase _$QuickPhraseFromJson(Map<String, dynamic> json) => QuickPhrase(
  id: json['id'] as String,
  content: json['content'] as String,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$QuickPhraseToJson(QuickPhrase instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

SystemQuickPhrase _$SystemQuickPhraseFromJson(Map<String, dynamic> json) =>
    SystemQuickPhrase(
      id: json['id'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$SystemQuickPhraseToJson(SystemQuickPhrase instance) =>
    <String, dynamic>{'id': instance.id, 'content': instance.content};
