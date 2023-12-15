import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/modules/add_employee/views/add_employee_view.dart';
import 'package:hajir/app/modules/dashboard/views/my_account.dart';
import 'package:hajir/app/modules/inbox/controllers/inbox_controller.dart';
import 'package:hajir/app/modules/inbox/models/inbox_response.dart';
import 'package:hajir/app/modules/language/views/language_view.dart';
import 'package:hajir/core/localization/l10n/strings.dart';
import 'package:intl/intl.dart';

class InboxDetail extends StatefulWidget {
  const InboxDetail({super.key, required this.index, required this.controller});
  final int index;
  final InboxController controller;

  @override
  State<InboxDetail> createState() => _InboxDetailState();
}

class _InboxDetailState extends State<InboxDetail> {
  @override
  Widget build(BuildContext context) {
    final leave =
        widget.controller.inboxResponse.value!.data!.candidates![widget.index];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: REdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              leave.name ?? "",
              style: AppTextStyles.b1,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              DateFormat('dd MMM yy').format(leave.createdAt ?? DateTime(0)) ??
                  '',
              style: AppTextStyles.body.copyWith(fontSize: 12.sp),
              // style: TextStyle(
              //     color: Colors.grey.shade600,),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              leave.leaveType?.desc ?? "",
              textAlign: TextAlign.start,
              style: AppTextStyles.body,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              strings.leave,
              style: AppTextStyles.body,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              strings.paid_leave,
              style: AppTextStyles.b1,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              strings.type,
              style: AppTextStyles.body,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              strings.half_day,
              style: AppTextStyles.b1,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              strings.duration,
              style: AppTextStyles.body,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "${leave.startDate} - ${leave.endDate}",
              style: AppTextStyles.medium.copyWith(color: Colors.grey),
            ),
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
                        child: Image.network(
                          leave.attachment ?? "",
                          height: 70,
                          width: 70,
                          errorBuilder: (_, __, ___) =>ImagePlaceholder()?? Image.asset(
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
            // CustomDropDownField(
            //     color: Colors.white,
            //     onChanged: (v) {},
            //     hint: 'Choose',
            //     items: [
            //       "Paid",
            //       "Unpaid",
            //     ]),
            // SizedBox(height: 20.h),
            Obx(
              () => Row(
                children: [
                  // Text(controller.inboxResponse.value!.data!
                  //     .candidates![index].approved
                  //     .toString()),
                  Expanded(
                      child: CustomButton(
                    height: 40.h,
                    onPressed: widget.controller.inboxResponse.value!.data!
                                .candidates![widget.index].status ==
                            'Pending'
                        ? () async {
                            // await widget.controller
                            //     .approveLeave(leave.leaveId ?? "");
                            // setState(() {});
                          }
                        : null,
                    label: widget.controller.inboxResponse.value!.data!
                                .candidates![widget.index].status ==
                            'Pending'
                        ? "Approve"
                        : widget.controller.inboxResponse.value!.data!
                            .candidates![widget.index].status
                            .toString(),
                  )),
                  if (widget.controller.inboxResponse.value!.data!
                          .candidates![widget.index].status ==
                      'Pending')
                    const SizedBox(
                      width: 20,
                    ),
                  if (widget.controller.inboxResponse.value!.data!
                          .candidates![widget.index].status ==
                      'Pending')
                    Expanded(
                      child: CustomButton(
                        height: 40.h,
                        labelColor: Colors.white,
                        onPressed: () async {
                          // await widget.controller.rejectLeave(leave.leaveId);
                          // setState(() {});
                        },
                        label: "Reject" ?? strings.cancel,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
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
      ),
    );
  }
}
