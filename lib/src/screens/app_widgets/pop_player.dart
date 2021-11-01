import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks/src/controllers/pop_sound.dart';
import 'package:stocks/src/services/portfolio.dart';

class PopSound extends StatelessWidget {
  const PopSound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///  Portfolio service reference
    final Portfolio portfolio = Portfolio();

    Provider.of<PopSoundController>(context);
    final AudioCache player = AudioCache(prefix: 'assets/sounds/', duckAudio: true);
    if (!portfolio.doneOnce) return const SizedBox();
    player.play('pop.mp3', volume: 0.2);
    return const SizedBox();
  }
}
