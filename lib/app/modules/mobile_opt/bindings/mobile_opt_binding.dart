import 'package:get/get.dart';

import '../controllers/mobile_opt_controller.dart';

class MobileOptBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MobileOptController>(
      () => MobileOptController(),
    );
  }
}
