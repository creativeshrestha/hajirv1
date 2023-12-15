import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hajir/app/config/app_colors.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/modules/candidate_login/views/widgets/clock_painter.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/routes/app_pages.dart';
import 'package:hajir/app/utils/custom_paint/arc_painter.dart';
import 'package:hajir/app/utils/shrimmerloading.dart';
import 'package:hajir/core/localization/l10n/strings.dart';
import 'package:intl/intl.dart';
import '../controllers/candidate_login_controller.dart';
import 'widgets/custom_paint/circular_progress_paint.dart';

// final DashboardController dashboardController = Get.find();
String _printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes min :$twoDigitSeconds sec";
}

Offset translate(double d, double theta) {
  final dx = d * cos(pi * theta / 180.0);
  final dy = d * sin(pi * theta / 180.0);
  return Offset(dx, dy);
  // update the x and y coordinates of the object by adding dx and dy
}

class CandidateLoginView extends GetView<CandidateLoginController> {
  const CandidateLoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 812,
        child: Obx(
          () => controller.loading.isTrue
              ? const Center(child: ShrimmerLoading())
              : Stack(children: [
                  SizedBox(
                    height: 229 + 30,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: ArcPainter(color: Colors.grey),
                    ),
                  ),
                  Obx(
                    () => controller.authStatusd.value ==
                            AuthStatus.Authenticated
                        ? Positioned(
                            top: 216 + 30,
                            right: 80,
                            left: 80,
                            child: Container(
                              alignment: Alignment.center,
                              child: Transform.translate(
                                offset: translate(
                                    90, -90 - (360 - controller.angle.value)),
                                child: Transform.rotate(
                                  angle: 0 ??
                                      (controller.testangel > .50 &&
                                              controller.testangel > .25
                                          ? .27 -
                                              pi /
                                                  36 *
                                                  controller.now.value.second
                                                      .toDouble()
                                          : .27 -
                                              pi /
                                                  36 *
                                                  controller.now.value.second
                                                      .toDouble()),
                                  // 25 0
                                  // 20> 0

                                  //30> 90
                                  // 50 90

                                  // 75 180
                                  // 60> 180

                                  // 0 -90
                                  // 80> -90
                                  //

                                  // controller.testangel >= .75
                                  //     ? pi
                                  //     : controller.testangel >= .5
                                  //         ? -pi / 2
                                  //         : controller.testangel >= .25
                                  //             ? 0
                                  //             : -pi / 2,
                                  // : pi / 2
                                  //     //15 0
                                  //     //30 -90
                                  //     //45 180
                                  //     //60
                                  //     -
                                  //     (controller
                                  //             .testangel +
                                  //         270 / 360),
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: controller.breakStarted.value ==
                                                BreakStatus.Started
                                            ? Colors.yellow.shade800
                                            : Colors.green.shade800,
                                        shape: BoxShape.circle),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                  Positioned(
                      top: 78,
                      left: 80,
                      right: 80,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            strings.today,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: AppColors.red),
                          ),
                          SizedBox(
                            height: 10.r,
                          ),
                          Text(
                            DateFormat('dd MMM yyyy').format(DateTime.now()),
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff555555)),
                          ),
                        ],
                      )),
                  Positioned(
                      top: 151 + 30,
                      left: 80,
                      right: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PercentageWidget(controller: controller),
                          const Positioned(
                              top: 70,
                              left: 47,
                              right: 47,
                              child: TimeWidget()),
                        ],
                      )),
                  Obx(
                    () => controller.authStatusd.value ==
                            AuthStatus.Authenticated
                        ? Positioned(
                            top: 216 + 30 + 100,
                            right: 100.r,
                            left: 100.r,
                            child: Container(
                              alignment: Alignment.center,
                              // child: Transform.translate(
                              //   offset: translate(
                              //       120, -90 - (360 - controller.angle.value)),
                              child: Text(
                                  _printDuration(controller.elapsedTime.value),
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600)),
                              // ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                  Positioned(
                      top: 367,
                      left: 18,
                      right: 18,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            height: 48,
                            width: 200,
                            child: Obx(() => controller.authStatusd.value ==
                                    AuthStatus.Authenticated
                                ? OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            color: Colors.red.shade800),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        )),
                                    onPressed: () {
                                      controller.logout();
                                    },
                                    child: Text(
                                      "Clock out", // strings.logout,
                                      style: AppTextStyles.b2
                                          .copyWith(color: AppColors.red),
                                    ))
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: controller.isLoggedOut
                                            ? Colors.grey
                                            : Colors.green,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24))),
                                    onPressed: () {
                                      if (!controller.isLoggedOut) {
                                        controller.login();
                                      } else {
                                        // controller.earning(0);
                                        controller.isLoggedOut = true;
                                        final DashboardController dC =
                                            Get.find();
                                        dC.companySelected = '';
                                      }
                                    },
                                    child: Text(
                                      controller.isLoggedOut
                                          ? "Clocked Out"
                                          : "Clock In",
                                      style: AppTextStyles.b2,
                                    ))),
                          ),
                          Obx(
                            () => controller.authStatusd.value ==
                                    AuthStatus.Authenticated
                                ? Column(
                                    children: [
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        onPressed: () {
                                          controller.startorStopBreak();
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Obx(
                                              () => Text(
                                                controller.breakStarted.value ==
                                                        BreakStatus.Started
                                                    ? strings.stop_break
                                                        .toUpperCase()
                                                    : strings.start_break
                                                        .toUpperCase(),
                                                style: AppTextStyles.medium
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors
                                                            .grey.shade600),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            SvgPicture.asset(
                                              controller.breakStarted.value ==
                                                      BreakStatus.Started
                                                  ? "assets/material-symbols_stop-outline-rounded.svg"
                                                  : "assets/codicon_debug-start.svg",
                                              height: controller
                                                          .breakStarted.value ==
                                                      BreakStatus.Started
                                                  ? 24
                                                  : 16,
                                              width: controller
                                                          .breakStarted.value ==
                                                      BreakStatus.Started
                                                  ? 24
                                                  : 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      // Text("😊"),
                                      Text(
                                        strings.todays_earning,
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 16.spMin),
                                        // style: AppTextStyles.medium
                                        //     .copyWith(fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 21,
                                      ),
                                      SizedBox(
                                        child: Obx(
                                          () => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/Group 173.svg',
                                                        width: 50.w,
                                                        height: 17.h,
                                                      ),
                                                      const Text(
                                                        "Rupiya",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 9,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ]),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      controller.earning
                                                          .toStringAsFixed(4),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineSmall!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 40.sp),
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/Group 173(1).svg',
                                                      width: 50.w,
                                                      height: 17.h,
                                                    ),
                                                    const Text(
                                                      "Paisa",
                                                      style: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                ),
                                                // Text(123.toString().padLeft(10, '0')),
                                                // Text(controller.earning.value
                                                //     .toInt()
                                                //     .toString()
                                                //     .padLeft(4, '0')
                                                //     .toString()
                                                //     .split('')[3]),
                                                // Text(controller.earning.value
                                                //     .toInt()
                                                //     .toString()
                                                //     .padLeft(4, '0')
                                                //     .toString()),
                                                // CandidateIncomeItem(
                                                //   value: int.parse(
                                                //     (controller.earning.value
                                                //         .toInt()
                                                //         .toString()
                                                //         .padLeft(4, '0')
                                                //         .toString()
                                                //         .split('')[0]),
                                                //   ),
                                                // ),
                                                // CandidateIncomeItem(
                                                //   value: int.parse(
                                                //     (controller.earning.value
                                                //         .toInt()
                                                //         .toString()
                                                //         .padLeft(4, '0')
                                                //         .toString()
                                                //         .split('')[1]),
                                                //   ),
                                                // ),
                                                // CandidateIncomeItem(
                                                //   value: int.parse(
                                                //     (controller.earning.value
                                                //         .toInt()
                                                //         .toString()
                                                //         .padLeft(4, '0')
                                                //         .toString()
                                                //         .split('')[2]),
                                                //   ),
                                                // ),
                                                // CandidateIncomeItem(
                                                //   value: int.parse(
                                                //     (controller.earning.value
                                                //         .toInt()
                                                //         .toString()
                                                //         .padLeft(4, '0')
                                                //         .toString()
                                                //         .split('')[3]),
                                                //   ),
                                                // ),
                                                // const SizedBox(
                                                //   width: 5,
                                                // ),
                                                // Dot(),
                                                // Obx(
                                                //   () => CandidateIncomeItem(
                                                //     value: controller.d2.value,
                                                //   ),
                                                // ),
                                                // const SizedBox(
                                                //   width: 5,
                                                // ),
                                                // Column(
                                                //   children: [
                                                //     Obx(() => CandidateIncomeItem(
                                                //         gradientTop: true,
                                                //         value: controller.d1.value == 0
                                                //             ? 9
                                                //             : controller.d1.value - 1)),
                                                //     const Spacer(),
                                                //     Obx(() => CandidateIncomeItem(
                                                //         value: controller.d1.value)),
                                                //     const Spacer(),
                                                //     Obx(
                                                //       () => CandidateIncomeItem(
                                                //           gradientBottom: true,
                                                //           value:
                                                //               (controller.d1.value + 1) ==
                                                //                       10
                                                //                   ? 0
                                                //                   : (controller.d1.value +
                                                //                       1)),
                                                //     ),
                                                //   ],
                                                // )
                                              ]),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      const Text(
                                        "Total earned salary till date",
                                        style:
                                            TextStyle(color: Colors.blueGrey),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "${(controller.earning.value + controller.total_earning.value).toStringAsFixed(2)}/-",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                // : controller.authStatus == AuthStatus.Unauthenticated
                                //     ? Text("Logged out")
                                : controller.isLoggedOut
                                    ? Column(
                                        children: [
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                """Congratulation!""",
                                                style: TextStyle(
                                                    fontSize: 28.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color.fromRGBO(
                                                        0, 128, 0, 1)),
                                              ),

                                              // Text(
                                              //   strings.today_you_ve_earned,
                                              //   style: Theme.of(context)
                                              //       .textTheme
                                              //       .titleMedium!
                                              //       .copyWith(
                                              //           fontSize: 18.sp,
                                              //           color: Colors.grey.shade700),
                                              // ),
                                              // Text(
                                              //   strings.todays_earning,
                                              //   style: AppTextStyles.medium.copyWith(
                                              //       fontWeight: FontWeight.w400),
                                              // ),
                                              Text(
                                                "\nToday earned",
                                                style: TextStyle(
                                                    fontSize: 22.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: const Color.fromRGBO(
                                                        85, 85, 85, 1)),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 30.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/Group 173.svg',
                                                      width: 50.w,
                                                      height: 17.h,
                                                    ),
                                                    const Text(
                                                      "Rupiya",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    )
                                                  ]),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Expanded(
                                                child: Obx(
                                                  () => Text(
                                                    "${controller.earning.value.toStringAsFixed(2)}/-",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 40),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/Group 173(1).svg',
                                                    width: 50.w,
                                                    height: 17.h,
                                                  ),
                                                  const Text(
                                                    "Paisa",
                                                    style: TextStyle(
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          //  const SizedBox(
                                          //   height: 40,
                                          // ),
                                          const Text(
                                            "Total earned salary till date",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    85, 85, 85, 1)),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "${controller.total_earning.value.toStringAsFixed(2)}/-",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          )
                                          //   ],
                                          // ),
                                          // Text(
                                          //   strings.thank_you,
                                          //   style: AppTextStyles.b1.copyWith(
                                          //       fontWeight: FontWeight.w600,
                                          //       color: Colors.green),
                                          // ),
                                          // const SizedBox(
                                          //   height: 8,
                                          // ),
                                          // Text(
                                          //   strings.have_a_good_time,
                                          //   style: TextStyle(color: Colors.grey.shade700),
                                          // ),
                                          // const SizedBox(
                                          //   height: 20,
                                          // ),
                                          // const Text(
                                          //   "😊",
                                          //   style: TextStyle(fontSize: 32),
                                          // ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          const SizedBox(
                                            height: 50,
                                          ),
                                          Text(
                                            strings.todays_earning,
                                            style: const TextStyle(
                                                color: Colors.blueGrey),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/Group 173.svg',
                                                        width: 50.w,
                                                        height: 17.h,
                                                      ),
                                                      const Text(
                                                        "Rupiya",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 9,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ]),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    // width: 80,
                                                    child: Text(
                                                        controller.earning
                                                            .toStringAsFixed(2),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineSmall!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                fontSize: 40),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/Group 173(1).svg',
                                                      width: 50.w,
                                                      height: 17.h,
                                                    ),
                                                    const Text(
                                                      "Paisa",
                                                      style: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                ),
                                                // Text(123.toString().padLeft(10, '0')),
                                                // Text(controller.earning.value
                                                //     .toInt()
                                                //     .toString()
                                                //     .padLeft(4, '0')
                                                //     .toString()
                                                //     .split('')[3]),
                                                // Text(controller.earning.value
                                                //     .toInt()
                                                //     .toString()
                                                //     .padLeft(4, '0')
                                                //     .toString()),
                                                // CandidateIncomeItem(
                                                //   value: int.parse(
                                                //     (controller.earning.value
                                                //         .toInt()
                                                //         .toString()
                                                //         .padLeft(4, '0')
                                                //         .toString()
                                                //         .split('')[0]),
                                                //   ),
                                                // ),
                                                // CandidateIncomeItem(
                                                //   value: int.parse(
                                                //     (controller.earning.value
                                                //         .toInt()
                                                //         .toString()
                                                //         .padLeft(4, '0')
                                                //         .toString()
                                                //         .split('')[1]),
                                                //   ),
                                                // ),
                                                // CandidateIncomeItem(
                                                //   value: int.parse(
                                                //     (controller.earning.value
                                                //         .toInt()
                                                //         .toString()
                                                //         .padLeft(4, '0')
                                                //         .toString()
                                                //         .split('')[2]),
                                                //   ),
                                                // ),
                                                // CandidateIncomeItem(
                                                //   value: int.parse(
                                                //     (controller.earning.value
                                                //         .toInt()
                                                //         .toString()
                                                //         .padLeft(4, '0')
                                                //         .toString()
                                                //         .split('')[3]),
                                                //   ),
                                                // ),
                                                // const SizedBox(
                                                //   width: 5,
                                                // ),
                                                // Dot(),
                                                // Obx(
                                                //   () => CandidateIncomeItem(
                                                //     value: controller.d2.value,
                                                //   ),
                                                // ),
                                                // const SizedBox(
                                                //   width: 5,
                                                // ),
                                                // Column(
                                                //   children: [
                                                //     Obx(() => CandidateIncomeItem(
                                                //         gradientTop: true,
                                                //         value: controller.d1.value == 0
                                                //             ? 9
                                                //             : controller.d1.value - 1)),
                                                //     const Spacer(),
                                                //     Obx(() => CandidateIncomeItem(
                                                //         value: controller.d1.value)),
                                                //     const Spacer(),
                                                //     Obx(
                                                //       () => CandidateIncomeItem(
                                                //           gradientBottom: true,
                                                //           value:
                                                //               (controller.d1.value + 1) ==
                                                //                       10
                                                //                   ? 0
                                                //                   : (controller.d1.value +
                                                //                       1)),
                                                //     ),
                                                //   ],
                                                // )
                                              ]),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          const Text(
                                            "Total earned salary till date",
                                            style: TextStyle(
                                                color: Colors.blueGrey),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "${controller.total_earning.value.toStringAsFixed(2)}/-",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          )
                                        ],
                                      ),
                          )
                        ],
                      )),
                  Positioned(
                    right: 0,
                    child: SafeArea(
                      child: IconButton(
                          onPressed: () {
                            Get.toNamed(Routes.NOTIFICATIONS);
                          },
                          icon: SizedBox(
                              height: 24,
                              width: 24,
                              child: Stack(
                                children: [
                                  SvgPicture.asset(
                                    "assets/notification.svg",
                                    height: 24,
                                    width: 24,
                                  ),
                                  // Obx(
                                  //   () => dashboardController
                                  //           .notificationController
                                  //           .notifications
                                  //           .isEmpty
                                  //       ? const SizedBox()
                                  //       : Positioned(
                                  //           top: 3,
                                  //           right: 0,
                                  //           child: Container(
                                  //             height: 8,
                                  //             width: 8,
                                  //             decoration: const BoxDecoration(
                                  //                 color: Colors.red,
                                  //                 shape: BoxShape.circle),
                                  //           ),
                                  //         ),
                                  // )
                                ],
                              ))),
                    ),
                  ),
                ]),
        ));
  }
}

