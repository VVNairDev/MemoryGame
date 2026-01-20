import 'dart:math';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  late AudioPlayer _audioPlayer;
  bool _soundEnabled = true;

  factory SoundManager() {
    return _instance;
  }

  SoundManager._internal() {
    _audioPlayer = AudioPlayer();
  }

  /// Generate a simple WAV file with a sine wave tone
  Future<Uint8List> _generateTone(
    int frequency,
    int durationMs, {
    int sampleRate = 44100,
  }) async {
    final int numSamples = (sampleRate * durationMs) ~/ 1000;
    final List<int> samples = [];

    // Generate sine wave samples
    for (int i = 0; i < numSamples; i++) {
      double sample =
          32767 * 0.3 * sin(2 * pi * frequency * i / sampleRate);
      samples.add((sample.toInt()) & 0xFF);
      samples.add(((sample.toInt()) >> 8) & 0xFF);
    }

    // Create a simple WAV file header
    final BytesBuilder wav = BytesBuilder();

    // RIFF header
    wav.addByte(0x52); // 'R'
    wav.addByte(0x49); // 'I'
    wav.addByte(0x46); // 'F'
    wav.addByte(0x46); // 'F'

    // File size (36 + data size)
    int fileSize = 36 + samples.length;
    wav.addByte(fileSize & 0xFF);
    wav.addByte((fileSize >> 8) & 0xFF);
    wav.addByte((fileSize >> 16) & 0xFF);
    wav.addByte((fileSize >> 24) & 0xFF);

    // "WAVE"
    wav.addByte(0x57); // 'W'
    wav.addByte(0x41); // 'A'
    wav.addByte(0x56); // 'V'
    wav.addByte(0x45); // 'E'

    // "fmt " chunk
    wav.addByte(0x66); // 'f'
    wav.addByte(0x6D); // 'm'
    wav.addByte(0x74); // 't'
    wav.addByte(0x20); // ' '

    // Chunk size (16 for PCM)
    wav.addByte(16);
    wav.addByte(0);
    wav.addByte(0);
    wav.addByte(0);

    // Audio format (1 = PCM)
    wav.addByte(1);
    wav.addByte(0);

    // Number of channels (1 = mono)
    wav.addByte(1);
    wav.addByte(0);

    // Sample rate
    wav.addByte(sampleRate & 0xFF);
    wav.addByte((sampleRate >> 8) & 0xFF);
    wav.addByte((sampleRate >> 16) & 0xFF);
    wav.addByte((sampleRate >> 24) & 0xFF);

    // Byte rate
    int byteRate = sampleRate * 2;
    wav.addByte(byteRate & 0xFF);
    wav.addByte((byteRate >> 8) & 0xFF);
    wav.addByte((byteRate >> 16) & 0xFF);
    wav.addByte((byteRate >> 24) & 0xFF);

    // Block align (2 bytes per sample)
    wav.addByte(2);
    wav.addByte(0);

    // Bits per sample (16)
    wav.addByte(16);
    wav.addByte(0);

    // "data" chunk
    wav.addByte(0x64); // 'd'
    wav.addByte(0x61); // 'a'
    wav.addByte(0x74); // 't'
    wav.addByte(0x61); // 'a'

    // Data size
    int dataSize = samples.length;
    wav.addByte(dataSize & 0xFF);
    wav.addByte((dataSize >> 8) & 0xFF);
    wav.addByte((dataSize >> 16) & 0xFF);
    wav.addByte((dataSize >> 24) & 0xFF);

    // Add samples
    wav.add(samples);

    return wav.toBytes();
  }

  Future<void> _playTone(int frequency, int durationMs) async {
    if (!_soundEnabled) return;
    try {
      final Uint8List wavData = await _generateTone(frequency, durationMs);
      await _audioPlayer.play(BytesSource(wavData));
      print('🔊 Playing ${frequency}Hz tone for ${durationMs}ms');
    } catch (e) {
      print('Error playing tone: $e');
    }
  }

  // Simple click sound - high beep
  Future<void> playClickSound() async {
    await _playTone(600, 100);
  }

  // Display sound - notification beep
  Future<void> playNumberDisplaySound() async {
    await _playTone(500, 150);
  }

  // Win sound - ascending tone sequence
  Future<void> playWinSound() async {
    if (!_soundEnabled) return;
    try {
      await _playTone(600, 100);
      await Future.delayed(const Duration(milliseconds: 100));
      await _playTone(700, 100);
      await Future.delayed(const Duration(milliseconds: 100));
      await _playTone(800, 200);
    } catch (e) {
      print('Error playing win sound: $e');
    }
  }

  // Lose sound - descending tone sequence
  Future<void> playLoseSound() async {
    if (!_soundEnabled) return;
    try {
      await _playTone(600, 100);
      await Future.delayed(const Duration(milliseconds: 100));
      await _playTone(400, 100);
      await Future.delayed(const Duration(milliseconds: 100));
      await _playTone(200, 200);
    } catch (e) {
      print('Error playing lose sound: $e');
    }
  }

  // Level up sound - ding
  Future<void> playLevelUpSound() async {
    await _playTone(800, 150);
  }

  // Error sound - buzzer
  Future<void> playErrorSound() async {
    await _playTone(300, 200);
  }

  // Countdown sound
  Future<void> playCountdownSound() async {
    await _playTone(700, 100);
  }

  void toggleSound(bool enabled) {
    _soundEnabled = enabled;
    if (_soundEnabled) {
      print('🔊 Sound enabled');
    } else {
      print('🔇 Sound disabled');
    }
  }

  bool get soundEnabled => _soundEnabled;

  void dispose() {
    _audioPlayer.dispose();
  }
}
