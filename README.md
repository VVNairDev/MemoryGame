# Number Memory Game

A challenging number memory game built with Flutter and BLoC architecture. Test and improve your memory skills through 100 difficulty levels!

## Features

✨ **100 Difficulty Levels** - Progressive challenge from easy to extreme
🎮 **Interactive Gameplay** - Tap numbers to recreate sequences
📊 **Detailed Statistics** - Track your performance metrics
🎨 **Beautiful UI** - Modern gradient design with smooth animations
⚡ **Responsive Design** - Works perfectly on all Android devices
🏆 **Performance Tracking** - Remember your best achievements

## Game Rules

1. **Watch & Memorize** - A sequence of digits appears on screen
2. **Remember** - The sequence displays for a limited time based on difficulty
3. **Recall** - Tap the digits in the exact order you saw them
4. **Advance** - Each correct sequence increases in length
5. **One Mistake** - Game ends on a single wrong tap

## Difficulty Progression

- **Levels 1-10** (Beginner) - 3-4 digit sequences
- **Levels 11-30** (Easy) - 4-5 digit sequences
- **Levels 31-50** (Medium) - 5-6 digit sequences
- **Levels 51-70** (Hard) - 6-7 digit sequences
- **Levels 71-90** (Very Hard) - 7-8 digit sequences
- **Levels 91-100** (Extreme) - 8+ digit sequences

## Architecture

Built with **BLoC (Business Logic Component)** pattern:
- **GameBloc** - Manages all game state and logic
- **GameEvents** - User actions and system events
- **GameStates** - UI representation of game states
- **Models** - Data classes for game entities

## Project Structure

```
lib/
├── bloc/
│   ├── game_bloc.dart
│   ├── game_event.dart
│   └── game_state.dart
├── models/
│   └── game_models.dart
├── screens/
│   ├── home_screen.dart
│   ├── game_play_screen.dart
│   └── game_result_screen.dart
├── widgets/
│   └── game_widgets.dart
├── utils/
│   └── game_utils.dart
└── main.dart
```

## Dependencies

- **flutter_bloc** (8.1.3) - State management
- **bloc** (8.1.2) - Business logic
- **equatable** (2.0.5) - Value equality
- **google_fonts** (6.1.0) - Custom fonts
- **gap** (3.0.1) - Spacing widget
- **lottie** (2.7.0) - Animations
- **confetti** (0.7.0) - Celebration effects
- **shared_preferences** (2.2.2) - Local storage
- **intl** (0.19.0) - Internationalization

## Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/number-memory-game.git
   cd number-memory-game
   ```

2. **Get Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

## Tips for Best Performance

1. **Early Levels** - Focus on getting patterns into memory
2. **Middle Levels** - Use visualization techniques
3. **Higher Levels** - Try chunking digits into groups
4. **Practice** - Play regularly to improve memory capacity

## Version History

- **v1.0.0** - Initial release with 100 levels



## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Contact

For questions or feedback, please open an issue on GitHub.

---

**Ready to challenge your memory?** Download Number Memory from Google Play Store today!