class PercentageWidget extends StatelessWidget {
  const PercentageWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final CandidateLoginController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 155,
        width: 155,
        padding: const EdgeInsets.all(11),
        decoration:
            const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Obx(
          () => !controller.isAuthenticated && !controller.isLoggedOut
              ? Container(
                  height: 155,
                  width: 155,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Transform.rotate(
                          angle: -pi / 2,
                          child: Clock(now: controller.now.value))),
                )
              : Obx(
                  () => controller.isLoggedOut
                      ? Stack(
                          children: [
                            Container(
                              height: 155,
                              width: 155,
                              padding: const EdgeInsets.all(18),
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Transform.rotate(
                                      angle: -pi / 2,
                                      child: Clock(now: controller.now.value))),
                            ),

                            // Container(
                            //   height: 155,
                            //   width: 155,
                            //   padding: const EdgeInsets.all(18),
                            //   child: Obx(() => CustomPaint(
                            //         painter: CircularPercentPaint(
                            //             color: controller.isLoggedOut
                            //                 ? Colors.red
                            //                 : null,
                            //             breakEndPercentage:
                            //                 controller.breakEndPercentage.value,
                            //             progress: (controller.percentage.value)
                            //                 .toInt(),
                            //             isFirstHalf: false),
                            //       )),
                            // ),

                            /// draw break
                            // if (controller.breakStarted.value ==
                            //         BreakStatus.Started ||
                            //     controller.breakStarted.value ==
                            //         BreakStatus.Ended)
                            //   Container(
                            //     height: 155,
                            //     width: 155,
                            //     padding: const EdgeInsets.all(18),
                            //     child: Obx(() => CustomPaint(
                            //           painter: CircularPercentPaint(
                            //               breakStartedPercentage: controller
                            //                   .breakStartedPercentage.value,
                            //               progress: controller
                            //                           .breakStarted.value ==
                            //                       BreakStatus.Started
                            //                   ? controller.percentage.value
                            //                       .toInt()
                            //                   : controller.breakStarted.value ==
                            //                           BreakStatus.Ended
                            //                       ? (controller
                            //                               .breakEndPercentage
                            //                               .value)
                            //                           .toInt()
                            //                       : 10,
                            //               isBreak: true),
                            //         )),
                            //   ),

                            // /// Afte break
                            // Container(
                            //   height: 155,
                            //   width: 155,
                            //   padding: const EdgeInsets.all(18),
                            //   child: Obx(
                            //     () => CustomPaint(
                            //         painter: CircularPercentPaint(
                            //       color: controller.isLoggedOut
                            //           ? Colors.red
                            //           : null,
                            //       progress: controller.breakStarted.value ==
                            //                   BreakStatus.Started ||
                            //               controller.breakStarted.value ==
                            //                   BreakStatus.Ended
                            //           ? (controller.breakStartedPercentage
                            //                       .value +
                            //                   2)
                            //               .toInt()
                            //           : (controller.percentage.value + 2.2)
                            //               .toInt(),
                            //     )),
                            //   ),
                            // ),
                          ],
                        )
                      : Stack(
                          children: [
                            Container(
                              height: 155,
                              width: 155,
                              padding: const EdgeInsets.all(18),
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Transform.rotate(
                                      angle: -pi / 2,
                                      child: Obx(() =>
                                          Clock(now: controller.now.value)))),
                            ),

                            Container(
                              height: 155,
                              width: 155,
                              padding: const EdgeInsets.all(18),
                              child: Obx(() => CustomPaint(
                                    painter: CircularPercentPaint(
                                        breakEndPercentage:
                                            controller.breakEndPercentage.value,
                                        progress: (controller.percentage.value)
                                            .toInt(),
                                        isFirstHalf: false),
                                  )),
                            ),

                            /// draw break
                            if (controller.breakStarted.value ==
                                    BreakStatus.Started ||
                                controller.breakStarted.value ==
                                    BreakStatus.Ended)
                              Container(
                                height: 155,
                                width: 155,
                                padding: const EdgeInsets.all(18),
                                child: Obx(
                                  () => CustomPaint(
                                      painter: CircularPercentPaint(
                                          breakStartedPercentage: controller
                                                  .breakStartedPercentage
                                                  .value +
                                              7,
                                          progress: controller
                                                      .breakStarted.value ==
                                                  BreakStatus.Started
                                              ? (controller.percentage.value +
                                                      2.2)
                                                  .toInt()
                                              : controller.breakStarted.value ==
                                                      BreakStatus.Ended
                                                  ? (controller
                                                              .breakEndPercentage
                                                              .value +
                                                          2.2)
                                                      .toInt()
                                                  : controller.angle.value
                                                      .toInt(),
                                          isBreak: true)),
                                ),
                              ),
                            Container(
                              height: 155,
                              width: 155,
                              padding: const EdgeInsets.all(18),
                              child: Obx(
                                () => CustomPaint(
                                    painter: CircularPercentPaint(
                                  progress: controller.breakStarted.value ==
                                              BreakStatus.Started ||
                                          controller.breakStarted.value ==
                                              BreakStatus.Ended
                                      ? controller.breakStartedPercentage.value
                                          .toInt()
                                      : controller.percentage.value.toInt(),
                                )),
                              ),
                            ),
                          ],
                        ),
                ),
        ));
  }
}

