import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:hajir/app/config/app_colors.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/modules/candidatecompanies/views/candidatecompanies_view.dart';
import 'package:hajir/app/modules/company_detail/views/pages/employee.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/reports.dart';
import 'package:hajir/app/modules/dashboard/views/my_account.dart';
import 'package:hajir/app/modules/employer_dashboard/models/company.dart';
import 'package:hajir/app/modules/language/views/language_view.dart';
import 'package:hajir/app/routes/app_pages.dart';
import 'package:hajir/app/utils/shrimmerloading.dart';
import 'package:hajir/core/localization/l10n/strings.dart';

import '../controllers/employer_dashboard_controller.dart';

class Companies extends StatelessWidget {
  const Companies({super.key});

  @override
  Widget build(BuildContext context) {
    final EmployerDashboardController controller = Get.find();
    return WillPopScope(
      onWillPop: (() async {
        var result = await Get.dialog(const ExitDialog());
        return result;
      }),
      child: RefreshIndicator(
        onRefresh: () async {
          controller.getCompanies();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Obx(() => controller.companyList.isNotEmpty
                      ? Text(
                          strings.companies_list,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 24.sp),
                        )
                      : const SizedBox()),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Obx(
                () => controller.loadingFailed.isFalse
                    ? Container(
                        height: 40,
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            vertical: 1, horizontal: 2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.r),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(236, 237, 240, 1),
                                  blurRadius: 2)
                            ],
                            color: const Color.fromRGBO(236, 237, 240, 1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: ReportsButton(
                                    activeColor: Colors.white,
                                    onPressed: () {
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
                                    },
                                    label: strings.inactive),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ),
              SizedBox(
                height: 20.h,
              ),
              Obx(() => controller.loading.isTrue
                  ? const Expanded(child: ShrimmerLoading())
                  : controller.isActive.isTrue &&
                              controller.companyList.isNotEmpty ||
                          controller.isActive.isFalse &&
                              controller.inactiveCompanies.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                              // shrinkWrap: true,
                              itemCount: controller.isActive.isTrue
                                  ? controller.companyList.length
                                  : controller.inactiveCompanies.length,
                              itemBuilder: (_, index) {
                                Company company = controller.isActive.isTrue
                                    ? controller.companyList[index]
                                    : controller.inactiveCompanies[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onLongPress: () {
                                      Get.dialog(CustomWidgetDialog(
                                          child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 16),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 16),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      company.name!
                                                              .capitalize ??
                                                          "NA",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.clip,
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
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        RichText(
                                                          text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      "${strings.employee.toUpperCase()} [  ",
                                                                  style: AppTextStyles.b2.copyWith(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade600),
                                                                ),
                                                                TextSpan(
                                                                    text: company
                                                                        .employeeCount
                                                                        .toString(),
                                                                    style: AppTextStyles.b2.copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: AppColors
                                                                            .primary,
                                                                        fontSize:
                                                                            10)),
                                                                const TextSpan(
                                                                    text:
                                                                        " ]          "),
                                                              ],
                                                              style: AppTextStyles
                                                                  .b2
                                                                  .copyWith(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .grey)),
                                                        ),
                                                        RichText(
                                                            text: TextSpan(
                                                                children: [
                                                              TextSpan(
                                                                  text:
                                                                      "${strings.approver.toUpperCase()} [  "),
                                                              TextSpan(
                                                                  text: company
                                                                      .approverCount
                                                                      .toString(),
                                                                  style: AppTextStyles.b2.copyWith(
                                                                      color: AppColors
                                                                          .primary,
                                                                      fontSize:
                                                                          10)),
                                                              const TextSpan(
                                                                  text: " ]"),
                                                            ],
                                                                style: AppTextStyles.b2.copyWith(
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
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 30,
                                                    child: CustomButton(
                                                        icon: Icons.edit,
                                                        color: Colors.white,
                                                        buttonStyle: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 12.sp),
                                                        onPressed: () {
                                                          Get.back();
                                                          Get.dialog(
                                                              CustomAlertDialog(
                                                                  title:
                                                                      "Are you sure you want to edit company?",
                                                                  action:
                                                                      "Edit",
                                                                  onPressed:
                                                                      () async {
                                                                    Get.back();
                                                                    await Get.toNamed(
                                                                        Routes
                                                                            .CREATE_COMPANY,
                                                                        parameters: {
                                                                          "id":
                                                                              "${company.id ?? 0}"
                                                                        });

                                                                    controller
                                                                        .getCompanies();
                                                                  }));
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
                                                        buttonStyle: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 12.sp),
                                                        color: Colors.white,
                                                        onPressed: () {
                                                          Get.back();

                                                          Get.dialog(
                                                              CustomAlertDialog(
                                                                  title:
                                                                      "Are you sure you want to ${controller.isActive.isTrue ? "Inactive" : "Active"} company?",
                                                                  action: controller
                                                                          .isActive
                                                                          .isTrue
                                                                      ? "Inactive"
                                                                      : "Active",
                                                                  onPressed:
                                                                      () async {
                                                                    // print(
                                                                    //     company.id);

                                                                    await controller.updateStatus(
                                                                        !controller
                                                                            .isActive
                                                                            .isTrue,
                                                                        company
                                                                            .id
                                                                            .toString());
                                                                    Get.back();
                                                                    controller
                                                                        .getCompanies();
                                                                  }));
                                                        },
                                                        label: !controller
                                                                .isActive.isTrue
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
                                                      buttonStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 12.sp),
                                                      labelColor: Colors.red,
                                                      color: Colors.white,
                                                      onPressed: () {
                                                        Get.back();
                                                        Get.dialog(
                                                            CustomAlertDialog(
                                                                title:
                                                                    "Are you sure you want to remove company permanently?",
                                                                action:
                                                                    "Delete",
                                                                onPressed:
                                                                    () async {
                                                                  await controller
                                                                      .deleteCompany(
                                                                          company
                                                                              .id
                                                                              .toString());
                                                                  Get.back();
                                                                  controller
                                                                      .getCompanies();
                                                                }));
                                                        // "Are you sure you want to remove company permanently?"
                                                        // 'Delete'
                                                      },
                                                      label: 'Delete'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )));
                                    },
                                    onTap: () {
                                      Get.toNamed(Routes.COMPANY_DETAIL,
                                          arguments: company,
                                          parameters: {
                                            'company_id': controller
                                                    .isActive.isTrue
                                                ? controller
                                                    .companyList[index].id
                                                    .toString()
                                                : controller
                                                    .inactiveCompanies[index].id
                                                    .toString(),
                                          });
                                    },
                                    child: Container(
                                      // height: 83,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 16),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    company.name!.capitalize ??
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
                                                      RichText(
                                                        text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    "${strings.employee.toUpperCase()} [  ",
                                                                style: AppTextStyles.b2.copyWith(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade600),
                                                              ),
                                                              TextSpan(
                                                                  text: company
                                                                      .employeeCount
                                                                      .toString(),
                                                                  style: AppTextStyles.b2.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: AppColors
                                                                          .primary,
                                                                      fontSize:
                                                                          10)),
                                                              const TextSpan(
                                                                  text:
                                                                      " ]          "),
                                                            ],
                                                            style: AppTextStyles
                                                                .b2
                                                                .copyWith(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .grey)),
                                                      ),
                                                      RichText(
                                                          text: TextSpan(
                                                              children: [
                                                            TextSpan(
                                                                text:
                                                                    "${strings.approver.toUpperCase()} [  "),
                                                            TextSpan(
                                                                text: company
                                                                    .approverCount
                                                                    .toString(),
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
                                                              style: AppTextStyles.b2.copyWith(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600))),
                                                    ],
                                                  ),
                                                ]),
                                          ),
                                          // const Spacer(),
                                          IconButton(
                                            onPressed: () async {
                                              var code = await generateBarCode(
                                                  company.id.toString());
                                              // String s = String.fromCharCodes(
                                              //     "$code".codeUnits);
                                              // var outputAsUint8List =
                                              //     Uint8List.fromList(s.codeUnits);

                                              Get.dialog(Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r)),
                                                insetPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 30),
                                                child: CompanyQRWidget(
                                                  qrcode: code,
                                                ),
                                              ));
                                            },
                                            icon: Icon(Icons.qr_code_2,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              // ),
                              ),
                        )
                      : controller.loading.isTrue
                          ? const SingleChildScrollView(
                              child: ShrimmerLoading())
                          : Column(
                              children: [
                                const SizedBox(
                                  height: 80,
                                ),
                                SvgPicture.asset(
                                  "assets/Group 115(1).svg",
                                  height: 160.48,
                                  width: 173.85,
                                ),
                                const SizedBox(
                                  height: 35,
                                ),
                                controller.loadingFailed.isTrue
                                    ? InkWell(
                                        onTap: () {
                                          controller.getCompanies();
                                        },
                                        child: const Text(
                                          "Try again",
                                        ))
                                    : Text(
                                        strings.not_created_company,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(color: AppColors.primary),
                                      ),
                              ],
                            ))
            ],
          ),
        ),
      ),
    );
  }
}

