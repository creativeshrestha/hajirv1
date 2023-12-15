import 'dart:io';

import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hajir/app/config/app_colors.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/data/providers/network/api_provider.dart';
import 'package:hajir/app/modules/add_employee/views/add_employee_view.dart';
import 'package:hajir/app/modules/candidate_login/views/widgets/custom_paint/circular_progress_paint.dart';
import 'package:hajir/app/modules/company_detail/controllers/company_detail_controller.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/profile.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/reports.dart';
import 'package:hajir/app/modules/employer_dashboard/controllers/employer_dashboard_controller.dart';
import 'package:hajir/app/modules/language/views/language_view.dart';
import 'package:hajir/app/modules/login/bindings/login_binding.dart';
import 'package:hajir/app/modules/login/controllers/login_controller.dart';
import 'package:hajir/app/routes/app_pages.dart';
import 'package:hajir/app/utils/shrimmerloading.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';
import 'package:hajir/core/localization/l10n/strings.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

class MonthlyReportsController extends GetxController {
  var dailyReport = {}.obs;
  var weeklyReport = {}.obs;
  var monthlyReport = {}.obs;
  var yearlyReport = {}.obs;
  var loading = false.obs;
  final AttendanceSystemProvider attendanceApi = Get.find();
  @override
  onInit() {
    super.onInit();

    getDailyReport();
    getWeeklyReport(Get.arguments);
    getMonthlyReport();
    getYearlyReport();
  }

  void getDailyReport() {}

  void getWeeklyReport(String empId) async {
    loading(true);
    try {
      var result = await attendanceApi.getEmployerWeeklyReport();
      weeklyReport(result.body['data']);
    } on UnauthorisedException catch (e) {
      loading(false);
      Get.to(() => Routes.LOGIN, binding: LoginBinding());
      Get.rawSnackbar(title: e.message, message: e.details['message']);
    } on BadRequestException catch (e) {
      loading(false);
      // Get.back();

      Get.rawSnackbar(title: e.message, message: e.details);
    } catch (e) {
      loading(false);

      // Get.back();

      Get.rawSnackbar(message: "Something Went Wrong".toString());
    }
  }

  void getMonthlyReport() {}

  void getYearlyReport() {}
} // To parse this JSON data, do
//
//     final filterReport = filterReportFromJson(jsonString);

FilterReport filterReportFromJson(String str) =>
    FilterReport.fromJson(json.decode(str));

String filterReportToJson(FilterReport data) => json.encode(data.toJson());

class FilterReport {
  String? status;
  String? message;
  Data? data;

  FilterReport({
    this.status,
    this.message,
    this.data,
  });

