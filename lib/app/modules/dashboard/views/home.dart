import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hajir/app/config/app_colors.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/modules/candidate_login/views/candidate_login_view.dart';
import 'package:hajir/app/modules/candidatecompanies/controllers/candidatecompanies_controller.dart';
import 'package:hajir/app/modules/candidatecompanies/views/candidatecompanies_view.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/dashboard/views/my_account.dart';
import 'package:hajir/app/routes/app_pages.dart';
import 'package:hajir/app/utils/shrimmerloading.dart';
import 'package:hajir/core/localization/l10n/strings.dart';

class Home extends GetView<DashboardController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var res = await Get.dialog(const ExitDialog());
        return res;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          controller.candidatecompaniesController.getCompanies();

          await controller.getInvitations();

          // await Future.delayed(2.seconds);
        },
        child: Obx(
          () => controller.isCompanySelected.isTrue
              ? const CandidateLoginView()
              :
              //  controller.loading.isTrue ||
              controller.candidatecompaniesController.loading.isTrue
                  ? const Center(child: ShrimmerLoading())
                  : controller.invitationlist.isNotEmpty
                      ? Column(
                          children: [
                            AppBar(
                              leading: const SizedBox(),
                              backgroundColor: Colors.white,
                              elevation: 0,
                              actions: [
                                IconButton(
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
                                            Positioned(
                                              top: 3,
                                              right: 0,
                                              child: Container(
                                                height: 8,
                                                width: 8,
                                                decoration: const BoxDecoration(
                                                    color: Colors.red,
                                                    shape: BoxShape.circle),
                                              ),
                                            ),
                                          ],
                                        ))),
                                const SizedBox(
                                  width: 20,
                                )
                              ],
                            ),
                            if (controller.invitationlist.isEmpty)
                              SizedBox(
                                  height: 160.48 + 26.52,
                                  width: 173.85,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 17,
                                        child: Image.asset(
                                          "assets/Group 89.png",
                                          height: 170,
                                          width: 170,
                                        ),
                                      ),
                                      SvgPicture.asset(
                                        "assets/Group 115(1).svg",
                                        height: 160.48,
                                        width: 173.85,
                                      ),
                                    ],
                                  )),
                            Expanded(
                              child: controller.loading.isTrue
                                  ? const Center(
                                      child: ShrimmerLoading())
                                  : ListView.builder(
                                      itemCount:
                                          controller.invitationlist.length,
                                      itemBuilder: (_, i) => AnimatedContainer(
                                            duration: 300.milliseconds,
                                            curve: Curves.ease,
                                            child: Column(children: [
                                              // const SizedBox(height: 36),
                                              Container(
                                                  // height: 167,
                                                  width: double.infinity,
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 32,
                                                      vertical: 12),
                                                  padding:
                                                      const EdgeInsets.all(32),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade300),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.92),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors
                                                                .grey.shade300,
                                                            blurRadius: 1)
                                                      ]),
                                                  child: Column(
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                  text:
                                                                      "${controller.invitationlist[i]['company']['name']} ",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium!
                                                                      .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w600)),
                                                              TextSpan(
                                                                  text: strings
                                                                      .is_invited_to_join_company,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleSmall)
                                                            ]),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            height: 32,
                                                            width: 113,
                                                            child:
                                                                ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                            AppColors
                                                                                .primary,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(
                                                                                24))),
                                                                    onPressed:
                                                                        () {
                                                                      // Get.snackbar("", "message");
                                                                      // Get.dialog(AlertDialog(
                                                                      //   content: Container(
                                                                      //     height: 200,
                                                                      //     width: 200,
                                                                      //     color: Colors.red,
                                                                      //   ),
                                                                      // ));
                                                                      // controller
                                                                      //         .isEmployed =
                                                                      //     true;
                                                                      controller.acceptInvitation(
                                                                          invitationId: controller.invitationlist[i]['id']
                                                                              .toString(),
                                                                          controller
                                                                              .invitationlist[i]['company']['id']
                                                                              .toString());
                                                                    },
                                                                    child: Text(
                                                                        strings
                                                                            .accept)),
                                                          ),
                                                          const SizedBox(
                                                            width: 14,
                                                          ),
                                                          SizedBox(
                                                            height: 32,
                                                            width: 113,
                                                            child:
                                                                ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        foregroundColor:
                                                                            AppColors
                                                                                .red,
                                                                        backgroundColor:
                                                                            Colors
                                                                                .white,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(
                                                                                24))),
                                                                    onPressed:
                                                                        () {
                                                                      controller.acceptInvitation(
                                                                          invitationId: controller.invitationlist[i]['id']
                                                                              .toString(),
                                                                          controller.invitationlist[i]['company']['id']
                                                                              .toString(),
                                                                          decline:
                                                                              true);
                                                                    },
                                                                    child: Text(
                                                                      strings
                                                                          .decline,
                                                                      style:
                                                                          AppTextStyles
                                                                              .b2,
                                                                    )),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ))
                                            ]),
                                          )),
                            ),
                          ],
                        )
                      : controller.isEmployed.value
                          ? controller.isCompanySelected.value
                              ? const CandidateLoginView()
                              : const CandidatecompaniesView()
                          : controller.candidatecompaniesController
                                      .candidateCompanies.isNotEmpty ||
                                  controller.candidatecompaniesController
                                      .inactiveCompanies.isNotEmpty //
                              ? const CandidatecompaniesView()
                              : SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      AppBar(
                                        leading: const SizedBox(),
                                        backgroundColor: Colors.white,
                                        elevation: 0,
                                        actions: [
                                          IconButton(
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
                                                    Obx(
                                                      () => controller
                                                              .notificationController
                                                              .notifications
                                                              .isNotEmpty
                                                          ? Positioned(
                                                              top: 3,
                                                              right: 0,
                                                              child: Container(
                                                                height: 8,
                                                                width: 8,
                                                                decoration: const BoxDecoration(
                                                                    color: Colors
                                                                        .red,
                                                                    shape: BoxShape
                                                                        .circle),
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                    )
                                                  ],
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          )
                                        ],
                                      ),
                                      // SizedBox(
                                      //   width: double.infinity,
                                      //   height:
                                      //       controller.invitationlist.isNotEmpty ? (9) : 125,
                                      // ),
                                      // if (controller.invitationlist.isNotEmpty)
                                      //   AnimatedContainer(
                                      //     duration: 300.milliseconds,
                                      //     curve: Curves.ease,
                                      //     child: Column(
                                      //       children: [
                                      //         Align(
                                      //           alignment: Alignment.topRight,
                                      //           child: Container(
                                      //             margin: const EdgeInsets.only(right: 16),
                                      //             height: 63,
                                      //             width: 228.67,
                                      //             padding: const EdgeInsets.all(14),
                                      //             decoration: BoxDecoration(
                                      //                 borderRadius:
                                      //                     BorderRadius.circular(5.92),
                                      //                 color: Colors.white,
                                      //                 boxShadow: [
                                      //                   BoxShadow(
                                      //                       color: Colors.grey.shade300,
                                      //                       blurRadius: 1)
                                      //                 ]),
                                      //             child: RichText(
                                      //                 text: TextSpan(children: [
                                      //               TextSpan(
                                      //                   text: !appSettings.isEnglish
                                      //                       ? strings.removed.split(" ").first
                                      //                       : strings.removed,
                                      //                   style: Theme.of(context)
                                      //                       .textTheme
                                      //                       .bodyMedium),
                                      //               TextSpan(
                                      //                   text: " Rasan Technologies ",
                                      //                   style: Theme.of(context)
                                      //                       .textTheme
                                      //                       .bodyMedium!
                                      //                       .copyWith(
                                      //                           fontWeight: FontWeight.w700)),
                                      //               TextSpan(
                                      //                   text: strings.company,
                                      //                   style: Theme.of(context)
                                      //                       .textTheme
                                      //                       .bodyMedium),
                                      //               TextSpan(
                                      //                   text: !appSettings.isEnglish
                                      //                       ? ("${strings.removed.replaceAll("${strings.removed.split(" ").first} ", " ")}।")
                                      //                       : "",
                                      //                   style: Theme.of(context)
                                      //                       .textTheme
                                      //                       .bodyMedium),
                                      //             ])),
                                      //           ),
                                      //         ),
                                      //         const SizedBox(
                                      //           height: 29,
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      if (controller.invitationlist.isEmpty)
                                        SizedBox(
                                            height: 160.48 + 26.52,
                                            width: 173.85,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: 17,
                                                  child: Image.asset(
                                                    "assets/Group 89.png",
                                                    height: 170,
                                                    width: 170,
                                                  ),
                                                ),
                                                SvgPicture.asset(
                                                  "assets/Group 115(1).svg",
                                                  height: 160.48,
                                                  width: 173.85,
                                                ),
                                              ],
                                            )),
                                      // Obx(() => controller.loading.isTrue
                                      //     ? const Center(
                                      //         child:
                                      //             CircularProgressIndicator())
                                      //     : const CircularProgressIndicator()),
                                      if (controller.invitationlist.isNotEmpty)
                                        const SizedBox()
                                      else ...[
                                        const SizedBox(
                                          height: 76,
                                        ),
                                        Text(
                                          strings.not_invited_to_company,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
        ),
      ),
    );
  }
}
