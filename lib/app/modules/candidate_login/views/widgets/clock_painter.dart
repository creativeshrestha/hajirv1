import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hajir/app/modules/candidate_login/controllers/candidate_login_controller.dart';
import 'package:hajir/app/modules/candidate_login/models/today_details.dart';
import 'package:intl/intl.dart';

hourMin(DateTime v) => [v.hour, v.minute];

class Breaks {
  final DateTime startedTime;
  final DateTime endedTime;

  Breaks(this.startedTime, this.endedTime);
}

class ClockPainter extends CustomPainter {
  final dateTime;
  final DateTime? loggedInTime;
  final DateTime? loggedOutTime;
  final List<Breaks> breaks = [];
  ClockPainter(this.dateTime, {this.loggedInTime, this.loggedOutTime});

  //60 sec 1 sec- degree

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    var fillBrush = Paint()
      ..color = const Color(0xFF444974)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13;
    var shadow = Paint()
      // ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13;
    var centerFillBrush = Paint()
      ..color = Colors.grey
      ..strokeWidth = 4;
    var secHandBrush = Paint()
      ..strokeCap = StrokeCap.round
      // ..shader = const RadialGradient(colors: [Colors.lightBlue, Colors.pink])
      //     .createShader(Rect.fromCircle(center: center, radius: radius))
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    var minHandBrush = Paint()
      ..strokeCap = StrokeCap.round
      // ..shader = const RadialGradient(colors: [Colors.lightBlue, Colors.pink])
      //     .createShader(Rect.fromCircle(center: center, radius: radius))
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    var hourHandBrush = Paint()
      // ..shader = const RadialGradient(colors: [Colors.lightBlue, Colors.pink])
      //     .createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeCap = StrokeCap.round
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    var dashBrush = Paint()..color = Colors.grey.shade200;
    var dashLoginBrush = Paint()..color = Colors.green.shade800;
    var dashHourBrush = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 1;
    var secondHandX =
        centerX + size.height / 2.5 * cos(dateTime.second * 6 * pi / 180);
    var secondHandY =
        centerX + size.height / 2.5 * sin(dateTime.second * 6 * pi / 180);

    var minHandX =
        centerX + size.height / 3.2 * cos(dateTime.minute * 6 * pi / 180);
    var minHandY =
        centerX + size.height / 3.2 * sin(dateTime.minute * 6 * pi / 180);

    var hourHandX =
        centerX + size.height / 5 * cos(dateTime.hour * 30 * pi / 180);
    var hourHandY =
        centerX + size.height / 5 * sin(dateTime.hour * 30 * pi / 180);

    // canvas.drawCircle(center, radius - 10, fillBrush);
    // canvas.drawCircle(center, radius - 10, outlineBrush);

    // canvas.drawCircle(center, radius - 0, fillBrush);
    // canvas.drawCircle(center, radius - 10, outlineBrush);
    // canvas.drawCircle(
    //     center, 65, centerFillBrush..color = Colors.grey.withOpacity(.1));
    // canvas.drawCircle(center, 50, centerFillBrush..color = Colors.white);
    canvas.drawLine(center, Offset(secondHandX, secondHandY), secHandBrush);

    canvas.drawLine(
        center, Offset(minHandX, minHandY), minHandBrush..color = Colors.grey);
    canvas.drawLine(center, Offset(hourHandX, hourHandY),
        hourHandBrush..color = Colors.grey);
    canvas.drawCircle(
        center, 3, centerFillBrush..color = Colors.blueGrey.shade200);
    // const progress = .97;

