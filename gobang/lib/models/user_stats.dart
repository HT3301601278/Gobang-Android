import 'package:json_annotation/json_annotation.dart';

part 'user_stats.g.dart';

/// 用户统计模型
@JsonSerializable()
class UserStats {
  @JsonKey(name: 'totalGames')
  final int totalGames;

  @JsonKey(name: 'wins')
  final int wins;

  @JsonKey(name: 'losses')
  final int losses;

  @JsonKey(name: 'draws')
  final int draws;

  @JsonKey(name: 'winRate')
  final double? winRate;

  @JsonKey(name: 'recentGames')
  final List<dynamic>? recentGames;

  const UserStats({
    required this.totalGames,
    required this.wins,
    required this.losses,
    required this.draws,
    this.winRate,
    this.recentGames,
  });

  /// 从JSON创建UserStats对象
  factory UserStats.fromJson(Map<String, dynamic> json) => _$UserStatsFromJson(json);

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$UserStatsToJson(this);

  /// 计算胜率
  double get calculatedWinRate {
    if (totalGames == 0) return 0.0;
    return (wins / totalGames) * 100;
  }

  /// 复制并修改部分字段
  UserStats copyWith({
    int? totalGames,
    int? wins,
    int? losses,
    int? draws,
    double? winRate,
    List<dynamic>? recentGames,
  }) {
    return UserStats(
      totalGames: totalGames ?? this.totalGames,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      draws: draws ?? this.draws,
      winRate: winRate ?? this.winRate,
      recentGames: recentGames ?? this.recentGames,
    );
  }

  @override
  String toString() => 'UserStats(totalGames: $totalGames, wins: $wins, losses: $losses, draws: $draws, winRate: $winRate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserStats && 
           other.totalGames == totalGames && 
           other.wins == wins && 
           other.losses == losses && 
           other.draws == draws && 
           other.winRate == winRate;
  }

  @override
  int get hashCode => 
      totalGames.hashCode ^ 
      wins.hashCode ^ 
      losses.hashCode ^ 
      draws.hashCode ^ 
      winRate.hashCode;
}
