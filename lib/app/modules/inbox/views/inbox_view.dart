import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/modules/inbox/views/inbox_detail.dart';
import 'package:hajir/app/routes/app_pages.dart';
import 'package:hajir/app/utils/shrimmerloading.dart';
import 'package:hajir/core/localization/l10n/strings.dart';

import '../controllers/inbox_controller.dart';

class InboxView extends GetView<InboxController> {
  const InboxView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.r,
      ),
      child: Obx(
        () => controller.loading.isTrue
            ? const Center(child: ShrimmerLoading())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                                Icons.arrow_back_ios)), // const BackButton(),
                        Text(
                          strings.inbox,
                          style: AppTextStyles.b1.copyWith(fontSize: 24.sp),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (controller.leaves['candidates'].isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 58.0),
                      child: Center(
                          child: Text(
                        "No Leave Data.",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                    ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: controller.inboxResponse.value.data
                                  ?.candidates?.length ??
                              0,
                          itemBuilder: (_, i) => Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(6),
                                  onTap: () async {
                                    Get.toNamed(Routes.CANDIDATE_LEAVE,
                                        arguments:
                                            controller.leaves['candidates'][i]);
                                    // Get.to(() => InboxDetail(
                                    //       index: i,
                                    //       controller: controller,
                                    //     ));
                                    // await controller.getAllLeaves();
                                  },
                                  child: Container(
                                    height: 74,
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200)),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          "assets/Mask group(1).png",
                                          height: 64,
                                          width: 64,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.leaves['candidates']
                                                        [i]['name']
                                                    .toString(),
                                                style: AppTextStyles.b1,
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      controller.leaves[
                                                                  'candidates']
                                                              [i]['leave_type']
                                                          ['title'],
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade600),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      controller
                                                          .leaves['candidates']
                                                              [i]['start_date']
                                                          .toString(),
                                                      style: AppTextStyles.body,
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )))
                ],
              ),
      ),
    )));
  }
}
