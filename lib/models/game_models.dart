import 'package:equatable/equatable.dart';

class GameLevel extends Equatable {
  final int level;
  final int sequenceLength;
  final int displayDuration;
  final int totalLevels;

  const GameLevel({
    required this.level,
    required this.sequenceLength,
    required this.displayDuration,
    this.totalLevels = 100,
  });

  GameLevel copyWith({
    int? level,
    int? sequenceLength,
    int? displayDuration,
    int? totalLevels,
  }) {
    return GameLevel(
      level: level ?? this.level,
      sequenceLength: sequenceLength ?? this.sequenceLength,
      displayDuration: displayDuration ?? this.displayDuration,
      totalLevels: totalLevels ?? this.totalLevels,
    );
  }

  @override
  List<Object?> get props => [level, sequenceLength, displayDuration, totalLevels];
}

class GameStats extends Equatable {
  final int highestLevel;
  final int totalGamesPlayed;
  final DateTime lastPlayedDate;

  const GameStats({
    required this.highestLevel,
    required this.totalGamesPlayed,
    required this.lastPlayedDate,
  });

  GameStats copyWith({
    int? highestLevel,
    int? totalGamesPlayed,
    DateTime? lastPlayedDate,
  }) {
    return GameStats(
      highestLevel: highestLevel ?? this.highestLevel,
      totalGamesPlayed: totalGamesPlayed ?? this.totalGamesPlayed,
      lastPlayedDate: lastPlayedDate ?? this.lastPlayedDate,
    );
  }

  @override
  List<Object?> get props => [highestLevel, totalGamesPlayed, lastPlayedDate];
}

class GameResult extends Equatable {
  final int levelReached;
  final int correctAttempts;
  final int wrongAttempts;
  final DateTime playedDate;
  final Duration gameDuration;

  const GameResult({
    required this.levelReached,
    required this.correctAttempts,
    required this.wrongAttempts,
    required this.playedDate,
    required this.gameDuration,
  });

  @override
  List<Object?> get props => [
        levelReached,
        correctAttempts,
        wrongAttempts,
        playedDate,
        gameDuration,
      ];
}
