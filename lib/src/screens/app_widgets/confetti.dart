import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class AppConfettiWidget extends StatefulWidget {
  const AppConfettiWidget({Key? key}) : super(key: key);

  @override
  _AppConfettiWidgetState createState() => _AppConfettiWidgetState();
}

class _AppConfettiWidgetState extends State<AppConfettiWidget> {
  final ConfettiController _controllerCenter =
      ConfettiController(duration: const Duration(seconds: 10));

  @override
  void initState() {
    // _controllerCenter =
    //     ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenter.play();
    super.initState();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step), halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //CENTER -- Blast
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            numberOfParticles: 5,
            confettiController: _controllerCenter,
            blastDirectionality:
                BlastDirectionality.explosive, // don't specify a direction, blast randomly
            shouldLoop: false, // start again as soon as the animation is finished
            maxBlastForce: 60,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.yellow,
              Colors.yellow,
              Colors.purple,
              Colors.blue,
            ], // manually specify the colors to be used

            createParticlePath: drawStar, // define a custom shape/path.
          ),
        ),
      ],
    );
  }
}
