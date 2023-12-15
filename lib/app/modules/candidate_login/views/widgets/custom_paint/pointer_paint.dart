import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class PointerPaint extends CustomPainter {
  final ui.Image image;
  final double angle;
  PointerPaint(this.image, this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    var fillBrush = Paint()
      ..color = Colors.green.shade900 //const Color(0xFF444974).withOpacity(.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);
    var outerCircleRadius = radius - 50;
    var innerCircleRadius = radius - 50;

    // drawRotatedImage(canvas, image as Image, 300, 300, 0);
    for (int i = 0; i < 360; i += 36) {
      var x1 = centerX + outerCircleRadius * cos(angle * pi / 180);
      var y1 = centerX + outerCircleRadius * sin(angle * pi / 180);

      var x2 = centerX + innerCircleRadius * cos(angle * pi / 180);
      var y2 = centerX + innerCircleRadius * sin(angle * pi / 180);

      // canvas.rotate(i.toDouble());
      // canvas.drawCircle(
      //     Offset(x1, y1), radius / 10, fillBrush..strokeWidth = 2);
      // rotate(canvas, centerX, centerY, i*pi/3.toDouble());

      // canvas.save();
      // canvas.translate(image.width / 2, image.height / 2);
      // canvas.rotate(i.toDouble());

      // canvas.drawCircle(Offset.zero, 20, Paint()..color = Colors.yellow);

      // canvas.drawImage(image, Offset(x1, y1), fillBrush);
      // final width = image.width.toDouble();
      // final height = image.height.toDouble();
      // canvas
      canvas.drawImage(image, Offset(x2, y2), fillBrush);
      canvas.drawCircle(Offset(x2, y2), 5, fillBrush);
      // canvas.drawLine(Offset(5, 5), Offset(10, 10), fillBrush);
      // canvas.translate(width / 2, height / 2);
      // canvas.rotate(angle);
      // canvas.translate(-width / 2, -height / 2);
      // canvas.drawImage(image, Offset(x1, y1), fillBrush);
      // canvas.rotate(i.toDouble());
      // canvas.restore();
      // var c = rotate(
      //     canvas,
      //     image,
      //     Offset(image.height / 2 + outerCircleRadius * cos(i * pi / 180),
      //         image.width / 2 + outerCircleRadius * sin(i * pi / 180)),
      //     Size(300, 300),
      //     i.toDouble());
      // c.drawImage(image, Offset(x1, y1), fillBrush);
      // rotate(canvas, image, Offset(centerX - 30, centerY - 30), Size(300, 300),
      //     i + 180.toDouble());
      // canvas.drawPaint(image, offset, paint)
      // canvas.drawLine(
      //     Offset(x1, y1),
      //     // 5,
      //     Offset(x2, y2),
      //     fillBrush
      //       // ..strokeWidth = 2
      //       ..strokeCap = StrokeCap.round);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
// import 'dart:ui' as ui;

//Add this CustomPaint widget to the Widget Tree
// CustomPaint(
//     size: Size(WIDTH, (WIDTH*0.9487179487179487).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
//     painter: RPSCustomPainter(),
// )

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff008000).withOpacity(1.0);
    canvas.drawCircle(Offset(size.width * 0.4358795, size.height * 0.5316757),
        size.width * 0.3205128, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.8579462, size.height * 0.3306946);
    path_1.cubicTo(
        size.width * 0.8579462,
        size.height * 0.3306946,
        size.width * 0.7564231,
        size.height * 0.5942946,
        size.width * 0.7434795,
        size.height * 0.6142486);
    path_1.lineTo(size.width * 0.5490872, size.height * 0.2179346);
    path_1.lineTo(size.width * 0.8579462, size.height * 0.3306946);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff008000).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