class Dot extends StatelessWidget {
  const Dot({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      ".",
      style: AppTextStyles().large.copyWith(color: AppColors.primary),
    );
  }
}

class CandidateIncomeItem extends StatelessWidget {
  const CandidateIncomeItem(
      {Key? key,
      this.gradientTop = false,
      this.gradientBottom = false,
      this.value = 0})
      : super(key: key);
  final bool gradientTop;
  final bool gradientBottom;
  final int value;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 9,
      ),
      height: 46,
      width: 33.95,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.57143),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                if (gradientTop) ...[
                  const Color.fromRGBO(255, 255, 255, 1),
                  const Color.fromRGBO(41, 100, 255, 1),
                ] else
                  ...[],
                const Color.fromRGBO(41, 100, 255, 1),
                gradientBottom
                    ? const Color.fromRGBO(255, 255, 255, 1)
                    : const Color.fromRGBO(34, 64, 139, 1)
              ])),
      child: Stack(alignment: Alignment.center, children: [
        Positioned(
            top: 0,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6.57143),
                    topRight: Radius.circular(6.57143),
                  ),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: gradientTop
                          ? [Colors.white, Colors.white24]
                          : [
                              const Color.fromRGBO(34, 64, 139, 1),
                              const Color.fromRGBO(41, 100, 255, 1),
                            ])),
              height: 26,
              width: 34,
            )),
        Text(
          value.toString(),
          style: AppTextStyles().large,
        )
      ]),
    );
  }
}

class TimeWidget extends StatefulWidget {
  const TimeWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<TimeWidget> createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget> {
  var now = DateTime.now();
  late Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(1.seconds, (timer) {});
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat('hh:mm a').format(now),
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.w700, color: Colors.black), //.shade200,
      // shadows: [const Shadow(color: Colors.black, offset: Offset(1, 1))]),
      textAlign: TextAlign.center,
    );
  }
}

class Clock extends StatefulWidget {
  const Clock({super.key, this.now});
  final DateTime? now;
  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  CandidateLoginController controller = Get.find();
  @override
  void initState() {
    super.initState();
    // timer = Timer.periodic(1.seconds, (timer) {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.now != null) {
      return Obx(
          () => CustomPaint(painter: ClockPainter(controller.now.value)));
    } else {
      return Obx(
        () => CustomPaint(
            painter: ClockPainter(
          controller.now.value,
        )),
      );
    }
  }
}
