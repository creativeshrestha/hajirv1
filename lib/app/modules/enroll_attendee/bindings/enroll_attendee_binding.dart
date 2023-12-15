import 'package:get/get.dart';

import '../controllers/enroll_attendee_controller.dart';

class EnrollAttendeeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EnrollAttendeeController>(
      () => EnrollAttendeeController(),
    );
  }
}
