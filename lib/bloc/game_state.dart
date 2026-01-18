import 'package:equatable/equatable.dart';
import 'package:number_memory_game/models/game_models.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {
  const GameInitial();
}

class LevelSelectionState extends GameState {
  const LevelSelectionState();
}

class GamePlayingState extends GameState {
  final GameLevel currentLevel;
  final List<int> sequence;
  final List<int> playerInput;
  final bool isDisplaying;
  final int correctAttempts;
  final int wrongAttempts;

  const GamePlayingState({
    required this.currentLevel,
    required this.sequence,
    required this.playerInput,
    required this.isDisplaying,
    required this.correctAttempts,
    required this.wrongAttempts,
  });

  GamePlayingState copyWith({
    GameLevel? currentLevel,
    List<int>? sequence,
    List<int>? playerInput,
    bool? isDisplaying,
    int? correctAttempts,
    int? wrongAttempts,
  }) {
    return GamePlayingState(
      currentLevel: currentLevel ?? this.currentLevel,
      sequence: sequence ?? this.sequence,
      playerInput: playerInput ?? this.playerInput,
      isDisplaying: isDisplaying ?? this.isDisplaying,
      correctAttempts: correctAttempts ?? this.correctAttempts,
      wrongAttempts: wrongAttempts ?? this.wrongAttempts,
    );
  }

  @override
  List<Object?> get props => [
        currentLevel,
        sequence,
        playerInput,
        isDisplaying,
        correctAttempts,
        wrongAttempts,
      ];
}

class SequenceDisplayingState extends GameState {
  final GameLevel currentLevel;
  final List<int> sequence;
  final int highlightedIndex;

  const SequenceDisplayingState({
    required this.currentLevel,
    required this.sequence,
    required this.highlightedIndex,
  });

  @override
  List<Object?> get props => [currentLevel, sequence, highlightedIndex];
}

class PlayerInputState extends GameState {
  final GameLevel currentLevel;
  final List<int> sequence;
  final List<int> playerInput;
  final int correctAttempts;
  final int wrongAttempts;

  const PlayerInputState({
    required this.currentLevel,
    required this.sequence,
    required this.playerInput,
    required this.correctAttempts,
    required this.wrongAttempts,
  });

  @override
  List<Object?> get props => [
        currentLevel,
        sequence,
        playerInput,
        correctAttempts,
        wrongAttempts,
      ];
}

class LevelCompleteState extends GameState {
  final GameLevel currentLevel;
  final int correctAttempts;
  final int wrongAttempts;

  const LevelCompleteState({
    required this.currentLevel,
    required this.correctAttempts,
    required this.wrongAttempts,
  });

  @override
  List<Object?> get props => [currentLevel, correctAttempts, wrongAttempts];
}

class GameOverState extends GameState {
  final GameResult result;

  const GameOverState(this.result);

  @override
  List<Object?> get props => [result];
}

class GameLoadingState extends GameState {
  const GameLoadingState();
}

class ErrorState extends GameState {
  final String message;

  const ErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
