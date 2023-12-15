import 'dart:convert';

import 'package:get/get.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/leave_report/model/leave_model.dart';

class LeaveReportController extends GetxController {
  //TODO: Implement LeaveReportController

  final count = 0.obs;
  final isActive = true.obs;

  final DashboardController dashboardController = Get.find();
  AttendanceSystemProvider attendanceApi = Get.find();
  var approvedleave = <Leave>[].obs;
  var rejected = <Leave>[].obs;
  var isloading = false.obs;
  @override
  void onInit() {
    super.onInit();
    getAllLeaves();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void getAllLeaves() async {
    isloading(true);
    try {
      var allLeaves = await attendanceApi
          .geAllLeaves(dashboardController.selectedCompany.value);
      try {
        AllLeaveResponse allLeaveResponse =
            allLeaveResponseFromJson(jsonEncode(allLeaves.body));
        approvedleave(allLeaveResponse.data!.approvedLeaves);
        rejected(allLeaveResponse.data!.unapprovedLeaves);
      } catch (e) {
        Get.rawSnackbar(message: "Type Mismatch".toString());
      }
    } catch (e) {
      Get.rawSnackbar(message: e.toString());
    }
    isloading(false);
  }
}
