import 'package:stocks/src/models/bus_events.dart';

import '/src/globals.dart';

class SoundManager {
  static SoundManager? _instance;

  SoundManager._internal() {
    appEventBus.on<PlaySound>().listen((event) {
      _playSound(event.soundFile);
    });
  }

  factory SoundManager() => _instance ??= SoundManager._internal();

  /// PlaySound event callback.
  void _playSound(String fileName) {
    appEventBus.fire(Notify(EventStatus.success, '$fileName is playing'));
  }
}
