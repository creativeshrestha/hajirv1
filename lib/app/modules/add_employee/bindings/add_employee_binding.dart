import 'package:get/get.dart';
import 'package:hajir/app/modules/add_employee/providers/candidate_provider.dart';

import '../controllers/add_employee_controller.dart';

class AddEmployeeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CandidateProvider(), fenix: true);
    Get.lazyPut<AddEmployeeController>(
      () => AddEmployeeController(),
    );
  }
}
