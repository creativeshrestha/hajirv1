import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/modules/company_detail/controllers/company_detail_controller.dart';
import 'package:hajir/app/modules/company_detail/views/pages/widgets/add_approver.dart';
import 'package:hajir/app/modules/company_detail/views/pages/widgets/monthly_report.dart';
import 'package:hajir/app/routes/app_pages.dart';

import '../../../../../core/localization/l10n/strings.dart';

// inbox ,monthly repot, add approver,enroll attendedd ,missing attendee ,
class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final CompanyDetailController controller = Get.find();
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        ListTile(
          title: Text(controller.company.value.name.toString(),
              style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w600)),
        ),
        const SizedBox(
          height: 20,
        ),
        ListTile(
          onTap: () {
            Get.toNamed(Routes.INBOX);
          },
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 20,
          ),
          title: Text(
            strings.inbox,
            style: AppTextStyles.accountStyle,
          ),
        ),
        ListTile(
          onTap: () {
            Get.bottomSheet(MonthlyReports(), isScrollControlled: true);
          },
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 20,
          ),
          title: Text(
            strings.monthly_reports,
            style: AppTextStyles.accountStyle,
          ),
        ),
        ListTile(
          onTap: () {
            Get.to(
              () => AddApprover(),
            );
          },
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 20,
          ),
          title: Text(
            strings.add_approver,
            style: AppTextStyles.accountStyle,
          ),
        ),
        // ListTile(
        //   onTap: () {
        //     Get.toNamed(Routes.ENROLL_ATTENDEE,
        //         arguments: controller.selectedCompany.value);
        //     // Get.bottomSheet(const AddApprover(),
        //     //     isScrollControlled: true);
        //   },
        //   trailing: const Icon(
        //     Icons.arrow_forward_ios,
        //     size: 20,
        //   ),
        //   title: Text(
        //     strings.enroll_attendee,
        //     style: AppTextStyles.accountStyle,
        //   ),
        // ),
        // ListTile(
        //   onTap: () {
        //     Get.toNamed(Routes.MISSING_ATTENDANCE);
        //   },
        //   trailing: const Icon(
        //     Icons.arrow_forward_ios,
        //     size: 20,
        //   ),
        //   title: Text(
        //     strings.missing_attendance,
        //     style: AppTextStyles.accountStyle,
        //   ),
        // ),
      ],
    );
  }
}
