import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hajir/app/config/app_colors.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/modules/candidate_login/controllers/candidate_login_controller.dart';
import 'package:hajir/app/modules/company_detail/controllers/company_detail_controller.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/reports.dart';
import 'package:hajir/app/modules/language/views/language_view.dart';
import 'package:hajir/app/modules/login/controllers/login_controller.dart';
import 'package:hajir/app/routes/app_pages.dart';
import 'package:hajir/app/utils/shrimmerloading.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';
import 'package:hajir/core/localization/l10n/strings.dart';

import '../controllers/candidatecompanies_controller.dart';

class CandidatecompaniesView extends GetView<CandidatecompaniesController> {
  const CandidatecompaniesView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController = Get.find();

    return ListView(
      children: [
        RPadding(
          padding: const EdgeInsets.all(16),
          child: Text(
            strings.companies_list,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        Container(
          height: 40,
          // height: 38.h,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.r),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromRGBO(236, 237, 240, 1), blurRadius: 2)
              ],
              color: const Color.fromRGBO(236, 237, 240, 1)),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ReportsButton(
                        activeColor: Colors.white,
                        onPressed: () {
                          // dashBoardController.selectedReport(0);
                          controller.isActive.value = true;
                        },
                        active: controller.isActive.isTrue,
                        label: strings.active),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ReportsButton(
                        activeColor: Colors.white,
                        active: !controller.isActive.isTrue,
                        onPressed: () {
                          controller.isActive.value = false;
                          // dashBoardController.selectedReport(1);
                        },
                        label: strings.inactive),
                  ),
                ),
                // const SizedBox(
                //   width: 20,
                // ),
                // Expanded(
                //   child: ReportsButton(
                //       active: controller.selectedReport == 2 ? true : false,
                //       onPressed: () {
                //         controller.selectedReport = (2);
                //         // dashBoardController.selectedReport(2);
                //       },
                //       label: strings.annual),
                // ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        Obx(
          () => controller.loading.isTrue
              ? const Center(child: ShrimmerLoading())
              : Column(
                  children: controller.isActive.isTrue
                      ? controller.candidateCompanies.isEmpty
                          ? [Text("No Active Companies")]
                          : controller.candidateCompanies
                              .map(
                                (e) => RPadding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onLongPress: () {
                                      controller.count(controller
                                          .candidateCompanies
                                          .indexOf(e));
                                      Get.dialog(CandidateDialog(
                                        e: e,
                                      ));
                                    },
                                    onTap: () async {
                                      var id = e['id'].toString();
                                      appSettings.companyId = id;

                                      showLoading();
                                      dashboardController.companySelected =
                                          (id);
                                      var hasData = await Get.find<
                                              CandidateLoginController>()
                                          .getTodayDetails();

                                      try {
                                        if (hasData) {
                                          dashboardController
                                              .isCompanySelected(true);
                                        } else {
                                          appSettings.companyId = '';
                                          dashboardController.companySelected =
                                              '';
                                        }
                                      } catch (e) {
                                        // Get.back();
                                      }

                                      // Get.back();
                                      // Get.toNamed(Routes.COMPANY_DETAIL,
                                      //     arguments: controller.companyList[index],
                                      //     parameters: {
                                      //       'company_id': controller.companyList[index].id.toString()
                                      //     });
                                    },
                                    child: Container(
                                      height: 83,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 16),
                                      // margin: const EdgeInsets.only(bottom: 10),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Row(
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  e['name']
                                                          .toString()
                                                          .capitalizeFirst ??
                                                      "NA",
                                                  style: AppTextStyles.b2
                                                      .copyWith(
                                                          fontSize: 18,
                                                          color:
                                                              AppColors.black),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    // RichText(
                                                    //   text: TextSpan(
                                                    //       children: [
                                                    //         TextSpan(
                                                    //           text: "${strings.employee} [  ",
                                                    //           style: AppTextStyles.b2.copyWith(
                                                    //               fontSize: 10,
                                                    //               fontWeight: FontWeight.w500,
                                                    //               color: Colors.grey.shade600),
                                                    //         ),
                                                    //         TextSpan(
                                                    //             text: "x",
                                                    //             style: AppTextStyles.b2.copyWith(
                                                    //                 fontWeight: FontWeight.w600,
                                                    //                 color: AppColors.primary,
                                                    //                 fontSize: 10)),
                                                    //         const TextSpan(text: " ]          "),
                                                    //       ],
                                                    //       style: AppTextStyles.b2
                                                    //           .copyWith(fontSize: 10, color: Colors.grey)),
                                                    // ),
                                                    RichText(
                                                        text: TextSpan(
                                                            children: [
                                                          const TextSpan(
                                                              text:
                                                                  "Office Time [  "),
                                                          TextSpan(
                                                              text:
                                                                  "${e['office_hour_start']?.toString().substring(0, 5) ?? "NA"} AM - ${e['office_hour_end']?.toString().substring(0, 5) ?? "NA"} PM",
                                                              style: AppTextStyles
                                                                  .b2
                                                                  .copyWith(
                                                                      color: AppColors
                                                                          .primary,
                                                                      fontSize:
                                                                          10)),
                                                          const TextSpan(
                                                              text: " ]"),
                                                        ],
                                                            style: AppTextStyles
                                                                .b2
                                                                .copyWith(
                                                                    fontSize:
                                                                        10.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade500))),
                                                  ],
                                                )
                                              ]),
                                          // const Spacer(),
                                          // Icon(
                                          //   Icons.arrow_forward,
                                          //   color: AppColors.primary,
                                          // )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList()
                      : controller.inactiveCompanies.isEmpty
                          ? [Text("No Inactive Companies")]
                          : controller.inactiveCompanies
                              .map(
                                (e) => RPadding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onLongPress: () {
                                      Get.dialog(CandidateDialog(
                                        e: e,
                                      ));
                                    },
                                    onTap: () {
                                      // var id = e['id'].toString();
                                      // appSettings.companyId = id;
                                      // dashboardController.companySelected = (id);
                                      // dashboardController.isCompanySelected(true);

                                      // Get.back();
                                      // Get.toNamed(Routes.COMPANY_DETAIL,
                                      //     arguments: controller.companyList[index],
                                      //     parameters: {
                                      //       'company_id': controller.companyList[index].id.toString()
                                      //     });
                                    },
                                    child: Container(
                                      height: 83,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 16),
                                      // margin: const EdgeInsets.only(bottom: 10),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Row(
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  e['name']
                                                          .toString()
                                                          .capitalizeFirst ??
                                                      "NA",
                                                  style: AppTextStyles.b2
                                                      .copyWith(
                                                          fontSize: 18,
                                                          color: AppColors
                                                              .primary),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    // RichText(
                                                    //   text: TextSpan(
                                                    //       children: [
                                                    //         TextSpan(
                                                    //           text: "${strings.employee} [  ",
                                                    //           style: AppTextStyles.b2.copyWith(
                                                    //               fontSize: 10,
                                                    //               fontWeight: FontWeight.w500,
                                                    //               color: Colors.grey.shade600),
                                                    //         ),
                                                    //         TextSpan(
                                                    //             text: "x",
                                                    //             style: AppTextStyles.b2.copyWith(
                                                    //                 fontWeight: FontWeight.w600,
                                                    //                 color: AppColors.primary,
                                                    //                 fontSize: 10)),
                                                    //         const TextSpan(text: " ]          "),
                                                    //       ],
                                                    //       style: AppTextStyles.b2
                                                    //           .copyWith(fontSize: 10, color: Colors.grey)),
                                                    // ),
                                                    RichText(
                                                        text: TextSpan(
                                                            children: [
                                                          const TextSpan(
                                                              text:
                                                                  "OfficeTime [  "),
                                                          TextSpan(
                                                              text:
                                                                  "${e['office_hour_start']?.toString().substring(0, 5) ?? "NA"} AM - ${e['office_hour_end']?.toString().substring(0, 5) ?? "NA"} PM",
                                                              style: AppTextStyles
                                                                  .b2
                                                                  .copyWith(
                                                                      color: AppColors
                                                                          .primary,
                                                                      fontSize:
                                                                          10)),
                                                          const TextSpan(
                                                              text: " ]"),
                                                        ],
                                                            style: AppTextStyles
                                                                .b2
                                                                .copyWith(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade600))),
                                                  ],
                                                )
                                              ]),
                                          // const Spacer(),
                                          // Icon(
                                          //   Icons.arrow_forward,
                                          //   color: AppColors.primary,
                                          // )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList()),
        )
      ],
    );
  }
}

