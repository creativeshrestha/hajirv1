import 'package:get/get.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/modules/company_detail/controllers/company_detail_controller.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/login/controllers/login_controller.dart';

class MissingAttendanceController extends GetxController {
  final attendanceApi = Get.find<AttendanceSystemProvider>();
  final count = 0.obs;
  var candidates = <dynamic>[].obs;
  var overTime = "01:00".obs;
  var loading = false.obs;
  var attendance_date = "".obs;
  var type = "".obs;
  var start_time = "".obs;
  var end_time = "".obs;
  var company_id = "".obs;
  var candidate_id = "".obs;
  @override
  void onInit() {
    getCandidates();
  }

  missingAttendanceSubmit() async {
    var data = {
      "start_time": start_time.value,
      "end_time": end_time.value,
      "companyid": Get.find<DashboardController>().selectedCompany.value,
      "candidateid": candidate_id.value,
      "type": type.value,
      "attendance_date": attendance_date.value
    };

    showLoading();
    try {
      Get.log(data.toString());
      var result = await attendanceApi.missingAttendee(data);
      Get.back();
      showSnackBar(result.body['message']);
    } catch (e) {
      Get.back();
      handleException(e);
    }
  }

  void increment() => count.value++;

  void officehours(String s) {}

  void getCandidates() async {
    try {
      loading(true);
      attendanceApi.approvercandidates(Get.arguments).then((v) {
        candidates(v.body['data']);
        loading(false);
      });
    } catch (e) {
      loading(false);
      handleException(e);
    }
  }
}
