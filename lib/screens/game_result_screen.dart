import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_memory_game/bloc/game_bloc.dart';
import 'package:number_memory_game/bloc/game_event.dart';
import 'package:number_memory_game/bloc/game_state.dart';
import 'package:intl/intl.dart';

class GameResultScreen extends StatefulWidget {
  const GameResultScreen({Key? key}) : super(key: key);

  @override
  State<GameResultScreen> createState() => _GameResultScreenState();
}

class _GameResultScreenState extends State<GameResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameOverState) {
          return _buildGameResult(context, state);
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildGameResult(BuildContext context, GameOverState state) {
    final result = state.result;
    final accuracy = result.correctAttempts > 0
        ? ((result.correctAttempts /
                (result.correctAttempts + result.wrongAttempts)) *
            100)
        : 0;

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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(32),
                  // Game Over Animation
                  ScaleTransition(
                    scale: Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.elasticOut,
                      ),
                    ),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.withOpacity(0.2),
                        border: Border.all(
                          color: Colors.red,
                          width: 3,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.close,
                          size: 50,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const Gap(24),
                  // Game Over Title
                  Text(
                    'Game Over',
                    style: GoogleFonts.roboto(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Gap(12),
                  // Level Reached
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF00D4FF),
                          Color(0xFF0099CC),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Level ${result.levelReached}',
                      style: GoogleFonts.roboto(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D47A1),
                      ),
                    ),
                  ),
                  const Gap(32),
                  // Stats Container
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white24,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Game Statistics',
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF00D4FF),
                          ),
                        ),
                        const Gap(24),
                        _buildStatCard(
                          'Sequences Completed',
                          '${result.correctAttempts}',
                          Icons.check_circle,
                          Colors.green,
                        ),
                        const Gap(16),
                        _buildStatCard(
                          'Wrong Attempts',
                          '${result.wrongAttempts}',
                          Icons.cancel,
                          Colors.red,
                        ),
                        const Gap(16),
                        _buildStatCard(
                          'Accuracy',
                          '${accuracy.toStringAsFixed(1)}%',
                          Icons.trending_up,
                          const Color(0xFF00D4FF),
                        ),
                      ],
                    ),
                  ),
                  const Gap(32),
                  // Performance Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.deepPurple.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      _getPerformanceMessage(result.levelReached),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const Gap(32),
                  // Action Buttons
                  Column(
                    children: [
                      // Play Again Button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF00D4FF),
                              Color(0xFF0099CC),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xFF00D4FF).withOpacity(0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              context
                                  .read<GameBloc>()
                                  .add(const ResetGameEvent());
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Center(
                              child: Text(
                                'PLAY AGAIN',
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0D47A1),
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Gap(12),
                      // Home Button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white24,
                            width: 2,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              context
                                  .read<GameBloc>()
                                  .add(const ResetGameEvent());
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Center(
                              child: Text(
                                'HOME',
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _getPerformanceMessage(int levelReached) {
    if (levelReached <= 5) {
      return 'Nice try! Keep practicing and you\'ll improve with each game. Focus on each digit carefully.';
    } else if (levelReached <= 15) {
      return 'Good effort! You\'re on the right track. Try to visualize the numbers as they appear.';
    } else if (levelReached <= 30) {
      return 'Impressive! You\'re building strong memory skills. Challenge yourself with higher difficulty levels.';
    } else if (levelReached <= 50) {
      return 'Excellent! Your memory is really sharp. You\'re doing great at this challenging game.';
    } else if (levelReached <= 75) {
      return 'Outstanding! You\'re a memory champion. Very few players reach this level!';
    } else {
      return '🏆 LEGENDARY! You\'ve achieved an extraordinary memory feat. You are a true master of this game!';
    }
  }
}
