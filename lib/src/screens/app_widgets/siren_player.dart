import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SirenPlayer extends StatefulWidget {
  const SirenPlayer({Key? key}) : super(key: key);

  @override
  _SirenPlayerState createState() => _SirenPlayerState();
}

class _SirenPlayerState extends State<SirenPlayer> {
  AudioCache player = AudioCache(prefix: 'assets/sounds/');

  @override
  void initState() {
    super.initState();
    // player = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    playSiren();
  }

  Future<void> playSiren() async {
    await player.play('siren1.mp3', volume: 0.3, mode: PlayerMode.LOW_LATENCY);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
