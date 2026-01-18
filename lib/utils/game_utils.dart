class GameUtils {
  static const int maxLevels = 100;
  static const int initialSequenceLength = 3;
  static const int maxDisplayDuration = 1500;
  static const int minDisplayDuration = 1000;
  static const int playerInputTimeLimit = 30000; // 30 seconds for beginner

  GameUtils();

  int calculateSequenceLength(int level) {
    // Progression: Level 1: 3, Level 2: 4, Level 3: 5, ... Level 13: 15, Level 14+: 15 (with reduced time)
    int length = 3 + (level - 1);
    return length > 15 ? 15 : length;
  }

  int calculateDisplayDuration(int level, int sequenceLength) {
    // Base display time: 1500ms for level 1, increases with sequence length
    // Each digit gets 1000ms minimum + 300ms per digit in sequence
    int baseDuration = 1500 + (sequenceLength * 300);
    int duration = baseDuration - (level * 3);
    return duration < minDisplayDuration ? minDisplayDuration : duration;
  }

  int calculatePlayerInputTimeLimit(int level) {
    // Beginner: 30 seconds, decreases to 10 seconds at higher levels
    int timeLimit = playerInputTimeLimit - (level * 200);
    return timeLimit < 10000 ? 10000 : timeLimit;
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
