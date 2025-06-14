// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStats _$UserStatsFromJson(Map<String, dynamic> json) => UserStats(
  totalGames: (json['totalGames'] as num).toInt(),
  wins: (json['wins'] as num).toInt(),
  losses: (json['losses'] as num).toInt(),
  draws: (json['draws'] as num).toInt(),
  winRate: (json['winRate'] as num?)?.toDouble(),
  recentGames: json['recentGames'] as List<dynamic>?,
);

Map<String, dynamic> _$UserStatsToJson(UserStats instance) => <String, dynamic>{
  'totalGames': instance.totalGames,
  'wins': instance.wins,
  'losses': instance.losses,
  'draws': instance.draws,
  'winRate': instance.winRate,
  'recentGames': instance.recentGames,
};
