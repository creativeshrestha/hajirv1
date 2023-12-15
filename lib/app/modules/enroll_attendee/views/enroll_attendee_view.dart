import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/modules/company_detail/views/pages/attendance.dart';
import 'package:hajir/app/modules/language/views/language_view.dart';
import 'package:hajir/app/utils/shrimmerloading.dart';
import 'package:hajir/core/localization/l10n/strings.dart';

import '../controllers/enroll_attendee_controller.dart';

class EnrollAttendeeView extends GetView<EnrollAttendeeController> {
  const EnrollAttendeeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Obx(
        () => controller.loading.isTrue
            ? const Center(child: ShrimmerLoading())
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const BackButton(),
                Text(
                  strings.enroll_attendee,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  height: 36.h,
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.r),
                      color: Colors.grey.shade100
                      // boxShadow: const [
                      //   BoxShadow(
                      //       color: Color.fromRGBO(236, 237, 240, 1), blurRadius: 2)
                      // ],
                      // color: const Color.fromRGBO(236, 237, 240, 1)),
                      ),
                  child: Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              controller.selected = 0;
                            },
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.r),
                                    color: controller.selected == 0
                                        ? Colors.white
                                        : Colors.transparent),
                                height: 32.h,
                                width: double.infinity,
                                child: Text(
                                  strings.clock_in,
                                  style: AppTextStyles.b2,
                                )),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              controller.selected = 1;
                            },
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.r),
                                    color: controller.selected == 1
                                        ? Colors.white
                                        : Colors.transparent),
                                height: 32.h,
                                width: double.infinity,
                                child: Text(
                                  strings.clock_out,
                                  style: AppTextStyles.b2,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AttendanceItem(
                        label: strings.attendee,
                        value: controller.data['data'] != null
                            ? (controller.data['data']['total_attendee'] ?? 0)
                                .toString()
                            : "",
                        color: const Color.fromRGBO(0, 128, 0, .1),
                        borderColor: const Color.fromRGBO(0, 128, 0, .05)),
                    AttendanceItem(
                        label: strings.absent,
                        value: controller.data['data'] != null
                            ? (controller.data['data']['absent'] ?? 0)
                                .toString()
                            : "",
                        color: const Color.fromRGBO(255, 80, 80, 0.1),
                        borderColor: const Color.fromRGBO(255, 80, 80, 0.05)),
                    AttendanceItem(
                      label: strings.late,
                      value: controller.data['data'] != null
                          ? (controller.data['data']['late'] ?? 0).toString()
                          : "",
                      color: const Color.fromRGBO(128, 128, 128, 0.1),
                      borderColor: const Color.fromRGBO(128, 128, 128, 0.05),
                    ),
                    AttendanceItem(
                      // onPressed: () {
                      //   Get.bottomSheet(
                      //     OverAllReports(),
                      //     isScrollControlled: true,
                      //   );
                      // },
                      label: strings.pending,
                      value: controller.data['data'] != null
                          ? (controller.data['data']['pending'] ?? "NA")
                              .toString()
                          : "".toString(),
                      color: const Color.fromRGBO(0, 0, 255, 0.1),
                      borderColor: const Color.fromRGBO(0, 0, 255, 0.1),
                    )
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                Expanded(
                    child: controller.data['data'] == null
                        ? const Text("Error")
                        : controller.data['data']['clockin_candidates']
                                    .length ==
                                0
                            ? const Center(child: Text("No Attendee"))
                            : Obx(
                                () => ListView.builder(
                                    itemCount: controller.selected == 1
                                        ? controller
                                            .data['data']['clockin_candidates']
                                            .length
                                        : controller
                                            .data['data']['clockout_candidates']
                                            .length,
                                    itemBuilder: (_, i) {
                                      var candidate = controller.selected == 1
                                          ? controller.data['data']
                                              ['clockin_candidates'][i]
                                          : controller.data['data']
                                              ['clockout_candidates'][i];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12.0),
                                        child: Container(
                                          // height: 66,
                                          padding: REdgeInsets.symmetric(
                                              vertical: 12),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey.shade200,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        (candidate['name'] ??
                                                                "")
                                                            .toString(),
                                                        style: AppTextStyles.b1
                                                            .copyWith(
                                                                fontSize: 14),
                                                      ),
                                                      const SizedBox(
                                                        height: 6,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            controller.selected ==
                                                                    0
                                                                ? (candidate[
                                                                            'start_time'] ??
                                                                        "")
                                                                    .toString()
                                                                : (candidate[
                                                                            'end_time'] ??
                                                                        "")
                                                                    .toString(),
                                                            style: AppTextStyles
                                                                .body
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                          ),
                                                          SizedBox(width: 2.w),
                                                          SvgPicture.asset(controller
                                                                      .selected ==
                                                                  0
                                                              ? "assets/material-symbols_arrow-insert-rounded.svg"
                                                              : "assets/material-symbols_arrow-insert-rounded(1).svg"),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 18,
                                              ),
                                              InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                onTap: () {
                                                  final message =
                                                      TextEditingController();
                                                  Get.dialog(Dialog(
                                                    child: Container(
                                                      // height: 300,

                                                      padding:
                                                          REdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.r),
                                                          color: Colors.white),
                                                      child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                      "Reporting -> ${candidate['name']}",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w600)),
                                                                ),
                                                                const CloseButton()
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            TextField(
                                                              controller:
                                                                  message,
                                                              maxLines: 4,
                                                              decoration: InputDecoration(
                                                                  hintText:
                                                                      "Your message",
                                                                  border: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade200))),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            CustomButton(
                                                                height: 40,
                                                                onPressed: () {
                                                                  controller.submitReport(
                                                                      message
                                                                          .text,
                                                                      candidate[
                                                                              'candidate_id']
                                                                          .toString(),
                                                                      candidate[
                                                                              'attendance_id']
                                                                          .toString());
                                                                },
                                                                label:
                                                                    ("Send")),
                                                          ]),
                                                    ),
                                                  ));
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                      // color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      // color: Colors.green.shade800,
                                                      border: Border.all(
                                                          color: Colors.grey)),
                                                  // height: 22,
                                                  child: Text(
                                                    "REPORT".toUpperCase(),
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600
                                                        // color: Colors.white,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 18,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ))
              ]),
      ),
    )));
  }
}
