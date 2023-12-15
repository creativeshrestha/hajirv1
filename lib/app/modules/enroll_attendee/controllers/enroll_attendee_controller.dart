import 'package:flutter/src/widgets/editable_text.dart';
import 'package:get/get.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/data/providers/network/apis/attendance_api.dart';
import 'package:hajir/app/modules/company_detail/controllers/company_detail_controller.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/login/controllers/login_controller.dart';

class EnrollAttendeeController extends GetxController {
  //TODO: Implement EnrollAttendeeController
  var companySelected = ''.obs;
  final AttendanceSystemProvider attendanceApi = Get.find();
  // final CompanyDetailController companyDetailController = Get.find();
  final count = 0.obs;
  final _selected = 0.obs;
  int get selected => _selected.value;
  set selected(int selected) => _selected(selected);
  var data = {}.obs;
  var loading = false.obs;
  @override
  onInit() {
    companySelected(Get.arguments);
    getEnrolled();
  }

  void increment() => count.value++;

  void getEnrolled() async {
    loading(true);
    try {
      var result = await attendanceApi.enrollAttendee(companySelected.value);
      data(result.body);
      loading(false);
    } catch (e) {
      loading(false);
      handleException(e);
    }
  }

  void submitReport(
      String message, String candidateId, String attendanceId) async {
    try {
      showLoading();
      var result = await attendanceApi.reportSubmit(
          companySelected.value, candidateId, message, attendanceId);
      Get.back();
      Get.back();
      showSnackBar(result.body['message']);
    } catch (e) {
      Get.back();
      handleException(e);
    }
  }
}
