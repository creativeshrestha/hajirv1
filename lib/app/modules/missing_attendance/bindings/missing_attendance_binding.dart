import 'package:get/get.dart';

import '../controllers/missing_attendance_controller.dart';

class MissingAttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MissingAttendanceController>(
      () => MissingAttendanceController(),
    );
  }
}
