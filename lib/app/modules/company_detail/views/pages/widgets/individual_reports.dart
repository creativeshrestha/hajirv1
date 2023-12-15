import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hajir/app/config/app_colors.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/modules/add_employee/views/add_employee_view.dart';
import 'package:hajir/app/modules/candidate_login/views/widgets/custom_paint/circular_progress_paint.dart';
import 'package:hajir/app/modules/company_detail/controllers/company_detail_controller.dart';
import 'package:hajir/app/modules/company_detail/models/payment_request.dart';
import 'package:hajir/app/modules/company_detail/views/pages/employee.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/profile.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/reports.dart';
import 'package:hajir/app/modules/language/views/language_view.dart';
import 'package:hajir/app/modules/login/controllers/login_controller.dart';
import 'package:hajir/app/utils/shrimmerloading.dart';
import 'package:hajir/core/localization/l10n/strings.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher_string.dart';

class IndividualReportController extends GetxController {
  final AttendanceSystemProvider attendanceApi = Get.find();
  final CompanyDetailController detailController = Get.find();

  var dailyReport = {}.obs;
  var weeklyReport = {}.obs;
  var monthlyReport = {}.obs;
  var annualReport = {}.obs;
  var loading = false.obs;
  var selectedPayment = "".obs;
  var notificationSelected = false.obs;
  var deductionSelected = false.obs;
  var bonusSelected = false.obs;
  var bonusAmount = TextEditingController();
  var deductionTdsTax = TextEditingController();
  getDailyReport(String id, String compId) async {
    loading(true);
    dailyReport['daily '] = {};

    if (Get.arguments['status'].toString().toLowerCase() != 'absent') {
      try {
        var result = await attendanceApi.getCandidateDailyReport(id, compId);
        dailyReport(result.body['data']);
      } catch (e) {
        Get.rawSnackbar(message: e.toString());
        dailyReport({});
      }
    } else {}
    getWeeklyReport(Get.arguments['candidate_id'].toString(),
        detailController.selectedCompany.value);
  }

  getWeeklyReport(String id, String compId) async {
    loading(true);
    weeklyReport['weekly_datas'] = {};
    try {
      var result = await attendanceApi.getCandidateWeeklyReport(id, compId);
      weeklyReport(result.body['data']);
    } catch (e) {
      Get.rawSnackbar(message: e.toString());
      dailyReport({});
    }
    getMonthlyReport(
        id: Get.arguments['candidate_id'].toString(),
        compId: detailController.selectedCompany.value);
  }

  getMonthlyReport({id, compId}) async {
    monthlyReport({});
    id = Get.arguments['candidate_id'].toString();
    compId = detailController.selectedCompany.value;
    var now = DateTime.now();

    var selectedMonth = DateFormat("yyyy-MM-dd")
        .format(DateTime(now.year, detailController.selectedMonth.value, 01));
    try {
      loading(true);
      var result = await attendanceApi.getCandidateMonthlyReport(id, compId,
          selectedMonth: selectedMonth);
      monthlyReport(result.body['data']);
    } catch (e) {
      Get.rawSnackbar(message: e.toString());
      dailyReport({});
    }
    getYearlyReport();
  }

  getYearlyReport() async {
    loading(true);
    try {
      var result = await attendanceApi.getCandidateYearlyReport(
          Get.arguments['candidate_id'].toString(),
          detailController.selectedCompany.value,
          detailController.selectedYear.value);
      annualReport(result.body['data']);
    } catch (e) {
      Get.rawSnackbar(
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.transparent,
          messageText: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(boxShadow: const [
              BoxShadow(color: Colors.black54, blurRadius: 3)
            ], borderRadius: BorderRadius.circular(4).r, color: Colors.white),
            child: Text(e.toString()),
          ));
      dailyReport({});
    }
    loading(false);
  }

  sendNotification(String message) async {
    var result = await attendanceApi.sendNotification(
        Get.arguments['id'].toString(),
        detailController.selectedCompany.value,
        message);

    Get.back();
    if (result.body['status'] == 'success') {
      Get.rawSnackbar(message: result.body['message']);
    }
  }

  @override
  onInit() {
    super.onInit();
    if (Get.arguments['status'].toString().toLowerCase() == 'absent') {
      Get.find<CompanyDetailController>().selectedReport(1);
    }

    getDailyReport(Get.arguments['candidate_id'].toString(),
        detailController.selectedCompany.value);
  }

  sendPayment() async {
    var paymentRequest = PaymentRequest(
        bonus: bonusAmount.text,
        deduction: deductionTdsTax.text,
        status: selectedPayment.value,
        paymentForMonth:
            DateFormat('yyyy-mm-dd').format(DateTime(now.year, now.month)));
    var candidateid = Get.arguments['candidate_id'].toString();
    try {
      showLoading();
      await attendanceApi.paymentSubmit(paymentRequest,
          detailController.selectedCompany.value.capitalizeFirst!, candidateid);
      Get.back();
      Get.back();
    } catch (e) {
      Get.back();
      Get.rawSnackbar(message: e.toString());
    }
  }
}

