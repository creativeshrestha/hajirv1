import 'package:get/get.dart';
import 'package:hajir/app/modules/candidate_leave/providers/leave_report_provider.dart';

import '../controllers/candidate_leave_controller.dart';

class CandidateLeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LeaveReportProvider());
    Get.lazyPut<CandidateLeaveController>(
      () => CandidateLeaveController(Get.find()),
    );
  }
}
