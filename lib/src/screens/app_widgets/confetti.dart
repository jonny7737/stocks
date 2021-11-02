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
      ConfettiController(duration: const Duration(seconds: 100));

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

  Path drawDollar(Size size) {
    final path = Path();

    // path.lineTo(size.width * 0.95, size.height * 0.6);
    // path.cubicTo(size.width * 0.95, size.height * 0.65, size.width * 0.92, size.height * 0.7,
    //     size.width * 0.84, size.height * 0.73);
    // path.cubicTo(size.width * 0.76, size.height * 0.77, size.width * 0.66, size.height * 0.79,
    //     size.width * 0.54, size.height * 0.79);
    // path.cubicTo(size.width * 0.54, size.height * 0.79, size.width * 0.54, size.height * 0.97,
    //     size.width * 0.54, size.height * 0.97);
    // path.cubicTo(size.width * 0.54, size.height * 0.97, size.width * 0.43, size.height * 0.97,
    //     size.width * 0.43, size.height * 0.97);
    // path.cubicTo(size.width * 0.43, size.height * 0.97, size.width * 0.43, size.height * 0.79,
    //     size.width * 0.43, size.height * 0.79);
    // path.cubicTo(size.width * 0.34, size.height * 0.79, size.width * 0.27, size.height * 0.79,
    //     size.width * 0.19, size.height * 0.78);
    // path.cubicTo(size.width * 0.12, size.height * 0.77, size.width * 0.06, size.height * 0.76, 0,
    //     size.height * 0.75);
    // path.cubicTo(0, size.height * 0.75, 0, size.height * 0.65, 0, size.height * 0.65);
    // path.cubicTo(0, size.height * 0.65, size.width * 0.02, size.height * 0.65, size.width * 0.02,
    //     size.height * 0.65);
    // path.cubicTo(size.width * 0.03, size.height * 0.66, size.width * 0.05, size.height * 0.66,
    //     size.width * 0.08, size.height * 0.67);
    // path.cubicTo(size.width * 0.11, size.height * 0.68, size.width * 0.14, size.height * 0.69,
    //     size.width * 0.17, size.height * 0.69);
    // path.cubicTo(size.width / 5, size.height * 0.7, size.width * 0.24, size.height * 0.71,
    //     size.width * 0.29, size.height * 0.71);
    // path.cubicTo(size.width / 3, size.height * 0.72, size.width * 0.38, size.height * 0.72,
    //     size.width * 0.43, size.height * 0.72);
    // path.cubicTo(size.width * 0.43, size.height * 0.72, size.width * 0.43, size.height / 2,
    //     size.width * 0.43, size.height / 2);
    // path.cubicTo(size.width * 0.4, size.height / 2, size.width * 0.38, size.height / 2,
    //     size.width * 0.36, size.height / 2);
    // path.cubicTo(size.width * 0.34, size.height * 0.49, size.width * 0.32, size.height * 0.49,
    //     size.width * 0.3, size.height * 0.49);
    // path.cubicTo(size.width * 0.19, size.height * 0.47, size.width * 0.12, size.height * 0.45,
    //     size.width * 0.08, size.height * 0.43);
    // path.cubicTo(size.width * 0.03, size.height * 0.4, size.width * 0.01, size.height * 0.36,
    //     size.width * 0.01, size.height * 0.32);
    // path.cubicTo(size.width * 0.01, size.height * 0.27, size.width * 0.05, size.height * 0.23,
    //     size.width * 0.12, size.height / 5);
    // path.cubicTo(size.width * 0.19, size.height * 0.16, size.width * 0.3, size.height * 0.14,
    //     size.width * 0.43, size.height * 0.14);
    // path.cubicTo(size.width * 0.43, size.height * 0.14, size.width * 0.43, 0, size.width * 0.43, 0);
    // path.cubicTo(size.width * 0.43, 0, size.width * 0.54, 0, size.width * 0.54, 0);
    // path.cubicTo(size.width * 0.54, 0, size.width * 0.54, size.height * 0.14, size.width * 0.54,
    //     size.height * 0.14);
    // path.cubicTo(size.width * 0.6, size.height * 0.14, size.width * 0.67, size.height * 0.14,
    //     size.width * 0.73, size.height * 0.15);
    // path.cubicTo(size.width * 0.8, size.height * 0.16, size.width * 0.86, size.height * 0.16,
    //     size.width * 0.9, size.height * 0.17);
    // path.cubicTo(size.width * 0.9, size.height * 0.17, size.width * 0.9, size.height * 0.27,
    //     size.width * 0.9, size.height * 0.27);
    // path.cubicTo(size.width * 0.9, size.height * 0.27, size.width * 0.89, size.height * 0.27,
    //     size.width * 0.89, size.height * 0.27);
    // path.cubicTo(size.width * 0.84, size.height * 0.26, size.width * 0.79, size.height * 0.24,
    //     size.width * 0.74, size.height * 0.23);
    // path.cubicTo(size.width * 0.69, size.height * 0.22, size.width * 0.62, size.height / 5,
    //     size.width * 0.54, size.height / 5);
    // path.cubicTo(size.width * 0.54, size.height / 5, size.width * 0.54, size.height * 0.43,
    //     size.width * 0.54, size.height * 0.43);
    // path.cubicTo(size.width * 0.56, size.height * 0.43, size.width * 0.58, size.height * 0.43,
    //     size.width * 0.6, size.height * 0.43);
    // path.cubicTo(size.width * 0.62, size.height * 0.44, size.width * 0.64, size.height * 0.44,
    //     size.width * 0.66, size.height * 0.44);
    // path.cubicTo(size.width * 0.75, size.height * 0.45, size.width * 0.82, size.height * 0.47,
    //     size.width * 0.88, size.height * 0.49);
    // path.cubicTo(size.width * 0.93, size.height * 0.52, size.width * 0.95, size.height * 0.56,
    //     size.width * 0.95, size.height * 0.6);
    // path.cubicTo(size.width * 0.95, size.height * 0.6, size.width * 0.95, size.height * 0.6,
    //     size.width * 0.95, size.height * 0.6);
    // path.lineTo(size.width * 0.43, size.height * 0.42);
    // path.cubicTo(size.width * 0.43, size.height * 0.42, size.width * 0.43, size.height / 5,
    //     size.width * 0.43, size.height / 5);
    // path.cubicTo(size.width * 0.36, size.height / 5, size.width * 0.3, size.height * 0.22,
    //     size.width * 0.26, size.height * 0.24);
    // path.cubicTo(size.width / 5, size.height * 0.26, size.width * 0.19, size.height * 0.28,
    //     size.width * 0.19, size.height * 0.31);
    // path.cubicTo(size.width * 0.19, size.height * 0.34, size.width / 5, size.height * 0.36,
    //     size.width * 0.24, size.height * 0.38);
    // path.cubicTo(size.width * 0.27, size.height * 0.39, size.width * 0.34, size.height * 0.41,
    //     size.width * 0.43, size.height * 0.42);
    // path.cubicTo(size.width * 0.43, size.height * 0.42, size.width * 0.43, size.height * 0.42,
    //     size.width * 0.43, size.height * 0.42);
    // path.lineTo(size.width * 0.77, size.height * 0.61);
    // path.cubicTo(size.width * 0.77, size.height * 0.58, size.width * 0.76, size.height * 0.56,
    //     size.width * 0.72, size.height * 0.55);
    // path.cubicTo(size.width * 0.68, size.height * 0.53, size.width * 0.62, size.height * 0.52,
    //     size.width * 0.54, size.height * 0.51);
    // path.cubicTo(size.width * 0.54, size.height * 0.51, size.width * 0.54, size.height * 0.72,
    //     size.width * 0.54, size.height * 0.72);
    // path.cubicTo(size.width * 0.61, size.height * 0.72, size.width * 0.67, size.height * 0.71,
    //     size.width * 0.71, size.height * 0.69);
    // path.cubicTo(size.width * 0.75, size.height * 0.67, size.width * 0.77, size.height * 0.65,
    //     size.width * 0.77, size.height * 0.61);
    // path.cubicTo(size.width * 0.77, size.height * 0.61, size.width * 0.77, size.height * 0.61,
    //     size.width * 0.77, size.height * 0.61);

    path.lineTo(size.width * 0.4, -0.01);
    path.cubicTo(size.width * 0.4, -0.01, size.width * 0.4, size.height * 0.13, size.width * 0.4,
        size.height * 0.13);
    path.cubicTo(size.width * 0.28, size.height * 0.13, size.width * 0.18, size.height * 0.15,
        size.width * 0.1, size.height * 0.19);
    path.cubicTo(size.width * 0.1, size.height * 0.19, size.width * 0.1, size.height * 0.19,
        size.width * 0.1, size.height * 0.19);
    path.cubicTo(size.width * 0.1, size.height * 0.19, size.width * 0.1, size.height * 0.19,
        size.width * 0.1, size.height * 0.19);
    path.cubicTo(size.width * 0.02, size.height * 0.22, -0.02, size.height * 0.27, -0.02,
        size.height * 0.32);
    path.cubicTo(-0.02, size.height * 0.37, size.width * 0.01, size.height * 0.4, size.width * 0.06,
        size.height * 0.43);
    path.cubicTo(size.width * 0.06, size.height * 0.43, size.width * 0.06, size.height * 0.43,
        size.width * 0.06, size.height * 0.43);
    path.cubicTo(size.width * 0.06, size.height * 0.43, size.width * 0.06, size.height * 0.43,
        size.width * 0.06, size.height * 0.43);
    path.cubicTo(size.width * 0.11, size.height * 0.46, size.width * 0.19, size.height * 0.49,
        size.width * 0.29, size.height / 2);
    path.cubicTo(size.width * 0.29, size.height / 2, size.width * 0.29, size.height / 2,
        size.width * 0.29, size.height / 2);
    path.cubicTo(size.width * 0.31, size.height / 2, size.width / 3, size.height * 0.51,
        size.width * 0.35, size.height * 0.51);
    path.cubicTo(size.width * 0.35, size.height * 0.51, size.width * 0.35, size.height * 0.51,
        size.width * 0.35, size.height * 0.51);
    path.cubicTo(size.width * 0.35, size.height * 0.51, size.width * 0.35, size.height * 0.51,
        size.width * 0.35, size.height * 0.51);
    path.cubicTo(size.width * 0.37, size.height * 0.51, size.width * 0.39, size.height * 0.51,
        size.width * 0.4, size.height * 0.51);
    path.cubicTo(size.width * 0.4, size.height * 0.51, size.width * 0.4, size.height * 0.71,
        size.width * 0.4, size.height * 0.71);
    path.cubicTo(size.width * 0.36, size.height * 0.7, size.width / 3, size.height * 0.7,
        size.width * 0.29, size.height * 0.7);
    path.cubicTo(size.width / 4, size.height * 0.69, size.width / 5, size.height * 0.69,
        size.width * 0.18, size.height * 0.68);
    path.cubicTo(size.width * 0.18, size.height * 0.68, size.width * 0.18, size.height * 0.68,
        size.width * 0.18, size.height * 0.68);
    path.cubicTo(size.width * 0.15, size.height * 0.68, size.width * 0.12, size.height * 0.67,
        size.width * 0.09, size.height * 0.66);
    path.cubicTo(size.width * 0.09, size.height * 0.66, size.width * 0.09, size.height * 0.66,
        size.width * 0.09, size.height * 0.66);
    path.cubicTo(size.width * 0.06, size.height * 0.65, size.width * 0.04, size.height * 0.64,
        size.width * 0.03, size.height * 0.64);
    path.cubicTo(size.width * 0.03, size.height * 0.64, size.width * 0.02, size.height * 0.64,
        size.width * 0.02, size.height * 0.64);
    path.cubicTo(size.width * 0.02, size.height * 0.64, -0.02, size.height * 0.64, -0.02,
        size.height * 0.64);
    path.cubicTo(-0.02, size.height * 0.64, -0.02, size.height * 0.76, -0.02, size.height * 0.76);
    path.cubicTo(-0.02, size.height * 0.76, -0.01, size.height * 0.76, -0.01, size.height * 0.76);
    path.cubicTo(size.width * 0.05, size.height * 0.78, size.width * 0.11, size.height * 0.79,
        size.width * 0.19, size.height * 0.79);
    path.cubicTo(size.width * 0.19, size.height * 0.79, size.width * 0.19, size.height * 0.79,
        size.width * 0.19, size.height * 0.79);
    path.cubicTo(size.width * 0.19, size.height * 0.79, size.width * 0.19, size.height * 0.79,
        size.width * 0.19, size.height * 0.79);
    path.cubicTo(size.width / 4, size.height * 0.8, size.width / 3, size.height * 0.81,
        size.width * 0.4, size.height * 0.81);
    path.cubicTo(size.width * 0.4, size.height * 0.81, size.width * 0.4, size.height,
        size.width * 0.4, size.height);
    path.cubicTo(size.width * 0.4, size.height, size.width * 0.56, size.height, size.width * 0.56,
        size.height);
    path.cubicTo(size.width * 0.56, size.height, size.width * 0.56, size.height * 0.8,
        size.width * 0.56, size.height * 0.8);
    path.cubicTo(size.width * 0.68, size.height * 0.8, size.width * 0.78, size.height * 0.78,
        size.width * 0.85, size.height * 0.74);
    path.cubicTo(size.width * 0.85, size.height * 0.74, size.width * 0.85, size.height * 0.74,
        size.width * 0.85, size.height * 0.74);
    path.cubicTo(size.width * 0.85, size.height * 0.74, size.width * 0.85, size.height * 0.74,
        size.width * 0.85, size.height * 0.74);
    path.cubicTo(size.width * 0.94, size.height * 0.7, size.width * 0.98, size.height * 0.66,
        size.width * 0.98, size.height * 0.6);
    path.cubicTo(size.width * 0.98, size.height * 0.55, size.width * 0.95, size.height * 0.51,
        size.width * 0.89, size.height * 0.49);
    path.cubicTo(size.width * 0.89, size.height * 0.49, size.width * 0.89, size.height * 0.49,
        size.width * 0.89, size.height * 0.49);
    path.cubicTo(size.width * 0.84, size.height * 0.46, size.width * 0.76, size.height * 0.44,
        size.width * 0.66, size.height * 0.43);
    path.cubicTo(size.width * 0.66, size.height * 0.43, size.width * 0.66, size.height * 0.43,
        size.width * 0.66, size.height * 0.43);
    path.cubicTo(size.width * 0.66, size.height * 0.43, size.width * 0.66, size.height * 0.43,
        size.width * 0.66, size.height * 0.43);
    path.cubicTo(size.width * 0.65, size.height * 0.43, size.width * 0.63, size.height * 0.42,
        size.width * 0.61, size.height * 0.42);
    path.cubicTo(size.width * 0.61, size.height * 0.42, size.width * 0.61, size.height * 0.42,
        size.width * 0.61, size.height * 0.42);
    path.cubicTo(size.width * 0.59, size.height * 0.42, size.width * 0.58, size.height * 0.42,
        size.width * 0.56, size.height * 0.42);
    path.cubicTo(size.width * 0.56, size.height * 0.42, size.width * 0.56, size.height * 0.22,
        size.width * 0.56, size.height * 0.22);
    path.cubicTo(size.width * 0.63, size.height * 0.23, size.width * 0.69, size.height * 0.23,
        size.width * 0.73, size.height * 0.24);
    path.cubicTo(size.width * 0.73, size.height * 0.24, size.width * 0.73, size.height * 0.24,
        size.width * 0.73, size.height * 0.24);
    path.cubicTo(size.width * 0.73, size.height * 0.24, size.width * 0.73, size.height * 0.24,
        size.width * 0.73, size.height * 0.24);
    path.cubicTo(size.width * 0.78, size.height / 4, size.width * 0.83, size.height * 0.27,
        size.width * 0.88, size.height * 0.28);
    path.cubicTo(size.width * 0.88, size.height * 0.28, size.width * 0.88, size.height * 0.29,
        size.width * 0.88, size.height * 0.29);
    path.cubicTo(size.width * 0.88, size.height * 0.29, size.width * 0.93, size.height * 0.29,
        size.width * 0.93, size.height * 0.29);
    path.cubicTo(size.width * 0.93, size.height * 0.29, size.width * 0.93, size.height * 0.17,
        size.width * 0.93, size.height * 0.17);
    path.cubicTo(size.width * 0.93, size.height * 0.17, size.width * 0.91, size.height * 0.16,
        size.width * 0.91, size.height * 0.16);
    path.cubicTo(size.width * 0.86, size.height * 0.15, size.width * 0.81, size.height * 0.14,
        size.width * 0.74, size.height * 0.14);
    path.cubicTo(size.width * 0.68, size.height * 0.13, size.width * 0.62, size.height * 0.13,
        size.width * 0.56, size.height * 0.12);
    path.cubicTo(
        size.width * 0.56, size.height * 0.12, size.width * 0.56, -0.01, size.width * 0.56, -0.01);
    path.cubicTo(size.width * 0.56, -0.01, size.width * 0.4, -0.01, size.width * 0.4, -0.01);
    path.lineTo(size.width * 0.45, size.height * 0.01);
    path.cubicTo(size.width * 0.45, size.height * 0.01, size.width * 0.51, size.height * 0.01,
        size.width * 0.51, size.height * 0.01);
    path.cubicTo(size.width * 0.51, size.height * 0.01, size.width * 0.51, size.height * 0.15,
        size.width * 0.51, size.height * 0.15);
    path.cubicTo(size.width * 0.51, size.height * 0.15, size.width * 0.54, size.height * 0.15,
        size.width * 0.54, size.height * 0.15);
    path.cubicTo(size.width * 0.6, size.height * 0.15, size.width * 0.66, size.height * 0.15,
        size.width * 0.73, size.height * 0.16);
    path.cubicTo(size.width * 0.79, size.height * 0.17, size.width * 0.84, size.height * 0.18,
        size.width * 0.88, size.height * 0.18);
    path.cubicTo(size.width * 0.88, size.height * 0.18, size.width * 0.88, size.height / 4,
        size.width * 0.88, size.height / 4);
    path.cubicTo(size.width * 0.84, size.height * 0.24, size.width * 0.8, size.height * 0.23,
        size.width * 0.75, size.height * 0.22);
    path.cubicTo(size.width * 0.75, size.height * 0.22, size.width * 0.75, size.height * 0.22,
        size.width * 0.75, size.height * 0.22);
    path.cubicTo(size.width * 0.7, size.height / 5, size.width * 0.63, size.height / 5,
        size.width * 0.54, size.height / 5);
    path.cubicTo(size.width * 0.54, size.height / 5, size.width * 0.51, size.height / 5,
        size.width * 0.51, size.height / 5);
    path.cubicTo(size.width * 0.51, size.height / 5, size.width * 0.51, size.height * 0.44,
        size.width * 0.51, size.height * 0.44);
    path.cubicTo(size.width * 0.51, size.height * 0.44, size.width * 0.53, size.height * 0.44,
        size.width * 0.53, size.height * 0.44);
    path.cubicTo(size.width * 0.55, size.height * 0.44, size.width * 0.57, size.height * 0.44,
        size.width * 0.59, size.height * 0.45);
    path.cubicTo(size.width * 0.59, size.height * 0.45, size.width * 0.59, size.height * 0.45,
        size.width * 0.59, size.height * 0.45);
    path.cubicTo(size.width * 0.59, size.height * 0.45, size.width * 0.59, size.height * 0.45,
        size.width * 0.59, size.height * 0.45);
    path.cubicTo(size.width * 0.62, size.height * 0.45, size.width * 0.64, size.height * 0.45,
        size.width * 0.65, size.height * 0.45);
    path.cubicTo(size.width * 0.74, size.height * 0.46, size.width * 0.81, size.height * 0.48,
        size.width * 0.86, size.height / 2);
    path.cubicTo(size.width * 0.86, size.height / 2, size.width * 0.86, size.height / 2,
        size.width * 0.86, size.height / 2);
    path.cubicTo(size.width * 0.86, size.height / 2, size.width * 0.86, size.height / 2,
        size.width * 0.86, size.height / 2);
    path.cubicTo(size.width * 0.91, size.height * 0.53, size.width * 0.93, size.height * 0.56,
        size.width * 0.93, size.height * 0.6);
    path.cubicTo(size.width * 0.93, size.height * 0.65, size.width * 0.89, size.height * 0.69,
        size.width * 0.82, size.height * 0.72);
    path.cubicTo(size.width * 0.75, size.height * 0.75, size.width * 0.66, size.height * 0.77,
        size.width * 0.54, size.height * 0.78);
    path.cubicTo(size.width * 0.54, size.height * 0.78, size.width * 0.51, size.height * 0.78,
        size.width * 0.51, size.height * 0.78);
    path.cubicTo(size.width * 0.51, size.height * 0.78, size.width * 0.51, size.height * 0.96,
        size.width * 0.51, size.height * 0.96);
    path.cubicTo(size.width * 0.51, size.height * 0.96, size.width * 0.45, size.height * 0.96,
        size.width * 0.45, size.height * 0.96);
    path.cubicTo(size.width * 0.45, size.height * 0.96, size.width * 0.45, size.height * 0.78,
        size.width * 0.45, size.height * 0.78);
    path.cubicTo(size.width * 0.45, size.height * 0.78, size.width * 0.43, size.height * 0.78,
        size.width * 0.43, size.height * 0.78);
    path.cubicTo(size.width * 0.35, size.height * 0.78, size.width * 0.27, size.height * 0.78,
        size.width / 5, size.height * 0.77);
    path.cubicTo(size.width / 5, size.height * 0.77, size.width / 5, size.height * 0.77,
        size.width / 5, size.height * 0.77);
    path.cubicTo(size.width * 0.13, size.height * 0.76, size.width * 0.07, size.height * 0.75,
        size.width * 0.03, size.height * 0.74);
    path.cubicTo(size.width * 0.03, size.height * 0.74, size.width * 0.03, size.height * 0.67,
        size.width * 0.03, size.height * 0.67);
    path.cubicTo(size.width * 0.04, size.height * 0.67, size.width * 0.05, size.height * 0.68,
        size.width * 0.07, size.height * 0.68);
    path.cubicTo(size.width * 0.07, size.height * 0.68, size.width * 0.07, size.height * 0.68,
        size.width * 0.07, size.height * 0.68);
    path.cubicTo(size.width * 0.07, size.height * 0.68, size.width * 0.07, size.height * 0.68,
        size.width * 0.07, size.height * 0.68);
    path.cubicTo(size.width * 0.1, size.height * 0.69, size.width * 0.13, size.height * 0.7,
        size.width * 0.16, size.height * 0.7);
    path.cubicTo(size.width * 0.16, size.height * 0.7, size.width * 0.16, size.height * 0.7,
        size.width * 0.16, size.height * 0.7);
    path.cubicTo(size.width * 0.16, size.height * 0.7, size.width * 0.16, size.height * 0.7,
        size.width * 0.16, size.height * 0.7);
    path.cubicTo(size.width / 5, size.height * 0.71, size.width * 0.24, size.height * 0.72,
        size.width * 0.28, size.height * 0.72);
    path.cubicTo(size.width * 0.28, size.height * 0.72, size.width * 0.28, size.height * 0.72,
        size.width * 0.28, size.height * 0.72);
    path.cubicTo(size.width * 0.28, size.height * 0.72, size.width * 0.28, size.height * 0.72,
        size.width * 0.28, size.height * 0.72);
    path.cubicTo(size.width / 3, size.height * 0.73, size.width * 0.37, size.height * 0.73,
        size.width * 0.43, size.height * 0.73);
    path.cubicTo(size.width * 0.43, size.height * 0.73, size.width * 0.45, size.height * 0.73,
        size.width * 0.45, size.height * 0.73);
    path.cubicTo(size.width * 0.45, size.height * 0.73, size.width * 0.45, size.height * 0.49,
        size.width * 0.45, size.height * 0.49);
    path.cubicTo(size.width * 0.45, size.height * 0.49, size.width * 0.43, size.height * 0.49,
        size.width * 0.43, size.height * 0.49);
    path.cubicTo(size.width * 0.41, size.height * 0.49, size.width * 0.38, size.height * 0.48,
        size.width * 0.36, size.height * 0.48);
    path.cubicTo(size.width * 0.36, size.height * 0.48, size.width * 0.36, size.height * 0.48,
        size.width * 0.36, size.height * 0.48);
    path.cubicTo(size.width * 0.36, size.height * 0.48, size.width * 0.36, size.height * 0.48,
        size.width * 0.36, size.height * 0.48);
    path.cubicTo(size.width * 0.34, size.height * 0.48, size.width * 0.32, size.height * 0.48,
        size.width * 0.3, size.height * 0.47);
    path.cubicTo(size.width * 0.3, size.height * 0.47, size.width * 0.3, size.height * 0.47,
        size.width * 0.3, size.height * 0.47);
    path.cubicTo(size.width * 0.3, size.height * 0.47, size.width * 0.3, size.height * 0.47,
        size.width * 0.3, size.height * 0.47);
    path.cubicTo(size.width / 5, size.height * 0.46, size.width * 0.13, size.height * 0.44,
        size.width * 0.09, size.height * 0.42);
    path.cubicTo(size.width * 0.05, size.height * 0.39, size.width * 0.03, size.height * 0.36,
        size.width * 0.03, size.height * 0.32);
    path.cubicTo(size.width * 0.03, size.height * 0.28, size.width * 0.07, size.height * 0.24,
        size.width * 0.13, size.height / 5);
    path.cubicTo(size.width / 5, size.height * 0.17, size.width * 0.3, size.height * 0.16,
        size.width * 0.43, size.height * 0.15);
    path.cubicTo(size.width * 0.43, size.height * 0.15, size.width * 0.45, size.height * 0.15,
        size.width * 0.45, size.height * 0.15);
    path.cubicTo(size.width * 0.45, size.height * 0.15, size.width * 0.45, size.height * 0.01,
        size.width * 0.45, size.height * 0.01);
    path.lineTo(size.width * 0.45, size.height / 5);
    path.cubicTo(size.width * 0.45, size.height / 5, size.width * 0.43, size.height / 5,
        size.width * 0.43, size.height / 5);
    path.cubicTo(size.width * 0.35, size.height / 5, size.width * 0.29, size.height / 5,
        size.width * 0.24, size.height * 0.23);
    path.cubicTo(size.width * 0.19, size.height / 4, size.width * 0.16, size.height * 0.28,
        size.width * 0.16, size.height * 0.31);
    path.cubicTo(size.width * 0.16, size.height * 0.34, size.width * 0.18, size.height * 0.37,
        size.width * 0.22, size.height * 0.39);
    path.cubicTo(size.width * 0.26, size.height * 0.41, size.width / 3, size.height * 0.42,
        size.width * 0.42, size.height * 0.43);
    path.cubicTo(size.width * 0.42, size.height * 0.43, size.width * 0.45, size.height * 0.43,
        size.width * 0.45, size.height * 0.43);
    path.cubicTo(size.width * 0.45, size.height * 0.43, size.width * 0.45, size.height * 0.42,
        size.width * 0.45, size.height * 0.42);
    path.cubicTo(size.width * 0.45, size.height * 0.42, size.width * 0.45, size.height / 5,
        size.width * 0.45, size.height / 5);
    path.lineTo(size.width * 0.4, size.height * 0.22);
    path.cubicTo(size.width * 0.4, size.height * 0.22, size.width * 0.4, size.height * 0.4,
        size.width * 0.4, size.height * 0.4);
    path.cubicTo(size.width / 3, size.height * 0.39, size.width * 0.28, size.height * 0.38,
        size.width / 4, size.height * 0.37);
    path.cubicTo(size.width * 0.23, size.height * 0.36, size.width / 5, size.height * 0.34,
        size.width / 5, size.height * 0.31);
    path.cubicTo(size.width / 5, size.height * 0.28, size.width * 0.23, size.height * 0.26,
        size.width * 0.27, size.height / 4);
    path.cubicTo(size.width * 0.27, size.height / 4, size.width * 0.27, size.height / 4,
        size.width * 0.27, size.height / 4);
    path.cubicTo(size.width * 0.27, size.height / 4, size.width * 0.27, size.height / 4,
        size.width * 0.27, size.height / 4);
    path.cubicTo(size.width * 0.31, size.height * 0.24, size.width * 0.35, size.height * 0.23,
        size.width * 0.4, size.height * 0.22);
    path.cubicTo(size.width * 0.4, size.height * 0.22, size.width * 0.4, size.height * 0.22,
        size.width * 0.4, size.height * 0.22);
    path.lineTo(size.width * 0.51, size.height / 2);
    path.cubicTo(size.width * 0.51, size.height / 2, size.width * 0.51, size.height * 0.73,
        size.width * 0.51, size.height * 0.73);
    path.cubicTo(size.width * 0.51, size.height * 0.73, size.width * 0.54, size.height * 0.73,
        size.width * 0.54, size.height * 0.73);
    path.cubicTo(size.width * 0.62, size.height * 0.73, size.width * 0.68, size.height * 0.72,
        size.width * 0.73, size.height * 0.7);
    path.cubicTo(size.width * 0.77, size.height * 0.68, size.width * 0.8, size.height * 0.65,
        size.width * 0.8, size.height * 0.61);
    path.cubicTo(size.width * 0.8, size.height * 0.58, size.width * 0.78, size.height * 0.55,
        size.width * 0.73, size.height * 0.54);
    path.cubicTo(size.width * 0.69, size.height * 0.52, size.width * 0.63, size.height * 0.51,
        size.width * 0.54, size.height / 2);
    path.cubicTo(size.width * 0.54, size.height / 2, size.width * 0.51, size.height / 2,
        size.width * 0.51, size.height / 2);
    path.lineTo(size.width * 0.56, size.height * 0.53);
    path.cubicTo(size.width * 0.63, size.height * 0.54, size.width * 0.68, size.height * 0.55,
        size.width * 0.7, size.height * 0.56);
    path.cubicTo(size.width * 0.7, size.height * 0.56, size.width * 0.7, size.height * 0.56,
        size.width * 0.7, size.height * 0.56);
    path.cubicTo(size.width * 0.7, size.height * 0.56, size.width * 0.7, size.height * 0.56,
        size.width * 0.7, size.height * 0.56);
    path.cubicTo(size.width * 0.73, size.height * 0.57, size.width * 0.75, size.height * 0.59,
        size.width * 0.75, size.height * 0.61);
    path.cubicTo(size.width * 0.75, size.height * 0.64, size.width * 0.73, size.height * 0.66,
        size.width * 0.7, size.height * 0.68);
    path.cubicTo(size.width * 0.7, size.height * 0.68, size.width * 0.7, size.height * 0.68,
        size.width * 0.7, size.height * 0.68);
    path.cubicTo(size.width * 0.7, size.height * 0.68, size.width * 0.7, size.height * 0.68,
        size.width * 0.7, size.height * 0.68);
    path.cubicTo(size.width * 0.67, size.height * 0.69, size.width * 0.62, size.height * 0.7,
        size.width * 0.56, size.height * 0.7);
    path.cubicTo(size.width * 0.56, size.height * 0.7, size.width * 0.56, size.height * 0.53,
        size.width * 0.56, size.height * 0.53);

    return path;
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
            gravity: 0.001,
            numberOfParticles: 20,
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

            createParticlePath: drawDollar, // define a custom shape/path.
          ),
        ),
      ],
    );
  }
}
