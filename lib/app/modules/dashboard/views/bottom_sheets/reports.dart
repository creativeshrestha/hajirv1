import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hajir/app/config/app_colors.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/data/providers/network/api_endpoint.dart';
import 'package:hajir/app/modules/candidate_login/controllers/candidate_login_controller.dart';
import 'package:hajir/app/modules/company_detail/views/pages/employee.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/dashboard/views/apply_leave.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/model/week.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/profile.dart';
import 'package:hajir/app/modules/mobile_opt/controllers/mobile_opt_controller.dart';
import 'package:hajir/app/utils/shrimmerloading.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';
import 'package:hajir/core/localization/l10n/strings.dart';
import 'package:intl/intl.dart';

var weekDay = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
var now = DateTime.now();

class ResultProvider extends GetConnect {
  @override
  onInit() {
    super.onInit();
    httpClient.baseUrl = APIEndpoint.baseUrl;
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
  }

  getAllWeeks(String date) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    return parseRes(await get(
        "candidate/report/month/allweeks/${appSettings.companyId}/$date",
        headers: globalHeaders));
  }

  getAllMonths(String date) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    return parseRes(await get(
        "/candidate/report/year/allmonths/${appSettings.companyId}/$date",
        headers: globalHeaders));
  }

  Future<BaseResponse> getMonthlyReport(String date) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    return parseRes(await get(
        "${APIEndpoint.monthlyReport}/${appSettings.companyId}/$date",
        query: {'from': date, 'to': date},
        headers: globalHeaders));
  }

  Future<BaseResponse> getWeeklyReport(from, to) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    return parseRes(await get(
        "${APIEndpoint.weeklyReport}/${appSettings.companyId}",
        query: {'from': from, 'to': to},
        headers: globalHeaders));
  }

  Future<BaseResponse> getYearlyReport(String year) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    return parseRes(await get(
        "${APIEndpoint.yearlyReport}/${appSettings.companyId}/$year",
        headers: globalHeaders));
  }
}

class ReportController extends GetxController {
  final ResultProvider repository = Get.find();
  var monthly = {}.obs;
  var weekly = {}.obs;
  var yearly = {}.obs;
  var selectedWeek = 0.obs;
  var loadingSuccess = false.obs;
  var loading = false.obs;
  var selectedMonth = 0.obs;
  var selectedReportType = 0.obs;
  var selectedYear = 0.obs;
  var now = DateTime.now();
  var list = [].obs;
  var weeklist = <Week>[].obs;
  double yearlyTotal() {
    double sum = 0;
    if (yearly['data'] != null) {
      if (yearly['data'].length > 0) {
        yearly['data'].forEach((e) {
          sum = sum + double.parse(e['total_earning'] ?? '0');
        });
      }
    }
    return sum;
  }

  // yearly['data']
  //     .fold(0, (int t, e) => (int.tryParse(e['total_earning']) ?? 0 + t)) ??
  // 0;
  selectMonth(int i) {
    selectedMonth(i);
  }

  int get selectedReport => selectedReportType.value;
  set selectedReport(int i) => selectedReportType(i);

  @override
  onInit() {
    super.onInit();
    selectedYear(now.year);
    getWeeks();
  }

  getWeeks() async {
    loading(true);
    var date = DateFormat('yyyy-MM-dd')
        .format(DateTime(now.year, selectedMonth.value, 1));

    try {
      var result = await repository.getAllWeeks(date);
      weeklist(weekFromJson(jsonEncode(result.body['data'])));
      print(weeklist);
      getWeeklyReport(
        weeklist[0].from,
        weeklist[0].to,
      );
    } catch (e) {}
  }

  getAllMonths() async {
    var result = await repository.getAllMonths(now.year.toString());
    print(result.body);
  }

  init() {
    // getWeeklyReport();
    getMonthlyReport();
    getYearlyReport();
  }

