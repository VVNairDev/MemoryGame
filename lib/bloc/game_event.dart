import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class StartGameEvent extends GameEvent {
  final int initialLevel;

  const StartGameEvent(this.initialLevel);

  @override
  List<Object?> get props => [initialLevel];
}

class GenerateSequenceEvent extends GameEvent {
  const GenerateSequenceEvent();
}

class DisplaySequenceEvent extends GameEvent {
  const DisplaySequenceEvent();
}

class HideSequenceEvent extends GameEvent {
  const HideSequenceEvent();
}

class PlayerInputEvent extends GameEvent {
  final int digit;

  const PlayerInputEvent(this.digit);

  @override
  List<Object?> get props => [digit];
}

class ClearInputEvent extends GameEvent {
  const ClearInputEvent();
}

class SubmitAnswerEvent extends GameEvent {
  const SubmitAnswerEvent();
}

class NextLevelEvent extends GameEvent {
  const NextLevelEvent();
}

class ResetGameEvent extends GameEvent {
  const ResetGameEvent();
}

class QuitGameEvent extends GameEvent {
  const QuitGameEvent();
}
