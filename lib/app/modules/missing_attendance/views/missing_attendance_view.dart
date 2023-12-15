import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/modules/add_employee/views/add_employee_view.dart';
import 'package:hajir/app/modules/company_detail/controllers/company_detail_controller.dart';
import 'package:hajir/app/modules/language/views/language_view.dart';
import 'package:hajir/app/utils/shrimmerloading.dart';
import 'package:hajir/core/localization/l10n/strings.dart';

import '../controllers/missing_attendance_controller.dart';

class MissingAttendanceView extends GetView<MissingAttendanceController> {
  const MissingAttendanceView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackButton(),
                Text(
                  "${strings.missing_attendance}/leaves",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w700),
                  // style: Theme.of(context)
                  //     .textTheme
                  //     .headline6!
                  //     .copyWith(fontSize: 24),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(() => controller.loading.isTrue
                    ? const ShrimmerLoading()
                    : CustomDropDownFieldWithDict(
                            hint: 'Select',
                            onChanged: (e) {
                              controller.candidate_id(e.toString());
                            },
                            values: [
                              ...controller.candidates
                            ],
                            items: [
                              ...controller.candidates.map((e) =>
                                  ((e['name'] ?? e['phone'] ?? "")).toString())
                            ]) ??
                        Text(controller.candidates.toString()) ??
                        CustomDropDownFieldWithDict(
                          onChanged: (e) {
                            controller.candidate_id(e.toString());
                          },
                          items: [],
                          hint: 'Select Candidate',
                          values: [...controller.candidates],
                        )),
                const SizedBox(
                  height: 20,
                ),
                CustomDropDownField(
                    onChanged: (e) {
                      controller.type(e);
                    },
                    hint: 'Select type',
                    items: const ['Present', 'Absent', 'Leave']),
                // CustomFormField(
                //   hint: strings.name_or_number,
                // ),
                const SizedBox(
                  height: 20,
                ),
                Obx(
                  () => CustomFormField(
                    onTap: () async {
                      var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now().subtract(90.days),
                          lastDate: DateTime.now());
                      if (date != null) {
                        controller
                            .attendance_date(date.toString().substring(0, 10));
                      }
                    },
                    hint: controller.attendance_date.value.isNotEmpty
                        ? controller.attendance_date.value
                        : strings.check_in_date,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(() => CustomFormField(
                      onTap: () async {
                        var time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null)
                          controller
                              .start_time(time.toString().substring(10, 15));
                      },
                      hint: controller.start_time.value.isNotEmpty
                          ? controller.start_time.value
                          : strings.check_in_time,
                    )),
                const SizedBox(
                  height: 20,
                ),
                Obx(() => CustomFormField(
                      onTap: () async {
                        var endTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (endTime != null) {
                          controller
                              .end_time(endTime.toString().substring(10, 15));
                        }
                      },
                      hint: controller.end_time.value.isNotEmpty
                          ? controller.end_time.value
                          : strings.check_out_time,
                    )),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      strings.overtime,
                      style: AppTextStyles.b2,
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 56,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              var time = controller.overTime.value.split(':');
                              var hour = int.parse(time.first);
                              var minute = int.parse(time.last);

                              if ((minute) < 60 && minute != 0) {
                                controller.overTime(
                                    "${(hour) < 10 ? '0$hour' : hour}:${(minute - 10)}");
                              } else if ((hour) <= 12 && hour != 0) {
                                controller.overTime(
                                    "${(hour - 1) < 10 ? '0${hour - 1}' : hour - 1}:00");
                              } else {}
                            },
                            child: Container(
                              height: 56,
                              width: 56,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      bottomLeft: Radius.circular(4))),
                              child: const Icon(Icons.remove),
                            ),
                          ),
                          Container(
                            width: 70,
                            height: 56,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            alignment: Alignment.center,
                            child: Obx(
                              () => Text(
                                controller.overTime.value,
                                style: AppTextStyles.b2,
                              ),
                            ),
                          ),
                          InkWell(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(4),
                                bottomRight: Radius.circular(4)),
                            onTap: () {
                              var time = controller.overTime.value.split(':');
                              var hour = int.parse(time.first);
                              var minute = int.parse(time.last);

                              if ((minute) < 60) {
                                controller.overTime(
                                    "${(hour) < 10 ? '0$hour' : hour}:${minute + 10}");
                              } else if ((hour) < 12) {
                                controller.overTime(
                                    "${(hour + 1) < 10 ? '0${hour + 1}' : hour + 1}:00");
                              } else {}
                            },
                            child: Container(
                              height: 56,
                              width: 56,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  color: Colors.grey.shade200,
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(4),
                                      bottomRight: Radius.circular(4))),
                              child: const Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                    onPressed: () {
                      controller.missingAttendanceSubmit();
                      // Get.back();
                    },
                    label: strings.add),
              ],
            )),
      ),
    ));
  }
}