  getWeeklyReport(from, to) async {
    try {
      loading(true);
      var result = await repository.getWeeklyReport(from, to);
      // print(result.body['data']['weekdata']);
      loading(false);
      // log(result.body['data'].toString());
      weekly(result.body['data']);
      // weekly({
      //   'weekdata': {
      //     '2022-02-05': 'Present',
      //     '2022-02-06': 'Present',
      //     '2022-02-07': 'Late',
      //     '2022-02-08': 'Business Holiday',
      //     '2022-02-09': 'Abscent',
      //     '2022-02-10': 'Government Holiday',
      //     '2022-02-11': 'Government Holiday',
      //   }
      // });

      // weekly['weekdata'].entries.forEach((e) => list.add({e.key, e.value}));
      // print(list);
      loadingSuccess(true);
      getMonthlyReport();
      getYearlyReport();
    } catch (e) {
      loading(false);
      Get.rawSnackbar(message: e.toString());
    }
  }

  getMonthlyReport() async {
    try {
      var date = DateFormat('yyyy-MM-dd')
          .format(DateTime(now.year, selectedMonth.value, 1));
      var result = await repository.getMonthlyReport(date.toString());
      loadingSuccess(true);
      // print(result.body);
      monthly(result.body['data']);

      log(result.body);
    } catch (e) {}
  }

  getYearlyReport() async {
    try {
      loading(true);
      loadingSuccess(false);
      // var year = DateTime.now().year.toString();
      var result = await repository.getYearlyReport(selectedYear.toString());
      loadingSuccess(true);
      loading(false);
      yearly(result.body['data']);
      // print(result.body);
    } catch (e) {}
  }

  void changeSelectedYear(int i) {
    selectedYear((now.year) - i);
    getYearlyReport();
  }
}

class Reports extends GetView<ReportController> {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController dashBoardController = Get.find();
    final CandidateLoginController candidateLoginController = Get.find();

    final GlobalKey globalKey = GlobalKey();

