import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:hajir/app/modules/candidate_login/views/widgets/custom_paint/pointer_paint.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class HolePainter extends CustomPainter {
  final width;
  final height;
  HolePainter(this.width, this.height);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    double y = height / 2.7;
    double x = width / 1.8;
    double w = 3;
    var rect = RRect.fromLTRBR(
        0, 0, width - 36, height - 36, const Radius.circular(0));
    paint.color = Colors.blue.withOpacity(.4);
    var rect2 = Rect.fromLTRB(
        width / 5 + w, 0 + w + height / 4, x + width / 5, y - w + height / 3);
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()
          ..addRRect(rect
              // RRect.fromLTRBR(100, 100, 300, 300, Radius.circular(10)),
              ),
        Path()
          ..addOval(rect2
              // Rect.fromCircle(center: Offset(200, 200), radius: 50),
              )
          ..close(),
      ),
      paint,
    );
    canvas.drawOval(
        rect2,
        paint
          ..style = PaintingStyle.stroke
          ..color = Colors.white
          ..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Clip extends CustomClipper<Path> {
  final double x;
  final double y;
  final double w;
  Clip({required this.x, required this.y, required this.w});

  @override
  Path getClip(Size size) {
    var path = Path();
    var rect = Rect.fromLTRB(0, 0, x, y);
    path.addOval(rect);
    path.fillType = PathFillType.evenOdd;
    var rect2 = Rect.fromLTRB(0 + w, 0 + w, x - w, y - w);
    path.addOval(rect2);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

Future<ui.Image> loadImage(String imageName) async {
  WidgetsFlutterBinding.ensureInitialized();
  final data = await rootBundle.load('assets/$imageName');
  return decodeImageFromList(data.buffer.asUint8List());
}

late ui.Image image;
main() async {
  image = await loadImage('Group 105.png');
  runApp(MaterialApp(
    home: Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: PointerWidget(
        image: image,
      ),
    ))),
  ));
}

class PointerWidget extends StatefulWidget {
  const PointerWidget({super.key, this.image});
  final dynamic image;

  @override
  State<PointerWidget> createState() => _PointerWidgetState();
}

class _PointerWidgetState extends State<PointerWidget> {
  double y = 300;
  double x = 200;
  double w = 3;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // body:
    double y = height / 2.7;
    double x = width / 1.8;
    return Container(
        height: height,
        width: width,
        color: Colors.yellow,
        child: Stack(
          children: [
            Center(
              child: Image.network(
                "https://www.holidify.com/images/bgImages/KATHMANDU.jpg",
                height: height,
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: CustomPaint(
                painter: HolePainter(width, height),
                child: Container(
                  alignment: Alignment.center,
                  height: height,
                  width: double.infinity,
                ),
              ),
            ),
            // Center(
            //     child: ClipPath(
            //         clipper: Clip(x: x, y: y, w: 3),
            //         child: Container(
            //           color: Colors.grey,
            //           height: y,
            //           width: x,
            //         ))),
          ],
        ));
    return Container(
      height: 300,
      // color: Colors.red,
      width: 300,
      child: Transform.rotate(
          angle: 30 * pi / 180,
          alignment: Alignment.center,
          child: CustomPaint(painter: PointerPaint(widget.image, 180))),
    );
  }
}

class MovingCardWidget extends StatefulWidget {
  const MovingCardWidget({super.key});

  @override
  State<MovingCardWidget> createState() => _MovingCardWidgetState();
}

class _MovingCardWidgetState extends State<MovingCardWidget>
    with SingleTickerProviderStateMixin {
  bool isFront = true;
  double verticalDrag = 0;
  late AnimationController controller;
  late Animation<double> animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (details) {
        controller.reset();

        setState(() {
          isFront = true;
          verticalDrag = 0;
        });
      },
      onVerticalDragUpdate: (details) {
        setState(() {
          verticalDrag += details.delta.dy;
          verticalDrag %= 360;

          setImageSide();
        });
      },
      onVerticalDragEnd: (details) {
        final double end = 360 - verticalDrag >= 180 ? 0 : 360;

        animation =
            Tween<double>(begin: verticalDrag, end: end).animate(controller)
              ..addListener(() {
                setState(() {
                  verticalDrag = animation.value;
                  setImageSide();
                });
              });
        controller.forward();
      },
      child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, .001)
            ..rotateX(verticalDrag / 180 * pi),
          child: isFront
              ? const Front()
              : Transform(
                  transform: Matrix4.identity()..rotateX(pi),
                  alignment: Alignment.center,
                  child: const Back(),
                )),
    );
  }

  void setImageSide() {
    if (verticalDrag <= 90 || verticalDrag >= 270) {
      isFront = true;
    } else {
      isFront = false;
    }
  }
}