class IndividualReport extends StatelessWidget {
  const IndividualReport({super.key});

  @override
  Widget build(BuildContext context) {
    final CompanyDetailController controller = Get.find();
    final individualReportController = Get.put(IndividualReportController());
    final TextEditingController message = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final repaintBoundary = GlobalKey();
    return AppBottomSheet(
      child: SizedBox(
        height: Get.height * .92,
        child: RepaintBoundary(
          key: repaintBoundary,
          child: SingleChildScrollView(
            child: Column(children: [
              /// TITLE
              TitleWidget(title: strings.individual_reports),

              ///  GAP
              const SizedBox(
                height: 18,
              ),

              Obx(
                () => individualReportController.loading.isTrue
                    ? const ShrimmerLoading()
                    : individualReportController.dailyReport.isEmpty
                        ? const SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                /// NAME DETAIL
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          Get.arguments['name'] ?? "NA",
                                          style: AppTextStyles.normal,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          Get.arguments['code'] ?? "NA",
                                          style: AppTextStyles.normal
                                              .copyWith(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        captureAndSharePng(repaintBoundary);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(6.r),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(
                                              .1,
                                            ),
                                            shape: BoxShape.circle),
                                        height: 30,
                                        width: 30,
                                        child: SvgPicture.asset(
                                          "assets/Vector(2).svg",
                                          color: Colors.grey,
                                          width: 15,
                                          height: 16,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        launchUrlString(
                                            'tel:${Get.arguments['phone']}');
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(6.r),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(
                                              .1,
                                            ),
                                            shape: BoxShape.circle),
                                        height: 30,
                                        width: 30,
                                        child: SvgPicture.asset(
                                          "assets/Vector(1).svg",
                                          color: Colors.grey,
                                          width: 15,
                                          height: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Obx(
                                  () => individualReportController
                                          .loading.isTrue
                                      ? const ShrimmerLoading()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (individualReportController
                                                        .dailyReport[
                                                    'weekly_datas'] !=
                                                null)
                                              Expanded(
                                                child: ReportsButton(
                                                    isbottomSheet: true,
                                                    onPressed: () {
                                                      if (Get.arguments[
                                                                  'status']
                                                              .toString()
                                                              .toLowerCase() ==
                                                          'absent') {
                                                      } else {
                                                        controller
                                                            .selectedReport(5);
                                                      }
                                                    },
                                                    active: controller
                                                                .selectedReport
                                                                .value ==
                                                            5
                                                        ? true
                                                        : false,
                                                    label: strings.daily
                                                        .toUpperCase()),
                                              ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: ReportsButton(
                                                  isbottomSheet: true,
                                                  onPressed: () {
                                                    controller
                                                        .selectedReport(0);
                                                  },
                                                  active: controller
                                                              .selectedReport
                                                              .value ==
                                                          0
                                                      ? true
                                                      : false,
                                                  label: strings.weekly
                                                      .toUpperCase()),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: ReportsButton(
                                                  isbottomSheet: true,
                                                  active: controller
                                                              .selectedReport
                                                              .value ==
                                                          1
                                                      ? true
                                                      : false,
                                                  onPressed: () {
                                                    controller
                                                        .selectedReport(1);
                                                  },
                                                  label: strings.monthly
                                                      .toUpperCase()),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: ReportsButton(
                                                  isbottomSheet: true,
                                                  active: controller
                                                              .selectedReport
                                                              .value ==
                                                          2
                                                      ? true
                                                      : false,
                                                  onPressed: () {
                                                    controller
                                                        .selectedReport(2);
                                                  },
                                                  label: strings.annual
                                                      .toUpperCase()),
                                            ),
                                          ],
                                        ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),

                                Obx(() => controller.selectedReport.value == 2
                                    ? const SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 8,
                                                  width: 8,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors
                                                          .green.shade800),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Obx(
                                                  () => Text(
                                                    "${strings.present.split(" ").first} [${individualReportController.weeklyReport['present']}]",
                                                    style: AppTextStyles.medium
                                                        .copyWith(
                                                            fontSize: 11,
                                                            color: Colors.green
                                                                .shade700),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 8,
                                                  width: 8,
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.grey),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "${strings.absent} [${individualReportController.weeklyReport['absent']}]",
                                                  style: AppTextStyles.medium
                                                      .copyWith(
                                                          fontSize: 11,
                                                          color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 8,
                                                  width: 8,
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.red),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Leave [${individualReportController.weeklyReport['leave']}]",
                                                  style: AppTextStyles.medium
                                                      .copyWith(
                                                          fontSize: 11,
                                                          color: Colors.red),
                                                ),
                                              ],
                                            ),
                                          ])),

                                Obx(() => controller.selectedReport.value == 2
                                    ? const SizedBox()
                                    : const SizedBox(
                                        height: 20,
                                      )),
                                Obx(
                                  () => controller.selectedReport.value == 2
                                      ? SizedBox(
                                          height: 31,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (_, i) => Obx(
                                              () => Container(
                                                margin: REdgeInsets.only(
                                                    right: 27.5),
                                                width: 41.w,
                                                child: InkWell(
                                                  onTap: () {
                                                    controller.selectedYear(
                                                        (now.year) - i);
                                                    individualReportController
                                                        .getYearlyReport();
                                                  },
                                                  child: Text(
                                                    // (Get.locale! == const Locale('en', 'US'))
                                                    //     ?
                                                    DateFormat("yyyy").format(
                                                        DateTime(
                                                            (now.year) - i))
                                                    // : ""
                                                    ,
                                                    style: TextStyle(
                                                        color: controller
                                                                    .selectedYear
                                                                    .value ==
                                                                ((now.year) - i)
                                                            ? Colors
                                                                .green.shade800
                                                            : Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12.sp),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ))
                                      : controller.selectedReport.value == 1
                                          ? SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: List.generate(
                                                    12,
                                                    (index) => InkWell(
                                                          onTap: () {
                                                            controller
                                                                .selectedMonth(
                                                                    index + 1);
                                                            individualReportController
                                                                .getMonthlyReport();
                                                          },
                                                          child: SizedBox(
                                                              width: 48.w,
                                                              height: 31.h,
                                                              child: Text(
                                                                DateFormat(
                                                                        "MMM dd")
                                                                    .format(DateTime(
                                                                        now
                                                                            .year,
                                                                        index +
                                                                            1,
                                                                        01)),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12.sp,
                                                                    color: controller.selectedMonth.value ==
                                                                            index +
                                                                                1
                                                                        ? Colors
                                                                            .green
                                                                        : Colors
                                                                            .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              )),
                                                        )),
                                              ),
                                            )
                                          : Column(
                                              children: [
                                                controller.selectedReport
                                                            .value ==
                                                        5
                                                    ? const SizedBox()
                                                    : SizedBox(
                                                        height: 30,
                                                        child:
                                                            SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Obx(
                                                                () =>
                                                                    WeekButton(
                                                                        onPressed:
                                                                            () {
                                                                          controller
                                                                              .selectedWeek(0);
                                                                          individualReportController.getWeeklyReport(
                                                                              Get.arguments['candidate_id'].toString(),
                                                                              individualReportController.detailController.selectedCompany.value);
                                                                        },
                                                                        label:
                                                                            "WEEK 1",
                                                                        active: controller.selectedWeek.value ==
                                                                                0
                                                                            ? true
                                                                            : false),
                                                              ),
                                                              Obx(() =>
                                                                  WeekButton(
                                                                      onPressed:
                                                                          () {
                                                                        controller
                                                                            .selectedWeek(1);

                                                                        individualReportController.getWeeklyReport(
                                                                            Get.arguments['candidate_id'].toString(),
                                                                            individualReportController.detailController.selectedCompany.value);
                                                                      },
                                                                      label:
                                                                          "WEEK 2",
                                                                      active: controller.selectedWeek.value ==
                                                                              1
                                                                          ? true
                                                                          : false)),
                                                              Obx(() =>
                                                                  WeekButton(
                                                                      onPressed:
                                                                          () {
                                                                        controller
                                                                            .selectedWeek(2);
                                                                        individualReportController.getWeeklyReport(
                                                                            Get.arguments['candidate_id'].toString(),
                                                                            individualReportController.detailController.selectedCompany.value);
                                                                      },
                                                                      label:
                                                                          "WEEK 3",
                                                                      active: controller.selectedWeek.value ==
                                                                              2
                                                                          ? true
                                                                          : false)),
                                                              Obx(() =>
                                                                  WeekButton(
                                                                      onPressed:
                                                                          () {
                                                                        controller
                                                                            .selectedWeek(3);
                                                                        individualReportController.getWeeklyReport(
                                                                            Get.arguments['candidate_id'].toString(),
                                                                            individualReportController.detailController.selectedCompany.value);
                                                                      },
                                                                      label:
                                                                          "WEEK 4",
                                                                      active: controller.selectedWeek.value ==
                                                                              3
                                                                          ? true
                                                                          : false)),
                                                              Obx(() =>
                                                                  WeekButton(
                                                                      onPressed:
                                                                          () {
                                                                        controller
                                                                            .selectedWeek(4);
                                                                        individualReportController.getWeeklyReport(
                                                                            Get.arguments['candidate_id'].toString(),
                                                                            individualReportController.detailController.selectedCompany.value);
                                                                      },
                                                                      label:
                                                                          "WEEK 5",
                                                                      active: controller.selectedWeek.value ==
                                                                              4
                                                                          ? true
                                                                          : false)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                SizedBox(
                                                  height: 40,
                                                  child: Obx(
                                                    () => individualReportController
                                                            .loading.isTrue
                                                        ? const ShrimmerLoading()
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: controller
                                                                        .selectedItem
                                                                        .value ==
                                                                    5
                                                                ? individualReportController.dailyReport[
                                                                            'weekly_datas'] ==
                                                                        null
                                                                    ? []
                                                                    : [
                                                                        ...individualReportController
                                                                            .dailyReport[
                                                                                'weekly_datas']
                                                                            .entries
                                                                            .map((e) =>
                                                                                WeekDay(
                                                                                  data: e,
                                                                                ))
                                                                      ]
                                                                : individualReportController
                                                                            .weeklyReport['weekly_datas'] ==
                                                                        null
                                                                    ? []
                                                                    : [
                                                                        ...individualReportController
                                                                            .weeklyReport[
                                                                                'weekly_datas']
                                                                            .entries
                                                                            .map((e) =>
                                                                                WeekDay(
                                                                                  data: e,
                                                                                ))
                                                                      ],
                                                            // children: List.generate(
                                                            //     controller.selectedWeek.value == 4
                                                            //         ? 3
                                                            //         : 7,
                                                            //     (index) => WeekDay(

                                                            //         data: individualReportController
                                                            //             .weeklyReport['weekdata']
                                                            //             .entries[index],
                                                            //         isActive:
                                                            //             (index == 2) ? true : false,
                                                            //         onPressed: () {},
                                                            //         day: weekDay[index],
                                                            //         date: controller
                                                            //                     .selectedWeek.value ==
                                                            //                 0
                                                            //             ? index + 1
                                                            //             : controller.selectedWeek
                                                            //                         .value ==
                                                            //                     1
                                                            //                 ? (7 + index)
                                                            //                 : controller.selectedWeek
                                                            //                             .value ==
                                                            //                         2
                                                            //                     ? (14 + index)
                                                            //                     : controller.selectedWeek
                                                            //                                 .value ==
                                                            //                             3
                                                            //                         ? (21 + index)
                                                            //                         : controller.selectedWeek
                                                            //                                     .value ==
                                                            //                                 4
                                                            //                             ? (28 + index)
                                                            //                             : (32 +
                                                            //                                 index),),
                                                            // ),
                                                          ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                ),
                                Obx(() => controller.selectedReport.value == 5
                                    ? Column(
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${individualReportController.dailyReport['start_time']}",
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              SvgPicture.asset(
                                                  "assets/material-symbols_arrow-insert-rounded.svg"),
                                              const Spacer(),
                                              Text(
                                                "${individualReportController.dailyReport['end_time']}",
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              SvgPicture.asset(
                                                  "assets/material-symbols_arrow-insert-rounded(1).svg"),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      strings.breaks,
                                                      style: const TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      "${individualReportController.dailyReport['break_time']}",
                                                      style: const TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 155,
                                                  width: 200,
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Positioned(
                                                        right: 40,
                                                        child: Container(
                                                          height: 140,
                                                          width: 140,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(18),
                                                          child: CustomPaint(
                                                            painter:
                                                                CircularPercentPaint(
                                                              color: Colors.red,
                                                              allGreen: false,
                                                              progress: 100,
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  strings
                                                                      .total_hours,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .green
                                                                          .shade800),
                                                                ),
                                                                Text(
                                                                  "${individualReportController.dailyReport['attendance_duration']}",
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                          top: 155 / 2 - 5,
                                                          right: 0,
                                                          child: Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              SvgPicture.asset(
                                                                "assets/Group 105.svg",
                                                                height: 24,
                                                                width: 30.5,
                                                              ),
                                                              const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            6.0),
                                                                child: Text(
                                                                  "",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              )
                                                            ],
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${strings.total_earning} ",
                                                style: TextStyle(
                                                    color: Colors
                                                        .blueGrey.shade600),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                "${individualReportController.dailyReport['totalearning']}",
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : const SizedBox()),
                                const SizedBox(
                                  height: 20,
                                ),
                                Obx(() => controller.selectedReport.value == 5
                                    ? const SizedBox()
                                    // : controller.selectedReport.value == 2
                                    //     ? Column(
                                    //         children: [
                                    //           Text(
                                    //             strings.annual_leave_summary,
                                    //             style: AppTextStyles()
                                    //                 .large
                                    //                 .copyWith(fontSize: 14, color: AppColors.primary),
                                    //           ),
                                    //         ],
                                    //       )
                                    : Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                strings.description,
                                                style: AppTextStyles()
                                                    .large
                                                    .copyWith(
                                                        fontSize: 14,
                                                        color:
                                                            AppColors.primary),
                                              ),
                                              const Spacer(),
                                              Text(
                                                strings.amount,
                                                style: AppTextStyles()
                                                    .large
                                                    .copyWith(
                                                        fontSize: 14,
                                                        color:
                                                            AppColors.primary),
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                            thickness: 1,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Obx(() =>
                                              controller.selectedReport.value ==
                                                      2
                                                  ? individualReportController
                                                                  .annualReport[
                                                              'datas'] ==
                                                          null
                                                      ? const SizedBox()
                                                      : Column(
                                                          children: [
                                                            ...List.generate(
                                                              individualReportController
                                                                  .annualReport[
                                                                      'datas']
                                                                      [0]
                                                                  .length,
                                                              (i) => Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        5.0),
                                                                child: DescriptionItem(
                                                                    status: individualReportController.annualReport['datas'][0][i]['status'].toString(),
                                                                    label: individualReportController.annualReport['datas'][0][i]['month'].toString()
                                                                    // DateFormat(
                                                                    //         'MMMM')
                                                                    //     .format(DateTime(
                                                                    //         2023, i + 1))
                                                                    ,
                                                                    value: individualReportController.annualReport['datas'][0][i]['amount'].toString()),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            const Divider(
                                                              thickness: 1,
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Total",
                                                                  style: AppTextStyles()
                                                                      .large
                                                                      .copyWith(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              AppColors.primary),
                                                                ),
                                                                const Spacer(),
                                                                Text(
                                                                  individualReportController
                                                                      .annualReport[
                                                                          'total']
                                                                      .toString(),
                                                                  style: AppTextStyles()
                                                                      .large
                                                                      .copyWith(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              AppColors.primary),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            const Divider(
                                                              thickness: 1,
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                          ],
                                                        )
                                                  : Column(
                                                      children: [
                                                        DescriptionItem(
                                                            label:
                                                                strings.salary,
                                                            value: controller
                                                                        .selectedReport
                                                                        .value ==
                                                                    0
                                                                ? individualReportController
                                                                    .weeklyReport[
                                                                        'current_week_salary']
                                                                    .toString()
                                                                : "${(double.tryParse(individualReportController.monthlyReport['salary'].toString()) ?? 0.0).toStringAsFixed(2)}/-"),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        if (controller
                                                                .selectedReport
                                                                .value !=
                                                            0)
                                                          DescriptionItem(
                                                              label: strings
                                                                  .overtime,
                                                              value:
                                                                  "${individualReportController.monthlyReport['overtime']} /-"),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        if (controller
                                                                .selectedReport
                                                                .value !=
                                                            0)
                                                          DescriptionItem(
                                                              label:
                                                                  strings.bonus,
                                                              value:
                                                                  "${individualReportController.monthlyReport['bonus']} /-"),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        if (controller
                                                                .selectedReport
                                                                .value !=
                                                            0)
                                                          DescriptionItem(
                                                              label: strings
                                                                  .allowance,
                                                              value:
                                                                  "${individualReportController.monthlyReport['allowance']} /-"),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Obx(() => controller
                                                                    .selectedReport
                                                                    .value ==
                                                                1
                                                            ? Column(
                                                                children: [
                                                                  const Divider(
                                                                    thickness:
                                                                        1,
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  DescriptionItem(
                                                                      label: strings
                                                                          .tax,
                                                                      value:
                                                                          "- ${individualReportController.monthlyReport['tax'].toString()} /-"),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  DescriptionItem(
                                                                      label: strings
                                                                          .penalty,
                                                                      value:
                                                                          "- ${individualReportController.monthlyReport['penalty'].toString()}/-"),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                ],
                                                              )
                                                            : const SizedBox()),
                                                        if (controller
                                                                .selectedReport
                                                                .value !=
                                                            0)
                                                          const Divider(
                                                            thickness: 1,
                                                          ),
                                                        if (controller
                                                                .selectedReport
                                                                .value !=
                                                            0)
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                        if (controller
                                                                .selectedReport
                                                                .value !=
                                                            0)
                                                          Row(
                                                            children: [
                                                              Text(
                                                                strings.balance,
                                                                style: AppTextStyles()
                                                                    .large
                                                                    .copyWith(
                                                                        fontSize:
                                                                            14,
                                                                        color: AppColors
                                                                            .primary),
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                "(${double.parse(individualReportController.monthlyReport['salary'].toString()) + individualReportController.monthlyReport['allowance'] + individualReportController.monthlyReport['overtime'] + individualReportController.monthlyReport['bonus']} - ${individualReportController.monthlyReport['tax'] + individualReportController.monthlyReport['penalty']}) = ${double.tryParse(individualReportController.monthlyReport['salary'].toString()) ?? 0 + individualReportController.monthlyReport['overtime'] - individualReportController.monthlyReport['tax'] - individualReportController.monthlyReport['penalty'] + individualReportController.monthlyReport['allowance'] + individualReportController.monthlyReport['bonus']}/-",
                                                                style: AppTextStyles()
                                                                    .large
                                                                    .copyWith(
                                                                        fontSize:
                                                                            14,
                                                                        color: AppColors
                                                                            .primary),
                                                              ),
                                                            ],
                                                          ),
                                                        if (controller
                                                                .selectedReport
                                                                .value !=
                                                            0)
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                        const Divider(
                                                          thickness: 1,
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Obx(() => controller
                                                                    .selectedReport
                                                                    .value ==
                                                                1
                                                            ? Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        "Sick Leave",
                                                                        // strings
                                                                        //     .leave_information,
                                                                        style: AppTextStyles().large.copyWith(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.primary),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Divider(
                                                                    thickness:
                                                                        1,
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  DescriptionItem(
                                                                      label:
                                                                          "Total"
                                                                      //  strings
                                                                      //     .sick_leave
                                                                      ,
                                                                      value:
                                                                          "${individualReportController.monthlyReport['total_leave']}"),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  DescriptionItem(
                                                                      label:
                                                                          "Avail",
                                                                      value:
                                                                          "-${individualReportController.monthlyReport['taken']}"),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  const Divider(
                                                                    thickness:
                                                                        1,
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        strings
                                                                            .remaining_leave,
                                                                        style: AppTextStyles().large.copyWith(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.primary),
                                                                      ),
                                                                      const Spacer(),
                                                                      Text(
                                                                        "${individualReportController.monthlyReport['total_available']} days",
                                                                        style: AppTextStyles().large.copyWith(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                AppColors.primary),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          18),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          "Leave Summary",
                                                                          style: AppTextStyles().large.copyWith(
                                                                              fontSize: 14,
                                                                              color: AppColors.primary)),
                                                                      const SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                120,
                                                                            width:
                                                                                180,
                                                                            child:
                                                                                CircularPercentIndicator(
                                                                              startAngle: 90,
                                                                              progressColor: Colors.green.shade800,
                                                                              lineWidth: 14,
                                                                              circularStrokeCap: CircularStrokeCap.round,
                                                                              backgroundColor: Colors.grey.shade300,
                                                                              center: Text(
                                                                                DateFormat('MMM dd').format(DateTime.now()).capitalize!,
                                                                                style: const TextStyle(fontWeight: FontWeight.w600),
                                                                              ),
                                                                              percent: ((int.parse(individualReportController.monthlyReport['total_leave'].toString()) == 0 ? 1 : int.parse(individualReportController.monthlyReport['total_leave'].toString())) / (int.parse(individualReportController.monthlyReport['total_available'].toString())) == double.infinity ? 0 : (int.tryParse(individualReportController.monthlyReport['total_leave']) ?? 1.0) ~/ individualReportController.monthlyReport['total_available']).toDouble(),
                                                                              radius: 50,
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                LeaveItem(
                                                                                  label: "Total ",
                                                                                  days: " ${individualReportController.monthlyReport['total_leave']} days",
                                                                                  color: Colors.blue.shade800,
                                                                                ),
                                                                                LeaveItem(
                                                                                  label: "Available",
                                                                                  days: " ${individualReportController.monthlyReport['total_available']} days",
                                                                                  color: Colors.green.shade600,
                                                                                ),
                                                                                LeaveItem(
                                                                                  label: "Avail",
                                                                                  days: " ${individualReportController.monthlyReport['taken']} days",
                                                                                  color: Colors.red.shade600,
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),

                                                                      const SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            36.h,
                                                                        width: double
                                                                            .infinity,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        padding:
                                                                            const EdgeInsets.all(2),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(7
                                                                                .r),
                                                                            boxShadow: const [
                                                                              BoxShadow(color: Color.fromRGBO(236, 237, 240, 1), blurRadius: 2)
                                                                            ],
                                                                            color: const Color.fromRGBO(
                                                                                236,
                                                                                237,
                                                                                240,
                                                                                1)),
                                                                        child:
                                                                            Obx(
                                                                          () =>
                                                                              Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: InkWell(
                                                                                  onTap: () {
                                                                                    individualReportController.notificationSelected(false);
                                                                                  },
                                                                                  child: Container(
                                                                                      alignment: Alignment.center,
                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(7.r), color: individualReportController.notificationSelected.isFalse ? Colors.white : Colors.transparent),
                                                                                      height: 32.h,
                                                                                      width: double.infinity,
                                                                                      child: Text(
                                                                                        "Payments",
                                                                                        style: AppTextStyles.b2.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp),
                                                                                      )),
                                                                                ),
                                                                              ),
                                                                              // Expanded(
                                                                              //   child: InkWell(
                                                                              //     onTap: () {
                                                                              //       controller.notificationSelected(false);
                                                                              //     },
                                                                              //     child: Container(
                                                                              //         alignment: Alignment.center,
                                                                              //         decoration: BoxDecoration(
                                                                              //             borderRadius: BorderRadius.circular(7.r),
                                                                              //             color: controller.notificationSelected.isTrue
                                                                              //                 ? Colors.white
                                                                              //                 : Colors.transparent),
                                                                              //         height: 32.h,
                                                                              //         width: double.infinity,
                                                                              //         child: Text(
                                                                              //           strings.active,
                                                                              //           style: AppTextStyles.b2,
                                                                              //         )),
                                                                              //   ),
                                                                              // ),
                                                                              Expanded(
                                                                                child: InkWell(
                                                                                  onTap: () {
                                                                                    individualReportController.notificationSelected(true);
                                                                                  },
                                                                                  child: Container(
                                                                                      alignment: Alignment.center,
                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(7.r), color: individualReportController.notificationSelected.isTrue ? Colors.white : Colors.transparent),
                                                                                      height: 32.h,
                                                                                      width: double.infinity,
                                                                                      child: Text(
                                                                                        "Notify",
                                                                                        style: AppTextStyles.b2.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp),
                                                                                      )),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20.h,
                                                                      ),

                                                                      /// Payments Notifiy
                                                                      Obx(() => individualReportController
                                                                              .notificationSelected
                                                                              .isFalse
                                                                          ? Form(
                                                                              key: formKey,
                                                                              child: const PaymentsNotifyWidget())
                                                                          : CustomFormField(
                                                                              controller: message,
                                                                              isMultiline: true,
                                                                              title: "Send personal notification",
                                                                              titlecolor: Colors.black,
                                                                              hint: "Message",
                                                                            )),
                                                                      const SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      Obx(
                                                                        () => CustomButton(
                                                                            onPressed: () {
                                                                              if (formKey.currentState!.validate()) {
                                                                                individualReportController.notificationSelected.isFalse ? individualReportController.sendPayment() : individualReportController.sendNotification(message.text);
                                                                              }
                                                                            },
                                                                            label: individualReportController.notificationSelected.isTrue ? "Send" : "Submit"),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              )
                                                            : const SizedBox()),
                                                      ],
                                                    ))
                                        ],
                                      )),

                                Obx(() =>
                                    controller.selectedReport.value == 1 ||
                                            controller.selectedReport.value == 2
                                        ? const SizedBox()
                                        : Column(
                                            children: [
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              CustomFormField(
                                                isMultiline: true,
                                                controller: message,
                                                titlecolor: Colors.black,
                                                title:
                                                    "Send message", // strings.message,
                                                hint: strings.message,
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              CustomButton(
                                                  onPressed: () {
                                                    individualReportController
                                                        .sendNotification(
                                                            message.text);
                                                  },
                                                  label: strings.add),
                                            ],
                                          )),

                                const SizedBox(
                                  height: 20,
                                ),
                              ]),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

class LeaveItem extends StatelessWidget {
  const LeaveItem({
    super.key,
    required this.label,
    required this.days,
    required this.color,
  });
  final String label;
  final String days;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 8),
          Text(
            "$label",
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Text(
            ":" + days,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class PaymentsNotifyWidget extends StatelessWidget {
  const PaymentsNotifyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<IndividualReportController>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CustomDropDownField(
        title: "Mark as",
        onChanged: (e) {
          controller.selectedPayment(e);
        },
        hint: 'Select value',
        items: const ['paid', 'unpaid', 'hold'],
      ),
      SizedBox(
        height: 20.h,
      ),
      Text(
        "Add Bonus",
        style: AppTextStyles.l1
            .copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
      ),
      SizedBox(
        height: 10.h,
      ),
      Obx(
        () => Row(
          children: [
            Checkbox(
                activeColor: AppColors.primary,
                value: controller.bonusSelected.isTrue,
                onChanged: (v) {
                  controller.bonusSelected(v);
                }),
            SizedBox(
              width: 20.w,
            ),
            if (controller.bonusSelected.isTrue)
              Expanded(
                child: TextFormField(
                  controller: controller.bonusAmount,
                  decoration: InputDecoration(
                      hintText: "eg. 5000",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      hintStyle: AppTextStyles.l1
                          .copyWith(fontWeight: FontWeight.w600),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300)),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                ),
              ),
          ],
        ),
      ),
      SizedBox(
        height: 20.h,
      ),
      Text(
        "Deduction (TDS or tax)",
        style: AppTextStyles.l1
            .copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
      ),
      SizedBox(
        height: 10.h,
      ),
      Obx(
        () => Row(
          children: [
            Checkbox(
                activeColor: AppColors.primary,
                value: controller.deductionSelected.isTrue,
                onChanged: (v) {
                  controller.deductionSelected(v);
                }),
            SizedBox(
              width: 20.w,
            ),
            if (controller.deductionSelected.isTrue)
              Expanded(
                child: TextFormField(
                  controller: controller.deductionTdsTax,
                  decoration: InputDecoration(
                      hintText: "eg. 120",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      hintStyle: AppTextStyles.l1
                          .copyWith(fontWeight: FontWeight.w600),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300)),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                ),
              ),
          ],
        ),
      ),
      SizedBox(
        height: 20.h,
      ),
    ]);
  }
}
