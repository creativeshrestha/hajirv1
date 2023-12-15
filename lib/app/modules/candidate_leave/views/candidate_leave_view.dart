import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/modules/add_employee/views/add_employee_view.dart';
import 'package:hajir/app/modules/dashboard/views/my_account.dart';
import 'package:hajir/app/modules/language/views/language_view.dart';
import 'package:hajir/app/utils/shrimmerloading.dart';
import 'package:hajir/core/localization/l10n/strings.dart';
import 'package:intl/intl.dart';

import '../controllers/candidate_leave_controller.dart';

class CandidateLeaveView extends GetView<CandidateLeaveController> {
  const CandidateLeaveView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('CandidateLeaveView'),
        //   centerTitle: true,
        // ),
        body: SafeArea(
      child: controller.obx(
          (state) => SingleChildScrollView(
                padding: REdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BackButton(),

                      Row(
                        children: [
                          // BackButton(),
                          // SizedBox(
                          //   width: 20,
                          // ),
                          Text(
                            strings.details,
                            style: AppTextStyles.b1.copyWith(fontSize: 24.sp),
                          ),
                          // Text((state?.data1?.toJson()).toString()),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        controller.leave.name ?? "",
                        style: AppTextStyles.b1,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        DateFormat('dd MMM yy').format(
                                controller.leave.createdAt ?? DateTime(0)) ??
                            '',
                        style: AppTextStyles.body.copyWith(fontSize: 12.sp),
                        // style: TextStyle(
                        //     color: Colors.grey.shade600,),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(state?.data1?.leavedetail?.remarks ?? ""),
                      const SizedBox(
                        height: 20,
                      ),
                      Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        controller.leave.leaveType?.desc ?? "",
                        textAlign: TextAlign.start,
                        style: AppTextStyles.body,
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  strings.leave,
                                  style: AppTextStyles.body,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  state?.data1?.leavedetail?.leaveType?.title ??
                                      "",
                                  style: AppTextStyles.b1,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  strings.type,
                                  style: AppTextStyles.body,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  state?.data1?.leavedetail?.type ?? "",
                                  style: AppTextStyles.b1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  strings.duration + " From",
                                  style: AppTextStyles.body,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  controller.leave.startDate ?? "",
                                  style: AppTextStyles.b1,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  strings.duration + " Till",
                                  style: AppTextStyles.body,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  controller.leave.endDate ?? "",
                                  style: AppTextStyles.b1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 4,
                      ),
                      // Text(
                      //   "${controller.leave.startDate} - ${controller.leave.endDate}",
                      //   style:
                      //       AppTextStyles.medium.copyWith(color: Colors.grey),
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        strings.attached,
                        style: AppTextStyles.body,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: List.generate(
                            1,
                            (index) => Container(
                                  height: 70,
                                  width: 70,
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        state?.data1?.leavedetail?.file ?? "",
                                    height: 70,
                                    width: 70,
                                    errorWidget: (_, __, ___) =>ImagePlaceholder()?? Image.asset(
                                      "assets/Avatar Profile.png",
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (state?.data1?.leavedetail?.status == "Pending" ||
                          state?.data1?.leavedetail?.status == '')
                        CustomDropDownField(
                            color: Colors.white,
                            value: controller.payType.value,
                            onChanged: (v) {
                              controller.payType(v);
                            },
                            hint: 'Choose',
                            items: [
                              "Paid",
                              "Unpaid",
                            ]),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          // Text(controller.inboxResponse.value!.data!
                          //     .candidates![index].approved
                          //     .toString()),
                          // if (state?.data1?.leavedetail?.status == "Pending" ||
                          //     state?.data1?.leavedetail?.status == '')
                          Expanded(
                              child: CustomButton(
                            height: 40.h,
                            onPressed: state?.data1?.leavedetail?.status ==
                                        "Pending" ||
                                    state?.data1?.leavedetail?.status == ''
                                ? () async {
                                    await controller.approveLeave(
                                        controller.leave.leaveId ?? "");
                                    // setState(() {});
                                  }
                                : null,
                            label: state?.data1?.leavedetail?.status ==
                                        "Pending" ||
                                    state?.data1?.leavedetail?.status == ''
                                ? "Approve"
                                : (state?.data1?.leavedetail?.status ?? "")
                                    .toString(),
                          )),
                          if (state?.data1?.leavedetail?.status == "Pending" ||
                              state?.data1?.leavedetail?.status == '')
                            const SizedBox(
                              width: 20,
                            ),
                          if (state?.data1?.leavedetail?.status == "Pending" ||
                              state?.data1?.leavedetail?.status == '')
                            Expanded(
                              child: CustomButton(
                                height: 40.h,
                                labelColor: Colors.white,
                                onPressed: () async {
                                  controller
                                      .rejectLeave(controller.leave.leaveId);
                                },
                                label: "Reject" ?? strings.cancel,
                                color: Colors.red,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      // CustomButton(
                      //     color: Colors.grey,
                      //     onPressed: () {
                      //       Get.back();
                      //     },
                      //     label: strings.back_to_home),
                      const SizedBox(
                        height: 20,
                      ),
                    ]),
              ),
          onLoading: ShrimmerLoading()),
    ));
  }
}