class Back extends StatelessWidget {
  const Back({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 250,
      decoration: BoxDecoration(
          color: Colors.black,
          gradient: const LinearGradient(
              colors: [Colors.red, Colors.yellow, Colors.grey],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          borderRadius: BorderRadius.circular(4)),
    );
  }
}

class Front extends StatelessWidget {
  const Front({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 250,
      decoration: BoxDecoration(
          color: Colors.red,
          gradient: const LinearGradient(
              colors: [Colors.blue, Colors.green, Colors.grey],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          borderRadius: BorderRadius.circular(4)),
    );
  }
}

// class ArcPaint extends StatefulWidget {
//   const ArcPaint({super.key});

//   @override
//   State<ArcPaint> createState() => _ArcPaintState();
// }

// class _ArcPaintState extends State<ArcPaint> {
//   double charge = 90;
//   var timer;
//   var breakOff = false;
//   var breakStarted = false;
//   var breakStopp = 60;

//   bool _showFrontSide = true;
//   @override
//   void initState() {
//     super.initState();
//     timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
//       if (charge > 100) {
//         charge = 0;
//         breakOff = false;
//         if (charge > 50) breakStarted = true;
//       } else {
//         charge = charge + 1;
//         if (charge > 60) breakOff = true;
//         breakStopp = 60;
//       }

//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     timer.cancel();
//     timer = null;
//   }

//   Widget __buildLayout({Key? key, String? faceName, Color? backgroundColor}) {
//     return Container(
//       key: key,
//       decoration: BoxDecoration(
//         shape: BoxShape.rectangle,
//         borderRadius: BorderRadius.circular(20.0),
//         color: backgroundColor,
//       ),
//       child: Center(
//         child: Text(faceName!.substring(0, 1),
//             style: const TextStyle(fontSize: 80.0)),
//       ),
//     );
//   }

//   Widget _buildFlitAnimation() {
//     return GestureDetector(
//       onTap: () => setState(() => _showFrontSide = !_showFrontSide),
//       child: Column(
//         children: [
//           SizedBox(
//             height: 200,
//             width: 200,
//             child: AnimatedSwitcher(
//               duration: const Duration(milliseconds: 600),
//               transitionBuilder: __transitionBuilder,
//               layoutBuilder: (widget, list) =>
//                   Stack(children: [widget!, ...list]),
//               switchInCurve: Curves.easeOutBack,
//               switchOutCurve: Curves.easeOutBack.flipped,
//               child: _showFrontSide ? _buildFront() : _buildRear(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget __transitionBuilder(Widget widget, Animation<double> animation) {
//     final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
//     return AnimatedBuilder(
//       animation: rotateAnim,
//       child: widget,
//       builder: (context, widget) {
//         final isUnder = (ValueKey(_showFrontSide) != widget!.key);
//         var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
//         tilt *= isUnder ? -1.0 : 1.0;
//         final value =
//             isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
//         return Transform(
//           transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
//           alignment: Alignment.center,
//           child: widget,
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // charge = 55;
//     return Column(
//       children: [
//         SizedBox(
//             height: 200,
//             width: 200,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 ///after break
//                 if (charge > 60)
//                   CustomPaint(
//                     painter: CirclePainter(
//                         secondHalf: true,
//                         isBreak: false,
//                         percentage: charge,
//                         isRepaint: charge >= 60
//                             ? true
//                             : false), // MyPainter() //BatteryPaint(charge: charge) // ArcPainter(percentage: 97),
//                   ),

//                 //break paint
//                 if (charge >= 50 || breakStarted)
//                   CustomPaint(
//                     painter: CirclePainter(
//                         isBreak: true,
//                         percentage: breakOff
//                             ? breakStopp
//                             : charge), // MyPainter() //BatteryPaint(charge: charge) // ArcPainter(percentage: 97),
//                   ),
//                 // // beforeBreak
//                 CustomPaint(
//                   painter: CirclePainter(
//                       isBreak: false,
//                       percentage: charge,
//                       isRepaint: charge >= 50
//                           ? false
//                           : true), // MyPainter() //BatteryPaint(charge: charge) // ArcPainter(percentage: 97),
//                 ),
//                 Text(charge.toStringAsFixed(2)),
//               ],
//             )),
//         // _buildFlitAnimation()
//       ],
//     );
//   }

//   Widget _buildFront() {
//     return __buildLayout(
//       key: const ValueKey(true),
//       backgroundColor: Colors.blue,
//       faceName: "F",
//     );
//   }

//   Widget _buildRear() {
//     return __buildLayout(
//       key: const ValueKey(false),
//       backgroundColor: Colors.blue.shade700,
//       faceName: "R",
//     );
//   }
// }

// class CirclePainter extends CustomPainter {
//   final percentage;
//   final bool isBreak;
//   final bool isRepaint;
//   final bool secondHalf;
//   CirclePainter(
//       {required this.percentage,
//       this.isBreak = false,
//       this.isRepaint = false,
//       this.secondHalf = false});
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => isRepaint;
//   Rect _pinRect(RRect bdr, width) {
//     // 1
//     final center = Offset(bdr.right, bdr.top + (bdr.height / 2.0));
//     // 2
//     const height = 5.0;
//     // 3
//     const width = 10;
//     // 4
//     return Rect.fromCenter(
//         center: center, width: width.toDouble(), height: height);
//   }

//   RRect _borderRRect(Size size) {
//     // 1
//     var margin = 0.0;
//     final symmetricalMargin = margin * 1;
//     // 2
//     num padding = 0;
//     num pinWidth = 0;
//     final width = size.width - symmetricalMargin - padding - pinWidth;
//     // 3
//     const height = 10.0;
//     // 4
//     final top = (size.height / 2) - (height / 2);
//     // 5
//     const radius = Radius.circular(height / 2);
//     // 6
//     final bounds = Rect.fromLTWH(margin + 100, top + 100, width / 2, 10);
//     // 7
//     return RRect.fromRectAndRadius(bounds, const Radius.circular(4));
//   }
// //  for (double i = 0; i < 360; i += 6) {
//   // if (i % 30 == 0) {
//   // var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
//   // var y1 = centerX + outerCircleRadius * sin(i * pi / 180);

//   // var x2 = centerX + innerCircleRadiusHour * cos(i * pi / 180);
//   // var y2 = centerX + innerCircleRadiusHour * sin(i * pi / 180);
//   // canvas.drawLine(
//   //     Offset(x1, y1), Offset(x2, y2), dashHourBrush..strokeWidth = 1);
//   // }
//   @override
//   void paint(Canvas canvas, Size size) {
//     var outerPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..color = Colors.grey;
//     var innerPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = 10
//       ..color = Colors.grey;
//     var fillPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..color = Colors.green
//       ..strokeWidth = 1;
//     var pinPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..color = Colors.green
//       ..strokeWidth = 1;
//     // if (!isBreak && !secondHalf ) {
//     //   canvas.drawCircle(
//     //       Offset(size.height / 2, size.width / 2), 38, innerPaint);
//     // }
//     // canvas.drawCircle(Offset(80, 100), 40, outerPaint);
//     // canvas.drawArc(
//     //     Rect.fromCircle(
//     //         center: Offset(size.height / 2, size.width / 2), radius: 35),
//     //     .02,
//     //     2 * math.pi * .93,
//     //     false,
//     //     fillPaint
//     //       ..color = Colors.green
//     //       ..strokeCap = StrokeCap.round);

//     // Battery border
//     // final bdr = _borderRRect(Size(20, 20));

//     // // Battery pin
//     // final pinRect = _pinRect(bdr, size.width);
//     // Paint borderPaint = Paint()..style = PaintingStyle.stroke;
//     // canvas.drawRRect(bdr, borderPaint);
//     var centerX = size.width / 2;
//     var centerY = size.height / 2;
//     var innerCircleRadius = 35;
//     var outerCircleRadius = 40;
//     var angle = percentage / 100 * 360;
//     var startAngle = secondHalf
//         ? (.6 * 360).toInt()
//         : isBreak
//             ? 349.2 ~/ 2
//             : 5;
//     if (!secondHalf) {
//       for (int i = startAngle;
//           i <
//               (isBreak
//                   ? angle
//                   : percentage < 50
//                       ? angle
//                       : 349 ~/ 2);
//           i++) {
//         if (isBreak) {
//           var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
//           var y1 = centerX + outerCircleRadius * sin(i * pi / 180);

//           var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
//           var y2 = centerX + innerCircleRadius * sin(i * pi / 180);
//           canvas.drawLine(
//               Offset(x1, y1),
//               Offset(x2, y2),
//               pinPaint
//                 ..strokeWidth = 5
//                 ..strokeCap = StrokeCap.round
//                 ..color = Colors.red);
//         } else {
//           var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
//           var y1 = centerX + outerCircleRadius * sin(i * pi / 180);

//           var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
//           var y2 = centerX + innerCircleRadius * sin(i * pi / 180);
//           canvas.drawLine(
//               Offset(x1, y1),
//               Offset(x2, y2),
//               pinPaint
//                 ..strokeWidth = 5
//                 ..strokeCap = StrokeCap.round);
//         }
//       }
//     } else {
//       {
//         for (int i = startAngle; i < angle; i++) {
//           var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
//           var y1 = centerX + outerCircleRadius * sin(i * pi / 180);

//           var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
//           var y2 = centerX + innerCircleRadius * sin(i * pi / 180);
//           canvas.drawLine(
//               Offset(x1, y1),
//               Offset(x2, y2),
//               pinPaint
//                 ..strokeWidth = 5
//                 ..strokeCap = StrokeCap.round
//               // ..color = Colors.yellow,
//               );
//         }
//       }
//     }
//     // canvas.drawArc(pinRect, math.pi / 2, -math.pi, true, pinPaint);
//   }
// }

// class MyPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     double centerPoint = size.height / 2;

//     double strokeWidth = 30;
//     double percentValue = 100 / 100;
//     double radius = centerPoint;

//     Paint paint = Paint()
//       ..color = Colors.white
//       ..strokeCap = StrokeCap.round
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth;

//     paint.shader = SweepGradient(
//       colors: const [Colors.black, Colors.pink],
//       tileMode: TileMode.repeated,
//       startAngle: _degreeToRad(270),
//       endAngle: _degreeToRad(270 + 360.0),
//     ).createShader(
//         Rect.fromCircle(center: Offset(centerPoint, centerPoint), radius: 0));

//     Rect rect = Rect.fromCircle(
//         center: Offset(centerPoint, centerPoint), radius: radius);

//     var scapSize = strokeWidth / 2;
//     double scapToDegree = scapSize / radius;

//     double startAngle = _degreeToRad(270) + scapToDegree;
//     double sweepAngle = _degreeToRad(360) - (2 * scapToDegree);

//     canvas.drawArc(rect, startAngle, percentValue * sweepAngle, false, paint);
//   }

//   double _degreeToRad(double degree) => degree * math.pi / 180;

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }

// class BatteryPaint extends CustomPainter {
//   BatteryPaint({required this.charge});

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
//   final margin = 10.0;
//   final padding = 10.0;
//   final pinWidth = 6;
//   final minCharge = 1;
//   final double charge;

//   RRect _borderRRect(Size size) {
//     // 1
//     final symmetricalMargin = margin * 2;
//     // 2
//     final width = size.width - symmetricalMargin - padding - pinWidth;
//     // 3
//     final height = width / 2;
//     // 4
//     final top = (size.height / 2) - (height / 2);
//     // 5
//     final radius = Radius.circular(height * 0.2);
//     // 6
//     final bounds = Rect.fromLTWH(margin, top, width, height);
//     // 7
//     return RRect.fromRectAndRadius(bounds, radius);
//   }

//   Rect _pinRect(RRect bdr, width) {
//     // 1
//     final center = Offset(bdr.right + padding, bdr.top + (bdr.height / 2.0));
//     // 2
//     final height = bdr.height * 0.38;
//     // 3
//     final width = pinWidth * 2;
//     // 4
//     return Rect.fromCenter(
//         center: center, width: width.toDouble(), height: height);
//   }

//   RRect _chargeRRect(RRect bdr) {
//     final percent = charge == 0
//         ? 0
//         : charge / 100; //minCharge * ((charge / minCharge).round());

//     final left = bdr.left + padding;
//     final top = bdr.top + padding;
//     final right = bdr.right - padding;
//     final bottom = bdr.bottom - padding;
//     final height = bottom - top;
//     final width = right - left;
//     final radius = Radius.circular(height * 0.15);
//     final rect = Rect.fromLTWH(left, top, width * percent, height);
//     return RRect.fromRectAndRadius(rect, radius);
//   }

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint pinPaint = Paint()..style = PaintingStyle.fill;
//     Paint chargePaint = Paint()
//       ..style = PaintingStyle.fill
//       ..color = Colors.green;
//     // Battery border
//     final bdr = _borderRRect(size);

//     // Battery pin
//     final pinRect = _pinRect(bdr, size.width);
//     // Battery charge progress
//     final chargeRRect = _chargeRRect(bdr);
//     canvas.drawRRect(chargeRRect, chargePaint);

//     canvas.drawArc(pinRect, math.pi / 2, -math.pi, true, pinPaint);
//     Paint borderPaint = Paint()..style = PaintingStyle.stroke;
//     canvas.drawRRect(bdr, borderPaint);
//   }
// }

// class ArcPainter extends CustomPainter {
//   final double percentage;

//   ArcPainter({required this.percentage});
//   @override
//   void paint(Canvas canvas, Size size) {
//     final p = percentage;
//     final w = size.width;
//     final h = size.height;
//     final r = h / 2;
//     Path path_0 = Path();
//     path_0.moveTo(size.width, size.height * 0.5000000);

//     path_0.cubicTo(size.width, size.height * 0.7761423, size.width * 0.7761423,
//         size.height, size.width * 0.5000000, size.height);
//     path_0.cubicTo(size.width * 0.2238577, size.height, 0,
//         size.height * 0.7761423, 0, size.height * 0.5000000);
//     path_0.cubicTo(0, size.height * 0.2238577, size.width * 0.2238577, 0,
//         size.width * 0.5000000, 0);
//     path_0.cubicTo(size.width * 0.7761423, 0, size.width,
//         size.height * 0.2238577, size.width, size.height * 0.5000000);
//     path_0.close();
//     path_0.moveTo(size.width * 0.1250000, size.height * 0.5000000);
//     path_0.cubicTo(
//         size.width * 0.1250000,
//         size.height * 0.7071072,
//         size.width * 0.2928928,
//         size.height * 0.8750000,
//         size.width * 0.5000000,
//         size.height * 0.8750000);
//     path_0.cubicTo(
//         size.width * 0.7071072,
//         size.height * 0.8750000,
//         size.width * 0.8750000,
//         size.height * 0.7071072,
//         size.width * 0.8750000,
//         size.height * 0.5000000);
//     path_0.cubicTo(
//         size.width * 0.8750000,
//         size.height * 0.2928928,
//         size.width * 0.7071072,
//         size.height * 0.1250000,
//         size.width * 0.5000000,
//         size.height * 0.1250000);
//     path_0.cubicTo(
//         size.width * 0.2928928,
//         size.height * 0.1250000,
//         size.width * 0.1250000,
//         size.height * 0.2928928,
//         size.width * 0.1250000,
//         size.height * 0.5000000);
//     path_0.close();

//     Paint paint0Fill = Paint()..style = PaintingStyle.fill;
//     paint0Fill.color = const Color(0xffEDEEF1).withOpacity(1.0);
//     canvas.drawPath(path_0, paint0Fill);
//     // Path path_0 = Path();
//     // path_0.moveTo(size.width * 0.9777778, size.height * 0.5000007);
//     // path_0.cubicTo(
//     //     size.width * 0.9900519,
//     //     size.height * 0.5000007,
//     //     size.width * 1.000052,
//     //     size.height * 0.5099556,
//     //     size.width * 0.9995037,
//     //     size.height * 0.5222163);
//     // path_0.cubicTo(
//     //     size.width * 0.9945704,
//     //     size.height * 0.6333133,
//     //     size.width * 0.9527037,
//     //     size.height * 0.7398407,
//     //     size.width * 0.8802000,
//     //     size.height * 0.8247259);
//     // path_0.cubicTo(
//     //     size.width * 0.8028889,
//     //     size.height * 0.9152519,
//     //     size.width * 0.6958030,
//     //     size.height * 0.9752222,
//     //     size.width * 0.5782170,
//     //     size.height * 0.9938444);
//     // path_0.cubicTo(
//     //     size.width * 0.4606319,
//     //     size.height * 1.012467,
//     //     size.width * 0.3402593,
//     //     size.height * 0.9885259,
//     //     size.width * 0.2387511,
//     //     size.height * 0.9263185);
//     // path_0.cubicTo(
//     //     size.width * 0.1372430,
//     //     size.height * 0.8641185,
//     //     size.width * 0.06126081,
//     //     size.height * 0.7677333,
//     //     size.width * 0.02447185,
//     //     size.height * 0.6545089);
//     // path_0.cubicTo(
//     //     size.width * -0.01231711,
//     //     size.height * 0.5412844,
//     //     size.width * -0.007498741,
//     //     size.height * 0.4186481,
//     //     size.width * 0.03806030,
//     //     size.height * 0.3086593);
//     // path_0.cubicTo(
//     //     size.width * 0.08361926,
//     //     size.height * 0.1986696,
//     //     size.width * 0.1669289,
//     //     size.height * 0.1085459,
//     //     size.width * 0.2730044,
//     //     size.height * 0.05449741);
//     // path_0.cubicTo(
//     //     size.width * 0.3790807,
//     //     size.height * 0.0004491415,
//     //     size.width * 0.5009607,
//     //     size.height * -0.01397630,
//     //     size.width * 0.6167230,
//     //     size.height * 0.01381570);
//     // path_0.cubicTo(
//     //     size.width * 0.7252681,
//     //     size.height * 0.03987511,
//     //     size.width * 0.8217556,
//     //     size.height * 0.1014489,
//     //     size.width * 0.8910519,
//     //     size.height * 0.1884252);
//     // path_0.cubicTo(
//     //     size.width * 0.8986963,
//     //     size.height * 0.1980244,
//     //     size.width * 0.8964593,
//     //     size.height * 0.2119563,
//     //     size.width * 0.8865333,
//     //     size.height * 0.2191696);
//     // path_0.lineTo(size.width * 0.8415852, size.height * 0.2518244);
//     // path_0.cubicTo(
//     //     size.width * 0.8316593,
//     //     size.height * 0.2590385,
//     //     size.width * 0.8178074,
//     //     size.height * 0.2567919,
//     //     size.width * 0.8100519,
//     //     size.height * 0.2472785);
//     // path_0.cubicTo(
//     //     size.width * 0.7548296,
//     //     size.height * 0.1795252,
//     //     size.width * 0.6787674,
//     //     size.height * 0.1315526,
//     //     size.width * 0.5933785,
//     //     size.height * 0.1110526);
//     // path_0.cubicTo(
//     //     size.width * 0.5007689,
//     //     size.height * 0.08881926,
//     //     size.width * 0.4032644,
//     //     size.height * 0.1003593,
//     //     size.width * 0.3184037,
//     //     size.height * 0.1435978);
//     // path_0.cubicTo(
//     //     size.width * 0.2335430,
//     //     size.height * 0.1868370,
//     //     size.width * 0.1668956,
//     //     size.height * 0.2589356,
//     //     size.width * 0.1304481,
//     //     size.height * 0.3469274);
//     // path_0.cubicTo(
//     //     size.width * 0.09400074,
//     //     size.height * 0.4349185,
//     //     size.width * 0.09014667,
//     //     size.height * 0.5330274,
//     //     size.width * 0.1195778,
//     //     size.height * 0.6236074);
//     // path_0.cubicTo(
//     //     size.width * 0.1490089,
//     //     size.height * 0.7141874,
//     //     size.width * 0.2097941,
//     //     size.height * 0.7912963,
//     //     size.width * 0.2910007,
//     //     size.height * 0.8410593);
//     // path_0.cubicTo(
//     //     size.width * 0.3722074,
//     //     size.height * 0.8908222,
//     //     size.width * 0.4685052,
//     //     size.height * 0.9099778,
//     //     size.width * 0.5625741,
//     //     size.height * 0.8950741);
//     // path_0.cubicTo(
//     //     size.width * 0.6566430,
//     //     size.height * 0.8801778,
//     //     size.width * 0.7423111,
//     //     size.height * 0.8322000,
//     //     size.width * 0.8041630,
//     //     size.height * 0.7597778);
//     // path_0.cubicTo(
//     //     size.width * 0.8611926,
//     //     size.height * 0.6930044,
//     //     size.width * 0.8945333,
//     //     size.height * 0.6094867,
//     //     size.width * 0.8993852,
//     //     size.height * 0.5222141);
//     // path_0.cubicTo(
//     //     size.width * 0.9000667,
//     //     size.height * 0.5099600,
//     //     size.width * 0.9099481,
//     //     size.height * 0.5000007,
//     //     size.width * 0.9222222,
//     //     size.height * 0.5000007);
//     // path_0.lineTo(size.width * 0.9777778, size.height * 0.5000007);
//     // path_0.close();

//     // Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
//     // paint_0_fill.color = Color(0xff008000).withOpacity(1.0);
//     // canvas.drawPath(path_0, paint_0_fill);
//     // final path = Path();
//     // path.moveTo(size.width, size.height * 0.5000000);
//     // path.cubicTo(size.width, size.height * 0.7761423, size.width * 0.7761423,
//     //     size.height, size.width * 0.5000000, size.height);
//     // path.cubicTo(size.width * 0.2238577, size.height, 0,
//     //     size.height * 0.7761423, 0, size.height * 0.5000000);
//     // path.cubicTo(0, size.height * 0.2238577, size.width * 0.2238577, 0,
//     //     size.width * 0.5000000, 0);
//     // path.cubicTo(size.width * 0.7761423, 0, size.width, size.height * 0.2238577,
//     //     size.width, size.height * 0.5000000);
//     // path.close();
//     // path.moveTo(size.width * 0.1250000, size.height * 0.5000000);
//     // path.cubicTo(
//     //     size.width * 0.1250000,
//     //     size.height * 0.7071072,
//     //     size.width * 0.2928928,
//     //     size.height * 0.8750000,
//     //     size.width * 0.5000000,
//     //     size.height * 0.8750000);
//     // path.cubicTo(
//     //     size.width * 0.7071072,
//     //     size.height * 0.8750000,
//     //     size.width * 0.8750000,
//     //     size.height * 0.7071072,
//     //     size.width * 0.8750000,
//     //     size.height * 0.5000000);
//     // path.cubicTo(
//     //     size.width * 0.8750000,
//     //     size.height * 0.2928928,
//     //     size.width * 0.7071072,
//     //     size.height * 0.1250000,
//     //     size.width * 0.5000000,
//     //     size.height * 0.1250000);
//     // path.cubicTo(
//     //     size.width * 0.2928928,
//     //     size.height * 0.1250000,
//     //     size.width * 0.1250000,
//     //     size.height * 0.2928928,
//     //     size.width * 0.1250000,
//     //     size.height * 0.5000000);
//     // path.cubicTo(x1, y1, x2, y2, x3, y3)
//     // path.moveTo(0, 0);
//     // path.lineTo(w / 2 - r, 0);
//     // path.arcToPoint(
//     //   Offset(w / 2 + r, 0),
//     //   radius: Radius.circular(r),
//     //   clockwise: false,
//     // );
//     // path.lineTo(w, 0);
//     // path.lineTo(w, h);
//     // path.lineTo(0, h);
//     // path.close();

//     // Paint paint = Paint()..style = PaintingStyle.fill;
//     // paint.color = Color(0xffEDEEF1).withOpacity(1.0);
//     // canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
