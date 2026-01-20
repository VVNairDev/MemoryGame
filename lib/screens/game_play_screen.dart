import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_memory_game/bloc/game_bloc.dart';
import 'package:number_memory_game/bloc/game_event.dart';
import 'package:number_memory_game/bloc/game_state.dart';
import 'package:number_memory_game/widgets/game_widgets.dart';

class GamePlayScreen extends StatefulWidget {
  const GamePlayScreen({Key? key}) : super(key: key);

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is SequenceDisplayingState) {
          return _buildSequenceDisplay(context, state);
        } else if (state is PlayerInputState) {
          return _buildPlayerInput(context, state);
        } else if (state is LevelCompleteState) {
          return _buildLevelComplete(context, state);
        } else if (state is GamePlayingState) {
          return _buildGamePlaying(context, state);
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _buildSequenceDisplay(
    BuildContext context,
    SequenceDisplayingState state,
  ) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0D47A1),
              const Color(0xFF1A237E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Level Info
                    Text(
                      'Level ${state.currentLevel.level}',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00D4FF),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Display current digit being shown
                    Text(
                      'Remember:',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Large display of the sequence being shown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D4FF).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF00D4FF),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00D4FF).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Text(
                        state.sequence.isNotEmpty && state.highlightedIndex >= 0
                            ? '${state.sequence[state.highlightedIndex]}'
                            : '',
                        style: GoogleFonts.roboto(
                          fontSize: 120,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF00FFFF),
                          shadows: [
                            Shadow(
                              color: const Color(0xFF00FFFF).withOpacity(0.8),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Show full sequence at bottom
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF00D4FF),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Full Sequence:',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.white60,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.sequence.join(' • '),
                            style: GoogleFonts.roboto(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF00D4FF),
                              letterSpacing: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerInput(BuildContext context, PlayerInputState state) {
    final screenSize = MediaQuery.of(context).size;
    final isPortrait = screenSize.height > screenSize.width;
    final gridSize = isPortrait 
        ? screenSize.width * 0.85 
        : screenSize.height * 0.5;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0D47A1),
              const Color(0xFF1A237E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Level Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Level ${state.currentLevel.level}',
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF00D4FF),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: CountdownTimer(
                            initialSeconds: (state.currentLevel.timeLimit / 1000).toInt(),
                            onTimeUp: () {
                              context.read<GameBloc>().add(const QuitGameEvent());
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your Turn',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Display Input
                    DigitDisplay(digits: state.playerInput),
                    if (state.showCorrectAnswer) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Correct:',
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      DigitDisplay(digits: state.sequence),
                    ],
                    const SizedBox(height: 24),
                    // Number Grid for Input
                    Container(
                      width: gridSize,
                      height: gridSize + 50,
                      padding: const EdgeInsets.all(8),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          bool isSelected =
                              state.playerInput.contains(index) &&
                              state.playerInput.lastIndexOf(index) ==
                                  state.playerInput.length - 1;
                          return Center(
                            child: NumberButton(
                              number: index,
                              isSelected: isSelected,
                              onTap: () {
                                context
                                    .read<GameBloc>()
                                    .add(PlayerInputEvent(index));
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Quit Button
                    GestureDetector(
                      onTap: () {
                        context.read<GameBloc>().add(const QuitGameEvent());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelComplete(
    BuildContext context,
    LevelCompleteState state,
  ) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1B5E20),
              const Color(0xFF2E7D32),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.withOpacity(0.3),
                        border: Border.all(
                          color: Colors.green.shade200,
                          width: 3,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check,
                          size: 48,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Level Complete!',
                      style: GoogleFonts.roboto(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Level ${state.currentLevel.level}',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildStatRow('Correct', '${state.correctAttempts}'),
                          const SizedBox(height: 12),
                          _buildStatRow('Wrong', '${state.wrongAttempts}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (state.currentLevel.level < 100)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF00D4FF),
                                Color(0xFF0099CC),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                context.read<GameBloc>().add(const NextLevelEvent());
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Center(
                                child: Text(
                                  'NEXT LEVEL',
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0D47A1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFFD700),
                                Color(0xFFFFA500),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                context.read<GameBloc>().add(const ResetGameEvent());
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Center(
                                child: Text(
                                  '🎉 YOU WON! 🎉',
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGamePlaying(BuildContext context, GamePlayingState state) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0D47A1),
              const Color(0xFF1A237E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: CircularProgressIndicator(
              color: const Color(0xFF00D4FF),
              backgroundColor: Colors.white24,
              strokeWidth: 3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF00D4FF),
          ),
        ),
      ],
    );
  }
}
