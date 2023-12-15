import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:hajir/app/config/app_colors.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/reports.dart';
import 'package:hajir/app/modules/leave_report/model/leave_model.dart';
import 'package:hajir/app/utils/shrimmerloading.dart';
import 'package:hajir/core/localization/l10n/strings.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/leave_report_controller.dart';

class LeaveReportView extends GetView<LeaveReportController> {
  const LeaveReportView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const BackButton(),
                  RPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Text(
                      "Leave Reports",
                      style: TextStyle(
                          fontSize: 24.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              CustomButton(
                controller: controller,
              ),
              const SizedBox(
                height: 24,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(),
              ),
              controller.isloading.isTrue
                  ? Expanded(
                      child: ShrimmerList(
                            child: Container(
                                // margin: REdgeInsets.symmetric(vertical: 8),
                                color: Colors.white,
                                height: 200),
                          ) ??
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: ShrimmerLoading(),
                            ),
                          ),
                    )
                  : const SizedBox(),
              if ((controller.isActive.isTrue
                      ? controller.approvedleave.length
                      : controller.rejected.length) >
                  0) ...[
                Expanded(
                    child: ListView.separated(
                        separatorBuilder: (_, i) => const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Divider(),
                            ),
                        itemCount: controller.isActive.isTrue
                            ? controller.approvedleave.length
                            : controller.rejected.length,
                        itemBuilder: (_, i) => InkWell(
                              onTap: () {
                                controller.count(i);
                              },
                              child: LeaveItem(
                                  index: i,
                                  leave: controller.isActive.isTrue
                                      ? controller.approvedleave[0]
                                      : controller.rejected[i]),
                            ))),
              ] else
                Center(
                    child: Text(
                        "No ${controller.isActive.isTrue ? 'Approved' : 'Rejected'} Leave.")),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //     onTap: (i) {
      //       Get.back();
      //     },
      //     items: [
      //       BottomNavigationBarItem(
      //           activeIcon: SvgPicture.asset(
      //             "assets/home.svg",
      //             height: 20,
      //             width: 19.98,
      //             color: AppColors.primary,
      //           ),
      //           icon: SvgPicture.asset(
      //             "assets/home.svg",
      //             color: Colors.grey,
      //             height: 20,
      //             width: 19.98,
      //           ),
      //           label: strings.home),
      //       // if (controller.companySelected != '')
      //       BottomNavigationBarItem(
      //           activeIcon: SvgPicture.asset(
      //             "assets/leave.svg",
      //             color: AppColors.primary,
      //             height: 20,
      //             width: 19.98,
      //           ),
      //           icon: SvgPicture.asset(
      //             "assets/leave.svg",
      //             height: 20,
      //             width: 19.98,
      //           ),
      //           label: strings.apply_leave),
      //       BottomNavigationBarItem(
      //           activeIcon: SvgPicture.asset(
      //             "assets/Icon.svg",
      //             height: 20,
      //             width: 19.98,
      //             color: AppColors.primary,
      //           ),
      //           icon: SvgPicture.asset(
      //             "assets/profile.svg",
      //             height: 20,
      //             width: 19.98,
      //             // color: Colors.grey,
      //           ),
      //           label: strings.my_account),
      //     ]),
    );
  }
}

class LeaveItem extends StatefulWidget {
  const LeaveItem({super.key, required this.leave, required this.index});
  final Leave leave;
  final int index;

  @override
  State<LeaveItem> createState() => _LeaveItemState();
}

class _LeaveItemState extends State<LeaveItem> {
  bool isExpanded = false;
  final LeaveReportController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return //!isExpanded
        Obx(() => controller.count.value != widget.index
            ? ListTile(
                // visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                dense: true,
                // onTap: () {
                //   isExpanded = true;
                //   setState(() {});
                // },
                title: Text(
                  widget.leave.leaveType ?? "NA",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 16.sp),
                ),
                trailing: Text(
                  widget.leave.applicationDate ?? "NA",
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ))
            : InkWell(
                // onTap: () {
                //   isExpanded = !isExpanded;
                //   setState(() {});
                // },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.leave.leaveType ?? "NA",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 16.sp),
                          ),
                          const Spacer(),
                          Text(
                            widget.leave.applicationDate ?? "NA",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        widget.leave.remarks ?? "NA",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Leave",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  widget.leave.leaveType ?? "",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Type",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  widget.leave.type ?? "",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Duration from",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  widget.leave.startDate ?? "",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Duration till",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  widget.leave.endDate ?? "",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     launchUrl(Uri.parse(widget.leave.documentUrl!));
                      //   },
                      //   child: Row(
                      //     children: [
                      //       Icon(Icons.file_present),
                      //       SizedBox(
                      //         width: 20,
                      //       ),
                      //       Text("View"),
                      //     ],
                      //   ),
                      // )
                      // Divider()
                    ],
                  ),
                ),
              ));
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.controller,
  });

  final LeaveReportController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 36,
      height: 36.h,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.r),
          boxShadow: const [
            BoxShadow(color: Color.fromRGBO(236, 237, 240, 1), blurRadius: 2)
          ],
          color: const Color.fromRGBO(236, 237, 240, 1)),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SizedBox(
                height: 35.h,
                child: ReportsButton(
                    activeColor: Colors.white,
                    onPressed: () {
                      // dashBoardController.selectedReport(0);
                      controller.isActive.value = true;
                    },
                    active: controller.isActive.isTrue,
                    label: "Approved"),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: SizedBox(
                height: 35.h,
                child: ReportsButton(
                    activeColor: Colors.white,
                    active: !controller.isActive.isTrue,
                    onPressed: () {
                      controller.isActive.value = false;
                      // dashBoardController.selectedReport(1);
                    },
                    label: "Rejected"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
