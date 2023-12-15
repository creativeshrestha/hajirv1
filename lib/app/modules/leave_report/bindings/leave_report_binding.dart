import 'package:get/get.dart';

import '../controllers/leave_report_controller.dart';

class LeaveReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaveReportController>(
      () => LeaveReportController(),
    );
  }
}
