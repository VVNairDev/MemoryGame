import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_memory_game/utils/sound_manager.dart';

class NumberButton extends StatefulWidget {
  final int number;
  final VoidCallback onTap;
  final bool isHighlighted;
  final bool isSelected;

  const NumberButton({
    Key? key,
    required this.number,
    required this.onTap,
    this.isHighlighted = false,
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<NumberButton> createState() => _NumberButtonState();
}

class _NumberButtonState extends State<NumberButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    if (widget.isHighlighted) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(NumberButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHighlighted && !oldWidget.isHighlighted) {
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    SoundManager().playClickSound();
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedScale(
          scale: _isPressed ? 0.9 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: widget.isHighlighted
                    ? [const Color(0xFF00FFFF), const Color(0xFF0099FF)]
                    : _isPressed
                        ? [const Color(0xFF4CAF50), const Color(0xFF45a049)]
                        : widget.isSelected
                            ? [const Color(0xFF6200EA), const Color(0xFF3700B3)]
                            : [const Color(0xFF2196F3), const Color(0xFF1976D2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                if (widget.isHighlighted)
                  BoxShadow(
                    color: const Color(0xFF00FFFF).withOpacity(0.8),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                BoxShadow(
                  color: _isPressed
                      ? const Color(0xFF4CAF50).withOpacity(0.6)
                      : widget.isHighlighted
                          ? const Color(0xFF00D4FF).withOpacity(0.6)
                          : Colors.black.withOpacity(0.3),
                  blurRadius: widget.isHighlighted ? 25 : _isPressed ? 15 : 8,
                  spreadRadius: widget.isHighlighted ? 3 : _isPressed ? 2 : 0,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${widget.number}',
                style: GoogleFonts.roboto(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DigitDisplay extends StatefulWidget {
  final List<int> digits;

  const DigitDisplay({
    Key? key,
    required this.digits,
  }) : super(key: key);

  @override
  State<DigitDisplay> createState() => _DigitDisplayState();
}

class _DigitDisplayState extends State<DigitDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..forward();
  }

  @override
  void didUpdateWidget(DigitDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if digits list changed (by length or content)
    if (oldWidget.digits.length != widget.digits.length ||
        !_listsEqual(oldWidget.digits, widget.digits)) {
      // Restart animation from beginning
      _animationController.forward(from: 0.0);
    }
  }

  // Helper method to compare two lists
  bool _listsEqual(List<int> list1, List<int> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.95, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A237E).withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF00D4FF),
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00D4FF).withOpacity(0.6),
              blurRadius: 20,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Text(
          widget.digits.isEmpty
              ? '- - -'
              : widget.digits.map((d) => d.toString()).join(' '),
          style: GoogleFonts.roboto(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF00FFFF),
            letterSpacing: 8,
            shadows: [
              Shadow(
                color: const Color(0xFF00D4FF).withOpacity(0.8),
                blurRadius: 15,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LevelProgressBar extends StatelessWidget {
  final int currentLevel;
  final int maxLevel;

  const LevelProgressBar({
    Key? key,
    required this.currentLevel,
    required this.maxLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level $currentLevel',
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '/$maxLevel',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.white60,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: currentLevel / maxLevel,
            minHeight: 8,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFF00D4FF),
            ),
          ),
        ),
      ],
    );
  }
}
class CountdownTimer extends StatefulWidget {
  final int initialSeconds;
  final VoidCallback? onTimeUp;

  const CountdownTimer({
    Key? key,
    required this.initialSeconds,
    this.onTimeUp,
  }) : super(key: key);

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int remainingSeconds;
  late int initialSeconds;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.initialSeconds;
    initialSeconds = widget.initialSeconds;
    _startCountdown();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          remainingSeconds--;
        });
        if (remainingSeconds > 0) {
          _startCountdown();
        } else {
          widget.onTimeUp?.call();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWarning = remainingSeconds <= 5;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isWarning 
            ? Colors.red.withOpacity(0.2) 
            : const Color(0xFF1A237E).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isWarning ? Colors.red : const Color(0xFF00D4FF),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Time Remaining',
            style: GoogleFonts.roboto(
              fontSize: 10,
              color: Colors.white60,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$remainingSeconds',
            style: GoogleFonts.roboto(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isWarning ? Colors.red : const Color(0xFF00D4FF),
            ),
          ),
        ],
      ),
    );
  }
}