  factory FilterReport.fromJson(Map<String, dynamic> json) => FilterReport(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  List<Candidate>? candidates;
  double? balance;

  Data({
    this.candidates,
    this.balance,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        candidates: json["candidates"] == null
            ? []
            : List<Candidate>.from(
                json["candidates"]!.map((x) => Candidate.fromJson(x))),
        balance: double.parse(json["balance"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "candidates": candidates == null
            ? []
            : List<dynamic>.from(candidates!.map((x) => x.toJson())),
        "balance": balance,
      };
}

class Candidate {
  int? id;
  String? name;
  String? status;
  dynamic amount;

  Candidate({
    this.id,
    this.name,
    this.status,
    this.amount,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) => Candidate(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "amount": amount,
      };
}

class ReportFilterController extends GetxController {
  final attendanceProvider = Get.find<AttendanceSystemProvider>();
  final CompanyDetailController companyDetailController = Get.find();
  var report = FilterReport.fromJson({}).obs;
  var date = DateTime.now();
  var selectedMonth = 0.obs;
  var selectedYear = 2023.obs;
  var loading = false.obs;
  var html = "";
  @override
  void onInit() {
    super.onInit();
    selectedMonth(date.month);
    selectedYear(now.year);
    getReport();
  }

  Future<void> getPdfLink() async {
    showLoading();
    try {
      var date = DateFormat('yyyy/MM')
          .format(DateTime(selectedYear.value, selectedMonth.value));
      var result = await attendanceProvider.getPdf(
          date, companyDetailController.selectedCompany.value);
      html = (result.body['data']);
      Get.back();
    } catch (e) {
      Get.back();
    }
  }

  Future<void> getReport() async {
    try {
      loading(true);
      attendanceProvider
          .filterReport(
              companyDetailController.selectedCompany.value,
              DateFormat('yyyy/MM')
                  .format(DateTime(selectedYear.value, selectedMonth.value)))
          .then((v) {
        report(FilterReport.fromJson(v.body));
        loading(false);
      });
    } catch (e) {
      loading(false);
      handleException(e);
    }
  }

  void downloadPdf() async {
    await getPdfLink();
    if (html != '') {
      var dir = Platform.isAndroid
          ? '/storage/emulated/0/Download'
          : (await getApplicationDocumentsDirectory()).path;
      try {
        var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
            html, dir, "${DateTime.now().microsecondsSinceEpoch}");
        showSnackBar("File Downloaded to ${generatedPdfFile.path}");
      } catch (e) {
        showSnackBar(e.toString());
      }
    }
  }

  void sharePdf() async {
    await getPdfLink();
    var dir = Platform.isAndroid
        ? (await getTemporaryDirectory()).path
        : (await getApplicationDocumentsDirectory()).path;
    var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        html, dir, "${DateTime.now().microsecondsSinceEpoch}");
    await Share.file('MonthlyReport', 'pdf', generatedPdfFile.readAsBytesSync(),
        'application/pdf');
  }
}

class MonthlyReports extends StatelessWidget {
  MonthlyReports({super.key});

  final ReportFilterController reportController =
      Get.put(ReportFilterController());
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final EmployerDashboardController controller = Get.find();
    reportController.getReport();
    reportController.selectedMonth(reportController.date.month);
    Future.delayed(1.seconds, () {
      scrollController!.animateTo(
          (70 * reportController.selectedMonth.value.toDouble()),
          duration: 2.seconds,
          curve: Curves.linear);
    });
    return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: AppBottomSheet(
          child: SizedBox(
              height: .9.sh,
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                    /// TITLE
                    TitleWidget(title: strings.monthly_reports),

                    ///  GAP
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 200.w,
                          child: CustomDropDownField(
                              onChanged: (String? e) {
                                reportController
                                    .selectedYear(int.tryParse(e ?? '0') ?? 0);
                                reportController.getReport();
                              },
                              hint: '2022',
                              value: reportController.selectedYear.value
                                  .toString(),
                              items: List.generate(
                                  5,
                                  (index) => (DateTime.now().year - index)
                                      .toString()).toList()),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              reportController.sharePdf();
                            },
                            icon: const Icon(Icons.share))
                      ],
                    ),
                    SizedBox(
                      height: 28.h,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //   child:
                    //       Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    //     /// NAME DETAIL
                    //     Row(
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: [
                    //         Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               "Nitesh Shrestha",
                    //               style: AppTextStyles.normal,
                    //             ),
                    //             const SizedBox(
                    //               height: 5,
                    //             ),
                    //             Text(
                    //               "RT001",
                    //               style: AppTextStyles.normal.copyWith(fontSize: 11),
                    //             ),
                    //           ],
                    //         ),
                    //         const Spacer(),
                    //         Container(
                    //           padding: EdgeInsets.all(6.r),
                    //           decoration: BoxDecoration(
                    //               color: Colors.grey.withOpacity(
                    //                 .1,
                    //               ),
                    //               shape: BoxShape.circle),
                    //           height: 30,
                    //           width: 30,
                    //           child: SvgPicture.asset(
                    //             "assets/Vector(2).svg",
                    //             color: Colors.grey,
                    //             width: 15,
                    //             height: 16,
                    //           ),
                    //         ),
                    //         const SizedBox(
                    //           width: 10,
                    //         ),
                    //         Container(
                    //           padding: EdgeInsets.all(6.r),
                    //           decoration: BoxDecoration(
                    //               color: Colors.grey.withOpacity(
                    //                 .1,
                    //               ),
                    //               shape: BoxShape.circle),
                    //           height: 30,
                    //           width: 30,
                    //           child: SvgPicture.asset(
                    //             "assets/Vector(1).svg",
                    //             color: Colors.grey,
                    //             width: 15,
                    //             height: 16,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     const SizedBox(
                    //       height: 20,
                    //     ),
                    //     Obx(
                    //       () => Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Expanded(
                    //             child: ReportsButton(
                    //                 isbottomSheet: true,
                    //                 onPressed: () {
                    //                   controller.selectedReport(5);
                    //                 },
                    //                 active:
                    //                     controller.selectedReport.value == 5 ? true : false,
                    //                 label: strings.daily),
                    //           ),
                    //           const SizedBox(
                    //             width: 20,
                    //           ),
                    //           Expanded(
                    //             child: ReportsButton(
                    //                 isbottomSheet: true,
                    //                 onPressed: () {
                    //                   controller.selectedReport(0);
                    //                 },
                    //                 active:
                    //                     controller.selectedReport.value == 0 ? true : false,
                    //                 label: strings.weekly),
                    //           ),
                    //           const SizedBox(
                    //             width: 20,
                    //           ),
                    //           Expanded(
                    //             child: ReportsButton(
                    //                 isbottomSheet: true,
                    //                 active:
                    //                     controller.selectedReport.value == 1 ? true : false,
                    //                 onPressed: () {
                    //                   controller.selectedReport(1);
                    //                 },
                    //                 label: strings.monthly),
                    //           ),
                    //           const SizedBox(
                    //             width: 20,
                    //           ),
                    //           Expanded(
                    //             child: ReportsButton(
                    //                 isbottomSheet: true,
                    //                 active:
                    //                     controller.selectedReport.value == 2 ? true : false,
                    //                 onPressed: () {
                    //                   controller.selectedReport(2);
                    //                 },
                    //                 label: strings.annual),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       height: 24,
                    //     ),
                    //     Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    //       Row(
                    //         children: [
                    //           Container(
                    //             height: 8,
                    //             width: 8,
                    //             decoration: BoxDecoration(
                    //                 shape: BoxShape.circle, color: Colors.green.shade800),
                    //           ),
                    //           const SizedBox(
                    //             width: 5,
                    //           ),
                    //           Text(
                    //             "${strings.present.split(" ").first} [4]",
                    //             style: AppTextStyles.medium
                    //                 .copyWith(fontSize: 11, color: Colors.green.shade700),
                    //           ),
                    //         ],
                    //       ),
                    //       Row(
                    //         children: [
                    //           Container(
                    //             height: 8,
                    //             width: 8,
                    //             decoration: const BoxDecoration(
                    //                 shape: BoxShape.circle, color: Colors.grey),
                    //           ),
                    //           const SizedBox(
                    //             width: 5,
                    //           ),
                    //           Text(
                    //             "${strings.absent} [1]",
                    //             style: AppTextStyles.medium
                    //                 .copyWith(fontSize: 11, color: Colors.grey),
                    //           ),
                    //         ],
                    //       ),
                    //       Row(
                    //         children: [
                    //           Container(
                    //             height: 8,
                    //             width: 8,
                    //             decoration: const BoxDecoration(
                    //                 shape: BoxShape.circle, color: Colors.red),
                    //           ),
                    //           const SizedBox(
                    //             width: 5,
                    //           ),
                    //           Text(
                    //             "Leave [1]",
                    //             style: AppTextStyles.medium
                    //                 .copyWith(fontSize: 11, color: Colors.red),
                    //           ),
                    //         ],
                    //       ),
                    //     ]),
                    //     const SizedBox(
                    //       height: 20,
                    //     ),
                    SizedBox(
                        height: 31,
                        child: ListView.builder(
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: 12,
                            itemBuilder: (_, i) {
                              return Obx(
                                () => Container(
                                  margin: REdgeInsets.only(right: 27.5),
                                  width: 41.w,
                                  child: InkWell(
                                    onTap: () {
                                      reportController.selectedMonth((i));
                                      reportController.getReport();
                                    },
                                    child: Text(
                                      DateFormat("MMM dd")
                                          .format(DateTime(2023, i + 1))
                                      // : ""
                                      ,
                                      style: TextStyle(
                                          color: reportController
                                                      .selectedMonth.value ==
                                                  i
                                              ? Colors.green
                                              : Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.sp),
                                    ),
                                  ),
                                ),
                              );
                            })),
                    SizedBox(height: 20.h),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Name",
                              style: AppTextStyles.b1.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15.sp),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Status",
                              style: AppTextStyles.b1.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15.sp),
                            ),
                          ),
                          Text(
                            "Amount",
                            style: AppTextStyles.b1.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 15.sp),
                          ),
                        ]),
                    const Divider(),
                    Obx(
                      () => reportController.loading.isTrue
                          ? ShrimmerLoading() // const CircularProgressIndicator()
                          : Column(children: [
                              ...List.generate(
                                  reportController.report.value.data?.candidates
                                          ?.length ??
                                      0, (index) {
                                var candidate = reportController
                                    .report.value.data?.candidates![index];
                                return Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              candidate!.name ?? '',
                                              style: AppTextStyles.l1.copyWith(
                                                  color: Colors.grey.shade800),
                                            ),
                                          ),
                                          Container(
                                              width: 50.w,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.r),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4)
                                                          .r,
                                                  color: Colors.green.shade100),
                                              child: Text(
                                                candidate.status ?? "",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        Colors.green.shade800),
                                              )),
                                          Expanded(
                                              child: Text(
                                            candidate.amount ?? "",
                                            textAlign: TextAlign.end,
                                          )),
                                        ]));
                              }),
                              const Divider(),
                              RPadding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Balance",
                                          style: AppTextStyles.b1.copyWith(
                                              color: AppColors.primary),
                                        ),
                                      ),
                                      Expanded(
                                          child: Text(
                                        reportController
                                                .report.value.data?.balance
                                                .toString() ??
                                            "",
                                        textAlign: TextAlign.end,
                                        style: AppTextStyles.b1
                                            .copyWith(color: AppColors.primary),
                                      )),
                                    ]),
                              ),
                              const Divider(),
                              SizedBox(
                                height: 20.h,
                              ),
                              SizedBox(
                                height: 38.h,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: CustomButton(
                                            onPressed: () {
                                              reportController.downloadPdf();
                                            },
                                            label: "Export")),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                        child: CustomButton(
                                            color: Colors.grey.shade200,
                                            onPressed: () async {
                                              await reportController
                                                  .getPdfLink();
                                              Get.toNamed(Routes.PDFVIEW,
                                                  arguments:
                                                      reportController.html);
                                            },
                                            label: "View PDF")),
                                  ],
                                ),
                              ),
                              //           : controller.selectedReport.value == 1
                              //               ? SingleChildScrollView(
                              //                   scrollDirection: Axis.horizontal,
                              //                   child: Row(
                              //                     children: List.generate(
                              //                         12,
                              //                         (index) => InkWell(
                              //                               onTap: () {
                              //                                 controller.selectedMonth(index + 1);
                              //                               },
                              //                               child: SizedBox(
                              //                                   width: 48.w,
                              //                                   height: 31.h,
                              //                                   child: Text(
                              //                                     DateFormat("MMM dd").format(
                              //                                         DateTime(now.year, index + 1,
                              //                                             now.day)),
                              //                                     style: TextStyle(
                              //                                         fontSize: 12.sp,
                              //                                         color: controller.selectedMonth
                              //                                                     .value ==
                              //                                                 index + 1
                              //                                             ? Colors.green
                              //                                             : Colors.grey,
                              //                                         fontWeight: FontWeight.w600),
                              //                                   )),
                              //                             )),
                              //                   ),
                              //                 )
                              //               : Column(
                              //                   children: [
                              //                     controller.selectedReport.value == 5
                              //                         ? const SizedBox()
                              //                         : SizedBox(
                              //                             height: 30,
                              //                             child: SingleChildScrollView(
                              //                               scrollDirection: Axis.horizontal,
                              //                               child: Row(
                              //                                 mainAxisAlignment:
                              //                                     MainAxisAlignment.start,
                              //                                 children: [
                              //                                   Obx(
                              //                                     () => WeekButton(
                              //                                         onPressed: () {
                              //                                           controller.selectedWeek(0);
                              //                                         },
                              //                                         label: "WEEK 1",
                              //                                         active: controller.selectedWeek
                              //                                                     .value ==
                              //                                                 0
                              //                                             ? true
                              //                                             : false),
                              //                                   ),
                              //                                   Obx(() => WeekButton(
                              //                                       onPressed: () {
                              //                                         controller.selectedWeek(1);
                              //                                       },
                              //                                       label: "WEEK 2",
                              //                                       active: controller
                              //                                                   .selectedWeek.value ==
                              //                                               1
                              //                                           ? true
                              //                                           : false)),
                              //                                   Obx(() => WeekButton(
                              //                                       onPressed: () {
                              //                                         controller.selectedWeek(2);
                              //                                       },
                              //                                       label: "WEEK 3",
                              //                                       active: controller
                              //                                                   .selectedWeek.value ==
                              //                                               2
                              //                                           ? true
                              //                                           : false)),
                              //                                   Obx(() => WeekButton(
                              //                                       onPressed: () {
                              //                                         controller.selectedWeek(3);
                              //                                       },
                              //                                       label: "WEEK 4",
                              //                                       active: controller
                              //                                                   .selectedWeek.value ==
                              //                                               3
                              //                                           ? true
                              //                                           : false)),
                              //                                   Obx(() => WeekButton(
                              //                                       onPressed: () {
                              //                                         controller.selectedWeek(4);
                              //                                       },
                              //                                       label: "WEEK 5",
                              //                                       active: controller
                              //                                                   .selectedWeek.value ==
                              //                                               4
                              //                                           ? true
                              //                                           : false)),
                              //                                 ],
                              //                               ),
                              //                             ),
                              //                           ),
                              //                     const SizedBox(
                              //                       height: 15,
                              //                     ),
                              //                     SizedBox(
                              //                       height: 40,
                              //                       child: Obx(
                              //                         () => SingleChildScrollView(
                              //                           scrollDirection: Axis.horizontal,
                              //                           child: Row(
                              //                               mainAxisAlignment:
                              //                                   MainAxisAlignment.start,
                              //                               children: List.generate(
                              //                                   controller.selectedWeek.value == 4
                              //                                       ? 3
                              //                                       : 7,
                              //                                   (index) => WeekDay(
                              //                                       isActive:
                              //                                           (index == 2) ? true : false,
                              //                                       onPressed: () {},
                              //                                       day: weekDay[index],
                              //                                       date: controller
                              //                                                   .selectedWeek.value ==
                              //                                               0
                              //                                           ? index + 1
                              //                                           : controller.selectedWeek
                              //                                                       .value ==
                              //                                                   1
                              //                                               ? (7 + index)
                              //                                               : controller.selectedWeek
                              //                                                           .value ==
                              //                                                       2
                              //                                                   ? (14 + index)
                              //                                                   : controller.selectedWeek
                              //                                                               .value ==
                              //                                                           3
                              //                                                       ? (21 + index)
                              //                                                       : controller.selectedWeek
                              //                                                                   .value ==
                              //                                                               4
                              //                                                           ? (28 + index)
                              //                                                           : (32 +
                              //                                                               index)))),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //     ),
                              //     Obx(() => controller.selectedReport.value == 5
                              //         ? Column(
                              //             children: [
                              //               const SizedBox(
                              //                 height: 20,
                              //               ),
                              //               Row(
                              //                 children: [
                              //                   const Text(
                              //                     "09:08:12 AM",
                              //                     style: TextStyle(color: Colors.grey),
                              //                   ),
                              //                   SvgPicture.asset(
                              //                       "assets/material-symbols_arrow-insert-rounded.svg"),
                              //                   const Spacer(),
                              //                   const Text(
                              //                     "09:08:12 PM",
                              //                     style: TextStyle(color: Colors.grey),
                              //                   ),
                              //                   SvgPicture.asset(
                              //                       "assets/material-symbols_arrow-insert-rounded(1).svg"),
                              //                 ],
                              //               ),
                              //               const SizedBox(
                              //                 height: 20,
                              //               ),
                              //               Row(
                              //                   mainAxisAlignment: MainAxisAlignment.center,
                              //                   children: [
                              //                     Column(
                              //                       crossAxisAlignment: CrossAxisAlignment.start,
                              //                       mainAxisSize: MainAxisSize.min,
                              //                       mainAxisAlignment: MainAxisAlignment.start,
                              //                       children: [
                              //                         Text(
                              //                           strings.breaks,
                              //                           style: const TextStyle(color: Colors.grey),
                              //                         ),
                              //                         const Text(
                              //                           "00:46:02",
                              //                           style: TextStyle(
                              //                               color: Colors.red,
                              //                               fontWeight: FontWeight.w700),
                              //                         )
                              //                       ],
                              //                     ),
                              //                     SizedBox(
                              //                       height: 155,
                              //                       width: 200,
                              //                       child: Stack(
                              //                         alignment: Alignment.center,
                              //                         children: [
                              //                           Positioned(
                              //                             right: 40,
                              //                             child: Container(
                              //                               height: 140,
                              //                               width: 140,
                              //                               padding: const EdgeInsets.all(18),
                              //                               child: CustomPaint(
                              //                                 painter: CircularPercentPaint(
                              //                                   allGreen: true,
                              //                                   progress: 70.toInt(),
                              //                                 ),
                              //                                 child: Column(
                              //                                   mainAxisAlignment:
                              //                                       MainAxisAlignment.center,
                              //                                   children: [
                              //                                     Text(
                              //                                       strings.total_hours,
                              //                                       style: TextStyle(
                              //                                           fontWeight: FontWeight.bold,
                              //                                           color: Colors.green.shade800),
                              //                                     ),
                              //                                     const Text(
                              //                                       "12:42:05",
                              //                                       style: TextStyle(
                              //                                           fontWeight: FontWeight.bold,
                              //                                           color: Colors.red),
                              //                                     ),
                              //                                   ],
                              //                                 ),
                              //                               ),
                              //                             ),
                              //                           ),
                              //                           Positioned(
                              //                               top: 155 / 2 - 5,
                              //                               right: 0,
                              //                               child: Stack(
                              //                                 alignment: Alignment.center,
                              //                                 children: [
                              //                                   SvgPicture.asset(
                              //                                     "assets/Group 105.svg",
                              //                                     height: 24,
                              //                                     width: 30.5,
                              //                                   ),
                              //                                   const Padding(
                              //                                     padding: EdgeInsets.only(left: 6.0),
                              //                                     child: Text(
                              //                                       "70 %",
                              //                                       style: TextStyle(
                              //                                           fontSize: 10,
                              //                                           fontWeight: FontWeight.bold,
                              //                                           color: Colors.white),
                              //                                     ),
                              //                                   )
                              //                                 ],
                              //                               ))
                              //                         ],
                              //                       ),
                              //                     ),
                              //                   ]),
                              //               const SizedBox(
                              //                 height: 20,
                              //               ),
                              //               Row(
                              //                 mainAxisAlignment: MainAxisAlignment.center,
                              //                 children: [
                              //                   Text(
                              //                     "${strings.total_earning} ",
                              //                     style: TextStyle(color: Colors.blueGrey.shade600),
                              //                   ),
                              //                   const Text(
                              //                     "8300 /-",
                              //                     style: TextStyle(
                              //                         color: Colors.red, fontWeight: FontWeight.w600),
                              //                   ),
                              //                 ],
                              //               ),
                              //             ],
                              //           )
                              //         : const SizedBox()),
                              //     const SizedBox(
                              //       height: 20,
                              //     ),
                              //     Obx(() => controller.selectedReport.value == 5
                              //         ? const SizedBox()
                              //         // : controller.selectedReport.value == 2
                              //         //     ? Column(
                              //         //         children: [
                              //         //           Text(
                              //         //             strings.annual_leave_summary,
                              //         //             style: AppTextStyles()
                              //         //                 .large
                              //         //                 .copyWith(fontSize: 14, color: AppColors.primary),
                              //         //           ),
                              //         //         ],
                              //         //       )
                              //         : Column(
                              //             children: [
                              //               Row(
                              //                 children: [
                              //                   Text(
                              //                     strings.description,
                              //                     style: AppTextStyles().large.copyWith(
                              //                         fontSize: 14, color: AppColors.primary),
                              //                   ),
                              //                   const Spacer(),
                              //                   Text(
                              //                     strings.amount,
                              //                     style: AppTextStyles().large.copyWith(
                              //                         fontSize: 14, color: AppColors.primary),
                              //                   ),
                              //                 ],
                              //               ),
                              //               const Divider(thickness: 1),
                              //               const SizedBox(
                              //                 height: 5,
                              //               ),
                              //               Obx(() => controller.selectedReport == 2
                              //                   ? Column(
                              //                       children: [
                              //                         ...List.generate(
                              //                           12,
                              //                           (i) => Padding(
                              //                             padding: const EdgeInsets.symmetric(
                              //                                 vertical: 5.0),
                              //                             child: DescriptionItem(
                              //                                 label: DateFormat('MMMM')
                              //                                     .format(DateTime(2023, i + 1)),
                              //                                 value: '6000'),
                              //                           ),
                              //                         ),
                              //                         const SizedBox(
                              //                           height: 5,
                              //                         ),
                              //                         const Divider(
                              //                           thickness: 1,
                              //                         ),
                              //                         const SizedBox(
                              //                           height: 5,
                              //                         ),
                              //                         Row(
                              //                           children: [
                              //                             Text(
                              //                               strings.total,
                              //                               style: AppTextStyles().large.copyWith(
                              //                                   fontSize: 14,
                              //                                   color: AppColors.primary),
                              //                             ),
                              //                             const Spacer(),
                              //                             Text(
                              //                               "2,40,000/-",
                              //                               style: AppTextStyles().large.copyWith(
                              //                                   fontSize: 14,
                              //                                   color: AppColors.primary),
                              //                             ),
                              //                           ],
                              //                         ),
                              //                         const SizedBox(
                              //                           height: 5,
                              //                         ),
                              //                         const Divider(
                              //                           thickness: 1,
                              //                         ),
                              //                         const SizedBox(
                              //                           height: 5,
                              //                         ),
                              //                       ],
                              //                     )
                              //                   : Column(
                              //                       children: [
                              //                         DescriptionItem(
                              //                             label: strings.salary, value: '6000'),
                              //                         const SizedBox(
                              //                           height: 5,
                              //                         ),
                              //                         DescriptionItem(
                              //                             label: strings.overtime, value: '6000'),
                              //                         const SizedBox(
                              //                           height: 5,
                              //                         ),
                              //                         DescriptionItem(
                              //                             label: strings.bonus, value: '6000'),
                              //                         const SizedBox(
                              //                           height: 5,
                              //                         ),
                              //                         DescriptionItem(
                              //                             label: strings.allowance, value: '6000'),
                              //                         const SizedBox(
                              //                           height: 5,
                              //                         ),
                              //                         Obx(() => controller.selectedReport.value == 1
                              //                             ? Column(
                              //                                 children: [
                              //                                   const Divider(
                              //                                     thickness: 1,
                              //                                   ),
                              //                                   const SizedBox(
                              //                                     height: 5,
                              //                                   ),
                              //                                   DescriptionItem(
                              //                                       label: strings.tax,
                              //                                       value: '6000'),
                              //                                   const SizedBox(
                              //                                     height: 5,
                              //                                   ),
                              //                                   DescriptionItem(
                              //                                       label: strings.penalty,
                              //                                       value: '6000'),
                              //                                   const SizedBox(
                              //                                     height: 5,
                              //                                   ),
                              //                                 ],
                              //                               )
                              //                             : const SizedBox()),
                              //                         const Divider(
                              //                           thickness: 1,
                              //                         ),
                              //                         const SizedBox(
                              //                           height: 5,
                              //                         ),
                              //                         Row(
                              //                           children: [
                              //                             Text(
                              //                               strings.balance,
                              //                               style: AppTextStyles().large.copyWith(
                              //                                   fontSize: 14,
                              //                                   color: AppColors.primary),
                              //                             ),
                              //                             const Spacer(),
                              //                             Text(
                              //                               " 21500",
                              //                               style: AppTextStyles().large.copyWith(
                              //                                   fontSize: 14,
                              //                                   color: AppColors.primary),
                              //                             ),
                              //                           ],
                              //                         ),
                              //                         const SizedBox(
                              //                           height: 5,
                              //                         ),
                              //                         const Divider(
                              //                           thickness: 1,
                              //                         ),
                              //                         const SizedBox(
                              //                           height: 20,
                              //                         ),
                              //                         Obx(() => controller.selectedReport.value == 1
                              //                             ? Column(
                              //                                 children: [
                              //                                   Row(
                              //                                     children: [
                              //                                       Text(
                              //                                         strings.leave_information,
                              //                                         style: AppTextStyles()
                              //                                             .large
                              //                                             .copyWith(
                              //                                                 fontSize: 14,
                              //                                                 color:
                              //                                                     AppColors.primary),
                              //                                       ),
                              //                                     ],
                              //                                   ),
                              //                                   const Divider(
                              //                                     thickness: 1,
                              //                                   ),
                              //                                   const SizedBox(
                              //                                     height: 5,
                              //                                   ),
                              //                                   DescriptionItem(
                              //                                       label: strings.sick_leave,
                              //                                       value: '6000'),
                              //                                   const SizedBox(
                              //                                     height: 5,
                              //                                   ),
                              //                                   DescriptionItem(
                              //                                       label: strings.extra_leave,
                              //                                       value: '6000'),
                              //                                   const SizedBox(
                              //                                     height: 5,
                              //                                   ),
                              //                                   const Divider(
                              //                                     thickness: 1,
                              //                                   ),
                              //                                   const SizedBox(
                              //                                     height: 5,
                              //                                   ),
                              //                                   Row(
                              //                                     children: [
                              //                                       Text(
                              //                                         strings.remaining_leave,
                              //                                         style: AppTextStyles()
                              //                                             .large
                              //                                             .copyWith(
                              //                                                 fontSize: 14,
                              //                                                 color:
                              //                                                     AppColors.primary),
                              //                                       ),
                              //                                       const Spacer(),
                              //                                       Text(
                              //                                         "17 days",
                              //                                         style: AppTextStyles()
                              //                                             .large
                              //                                             .copyWith(
                              //                                                 fontSize: 14,
                              //                                                 color:
                              //                                                     AppColors.primary),
                              //                                       ),
                              //                                     ],
                              //                                   ),
                              //                                 ],
                              //                               )
                              //                             : const SizedBox()),
                              //                       ],
                              //                     ))
                              //             ],
                              //           )),

                              //     Obx(() => controller.selectedReport.value == 1 ||
                              //             controller.selectedReport.value == 2
                              //         ? const SizedBox()
                              //         : Column(
                              //             children: [
                              //               const SizedBox(
                              //                 height: 20,
                              //               ),
                              //               CustomFormField(
                              //                 isMultiline: true,
                              //                 title: strings.send_notification,
                              //                 hint: strings.message,
                              //               ),
                              //             ],
                              //           ))

                              const SizedBox(
                                height: 20,
                              ),
                              // CustomButton(onPressed: () {}, label: strings.add),

                              const SizedBox(
                                height: 20,
                              ),
                              //   ]),
                              // )
                            ]),
                    ),
                  ]))),
        ));
  }
}
