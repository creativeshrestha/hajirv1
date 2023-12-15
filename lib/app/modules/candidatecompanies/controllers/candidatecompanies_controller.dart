import 'package:get/get.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';

class CandidatecompaniesController extends GetxController {
  final count = 0.obs;
  var candidateCompanies = [].obs;
  var inactiveCompanies = [].obs;
  final isActive = true.obs;
  var loading = false.obs;

  final attendanceApi = Get.find<AttendanceSystemProvider>();
  @override
  void onInit() {
    super.onInit();
    getCompanies();
  }

  void increment() => count.value++;

  void getCompanies() async {
    loading(true);
    candidateCompanies.clear();
    try {
      var result = await attendanceApi.candidateCompanies();
      inactiveCompanies(result.body['data']['inactive_companies']);

      candidateCompanies(result.body['data']['active_companies']);

      if (candidateCompanies.isEmpty) {
        appSettings.isEmployed = false;
        final DashboardController dashboardController = Get.find();
        dashboardController.isEmployed.value = false;
      }
      loading(false);
    } catch (e) {
      loading(false);
      handleException(e);
    }
    loading(false);
  }
}
