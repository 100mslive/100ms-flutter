//Dart imports
import 'dart:math' as math;

//Package imports
import 'package:flutter/material.dart';

class CircleWavePainter extends CustomPainter {
  final double waveRadius;
  late Paint wavePaint, paint1;
  final bool isAudioOff;
  CircleWavePainter(this.waveRadius,this.isAudioOff) {
    wavePaint = Paint()
      ..color = Colors.blue.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    paint1 = Paint()
      ..color = Colors.blue.shade700
      ..style = PaintingStyle.fill;
  }
  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width;
    double centerY = size.height;
    double maxRadius = hypot(centerX, centerY);

    var currentRadius = waveRadius;
    canvas.drawCircle(Offset(centerX, centerY), 50, paint1);

    if(!isAudioOff){
        while (currentRadius < maxRadius) {
          canvas.drawCircle(Offset(centerX, centerY), currentRadius, wavePaint);
        currentRadius += 10.0;
      }
    }
  }

  @override
  bool shouldRepaint(CircleWavePainter oldDelegate) {
    return oldDelegate.waveRadius != waveRadius;
  }

  double hypot(double x, double y) {
    return math.sqrt(x * x + y * y);
  }
}