class CustomWidgetDialog extends StatelessWidget {
  const CustomWidgetDialog({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.zero,
        alignment: const Alignment(0, -.6),
        backgroundColor: Colors.transparent,
        child: child);
  }
}

class CustomDialogCompanyDetail extends StatelessWidget {
  const CustomDialogCompanyDetail({super.key, this.e, this.isEmployer = false});
  final bool isEmployer;

  final e;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CompanyDetailController>();
    // final controller = isEmployer
    //     ? Get.find<CompanyDetailController>()
    //     : Get.find<CandidatecompaniesController>();
    return Dialog(
      insetPadding: EdgeInsets.zero,
      alignment: const Alignment(0, -.54),
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: REdgeInsets.symmetric(horizontal: 16, vertical: 16),
            margin: REdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e['name'].toString().capitalizeFirst ?? "NA",
                            style: AppTextStyles.b2.copyWith(
                                fontSize: 18, color: AppColors.primary),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // RichText(
                              //   text: TextSpan(
                              //       children: [
                              //         TextSpan(
                              //           text: "${strings.employee} [  ",
                              //           style: AppTextStyles.b2.copyWith(
                              //               fontSize: 10,
                              //               fontWeight: FontWeight.w500,
                              //               color: Colors.grey.shade600),
                              //         ),
                              //         TextSpan(
                              //             text: "x",
                              //             style: AppTextStyles.b2.copyWith(
                              //                 fontWeight: FontWeight.w600,
                              //                 color: AppColors.primary,
                              //                 fontSize: 10)),
                              //         const TextSpan(text: " ]          "),
                              //       ],
                              //       style: AppTextStyles.b2
                              //           .copyWith(fontSize: 10, color: Colors.grey)),
                              // ),
                              RichText(
                                  text: TextSpan(
                                      children: [
                                    const TextSpan(text: "OfficeTime [  "),
                                    TextSpan(
                                        text:
                                            "${e['office_hour_start']?.toString() ?? "NA"} AM - ${e['office_hour_end']?.toString() ?? "NA"} PM",
                                        style: AppTextStyles.b2.copyWith(
                                            color: AppColors.primary,
                                            fontSize: 10)),
                                    const TextSpan(text: " ]"),
                                  ],
                                      style: AppTextStyles.b2.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade600))),
                            ],
                          )
                        ]),
                    // const Spacer(),
                    // Icon(
                    //   Icons.arrow_forward,
                    //   color: AppColors.primary,
                    // )
                  ],
                ),
              ],
            ),
          ),
          RPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 30,
                    child: CustomButton(
                        icon: Icons.edit,
                        color: Colors.white,
                        buttonStyle: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 12.sp),
                        onPressed: () async {
                          Get.back();
                          await Get.dialog(CustomAlertDialog(
                              title: "Are you sure you want to edit employee?",
                              action: "Edit",
                              onPressed: () async {
                                Get.back();
                                await Get.toNamed(Routes.ADD_EMPLOYEE,
                                    parameters: {
                                      'id':
                                          (e['candidate_id'] ?? "").toString(),
                                      "companyId":
                                          Get.find<CompanyDetailController>()
                                              .company
                                              .value
                                              .id
                                              .toString()
                                    });
                              }));

                          // Get.back();
                        },
                        label: 'Edit'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SizedBox(
                    height: 30,
                    child: CustomButton(
                        icon: Icons.check,
                        color: Colors.white,
                        buttonStyle: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 12.sp),
                        onPressed: () {
                          var isActive = controller.selectedItem.value == 1;

                          // Get.back();
                          Get.dialog(CustomAlertDialog(
                              title:
                                  "Are you sure you want to ${isEmployer ? "inactive" : "Active"} company?",
                              action: isEmployer
                                  //? controller.isActive.isTrue
                                  ? "Inactive"
                                  : "Active",
                              onPressed: () {
                                Get.back();
                                controller.changeEmployeeStatus(
                                    isEmployer ? false : true,
                                    (e['candidate_id'] ?? "").toString());
                                // isEmployer
                                //     ?
                                // Get.find<CompanyDetailController>()
                                //         .changeEmployeeStatus(e['candidate_id'])
                                // : Get.find<DashboardController>()
                                //     .acceptInvitation(
                                //     e['id'].toString(),
                                //   )
                              }));
                        },
                        label: !isEmployer
                            ?
                            // ? Get.find<CompanyDetailController>()
                            //             .selectedItem
                            //             .value ==

                            //     ?
                            strings.active
                            : strings.inactive
                        // : Get.find<CandidatecompaniesController>()
                        //         .isActive
                        //         .isTrue
                        //     ? strings.active
                        //     : strings.inactive,
                        ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 30,
                  width: 100,
                  child: CustomButton(
                      icon: Icons.delete,
                      labelColor: Colors.red,
                      buttonStyle: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 12.sp),
                      color: Colors.white,
                      onPressed: () {
                        Get.back();
                        Get.dialog(CustomAlertDialog(
                            title:
                                "Are you sure you want to remove employee permanently?",
                            action: "Delete",
                            onPressed: () {
                              controller.deleteCandidate(
                                  e['candidate_id'].toString());
                              // isEmployer
                              //     ? Get.find<CompanyDetailController>()
                              //         .deleteCompany(e['id'].toString())
                              //     : Get.find<DashboardController>()
                              //         .deleteCompany(e['id'].toString());
                              // Get.back();
                            }));
                        // "Are you sure you want to remove company permanently?"
                        // 'Delete'
                      },
                      label: 'Delete'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CandidateDialog extends StatelessWidget {
  const CandidateDialog({super.key, this.e, this.isEmployer = false});
  final bool isEmployer;

  final e;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CandidatecompaniesController>();
    return Dialog(
      insetPadding: EdgeInsets.zero,
      alignment: const Alignment(0, -.54),
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: REdgeInsets.symmetric(horizontal: 16, vertical: 16),
            margin: REdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e['name'].toString().capitalizeFirst ?? "NA",
                            style: AppTextStyles.b2.copyWith(
                                fontSize: 18, color: AppColors.primary),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // RichText(
                              //   text: TextSpan(
                              //       children: [
                              //         TextSpan(
                              //           text: "${strings.employee} [  ",
                              //           style: AppTextStyles.b2.copyWith(
                              //               fontSize: 10,
                              //               fontWeight: FontWeight.w500,
                              //               color: Colors.grey.shade600),
                              //         ),
                              //         TextSpan(
                              //             text: "x",
                              //             style: AppTextStyles.b2.copyWith(
                              //                 fontWeight: FontWeight.w600,
                              //                 color: AppColors.primary,
                              //                 fontSize: 10)),
                              //         const TextSpan(text: " ]          "),
                              //       ],
                              //       style: AppTextStyles.b2
                              //           .copyWith(fontSize: 10, color: Colors.grey)),
                              // ),
                              RichText(
                                  text: TextSpan(
                                      children: [
                                    const TextSpan(text: "OfficeTime [  "),
                                    TextSpan(
                                        text:
                                            "${e['office_hour_start']?.toString().substring(0, 5) ?? "NA"} AM - ${e['office_hour_end']?.toString().substring(0, 5) ?? "NA"} PM",
                                        style: AppTextStyles.b2.copyWith(
                                            color: AppColors.primary,
                                            fontSize: 10)),
                                    const TextSpan(text: " ]"),
                                  ],
                                      style: AppTextStyles.b2.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade600))),
                            ],
                          )
                        ]),
                    // const Spacer(),
                    // Icon(
                    //   Icons.arrow_forward,
                    //   color: AppColors.primary,
                    // )
                  ],
                ),
              ],
            ),
          ),
          RPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Expanded(
                //   child: SizedBox(
                //     height: 30,
                //     child: CustomButton(
                //         icon: Icons.edit,
                //         color: Colors.white,
                //         onPressed: () async {
                //           await Get.dialog(CustomAlertDialog(
                //               title: "Are you sure you want to edit company?",
                //               action: "Edit",
                //               onPressed: () {
                //                 Get.toNamed(Routes.ADD_EMPLOYEE, parameters: {
                //                   'id': e['candidate_id'].toString(),
                //                   "companyId":
                //                       Get.find<CompanyDetailController>()
                //                           .company
                //                           .value
                //                           .id
                //                           .toString()
                //                 });
                //               }));
                //           Get.back();
                //         },
                //         label: 'Edit'),
                //   ),
                // ),
                // const SizedBox(
                //   width: 10,
                // ),
                SizedBox(
                  height: 30,
                  width: 100,
                  child: CustomButton(
                      icon: Icons.check,
                      color: Colors.white,
                      onPressed: () {
                        Get.back();
                        Get.dialog(CustomAlertDialog(
                            title:
                                "Are you sure you want to ${controller.isActive.isTrue ? "inactive" : "Active"} company?",
                            action:

                                //  Get.find<CompanyDetailController>()
                                //             .selectedItem
                                //             .value ==
                                //         2
                                controller.isActive.isTrue
                                    ? "Inactive"
                                    : "Active",
                            onPressed: () {
                              // final DashboardController dashboardController =
                              //     Get.find();
                              // isEmployer
                              //     ? Get.find<CompanyDetailController>()
                              //         .changeEmployeeStatus(e['candidate_id'])
                              //     : Get.find<DashboardController>()
                              //         .acceptInvitation(
                              //         e['id'].toString(),
                              //       );
                              // Get.back();
                            }));
                      },
                      label: isEmployer
                          ? Get.find<CompanyDetailController>()
                                      .selectedItem
                                      .value ==
                                  2
                              ? strings.active
                              : strings.inactive
                          : !controller.isActive.isTrue
                              ? strings.active
                              : strings.inactive),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 30,
                  width: 100,
                  child: CustomButton(
                      icon: Icons.delete,
                      labelColor: Colors.red,
                      color: Colors.white,
                      onPressed: () {
                        Get.back();
                        Get.dialog(CustomAlertDialog(
                            title:
                                "Are you sure you want to remove company permanently?",
                            action: "Delete",
                            onPressed: () {
                              isEmployer
                                  ? Get.find<CompanyDetailController>()
                                      .deleteCompany(e['id'].toString())
                                  : Get.find<DashboardController>()
                                      .deleteCompany(e['id'].toString());
                              Get.back();
                            }));
                        // "Are you sure you want to remove company permanently?"
                        // 'Delete'
                      },
                      label: 'Delete'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CompanyAlertDialog extends StatelessWidget {
  const CompanyAlertDialog({super.key, this.e, this.isEmployer = false});
  final bool isEmployer;

  final e;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CompanyDetailController>();
    return Dialog(
      insetPadding: EdgeInsets.zero,
      alignment: const Alignment(0, -.54),
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: REdgeInsets.symmetric(horizontal: 16, vertical: 16),
            margin: REdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e['name'].toString().capitalizeFirst ?? "NA",
                            maxLines: 1,
                            style: AppTextStyles.b2.copyWith(
                                fontSize: 18, color: AppColors.primary),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RichText(
                                  text: TextSpan(
                                      children: [
                                    const TextSpan(text: "OfficeTime [  "),
                                    TextSpan(
                                        text:
                                            "${e['office_hour_start']?.toString().substring(0, 5) ?? "NA"} AM - ${e['office_hour_end']?.toString().substring(0, 5) ?? "NA"} PM",
                                        style: AppTextStyles.b2.copyWith(
                                            color: AppColors.primary,
                                            fontSize: 10)),
                                    const TextSpan(text: " ]"),
                                  ],
                                      style: AppTextStyles.b2.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade600))),
                            ],
                          )
                        ]),
                  ],
                ),
              ],
            ),
          ),
          RPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 30,
                    child: CustomButton(
                        icon: Icons.edit,
                        color: Colors.white,
                        onPressed: () async {
                          await Get.dialog(CustomAlertDialog(
                              title: "Are you sure you want to edit employee?",
                              action: "Edit",
                              onPressed: () {
                                Get.toNamed(Routes.ADD_EMPLOYEE, parameters: {
                                  'id': e['candidate_id'].toString(),
                                  "companyId":
                                      Get.find<CompanyDetailController>()
                                          .company
                                          .value
                                          .id
                                          .toString()
                                });
                              }));
                          Get.back();
                        },
                        label: 'Edit'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SizedBox(
                    height: 30,
                    child: CustomButton(
                        icon: Icons.check,
                        color: Colors.white,
                        onPressed: () {
                          Get.back();
                          Get.dialog(CustomAlertDialog(
                              title:
                                  "Are you sure you want to ${Get.find<CompanyDetailController>().selectedItem.value == 2 ? "inactive" : "Active"} employee?",
                              action: Get.find<CompanyDetailController>()
                                          .selectedItem
                                          .value ==
                                      2
                                  //? controller.isActive.isTrue
                                  ? "Inactive"
                                  : "Active",
                              onPressed: () {
                                isEmployer
                                    ? Get.find<CompanyDetailController>()
                                        .changeEmployeeStatus(
                                            controller.selectedItem.value == 2,
                                            e['candidate_id'].toString())
                                    : Get.find<DashboardController>()
                                        .acceptInvitation(
                                        e['id'].toString(),
                                      );
                                Get.back();
                              }));
                        },
                        label: isEmployer
                            ? Get.find<CompanyDetailController>()
                                        .selectedItem
                                        .value ==
                                    2
                                ? strings.active
                                : strings.inactive
                            : Get.find<CandidatecompaniesController>()
                                    .isActive
                                    .isTrue
                                ? strings.active
                                : strings.inactive),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 30,
                  width: 100,
                  child: CustomButton(
                    icon: Icons.delete,
                    labelColor: Colors.red,
                    color: Colors.white,
                    onPressed: () {
                      Get.back();
                      Get.dialog(CustomAlertDialog(
                          title:
                              "Are you sure you want to remove company permanently?",
                          action: "Delete",
                          onPressed: () {
                            isEmployer
                                ? Get.find<CompanyDetailController>()
                                    .deleteCompany(e['id'].toString())
                                : Get.find<DashboardController>()
                                    .deleteCompany(e['id'].toString());
                            Get.back();
                          }));
                      // "Are you sure you want to remove company permanently?"
                      // 'Delete'
                    },
                    label: 'Delete',
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.action,
    required this.onPressed,
  });
  final String title;
  final String action;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: 120,
          height: 40,
          child: CustomButton(
              onPressed: () {
                Get.back();
              },
              label: 'Cancel'),
        ),
        SizedBox(
            width: 120,
            height: 40,
            child: CustomButton(
                color: Colors.grey.shade300,
                labelColor: Colors.red,
                onPressed: onPressed,
                label: action))
      ],
    );
  }
}
