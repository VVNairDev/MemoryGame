import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_memory_game/bloc/game_bloc.dart';
import 'package:number_memory_game/bloc/game_event.dart';
import 'package:number_memory_game/bloc/game_state.dart';
import 'package:number_memory_game/screens/game_play_screen.dart';
import 'package:number_memory_game/screens/game_result_screen.dart';
import 'package:number_memory_game/screens/home_screen.dart';
import 'package:number_memory_game/utils/game_utils.dart';
import 'package:number_memory_game/utils/app_constants.dart';

void main() {
  setupSystemUI();
  runApp(const MemoryGameApp());
}

class MemoryGameApp extends StatelessWidget {
  const MemoryGameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Memory Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0D47A1),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D47A1),
          elevation: 0,
        ),
      ),
      home: BlocProvider(
        create: (context) => GameBloc(gameUtils: GameUtils()),
        child: const MemoryGameHome(),
      ),
    );
  }
}

class MemoryGameHome extends StatelessWidget {
  const MemoryGameHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameInitial) {
          return const HomeScreen();
        } else if (state is GameLoadingState) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00D4FF),
              ),
            ),
          );
        } else if (state is SequenceDisplayingState ||
            state is PlayerInputState ||
            state is LevelCompleteState ||
            state is GamePlayingState) {
          return const GamePlayScreen();
        } else if (state is GameOverState) {
          return const GameResultScreen();
        } else if (state is ErrorState) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 50, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<GameBloc>()
                          .add(const ResetGameEvent());
                    },
                    child: const Text('Go Home'),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
