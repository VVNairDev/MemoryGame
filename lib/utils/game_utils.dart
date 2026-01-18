class GameUtils {
  static const int maxLevels = 100;
  static const int initialSequenceLength = 3;
  static const int maxDigits = 15;
  static const int maxDisplayDuration = 1500;
  static const int minDisplayDuration = 800;
  static const int playerInputTimeLimit = 30000; // 30 seconds for beginner

  GameUtils();

  int calculateSequenceLength(int level) {
    // Progression: Level 1: 3, Level 2: 4, Level 3: 5, ... Level 13: 15, Level 14+: 15 (max digits)
    int length = 3 + (level - 1);
    return length > maxDigits ? maxDigits : length;
  }

  int calculateDisplayDuration(int level, int sequenceLength) {
    // Display duration decreases as level increases
    // At level 1: 1500ms, gradually decreases to 800ms minimum
    int duration = 1500 - (level * 20);
    return duration < minDisplayDuration ? minDisplayDuration : duration;
  }

  int calculatePlayerInputTimeLimit(int level) {
    // Time limit based on sequence length and level
    // Start with 30 seconds, reduce based on level
    // Minimum is 5 seconds
    int timeLimit = playerInputTimeLimit - (level * 100);
    return timeLimit < 5000 ? 5000 : timeLimit;
  }

  int calculateDifficulty(int level) {
    return ((level / maxLevels) * 100).toInt();
  }

  String getDifficultyLabel(int level) {
    if (level <= 10) return 'Beginner';
    if (level <= 30) return 'Easy';
    if (level <= 50) return 'Medium';
    if (level <= 70) return 'Hard';
    if (level <= 90) return 'Very Hard';
    return 'Extreme';
  }
}
