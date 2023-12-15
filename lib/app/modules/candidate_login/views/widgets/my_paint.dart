import 'dart:math' as math;

import 'package:flutter/material.dart';

class SemiCircleWidget extends StatelessWidget {
  final double? diameter;
  final double? sweepAngle;
  final Color? color;

  const SemiCircleWidget({
    Key? key,
    this.diameter = 200,
    @required this.sweepAngle,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(sweepAngle, color),
      size: Size(diameter!, diameter!),
    );
  }
}

class MyPainter extends CustomPainter {
  MyPainter(this.sweepAngle, this.color);
  final double? sweepAngle;
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    double degToRad(double deg) => deg * (math.pi / 180.0);

    var paint1 = Paint()
      ..color = color! // Color(0xff63aa65)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 14;
    //draw arc
    final path1 = Path()
      ..arcTo(
        Rect.fromCenter(
            center: Offset((size.height) / 2, (size.width) / 2),
            width: size.height - 15,
            height: size.height - 15),
        // Offset(size.height - 130, size.width - 130) &
        //     Size(size.height, size.width),
        degToRad(180), //radians
        degToRad(sweepAngle!), //radians
        false,
      );
    canvas.drawPath(path1, paint1); // 8.
    // final Paint paint = Paint()
    //   ..strokeWidth = 60.0 // 1.
    //   ..style = PaintingStyle.stroke // 2.
    //   ..color = color!; // 3.

    // final path = Path()
    //   ..arcTo(
    //       // 4.
    //       Rect.fromCenter(
    //         center: Offset((size.height) / 2, size.width / 2),
    //         height: size.height - 60,
    //         width: size.width - 60,
    //       ), // 5.
    //       degToRad(180), // 6.
    //       degToRad(sweepAngle!), // 7.
    //       false);

    // canvas.drawPath(path, paint); // 8.
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
