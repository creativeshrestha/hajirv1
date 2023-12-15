import 'package:get/get.dart';
import 'package:hajir/app/modules/company_detail/provider/employer_report_provider.dart';
import 'package:hajir/app/modules/company_detail/views/pages/widgets/overall_reports.dart';

import '../controllers/company_detail_controller.dart';

class CompanyDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompanyDetailController>(
      () => CompanyDetailController(),
    );
    Get.lazyPut(() => EmployerReportProvider());
    Get.lazyPut(() => OverallController(), fenix: true);
  }
}
