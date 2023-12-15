import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hajir/app/config/app_colors.dart';
import 'package:hajir/app/config/app_constants.dart';
import 'package:hajir/app/modules/candidate_login/views/candidate_login_view.dart';
import 'package:hajir/app/routes/app_pages.dart';
import 'package:hajir/app/utils/custom_paint/arc_painter.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';
import 'package:hajir/core/localization/l10n/strings.dart';
import 'dart:math';
import '../controllers/language_controller.dart';

class LanguageView extends GetView<LanguageController> {
  const LanguageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));

    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Stack(
            children: [
              CustomPaint(
                size: Size(Get.width, (Get.width * 0.812).toDouble()),
                painter: ArcPainter(color: AppColors.deepOrange),
              ),
              Positioned(
                  left: 47.r,
                  top: 128.h,
                  right: 47.h,
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      height: 281.r,
                      width: 281.r,
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromRGBO(255, 80, 80, .19),
                                  Color.fromRGBO(236, 236, 236, 0)
                                ]),
                            shape: BoxShape.circle),
                        height: 257.r,
                        width: 257.r,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            //       Container(
                            //            height: 240,
                            //  width:240,
                            //         child: ClockWidget()),
                            Image.asset(
                              "assets/Ellipse 13.png",
                              height: 240.r,
                              width: 240.r,
                            ),
                            Image.asset(
                              AppImages.logo,
                              height: 60.h,
                              width: 178.w,
                            ),
                          ],
                        ),
                      ))),
              Positioned(
                  top: 503.h,
                  left: 16.r,
                  right: 16.r,
                  child: Column(
                    children: [
                      Text(
                        strings.choose_language,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.sp,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                          onPressed: () {
                            appSettings.changeLang();
                            Get.offNamed(Routes.WELCOME);
                          },
                          label: "English"),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        strings.or,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 13),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomButton(
                          onPressed: () {
                            appSettings.changeLang(en: false);
                            Get.offNamed(Routes.WELCOME);
                          },
                          label: "Nepali",
                          labelColor: Colors.white,
                          color: AppColors.red)
                    ],
                  ))
            ],
          ),
        ));
  }
}

class ClockWidget extends StatefulWidget {
  const ClockWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  var now = DateTime.now();
  late Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(1.seconds, (timer) {
      now = DateTime.now();
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(angle: -pi / 2, child: Clock(now: now));
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.onPressed,
      this.icon,
      required this.label,
      this.labelColor,
      this.buttonStyle,
      this.height,
      this.color = const Color.fromRGBO(34, 64, 139, 1)})
      : super(key: key);
  final Function()? onPressed;
  final String label;
  final double? height;
  final Color color;
  final Color? labelColor;
  final IconData? icon;
  final TextStyle? buttonStyle;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 40,
      width: double.infinity,
      child: icon == null
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: color,
                  foregroundColor: color == const Color.fromRGBO(34, 64, 139, 1)
                      ? null
                      : labelColor ?? Colors.black),
              onPressed: onPressed,
              child: Text(label,
                  style: buttonStyle ??
                      TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14.spMin)))
          : ElevatedButton.icon(
              icon: Icon(
                icon,
                color: labelColor ?? const Color.fromRGBO(34, 64, 139, 1),
                size: 16,
              ),
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: color,
                  foregroundColor: color == const Color.fromRGBO(34, 64, 139, 1)
                      ? null
                      : labelColor ?? Colors.black),
              onPressed: onPressed,
              label: Text(
                label,
                style: buttonStyle ??
                    TextStyle(fontWeight: FontWeight.w700, fontSize: 12.spMin),
              )),
    );
  }
}