    return RepaintBoundary(
      key: globalKey,
      child: AppBottomSheet(
        child: SizedBox(
          height: .9.sh,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TitleWidget(title: strings.reports),
                const SizedBox(
                  height: 18,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dashBoardController.user.value.name
                                        .toString()
                                        .capitalize ??
                                    dashBoardController.user.value.name
                                        .toString(),
                                style: AppTextStyles.normal
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Obx(
                                () => Text(
                                  // Get.find<CandidateLoginController>()
                                  candidateLoginController.companyCode.value
                                      .toString(),
                                  style: AppTextStyles.normal.copyWith(
                                      color: Colors.grey, fontSize: 11.sp),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          InkWell(
                              onTap: () {
                                captureAndSharePng(globalKey);
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
                              )),
                          // const SizedBox(
                          //   width: 10,
                          // ),
                          // Container(
                          //   padding: EdgeInsets.all(6.r),
                          //   decoration: BoxDecoration(
                          //       color: Colors.grey.withOpacity(
                          //         .1,
                          //       ),
                          //       shape: BoxShape.circle),
                          //   height: 30,
                          //   width: 30,
                          //   child: SvgPicture.asset(
                          //     "assets/Vector(1).svg",
                          //     color: Colors.grey,
                          //     width: 15,
                          //     height: 16,
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ReportsButton(
                                  fontSize: 12.sp,
                                  onPressed: () {
                                    // dashBoardController.selectedReport(0);
                                    controller.selectedReport = (0);
                                  },
                                  active: controller.selectedReport == 0
                                      ? true
                                      : false,
                                  label: strings.weekly),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: ReportsButton(
                                  fontSize: 12.sp,
                                  active: controller.selectedReport == 1
                                      ? true
                                      : false,
                                  onPressed: () {
                                    controller.selectedReport = (1);
                                    // dashBoardController.selectedReport(1);
                                  },
                                  label: strings.monthly),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: ReportsButton(
                                  fontSize: 12.sp,
                                  active: controller.selectedReport == 2
                                      ? true
                                      : false,
                                  onPressed: () {
                                    controller.selectedReport = (2);
                                    // dashBoardController.selectedReport(2);
                                  },
                                  label: strings.annual),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Obx(
                        () => controller.selectedReport == 2
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
                                              color: Colors.green.shade800),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Obx(
                                          () => Text(
                                            "Present [${controller.selectedReport == 0 ? controller.weekly['present'] ?? 'NA' : controller.monthly['presentCount'] ?? 'NA'}]",
                                            style: AppTextStyles.medium
                                                .copyWith(
                                                    fontSize: 11,
                                                    color:
                                                        Colors.green.shade700),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 8,
                                          width: 8,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Obx(() => Text(
                                              "Absent [${controller.selectedReportType.value == 0 ? controller.weekly['absent'] ?? "NA" : controller.monthly['absentcount'].toString()}]",
                                              style: AppTextStyles.medium
                                                  .copyWith(
                                                      fontSize: 11,
                                                      color: Colors.grey),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 8,
                                          width: 8,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Obx(
                                          () => Text(
                                            "Leave [${controller.selectedReport == 0 ? controller.weekly['leave'] ?? "NA" : controller.monthly['leavecount']}]",
                                            style: AppTextStyles.medium
                                                .copyWith(
                                                    fontSize: 11,
                                                    color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => controller.selectedReport == 2
                            ? SizedBox(
                                height: 31,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (_, i) => Obx(
                                    () => Container(
                                      margin: REdgeInsets.only(right: 27.5),
                                      width: 41.w,
                                      child: InkWell(
                                        onTap: () {
                                          controller.changeSelectedYear(i);
                                        },
                                        child: Text(
                                          // (Get.locale! == const Locale('en', 'US'))
                                          //     ?
                                          DateFormat("yyyy")
                                              .format(DateTime((now.year) - i))
                                          // : ""
                                          ,
                                          style: TextStyle(
                                              color: controller
                                                          .selectedYear.value ==
                                                      ((now.year) - i)
                                                  ? Colors.green
                                                  : Colors.grey,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12.sp),
                                        ),
                                      ),
                                    ), //     : true,
                                    // isActive: controller
                                    //         .loadingSuccess
                                    //         .isTrue
                                    //     ? controller.weekly[
                                    //             'weekdata ']
                                    //         .containsKey(weekDay[index].capitalizeFirst)
                                    //     : false,
                                  ),
                                ))
                            : controller.selectedReport == 1
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(
                                          12,
                                          (index) => InkWell(
                                                onTap: () {
                                                  // controller.selectMonth(index);

                                                  // dashBoardController
                                                  //     .selectedMonth(index + 1);
                                                },
                                                child: SizedBox(
                                                    width: 48.w,
                                                    height: 31.h,
                                                    child: Text(
                                                      DateFormat("MMM dd")
                                                          .format(DateTime(
                                                              now.year,
                                                              index + 1,
                                                              now.day)),
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color: dashBoardController
                                                                      .selectedMonth
                                                                      .value ==
                                                                  index + 1
                                                              ? Colors.green
                                                              : Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )),
                                              )),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Obx(
                                                () => Row(children: [
                                                  ...controller.weeklist
                                                      .map((element) =>
                                                          WeekButton(
                                                              active: controller
                                                                      .selectedWeek
                                                                      .value ==
                                                                  controller
                                                                      .weeklist
                                                                      .indexOf(
                                                                          element),
                                                              // active: DateTime
                                                              //         .parse(element
                                                              //             .from)
                                                              //     .isAfter(DateTime
                                                              //         .parse(controller
                                                              //             .weeklist[controller
                                                              //                 .selectedWeek
                                                              //                 .value]
                                                              //             .from)),
                                                              onPressed: () {
                                                                var selectedIndex =
                                                                    controller
                                                                        .weeklist
                                                                        .indexOf(
                                                                            element);
                                                                controller
                                                                    .selectedWeek(
                                                                        selectedIndex);
                                                                controller.getWeeklyReport(
                                                                    controller
                                                                        .weeklist[
                                                                            selectedIndex]
                                                                        .from,
                                                                    controller
                                                                        .weeklist[
                                                                            selectedIndex]
                                                                        .to);
                                                              },
                                                              label:
                                                                  element.name))
                                                      .toList()
                                                ]),
                                              ),
                                              // Obx(
                                              //   () => WeekButton(
                                              //       onPressed: () {
                                              //         // if(now.day ~/ 7 + 1)
                                              //         // dashBoardController
                                              //         //     .selectedWeek(0);
                                              //       },
                                              //       label: "WEEK 1",
                                              //       active: dashBoardController
                                              //                   .selectedWeek
                                              //                   .value ==
                                              //               0
                                              //           ? true
                                              //           : false),
                                              // ),
                                              // Obx(() => WeekButton(
                                              //     onPressed: () {
                                              //       // dashBoardController
                                              //       //     .selectedWeek(1);
                                              //     },
                                              //     label: "WEEK 2",
                                              //     active: dashBoardController
                                              //                 .selectedWeek
                                              //                 .value ==
                                              //             1
                                              //         ? true
                                              //         : false)),
                                              // Obx(() => WeekButton(
                                              //     onPressed: () {
                                              //       // dashBoardController
                                              //       //     .selectedWeek(2);
                                              //     },
                                              //     label: "WEEK 3",
                                              //     active: dashBoardController
                                              //                 .selectedWeek
                                              //                 .value ==
                                              //             2
                                              //         ? true
                                              //         : false)),
                                              // Obx(() => WeekButton(
                                              //     onPressed: () {
                                              //       // dashBoardController
                                              //       //     .selectedWeek(3);
                                              //     },
                                              //     label: "WEEK 4",
                                              //     active: dashBoardController
                                              //                 .selectedWeek
                                              //                 .value ==
                                              //             3
                                              //         ? true
                                              //         : false)),
                                              // Obx(() => WeekButton(
                                              //     onPressed: () {
                                              //       // dashBoardController
                                              //       //     .selectedWeek(4);
                                              //     },
                                              //     label: "WEEK 5",
                                              //     active: dashBoardController
                                              //                 .selectedWeek
                                              //                 .value ==
                                              //             4
                                              //         ? true
                                              //         : false)),
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
                                          () => controller.loading.isTrue
                                              ? const ShrimmerLoading()
                                              : controller
                                                      .loadingSuccess.isFalse
                                                  ? InkWell(
                                                      onTap: () {
                                                        controller.init();
                                                      },
                                                      child: const Text(
                                                          'Try again'))
                                                  : SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          ...controller
                                                              .weekly[
                                                                  'weekdata']
                                                              .entries
                                                              .map((v) =>
                                                                  WeekDay(
                                                                    data: v,
                                                                  )), // Text({
                                                          //   v.key,
                                                          //   v.value
                                                          // }.toString())
                                                          // Text(controller
                                                          //     .weekly['weekdata']
                                                          //     .entries
                                                          //     .map((v) => {
                                                          //           v.key,
                                                          //           v.value
                                                          //         }.toString())
                                                          //     .toString())
                                                          // controller.weekly['weekdata']
                                                          //     .entries
                                                          //     .forEach((e) => Text({
                                                          //           e.key,
                                                          //           e.value
                                                          //         }.toString())),
                                                        ]
                                                        // .toList()
                                                        ,
                                                        // children: List.generate(
                                                        //     dashBoardController
                                                        //                 .selectedWeek
                                                        //                 .value ==
                                                        //             4
                                                        //         ? (DateTime(now.year, now.month + 1)
                                                        //                 .difference(DateTime(
                                                        //                     now.year,
                                                        //                     now
                                                        //                         .month))
                                                        //                 .inDays) -
                                                        //             27
                                                        //         : 7,
                                                        //     (index) => WeekDay(
                                                        //         day:
                                                        //             getWeekDay(index),
                                                        //         isActive: false,

                                                        //         // isActive: controller
                                                        //         //         .loadingSuccess
                                                        //         //         .isTrue
                                                        //         //     ? controller.now
                                                        //         //                 .toString()
                                                        //         //                 .substring(
                                                        //         //                     0, 10) ==
                                                        //         //             (7 + index)
                                                        //         //         ? true
                                                        //         //         : false
                                                        //         //     : false,
                                                        //         // isActive: controller
                                                        //         //         .loadingSuccess
                                                        //         //         .isTrue
                                                        //         //     ? controller
                                                        //         //         .weekly['weekdata']
                                                        //         //             [getDateByIndex(index)]
                                                        //         //         .contains('Late')
                                                        //         //     // .values
                                                        //         //     // [index]
                                                        //         //     // .contains(
                                                        //         //     //     'Late') //getDateByIndex(index))
                                                        //         //     : true,
                                                        //         // isActive: controller
                                                        //         //         .loadingSuccess
                                                        //         //         .isTrue
                                                        //         //     ? controller.weekly[
                                                        //         //             'weekdata ']
                                                        //         //         .containsKey(weekDay[index].capitalizeFirst)
                                                        //         //     : false,
                                                        //         date: dashBoardController
                                                        //                     .selectedWeek
                                                        //                     .value ==
                                                        //                 0
                                                        //             ? index + 1
                                                        //             : dashBoardController
                                                        //                         .selectedWeek
                                                        //                         .value ==
                                                        //                     1
                                                        //                 ? (7 + index)
                                                        //                 : dashBoardController
                                                        //                             .selectedWeek
                                                        //                             .value ==
                                                        //                         2
                                                        //                     ? (14 + index)
                                                        //                     : dashBoardController.selectedWeek.value == 3
                                                        //                         ? (21 + index)
                                                        //                         : dashBoardController.selectedWeek.value == 4
                                                        //                             ? (28 + index)
                                                        //                             : (32 + index)))
                                                      ),
                                                    ),
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            "Descirption",
                            style: AppTextStyles().large.copyWith(
                                fontSize: 14, color: AppColors.primary),
                          ),
                          const Spacer(),
                          // Text(
                          //   "Amount",
                          //   style: AppTextStyles()
                          //       .large
                          //       .copyWith(fontSize: 14, color: AppColors.primary),
                          // ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(thickness: 1),
                      const SizedBox(
                        height: 5,
                      ),
                      Obx(() => controller.yearly['monthly_datas'] != null
                          ? controller.selectedReport == 2
                              ? controller.loading.isTrue
                                  ? const ShrimmerLoading()
                                  : controller.loadingSuccess.isFalse
                                      ? InkWell(
                                          onTap: () => controller.init(),
                                          child: const Text('Try again'))
                                      : Column(
                                          children: [
                                            // Text(controller.yearly.toString()),
                                            if (controller
                                                    .yearly['monthly_datas'] !=
                                                null)
                                              ...List.generate(
                                                controller
                                                    .yearly['monthly_datas']
                                                    .length,
                                                (i) => Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: DescriptionItem(
                                                      label: DateFormat('MMMM')
                                                          .format(DateTime(
                                                              2023, i + 1)),
                                                      value:
                                                          '${controller.yearly['monthly_datas'][i]['earning']} '),
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
                                                          fontSize: 14,
                                                          color: AppColors
                                                              .primary),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  "${controller.yearly['total']}/-",
                                                  style: AppTextStyles()
                                                      .large
                                                      .copyWith(
                                                          fontSize: 14,
                                                          color: AppColors
                                                              .primary),
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
                              : controller.loading.isTrue
                                  ? const SizedBox()
                                  : Column(
                                      children: [
                                        DescriptionItem(
                                            label: strings.salary,
                                            value: controller.selectedReport ==
                                                    0
                                                ? '${controller.weekly['current_week_salary'].toStringAsFixed(2)}'
                                                : '${controller.monthly['monthly_salary'] ?? 0.toStringAsFixed(2)}'),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        DescriptionItem(
                                            label: strings.overtime,
                                            value: controller.selectedReport ==
                                                    0
                                                ? '${controller.weekly['current_week_overtime'].toStringAsFixed(2)}'
                                                : '${controller.monthly['monthly_overtime'].toStringAsFixed(2)}'),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        DescriptionItem(
                                            label: strings.bonus,
                                            value: controller.selectedReport ==
                                                    0
                                                ? '${controller.weekly['current_week_bonus'].toStringAsFixed(2)}'
                                                : '${controller.monthly['monthly_bonus'].toStringAsFixed(2)}'),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        DescriptionItem(
                                            label: strings.allowance,
                                            value: controller.selectedReport ==
                                                    0
                                                ? '${controller.weekly['current_week_allowance'].toStringAsFixed(2)}'
                                                : '${controller.monthly['monthly_allowance'].toStringAsFixed(2)}'),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Obx(() => controller.selectedReport == 1
                                            ? Column(
                                                children: [
                                                  const Divider(
                                                    thickness: 1,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  DescriptionItem(
                                                      label: strings.tax,
                                                      value: controller
                                                                  .selectedReport ==
                                                              0
                                                          ? '${controller.weekly['monthly_tax'].toStringAsFixed(2)}'
                                                          : '${controller.monthly['monthly_tax'].toStringAsFixed(2)}'),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  DescriptionItem(
                                                      label: strings.penalty,
                                                      value:
                                                          '${controller.monthly['monthly_penalty'].toStringAsFixed(2)}'),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              )
                                            : const SizedBox()),
                                        const Divider(
                                          thickness: 1,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              strings.balance,
                                              style: AppTextStyles()
                                                  .large
                                                  .copyWith(
                                                      fontSize: 14,
                                                      color: AppColors.primary),
                                            ),
                                            const Spacer(),
                                            Text(
                                              controller.selectedReport == 0
                                                  ? '${controller.weekly['current_week_total_salary'].toStringAsFixed(2)}'
                                                  : controller.monthly[
                                                              'monthly_total_deduction'] ==
                                                          0
                                                      ? controller.monthly[
                                                              'monthly_total_salary']
                                                          .toString()
                                                      : "(${controller.monthly['monthly_total_salary']} - ${controller.monthly['monthly_total_deduction']}) = ${controller.monthly['monthly_total_salary']}"
                                              // "['current_week_total_salary'] "
                                              ,
                                              style: AppTextStyles()
                                                  .large
                                                  .copyWith(
                                                      fontSize: 14,
                                                      color: AppColors.primary),
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
                                          height: 20,
                                        ),
                                        Obx(() => controller.selectedReport == 1
                                            ? Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        strings
                                                            .leave_information,
                                                        style: AppTextStyles()
                                                            .large
                                                            .copyWith(
                                                                fontSize: 14,
                                                                color: AppColors
                                                                    .primary),
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(
                                                    thickness: 1,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  DescriptionItem(
                                                      label: strings.sick_leave,
                                                      value:
                                                          "${controller.monthly['monthly_sick_leave']}"),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  DescriptionItem(
                                                      label:
                                                          strings.extra_leave,
                                                      value:
                                                          "${controller.monthly['monthly_casual_leave']}"),
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
                                                        strings.remaining_leave,
                                                        style: AppTextStyles()
                                                            .large
                                                            .copyWith(
                                                                fontSize: 14,
                                                                color: AppColors
                                                                    .primary),
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        "${controller.monthly['avaliable_leave']}",
                                                        style: AppTextStyles()
                                                            .large
                                                            .copyWith(
                                                                fontSize: 14,
                                                                color: AppColors
                                                                    .primary),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            : const SizedBox()),
                                      ],
                                    )
                          : const SizedBox()),
                      const SizedBox(
                        height: 5,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getDateByIndex(int index) {
    final DashboardController dashBoardController = Get.find();
    var date = dashBoardController.selectedWeek.value == 0
        ? index + 1
        : dashBoardController.selectedWeek.value == 1
            ? (7 + index)
            : dashBoardController.selectedWeek.value == 2
                ? (14 + index)
                : dashBoardController.selectedWeek.value == 3
                    ? (21 + index)
                    : dashBoardController.selectedWeek.value == 4
                        ? (28 + index)
                        : (32 + index);
    return DateTime(now.year, now.month, date).toString().substring(0, 10);
  }

  getWeekDay(int index) {
    final DashboardController dashBoardController = Get.find();
    var date = dashBoardController.selectedWeek.value == 0
        ? index + 1
        : dashBoardController.selectedWeek.value == 1
            ? (7 + index)
            : dashBoardController.selectedWeek.value == 2
                ? (14 + index)
                : dashBoardController.selectedWeek.value == 3
                    ? (21 + index)
                    : dashBoardController.selectedWeek.value == 4
                        ? (28 + index)
                        : (32 + index);
    return DateFormat('EEE').format(DateTime(now.year, now.month, date));
    //weekDay[index];
  }
}

class DescriptionItem extends StatelessWidget {
  const DescriptionItem(
      {Key? key, required this.label, this.value = '', this.status})
      : super(key: key);
  final String label;
  final String value;
  final status;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade800),
            // style: AppTextStyles.medium,
          ),
          const Spacer(),
          if (status != null)
            Container(
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: status.toString() == 'unpaid'
                        ? Colors.yellow.shade100
                        : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        color: status.toString() == 'unpaid'
                            ? Colors.red.shade500
                            : Colors.green.shade300)),
                width: 60,
                child: Text(
                  status.toString().toUpperCase(),
                  style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w900,
                    color: status.toString() == 'unpaid'
                        ? Colors.red.shade500
                        : Colors.green.shade800,
                  ),
                )),
          const SizedBox(
            width: 20,
          ),
          Text(
            value.toString(),
            style: AppTextStyles.medium.copyWith(color: Colors.grey.shade700),
          )
        ],
      ),
    );
  }
}

class WeekDay extends StatelessWidget {
  const WeekDay(
      {Key? key,
      this.data =
          const MapEntry('2022-03-01', 'Present'), //{'2022-03-01': 'Present'},
      this.day,
      this.date,
      this.onPressed,
      this.isActive})
      : super(key: key);
  final String? day;
  final int? date;
  final bool? isActive;
  final onPressed;
  final data;

  @override
  Widget build(BuildContext context) {
    bool isEmployer = isActive != null;

    // print(now.day);
    // print(day);
    var thisday = DateFormat('EEE').format(DateTime.parse(data.key));
    bool isLeave() {
      var leave = (thisday == "Sun" || thisday == "Sat") ? true : false;
      return leave;
    }

    var textStyle = TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: isLeave()
            ? Colors.red
            : data.value.contains('Holiday')
                ? Colors.red
                : data.value == 'Present' || data.value == 'Late'
                    ? Colors.green
                    : Colors.grey.shade700);
    return Tooltip(
      message: data.value,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              thisday,
              style: textStyle,
              // style: TextStyle(
              //     fontSize: 10.sp,
              //     fontWeight: FontWeight.w600,
              //     color: isEmployer
              //         ? isActive
              //             ? Colors.green
              //             : isLeave()
              //                 ? Colors.red
              //                 : Colors.grey
              //         : Colors.green),
            ),
            const SizedBox(
              height: 6,
            ),
            Container(
              decoration: BoxDecoration(
                  border: now.day.toString() == day
                      ? Border.all(color: Colors.green)
                      : null),
              child: Text(data.key.toString().split('-').last, style: textStyle
                  //   color: isEmployer
                  //       ? isActive
                  //           ? Colors.green
                  //           : isLeave()
                  //               ? Colors.red
                  //               : Colors.grey
                  //       : Colors.green,
                  // ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeekButton extends StatelessWidget {
  const WeekButton(
      {Key? key, this.active = false, required this.label, this.onPressed})
      : super(key: key);
  final onPressed;
  final bool active;
  final String label;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.transparent)),
      onPressed: onPressed,
      child: Text(
        label,
        style: AppTextStyles.b2.copyWith(
            fontSize: 10, color: active ? Colors.green : Colors.grey.shade600),
      ),
    );
  }
}

class ReportsButton extends StatelessWidget {
  const ReportsButton(
      {Key? key,
      this.onPressed,
      required this.label,
      this.fontSize,
      this.active = false,
      this.isbottomSheet = false,
      this.borderRadius = 4.0,
      this.activeColor})
      : super(key: key);
  final onPressed;
  final String label;
  final bool isbottomSheet;
  final double? fontSize;
  final bool active;
  final double borderRadius;
  final Color? activeColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: onPressed,
      child: Container(
          height: 28.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? activeColor ?? Colors.green.shade800
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: RPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                label,
                style: TextStyle(
                    fontSize: fontSize ??
                        (isbottomSheet
                            ? 10.sp
                            : active
                                ? 12.sp
                                : 12.sp),
                    fontWeight: FontWeight.w600,
                    color: active
                        ? activeColor != null
                            ? Colors.black
                            : Colors.white
                        : const Color.fromRGBO(0, 0, 0, 0).withOpacity(.4)),
              ))),
    );
  }
}
