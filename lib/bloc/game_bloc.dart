import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_memory_game/bloc/game_event.dart';
import 'package:number_memory_game/bloc/game_state.dart';
import 'package:number_memory_game/models/game_models.dart';
import 'package:number_memory_game/utils/game_utils.dart';
import 'package:number_memory_game/utils/sound_manager.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameUtils gameUtils;
  late GameLevel currentLevel;
  late List<int> sequence;
  late List<int> playerInput;
  late DateTime gameStartTime;
  int correctAttempts = 0;
  int wrongAttempts = 0;

  GameBloc({required this.gameUtils}) : super(const GameInitial()) {
    on<StartGameEvent>(_onStartGame);
    on<GenerateSequenceEvent>(_onGenerateSequence);
    on<DisplaySequenceEvent>(_onDisplaySequence);
    on<HideSequenceEvent>(_onHideSequence);
    on<PlayerInputEvent>(_onPlayerInput);
    on<ClearInputEvent>(_onClearInput);
    on<SubmitAnswerEvent>(_onSubmitAnswer);
    on<NextLevelEvent>(_onNextLevel);
    on<ResetGameEvent>(_onResetGame);
    on<QuitGameEvent>(_onQuitGame);
  }

  FutureOr<void> _onStartGame(
    StartGameEvent event,
    Emitter<GameState> emit,
  ) async {
    emit(const GameLoadingState());
    gameStartTime = DateTime.now();
    correctAttempts = 0;
    wrongAttempts = 0;
    currentLevel = _generateGameLevel(event.initialLevel);
    sequence = [];
    playerInput = [];
    
    // Generate initial sequence with random digits based on level
    int sequenceLength = gameUtils.calculateSequenceLength(event.initialLevel);
    Random random = Random();
    for (int i = 0; i < sequenceLength; i++) {
      sequence.add(random.nextInt(10)); // 0-9
    }

    await Future.delayed(const Duration(milliseconds: 500));
    
    add(const DisplaySequenceEvent());
  }

  FutureOr<void> _onGenerateSequence(
    GenerateSequenceEvent event,
    Emitter<GameState> emit,
  ) {
    Random random = Random();
    // Only add a digit if we haven't reached the max
    if (sequence.length < GameUtils.maxDigits) {
      sequence.add(random.nextInt(10)); // 0-9
    }
    
    emit(GamePlayingState(
      currentLevel: currentLevel,
      sequence: sequence,
      playerInput: [],
      isDisplaying: true,
      correctAttempts: correctAttempts,
      wrongAttempts: wrongAttempts,
    ));

    add(const DisplaySequenceEvent());
  }

  FutureOr<void> _onDisplaySequence(
    DisplaySequenceEvent event,
    Emitter<GameState> emit,
  ) async {
    for (int i = 0; i < sequence.length; i++) {
      // Delay before showing next number (500ms)
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Play sound when displaying number
      SoundManager().playNumberDisplaySound();
      
      emit(SequenceDisplayingState(
        currentLevel: currentLevel,
        sequence: sequence,
        highlightedIndex: i,
      ));

      // Display the number for the calculated duration
      await Future.delayed(
        Duration(milliseconds: currentLevel.displayDuration),
      );
    }

    // Add delay before player input phase starts
    await Future.delayed(const Duration(milliseconds: 800));

    playerInput = [];
    emit(PlayerInputState(
      currentLevel: currentLevel,
      sequence: sequence,
      playerInput: playerInput,
      correctAttempts: correctAttempts,
      wrongAttempts: wrongAttempts,
    ));
  }

  FutureOr<void> _onHideSequence(
    HideSequenceEvent event,
    Emitter<GameState> emit,
  ) {
    emit(PlayerInputState(
      currentLevel: currentLevel,
      sequence: sequence,
      playerInput: playerInput,
      correctAttempts: correctAttempts,
      wrongAttempts: wrongAttempts,
    ));
  }

  FutureOr<void> _onPlayerInput(
    PlayerInputEvent event,
    Emitter<GameState> emit,
  ) {
    // Check if input is valid before adding
    if (playerInput.length < sequence.length) {
      playerInput.add(event.digit);
      // Create a new list instance for Equatable comparison
      final List<int> newPlayerInput = List.from(playerInput);

      // Check if the latest input is correct
      if (playerInput.last != sequence[playerInput.length - 1]) {
        wrongAttempts++;
        // Play error sound for wrong input
        SoundManager().playErrorSound();
        // Wrong input - show user what was correct
        emit(PlayerInputState(
          currentLevel: currentLevel,
          sequence: sequence,
          playerInput: newPlayerInput,
          correctAttempts: correctAttempts,
          wrongAttempts: wrongAttempts,
          showCorrectAnswer: true,
        ));

        Future.delayed(const Duration(milliseconds: 1500), () {
          add(const QuitGameEvent());
        });
      } else {
        // Correct input so far
        if (playerInput.length == sequence.length) {
          // Level completed
          correctAttempts++;
          // Play win sound
          SoundManager().playWinSound();
          emit(LevelCompleteState(
            currentLevel: currentLevel,
            correctAttempts: correctAttempts,
            wrongAttempts: wrongAttempts,
          ));
        } else {
          // More digits to enter
          emit(PlayerInputState(
            currentLevel: currentLevel,
            sequence: sequence,
            playerInput: newPlayerInput,
            correctAttempts: correctAttempts,
            wrongAttempts: wrongAttempts,
          ));
        }
      }
    }
  }

  FutureOr<void> _onClearInput(
    ClearInputEvent event,
    Emitter<GameState> emit,
  ) {
    playerInput = [];
    emit(PlayerInputState(
      currentLevel: currentLevel,
      sequence: sequence,
      playerInput: playerInput,
      correctAttempts: correctAttempts,
      wrongAttempts: wrongAttempts,
    ));
  }

  FutureOr<void> _onSubmitAnswer(
    SubmitAnswerEvent event,
    Emitter<GameState> emit,
  ) async {
    if (playerInput.length != sequence.length) {
      return;
    }

    bool isCorrect = _compareSequences(playerInput, sequence);
    if (isCorrect) {
      correctAttempts++;
      emit(LevelCompleteState(
        currentLevel: currentLevel,
        correctAttempts: correctAttempts,
        wrongAttempts: wrongAttempts,
      ));
    } else {
      wrongAttempts++;
      add(const QuitGameEvent());
    }
  }

  FutureOr<void> _onNextLevel(
    NextLevelEvent event,
    Emitter<GameState> emit,
  ) async {
    if (currentLevel.level >= 100) {
      // Game won - play level up sound
      SoundManager().playWinSound();
      add(const QuitGameEvent());
      return;
    }

    // Play level up sound
    SoundManager().playLevelUpSound();

    int nextLevel = currentLevel.level + 1;
    currentLevel = _generateGameLevel(nextLevel);
    playerInput = [];

    // Generate completely new random sequence for the new level
    Random random = Random();
    int requiredLength = gameUtils.calculateSequenceLength(nextLevel);
    
    // Clear and rebuild sequence with random digits
    sequence.clear();
    for (int i = 0; i < requiredLength; i++) {
      sequence.add(random.nextInt(10)); // 0-9
    }

    await Future.delayed(const Duration(milliseconds: 500));
    add(const DisplaySequenceEvent());
  }

  FutureOr<void> _onResetGame(
    ResetGameEvent event,
    Emitter<GameState> emit,
  ) {
    emit(const GameInitial());
  }

  FutureOr<void> _onQuitGame(
    QuitGameEvent event,
    Emitter<GameState> emit,
  ) {
    DateTime gameEndTime = DateTime.now();
    Duration gameDuration = gameEndTime.difference(gameStartTime);

    // Play lose sound
    SoundManager().playLoseSound();

    GameResult result = GameResult(
      levelReached: currentLevel.level,
      correctAttempts: correctAttempts,
      wrongAttempts: wrongAttempts,
      playedDate: gameStartTime,
      gameDuration: gameDuration,
    );

    emit(GameOverState(result));
  }

  GameLevel _generateGameLevel(int level) {
    int sequenceLength = gameUtils.calculateSequenceLength(level);
    int displayDuration = gameUtils.calculateDisplayDuration(level, sequenceLength);
    int timeLimit = gameUtils.calculatePlayerInputTimeLimit(level);

    return GameLevel(
      level: level,
      sequenceLength: sequenceLength,
      displayDuration: displayDuration,
      totalLevels: 100,
      timeLimit: timeLimit,
    );
  }

  bool _compareSequences(List<int> player, List<int> correct) {
    if (player.length != correct.length) return false;
    for (int i = 0; i < player.length; i++) {
      if (player[i] != correct[i]) return false;
    }
    return true;
  }
}
