import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/modules/company_detail/views/pages/widgets/add_approver.dart';
import 'package:hajir/app/modules/company_detail/views/pages/widgets/monthly_report.dart';
import 'package:hajir/app/modules/company_detail/views/pages/widgets/my_plans.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/change_language.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/change_number.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/profile.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/reports.dart';
import 'package:hajir/app/modules/employer_dashboard/controllers/employer_dashboard_controller.dart';
import 'package:hajir/app/modules/language/views/language_view.dart';
import 'package:hajir/app/routes/app_pages.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';
import 'package:hajir/core/localization/l10n/strings.dart';
import 'package:shimmer/shimmer.dart';

var profileData;

class MyAccount extends StatefulWidget {
  const MyAccount({
    super.key,
    this.isEmployer = false,
  });
  final bool isEmployer;

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  var isloading = false;

  final AttendanceSystemProvider attendanceApi = Get.find();
  getProfile({bool employer = false}) async {
    isloading = true;
    if (mounted) setState(() {});
    try {
      BaseResponse response = employer
          ? await attendanceApi.getProfileEmployer()
          : await attendanceApi.getProfile();
      if (response.body != null) profileData = response.body;

      isloading = false;

      setState(() {});
    } catch (e) {
      isloading = false;
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    if (!appSettings.employer) {
      if (profileData == null) getProfile();
    } else {
      if (profileData == null) getProfile(employer: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (appSettings.employer) {
      final EmployerDashboardController controller = Get.find();
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(
                  strings.my_account,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ),
              // const SizedBox(
              //   height: 12,
              // ),
              if (isloading)
                const CustomShrimmer()
              else
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      profileData != null
                          ? CachedNetworkImage(
                              imageUrl:
                                  profileData['data']['profile_image'] ?? "",
                              height: 50,
                              width: 50,
                              progressIndicatorBuilder: (_, value, download) =>
                                  Center(
                                child: CircularProgressIndicator(
                                    value: download.progress),
                              ),
                              errorWidget: (_, __, ___) {
                                return ImagePlaceholder();
                              },
                            )
                          : const SizedBox(height: 50),
                      const SizedBox(
                        width: 20,
                      ),
                      if (profileData != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileData['data']['name'] ??
                                  profileData['data']['phone'] ??
                                  "NA",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              profileData['data']['email'] ?? "NA",
                              style: TextStyle(
                                  fontSize: 15.sp, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              const SizedBox(
                height: 28,
              ),
              ListTile(
                onTap: () async {
                  if (profileData != null) {
                    var result = await Get.bottomSheet(
                        Profile(
                          profileData: profileData,
                          // onSuccess: getProfile(),
                        ),
                        isScrollControlled: true);
                    if (result) getProfile(employer: true);
                  }
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                // tileColor: Color.fromRGBO(67, 118, 254, 0.05),
                title: Text(
                  strings.profile,
                  style: AppTextStyles.accountStyle,
                ),
              ),
              if (!widget.isEmployer)
                if (controller.isEmployed)
                  ListTile(
                    onTap: () {
                      Get.bottomSheet(const Reports(),
                          isScrollControlled: true);
                    },
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                    title: Text(
                      strings.reports,
                      style: AppTextStyles.accountStyle,
                    ),
                  )
                else
                  const SizedBox()
              else ...[
                ListTile(
                  onTap: () {
                    Get.bottomSheet(const MyPlans(), isScrollControlled: true);
                  },
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                  title: Text(
                    strings.my_plans,
                    style: AppTextStyles.accountStyle,
                  ),
                ),
              ],
              ListTile(
                onTap: () {
                  Get.bottomSheet(const ChangeNumber(),
                      isScrollControlled: true);
                  // Get.bottomSheet(const AddApprover(), isScrollControlled: true);
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                title: Text(
                  strings.settings,
                  style: AppTextStyles.accountStyle,
                ),
              ),
              ListTile(
                onTap: () {
                  Get.bottomSheet(const ChangeLanguage(),
                      isScrollControlled: true);
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                title: Text(
                  strings.change_language,
                  style: AppTextStyles.accountStyle,
                ),
              ),
              ListTile(
                onTap: () {
                  Get.dialog(LogoutDialog(controller: controller));
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                title: Text(
                  strings.logout,
                  style: AppTextStyles.accountStyle,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      );
    } else {
      final DashboardController controller = Get.find();
      if (profileData != null) {
        controller.user.value.name = "${profileData['data']['name'] ?? "NA"}";

        controller.user.value.email = profileData['data']['email'] ?? 'NA';
      }

      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(
                  strings.my_account,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ),
              if (isloading)
                const CustomShrimmer()
              // const Center(
              //   // padding: EdgeInsets.symmetric(horizontal: 16),
              //   child: CircularProgressIndicator(),
              // )
              else if (profileData != null)
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        // !controller.isEmployed
                        //     ? const CircleAvatar(
                        //         radius: 32, child: Icon(Icons.person))
                        //     :
                        // Image.asset(
                        //   "assets/Avatar Profile.png",
                        //   height: 64,
                        //   width: 64,
                        // ),
                        profileData != null
                            ? CachedNetworkImage(
                                imageUrl:
                                    profileData['data']['profile_image'] ?? "",
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) =>
                                    ImagePlaceholder() ??
                                    Image.asset(
                                      "assets/Avatar Profile.png",
                                      height: 50,
                                      width: 50,
                                    ),
                              )
                            : const SizedBox(
                                height: 50,
                                width: 50,
                                // child: Icon(
                                //   CupertinoIcons.person_circle,
                                //   // size: 50,
                                // ),
                              ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                // !controller.isEmployed &&
                                // controller.isEmployed
                                //     ?
                                controller.user.value.name == "NA"
                                    ? controller.user.value.phone ?? "NA"
                                    : controller.user.value.name
                                            .toString()
                                            .capitalize ??
                                        "NA".toString(),
                                // : "+977 ${controller.user.value.phone}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              controller.user.value.email ?? "",
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(
                height: 28,
              ),
              ListTile(
                onTap: () async {
                  if (profileData != null) {
                    var result = await Get.bottomSheet(
                        Profile(profileData: profileData),
                        isScrollControlled: true);
                    if (result == true) getProfile();
                  }
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                // tileColor: Color.fromRGBO(67, 118, 254, 0.05),
                title: Text(
                  strings.profile,
                  style: AppTextStyles.accountStyle,
                ),
              ),
              // if (!widget.isEmployer)
              // if (controller.isEmployed)
              ...[
                Obx(
                  () => controller.selectedCompany.isNotEmpty
                      ? Column(
                          children: [
                            ListTile(
                              onTap: () {
                                if (controller
                                    .selectedCompany.value.isNotEmpty) {
                                  Get.bottomSheet(const Reports(),
                                      isScrollControlled: true);
                                } else {
                                  Get.rawSnackbar(message: "Select a company");
                                }
                              },
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                              title: Text(
                                strings.reports,
                                style: AppTextStyles.accountStyle,
                              ),
                            ),
                            if (controller.selectedCompany.value.isNotEmpty)
                              ListTile(
                                onTap: () {
                                  if (controller
                                      .selectedCompany.value.isNotEmpty) {
                                    Get.toNamed(Routes.LEAVE_REPORT);
                                  } else {
                                    Get.rawSnackbar(
                                        message: "Select a company");
                                  }
                                  // Get.bottomSheet(const Reports(), isScrollControlled: true);
                                },
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                ),
                                title: Text(
                                  "Leave Reports",
                                  style: AppTextStyles.accountStyle,
                                ),
                              ),
                          ],
                        )
                      : const SizedBox(),
                ),
              ],
              // else
              //   const SizedBox()
              // else ...[
              //   ListTile(
              //     onTap: () {
              //       Get.toNamed(Routes.INBOX);
              //     },
              //     trailing: const Icon(
              //       Icons.arrow_forward_ios,
              //       size: 20,
              //     ),
              //     title: Text(
              //       strings.inbox,
              //       style: AppTextStyles.accountStyle,
              //     ),
              //   ),
              //   ListTile(
              //     onTap: () {
              //       Get.bottomSheet(const MonthlyReports(),
              //           isScrollControlled: true);
              //     },
              //     trailing: const Icon(
              //       Icons.arrow_forward_ios,
              //       size: 20,
              //     ),
              //     title: Text(
              //       strings.monthly_reports,
              //       style: AppTextStyles.accountStyle,
              //     ),
              //   ),
              //   ListTile(
              //     onTap: () {
              //       Get.bottomSheet(const AddApprover(),
              //           isScrollControlled: true);
              //     },
              //     trailing: const Icon(
              //       Icons.arrow_forward_ios,
              //       size: 20,
              //     ),
              //     title: Text(
              //       strings.add_approver,
              //       style: AppTextStyles.accountStyle,
              //     ),
              //   ),
              //   ListTile(
              //     onTap: () {
              //       Get.bottomSheet(const MyPlans(), isScrollControlled: true);
              //     },
              //     trailing: const Icon(
              //       Icons.arrow_forward_ios,
              //       size: 20,
              //     ),
              //     title: Text(
              //       strings.my_plans,
              //       style: AppTextStyles.accountStyle,
              //     ),
              //   ),

              if (controller
                  .candidatecompaniesController.candidateCompanies.isNotEmpty)
                if (controller.candidatecompaniesController
                            .candidateCompanies[(controller.count.value)]
                        ['is_approver'] ==
                    '1') ...[
                  ListTile(
                    onTap: () {
                      Get.toNamed(Routes.ENROLL_ATTENDEE,
                          arguments: controller.selectedCompany.value);
                      // Get.bottomSheet(const AddApprover(),
                      //     isScrollControlled: true);
                    },
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                    title: Text(
                      strings.enroll_attendee,
                      style: AppTextStyles.accountStyle,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.toNamed(Routes.MISSING_ATTENDANCE,
                          arguments: controller.selectedCompany.value);
                    },
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                    title: Text(
                      strings.missing_attendance,
                      style: AppTextStyles.accountStyle,
                    ),
                  ),
                ],
              // ],
              ListTile(
                onTap: () {
                  Get.bottomSheet(const ChangeNumber(),
                      isScrollControlled: true);
                  // Get.bottomSheet(const AddApprover(), isScrollControlled: true);
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                title: Text(
                  strings.settings,
                  style: AppTextStyles.accountStyle,
                ),
              ),
              ListTile(
                onTap: () {
                  Get.bottomSheet(const ChangeLanguage(),
                      isScrollControlled: true);
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                title: Text(
                  strings.change_language,
                  style: AppTextStyles.accountStyle,
                ),
              ),
              ListTile(
                onTap: () {
                  Get.dialog(LogoutDialog(controller: controller));
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                title: Text(
                  strings.logout,
                  style: AppTextStyles.accountStyle,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      );
    }
  }
}

var placeholder = "assets/Vector logo-.png";

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      placeholder,
      height: 50,
      width: 50,
    );
  }
}

class CustomShrimmer extends StatelessWidget {
  const CustomShrimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
                height: 50,
                width: 50,
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 25,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          "   ".toString(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Container(
                        height: 20,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          "......",
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({Key? key, required this.controller}) : super(key: key);
  final controller;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        // height: 190.h,
        width: 338.w,
        // alignment: Alignment.center,
        padding: const EdgeInsets.all(30.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            strings.logout_dialog,
            style: AppTextStyles.medium
                .copyWith(fontSize: 15, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 30.h,
          ),
          SizedBox(
            width: double.infinity,
            // width: 320.w,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  // height: 40,
                  width: 120,
                  child: CustomButton(
                      color: Colors.grey,
                      onPressed: () => Get.back(),
                      labelColor: Colors.white,
                      label: strings.cancel),
                ),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  // height: 40,
                  width: 120,
                  child: CustomButton(
                      color: Colors.red.shade700,
                      labelColor: Colors.white,
                      onPressed: () => logout(controller),
                      label: strings.logout),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  logout(controller) {
    controller.logout();

    // if (appSettings.type == 'candidate') {
    //   Get.find<DashboardController>().logout();
    // } else {
    //   Get.find<EmployerDashboardController>().logout();
    //   // Get.offAllNamed(Routes.WELCOME);
    // }
  }
}

class ExitDialog extends StatelessWidget {
  const ExitDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          "Are you sure you want to quit app ? ",
          style: AppTextStyles.b1,
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 320.w,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: CustomButton(
                    color: Colors.grey,
                    labelColor: Colors.white,
                    onPressed: () => Get.back(result: false),
                    label: strings.cancel),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: CustomButton(
                    color: Colors.red.shade700,
                    labelColor: Colors.white,
                    onPressed: () => Get.back(result: true),
                    label: 'Exit'),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
