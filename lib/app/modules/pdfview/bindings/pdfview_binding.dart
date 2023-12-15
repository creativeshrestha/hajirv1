import 'package:get/get.dart';

import '../controllers/pdfview_controller.dart';

class PdfviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PdfviewController>(
      () => PdfviewController(),
    );
  }
}
