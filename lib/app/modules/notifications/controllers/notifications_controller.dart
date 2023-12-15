import 'package:get/get.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';

class NotificationsController extends GetxController {
  var notifications = [].obs;
  final count = 0.obs;
  final attendanceApi = Get.find<AttendanceSystemProvider>();
  var loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  getNotifications() async {
    loading(true);
    try {
      var result = await attendanceApi.notifications();

      loading(false);
      notifications(result.body['data']['notifications']);
    } catch (e) {
      loading(false);
      handleException(e);
    }
  }

  void increment() => count.value++;
}
