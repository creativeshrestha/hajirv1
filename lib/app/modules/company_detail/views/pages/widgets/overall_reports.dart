import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hajir/app/config/app_colors.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/modules/candidate_login/views/widgets/custom_paint/circular_progress_paint.dart';
import 'package:hajir/app/modules/company_detail/controllers/company_detail_controller.dart';
import 'package:hajir/app/modules/company_detail/views/pages/employee.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/profile.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/reports.dart';
import 'package:hajir/app/utils/shrimmerloading.dart';
import 'package:hajir/core/localization/l10n/strings.dart';
import 'package:percent_indicator/percent_indicator.dart';

class OverallController extends GetxController {
  var loading = false.obs;
  var dailyReport = {}.obs;
  final CompanyDetailController controller = Get.find();
  final AttendanceSystemProvider attendanceApi = Get.find();
  @override
  onInit() {
    super.onInit();
    getDailyReports();
  }

  void getDailyReports() async {
    loading(true);
    try {
      var result = await attendanceApi.getOverAllDailyReport(
          companyId: controller.selectedCompany.value,
          type: controller.selectedReport.value);
      dailyReport(result.body['data']);
    } catch (e) {
      handleException(e);
      // Get.rawSnackbar(
      //     borderRadius: 10.r,
      //     borderColor: Colors.grey.shade200,
      //     message: e.toString(),
      //     snackPosition: SnackPosition.TOP);
    }
    loading(false);
  }
}

class OverAllReports extends StatelessWidget {
  const OverAllReports({super.key});

  @override
  Widget build(BuildContext context) {
    final OverallController overallController = Get.find();
    final CompanyDetailController controller = Get.find();
    final GlobalKey globalKey = GlobalKey();
    return RepaintBoundary(
      key: globalKey,
      child: AppBottomSheet(
        child: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16),
            child: SizedBox(
              height: Get.height * .9,
              child: Column(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TitleWidget(title: strings.overall_reports),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: REdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ReportsButton(
                                isbottomSheet: true,
                                onPressed: () {
                                  controller.selectedReport(5);
                                  overallController.getDailyReports();
                                },
                                active: controller.selectedReport.value == 5
                                    ? true
                                    : false,
                                label: strings.daily),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: ReportsButton(
                                isbottomSheet: true,
                                onPressed: () {
                                  controller.selectedReport(0);
                                  overallController.getDailyReports();
                                },
                                active: controller.selectedReport.value == 0
                                    ? true
                                    : false,
                                label: strings.weekly),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: ReportsButton(
                                isbottomSheet: true,
                                active: controller.selectedReport.value == 1
                                    ? true
                                    : false,
                                onPressed: () {
                                  controller.selectedReport(1);
                                  overallController.getDailyReports();
                                },
                                label: strings.monthly),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: ReportsButton(
                                isbottomSheet: true,
                                active: controller.selectedReport.value == 2
                                    ? true
                                    : false,
                                onPressed: () {
                                  controller.selectedReport(2);
                                  overallController.getDailyReports();
                                },
                                label: strings.annual),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                overallController.loading.isTrue
                    ? const Expanded(child: ShrimmerLoading())
                    : overallController.dailyReport['total_attendee'] == null
                        ? const SizedBox()
                        : Column(
                            children: [
                              ReportItem(
                                title: strings.attendee,
                                value: overallController
                                    .dailyReport['total_attendee']
                                    .toString(),
                                color: const Color.fromRGBO(0, 128, 0, .1),
                              ),
                              ReportItem(
                                title: strings.absent,
                                value: overallController.dailyReport['absent']
                                    .toString(),
                                color: const Color.fromRGBO(255, 80, 80, 0.1),
                              ),
                              ReportItem(
                                title: strings.late,
                                value: overallController.dailyReport['late']
                                    .toString(),
                                color: const Color.fromRGBO(128, 128, 128, 0.1),
                              ),
                              ReportItem(
                                title: strings.early_punch_out,
                                value: overallController
                                    .dailyReport['punch_out']
                                    .toString(),
                                color: const Color.fromRGBO(0, 0, 255, 0.1),
                              ),
                              ReportItem(
                                title: "Leave Taken",
                                value: overallController
                                    .dailyReport['leave_taken']
                                    .toString(),
                                color: const Color.fromRGBO(0, 0, 255, 0.1),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              SizedBox(
                                // height: 90,
                                // width: 90,
                                child: CircularPercentIndicator(
                                      radius: 50.0,
                                      lineWidth: 12.0,
                                      percent: overallController
                                              .dailyReport['percentage'] /
                                          100,
                                      center: new Text(
                                          "${overallController.dailyReport['percentage'].toStringAsFixed(2)}%"),
                                      progressColor: Colors.green,
                                    ) ??
                                    CustomPaint(
                                      painter: CircularPercentPaint(
                                        allGreen: true,
                                        progress: overallController
                                                .dailyReport['percentage']
                                                .toInt() ??
                                            0,
                                      ),
                                      child: Center(
                                          child: Text(
                                        '${overallController.dailyReport['percentage'].toStringAsFixed(2) ?? '0'}%',
                                        style: AppTextStyles.b1.copyWith(
                                            color: Colors.green.shade800),
                                      )),
                                    ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Text(
                                strings.attendance_records,
                                style: AppTextStyles.title,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                if (overallController.loading.isFalse)
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 40,
                          child: OutlinedButton(
                            onPressed: () {
                              captureAndSharePng(globalKey);
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.grey.shade200,
                                    child: SvgPicture.asset(
                                      "assets/Vector(2).svg",
                                      color: AppColors.primary.withOpacity(.6),
                                      height: 12,
                                      width: 12,
                                    )),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text("Share"),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                // backgroundColor: Colors.blue.withOpacity(.1),
                                // shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(40))
                                ),
                            onPressed: () async {
                              try {
                                await captureAndDownload(globalKey);
                                Get.rawSnackbar(
                                    message: "File Downloaded".toString());
                              } catch (e) {
                                Get.rawSnackbar(message: e.toString());
                              }
                            },
                            child: Container(
                              // height: 60,
                              padding: const EdgeInsets.all(8.0),
                              child: Text(strings.export),
                            ),
                          ),
                        )
                      ]),
                const SizedBox(
                  height: 20,
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class ReportItem extends StatelessWidget {
  const ReportItem({
    required this.color,
    required this.title,
    required this.value,
    Key? key,
  }) : super(key: key);
  final String title;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        height: 40.h,
        decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          children: [
            Text(
              value,
              style: AppTextStyles.b1.copyWith(color: Colors.red),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: VerticalDivider(),
            ),
            Text(
              title,
              style: AppTextStyles.b2,
            )
          ],
        ));
  }
}
