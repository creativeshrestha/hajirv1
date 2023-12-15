import 'package:get/get.dart';
import 'package:hajir/app/modules/candidate_login/controllers/candidate_login_controller.dart';
import 'package:hajir/app/modules/candidatecompanies/controllers/candidatecompanies_controller.dart';
import 'package:hajir/app/modules/dashboard/views/apply_leave.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/reports.dart';
import 'package:hajir/app/modules/notifications/controllers/notifications_controller.dart';

import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CandidateLoginController(), fenix: true);
    Get.lazyPut<ApplyLeaveController>(() => ApplyLeaveController(),
        fenix: true);
    Get.lazyPut(() => ReportController(), fenix: true);
    Get.lazyPut(() => NotificationsController(), fenix: true);
    Get.lazyPut<CandidatecompaniesController>(
        () => CandidatecompaniesController(),
        fenix: true);

    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
  }
}