    const startAngle = pi / 2;
    // const sweepAngle = -2 * pi * progress;
    // const breakAngle = -2 * pi * .1;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius + 15),
        startAngle, 360, false, fillBrush..color = Colors.grey.shade100);
    // canvas.drawArc(Rect.fromCircle(center: center, radius: radius + 15),
    //     startAngle - .17, sweepAngle, false, fillBrush..color = Colors.green);
    // canvas.drawArc(Rect.fromCircle(center: center, radius: radius + 15),
    //     -pi / 2, breakAngle + .09, false, shadow..color = Colors.red);
    // canvas.drawArc(Rect.fromCircle(center: center, radius: radius + 20),
    //     startAngle, sweepAngle, false, fillBrush..color = Colors.red);
    var outerCircleRadius = radius;
    var innerCircleRadiusHour = radius - 5;

    var innerCircleRadius = radius - 4;
    final controller = Get.find<CandidateLoginController>();
    var angle = Get.find<CandidateLoginController>().angle.value;

    if (controller.loggedInDateAndTime.value.isNotEmpty || angle != 0) {
      var startTimeInMinutes = DateFormat("h:mm aa").format(DateTime.parse(
          Get.find<CandidateLoginController>().loggedInDateAndTime.value));

      var date = (startTimeInMinutes
          .substring(0, startTimeInMinutes.indexOf(" "))
          .split(":"));

      var now = DateTime.now();
      var endTime = now.hour >= 12 ? (now.hour - 12) : now.hour;
      var endMin = now.minute;
      var startangle = (int.parse(date[0] == '12' ? '0' : date[0]) * 30 +
              int.parse(date[1]) * 30 / 60)
          .toInt();
      var endangle =
          (endTime * 30 + endMin * 1 / 60 * 30 + now.second * 1 / 3600 * 30)
              .toInt();

      for (int i = 0; (i) < 360; i += 1) {
        // (((now.hour - int.parse(date[0])) > 12)
        // ? 0.0
        // : startangle.toInt())

        if (i >=
                (startangle.toInt() > endangle.toInt()
                    ? 0.0
                    : startangle.toInt()) &&
            (i <= (endangle).toInt())) {
          var x1 = centerX + (outerCircleRadius + 20) * cos(i * pi / 180);
          var y1 = centerX + (outerCircleRadius + 20) * sin(i * pi / 180);

          var x2 = centerX + (innerCircleRadiusHour + 15) * cos(i * pi / 180);
          var y2 = centerX + (innerCircleRadiusHour + 15) * sin(i * pi / 180);
          canvas.drawLine(
              Offset(x1, y1),
              Offset(x2, y2),
              dashLoginBrush
                ..strokeWidth = 4
                ..style = PaintingStyle.stroke
                ..color = controller.isLoggedOut
                    ? Colors.red
                    : endangle == i
                        ? Colors.black
                        : Colors.green.shade800
                ..strokeCap = StrokeCap.round);
        }
      }
      // print(endangle.toInt());
      // print(startangle);
      // if (true) {
      //   var i = endangle;
      //   var x1 = centerX + (outerCircleRadius + 20) * cos(i * pi / 180);
      //   var y1 = centerX + (outerCircleRadius + 20) * sin(i * pi / 180);

      //   var x2 = centerX + (innerCircleRadiusHour + 15) * cos(i * pi / 180);
      //   var y2 = centerX + (innerCircleRadiusHour + 15) * sin(i * pi / 180);
      //   canvas.drawLine(
      //       Offset(x1, y1),
      //       Offset(x2, y2),
      //       dashLoginBrush
      //         ..strokeWidth = 2
      //         ..style = PaintingStyle.stroke
      //         ..color = controller.isLoggedOut ? Colors.red : Colors.black
      //         ..strokeCap = StrokeCap.round);
      // }
      if (startangle > endangle) {
        for (int i = startangle.toInt(); i < 360; i += 1) {
          // print(i);
          // if (i >= startangle && (i <= controller.angle.value))
          {
            var x1 = centerX + (outerCircleRadius + 20) * cos(i * pi / 180);
            var y1 = centerX + (outerCircleRadius + 20) * sin(i * pi / 180);

            var x2 = centerX + (innerCircleRadiusHour + 15) * cos(i * pi / 180);
            var y2 = centerX + (innerCircleRadiusHour + 15) * sin(i * pi / 180);
            canvas.drawLine(
                Offset(x1, y1),
                Offset(x2, y2),
                dashLoginBrush
                  ..strokeWidth = 4
                  ..style = PaintingStyle.stroke
                  ..color = controller.isLoggedOut
                      ? Colors.red
                      : endangle.toInt() == i
                          ? Colors.black
                          : Colors.green.shade800
                  ..strokeCap = StrokeCap.round);
          }
        }
      }

      for (var element in controller.breakList) {
        // print(element.startPercent);
        // print(element.endPercent);
        for (int i = element.startPercent;
            i <= (element.endPercent ?? endangle);
            i += 1) {
          // Get.log(element.startPercent.toString());
          // Get.log(element.endPercent.toString());
          // if ((i >= controller.breakStartedPercentage.value) && i <= 17)
          {
            var x1 = centerX + (outerCircleRadius + 20) * cos(i * pi / 180);
            var y1 = centerX + (outerCircleRadius + 20) * sin(i * pi / 180);

            var x2 = centerX + (innerCircleRadiusHour + 15) * cos(i * pi / 180);
            var y2 = centerX + (innerCircleRadiusHour + 15) * sin(i * pi / 180);

            canvas.drawLine(
                Offset(x1, y1),
                Offset(x2, y2),
                dashLoginBrush
                  ..strokeWidth = 4
                  ..style = PaintingStyle.stroke
                  ..color = controller.isLoggedOut ? Colors.red : Colors.orange
                  ..strokeCap = StrokeCap.round);
          }
        }
      }
      // if (controller.breakStarted.value == BreakStatus.Started) {
      //   for (double i = controller.breakStartedPercentage.value;
      //       i <
      //           ((controller.breakEndPercentage.value.toInt() != 0)
      //               ? controller.breakEndPercentage.value.toInt()
      //               : controller.angle.value);
      //       i += 1) {
      //     // if ((i >= controller.breakStartedPercentage.value) && i <= 17)
      //     {
      //       var x1 = centerX + (outerCircleRadius + 20) * cos(i * pi / 180);
      //       var y1 = centerX + (outerCircleRadius + 20) * sin(i * pi / 180);

      //       var x2 = centerX + (innerCircleRadiusHour + 15) * cos(i * pi / 180);
      //       var y2 = centerX + (innerCircleRadiusHour + 15) * sin(i * pi / 180);

      //       canvas.drawLine(
      //           Offset(x1, y1),
      //           Offset(x2, y2),
      //           dashLoginBrush
      //             ..strokeWidth = 4
      //             ..style = PaintingStyle.stroke
      //             ..color = Colors.orange
      //             ..strokeCap = StrokeCap.round);
      //     }
      //   }
      // }
    }
    for (double i = 0; i < 360; i += 6) {
      if (i % 30 == 0) {
        var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
        var y1 = centerX + outerCircleRadius * sin(i * pi / 180);

        var x2 = centerX + innerCircleRadiusHour * cos(i * pi / 180);
        var y2 = centerX + innerCircleRadiusHour * sin(i * pi / 180);
        canvas.drawLine(
            Offset(x1, y1), Offset(x2, y2), dashHourBrush..strokeWidth = 1);
      } else {
        var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
        var y1 = centerX + outerCircleRadius * sin(i * pi / 180);

        var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
        var y2 = centerX + innerCircleRadius * sin(i * pi / 180);
        canvas.drawLine(
            Offset(x1, y1), Offset(x2, y2), dashBrush..strokeWidth = 1);
      }
    }
  }
}
