import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SirenPlayer extends StatefulWidget {
  const SirenPlayer({Key? key}) : super(key: key);

  @override
  _SirenPlayerState createState() => _SirenPlayerState();
}

class _SirenPlayerState extends State<SirenPlayer> {
  late AudioPlayer player;
  late AudioPlayer player2;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player2 = AudioPlayer();
    playSiren();
  }

  Future<void> playSiren() async {
    await player.setAsset('assets/sounds/siren1.mp3');
    await player.setClip(start: const Duration(seconds: 1), end: const Duration(seconds: 4));
    await player.setVolume(3.0);
    player.play();
  }

  @override
  void dispose() {
    player.dispose();
    player2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
