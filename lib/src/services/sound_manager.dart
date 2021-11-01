import 'package:audioplayers/audioplayers.dart';
import 'package:stocks/src/models/bus_events.dart';

import '/src/globals.dart';

/// Event listener for PlaySound events.
class SoundManager {
  static SoundManager? _instance;

  SoundManager._internal() {
    appEventBus.on<PlaySound>().listen((event) {
      _playSound(event.soundFile);
    });
  }

  factory SoundManager() => _instance ??= SoundManager._internal();

  /// AudioCache local audio player pool
  final List<AudioCache> players = [
    AudioCache(prefix: 'assets/sounds/', duckAudio: true),
    AudioCache(prefix: 'assets/sounds/', duckAudio: true),
    AudioCache(prefix: 'assets/sounds/', duckAudio: true),
    AudioCache(prefix: 'assets/sounds/', duckAudio: true),
  ];

  int activePlayer = 0;
  AudioCache get nextPlayer {
    if (activePlayer == players.length) activePlayer = 0;
    return players[activePlayer++];
  }

  /// PlaySound event callback.
  /// Use next available player from pool.  Pool length is 4.
  /// This allows playing 4 simultaneous sound effects.
  void _playSound(String fileName) {
    if (!soundEnabled) return;
    nextPlayer.play(fileName, volume: 0.1);
  }
}