class CompanyQRWidget extends StatelessWidget {
  const CompanyQRWidget({
    super.key,
    required this.qrcode,
  });
  final Uint8List qrcode;
  @override
  Widget build(BuildContext context) {
    final repaintBoundary = GlobalKey();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Align(
            alignment: Alignment.topRight,
            child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: REdgeInsets.only(right: 12.0, top: 12),
                  child: Icon(
                    Icons.close,
                    size: 24.r,
                  ),
                ))),
        RepaintBoundary(
            key: repaintBoundary,
            child: SizedBox(
                height: 136.r, width: 136.r, child: Image.memory(qrcode))),
        SizedBox(height: 16.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40.r),
          child: InkWell(
            onTap: () {
              captureAndSharePng(repaintBoundary);
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              CircleAvatar(
                  radius: 14.r,
                  backgroundColor: Colors.grey.shade200,
                  child: Icon(Icons.share_outlined,
                      color: AppColors.primary, size: 18.r)),
              const SizedBox(width: 8),
              Text("Share / Print PDF",
                  style:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
              SizedBox(
                height: 16.r,
              )
            ]),
          ),
        )
      ]),
    );
  }
}

class EmployerDashboardView extends GetView<EmployerDashboardController> {
  const EmployerDashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    var pages = [
      const Companies(),
      const MyAccount(
        isEmployer: true,
      )
    ];

    return Scaffold(
      body: SafeArea(child: Obx(() => pages[controller.selectedIndex.value])),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            selectedItemColor: AppColors.primary,
            currentIndex: controller.selectedIndex.value,
            selectedLabelStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
            onTap: (i) {
              controller.selectedIndex(i);
            },
            items: [
              BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    "assets/home.svg",
                    height: 24,
                    width: 24,
                    color: AppColors.primary,
                  ),
                  icon: SvgPicture.asset(
                    "assets/home.svg",
                    color: Colors.grey,
                    height: 24,
                    width: 24,
                  ),
                  label: strings.home),
              BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    "assets/Icon.svg",
                    height: 24,
                    width: 24,
                    color: AppColors.primary,
                  ),
                  icon: SvgPicture.asset(
                    "assets/profile.svg",
                    height: 24,
                    width: 24,
                    fit: BoxFit.cover,
                  ),
                  label: strings.my_account),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Get.toNamed(
            Routes.CREATE_COMPANY,
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
