import 'dart:io';

import 'package:get/get.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/data/providers/network/api_provider.dart';
import 'package:hajir/app/modules/company_detail/provider/employer_report_provider.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/employer_dashboard/models/company.dart';
import 'package:hajir/app/modules/login/controllers/login_controller.dart';
import 'package:hajir/app/modules/mobile_opt/controllers/mobile_opt_controller.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';

class ExceptionHandler {
  Future<T?> handleFunc<T>({required T Function() handle}) async {
    try {
      handle();
    } catch (e) {
      Get.rawSnackbar(message: e.toString());
    }
    return null;
  }
}

class CompanyDetailController extends GetxController {
  final selectedItem = 1.obs;
  var company = Company.empty().obs;
  var candidates = <EmployeeModel>[].obs;
  var loading = false.obs;
  var myPlan = "Free(Forever)".obs;
  final _selected = 0.obs;
  int get selected => _selected.value;
  set selected(int value) => _selected(value);
  var selectedWeek = 0.obs;
  var selectedDay = DateTime.now().day.obs;
  var selectedYear = DateTime.now().year.obs;
  var selectedMonth = 0.obs;
  var selectedReport = 0.obs;
  var invitationlist = [].obs;
  var emplist = [].obs;
  var params = {}.obs;
  var employerReport = {}.obs;
  var inactiveCandidates = {}.obs;
  var attendanceLoading = false.obs;
  var activeCandidates = {}.obs;
  final attendanceApi = Get.find<AttendanceSystemProvider>();
  final EmployerReportProvider repository = Get.find();
  var selectedCompany = '0'.obs;
  var loadingFailed = false.obs;
  @override
  void onInit() {
    super.onInit();
    company(Get.arguments);
    selectedCompany(Get.parameters['company_id'].toString());
    params(Get.parameters);
    getallCandidates();
    var now = DateTime.now();
    selectedMonth(now.month);
  }

  void increment() => selectedItem.value++;
  getallCandidates() async {
    loading(true);
    appSettings.companyId = selectedCompany.value;
    var companyId = selectedCompany;
    try {
      var employeeList =
          await attendanceApi.allCandidates(companyId.toString());

      if (employeeList.body['data'] is Map) {
        if (employeeList.body['data']['active_candidates'].length is int) {
          emplist(employeeList.body['data']['active_candidates']);
          invitationlist(employeeList.body['data']['inactive_candidates']);
        } else {
          Get.rawSnackbar(message: 'Format Exception');
        }
      } else {
        loadingFailed(true);
      }

      // var allInvitations =
      //     await attendanceApi.getAllInvitationList(companyId.value.toString());
      // invitationlist(allInvitations.body['data']['candidates']);
      getEmployerReport();
    } on BadRequestException catch (e) {
      loading(false);
      Get.rawSnackbar(
          title: e.message.toString(), message: e.details.toString());
    } on SocketException catch (e) {
      loading(false);
      Get.rawSnackbar(message: e.message);
    } catch (e) {
      log(e.toString());
      loading(false);
      loadingFailed(true);
      handleException(e);
      // Get.rawSnackbar(message: "Something Went Wrong ".toString());
    }
  }

  void getEmployee() {
    loading(false);
    Future.delayed(2.seconds, () {
      candidates(employeeList);
      loading(false);
    });
  }

  sendInvitation(String candidateId) async {
    try {
      if (loading.isFalse) {
        showLoading();
        if (Get.isSnackbarOpen) {
          await Get.closeCurrentSnackbar();
        }
      }

      var result = await attendanceApi.sendInvitation(
          params['company_id'], candidateId, 'Not-Approved');
      Get.back();

      Get.rawSnackbar(message: result.message.toString());
      getallCandidates();
    } on BadRequestException catch (e) {
      loading(false);
      Get.back();

      Get.rawSnackbar(title: e.message, message: e.details);
    } catch (e) {
      log(e.toString());

      Get.back();

      Get.rawSnackbar(message: "Something Went Wrong".toString());
    }
  }

  void removeEmployee(String candidateId) async {
    showLoading();
    if (Get.isSnackbarOpen) {
      await Get.closeCurrentSnackbar();
    }
    try {
      var result = await attendanceApi.deleteInvitation(
        params['company_id'],
        candidateId,
      );
      Get.back();

      Get.rawSnackbar(message: result.body.toString());
      getallCandidates();
    } on BadRequestException catch (e) {
      loading(false);
      Get.back();

      Get.rawSnackbar(title: e.message, message: e.details);
    } catch (e) {
      log(e.toString());
      loading(false);

      Get.back();

      Get.rawSnackbar(message: "Something Went Wrong".toString());
    }
  }

  getEmployerReport() async {
    try {
      attendanceLoading(true);
      var result = await repository.getEmployerReport(selectedCompany.value);

      employerReport(result.body['data']);
      loading(false);
      loadingFailed(false);
      attendanceLoading(false);
    } catch (e) {
      attendanceLoading(false);
      loading(false);
      loadingFailed(true);
      handleException(e);
      Get.rawSnackbar(message: e.toString());
    }
  }

  void getInactiveCandidates() async {
    attendanceLoading(true);
    try {
      var result =
          await attendanceApi.getInactiveCandidates(selectedCompany.value);
      employerReport['candidates'] = result.body['data']['candidates'];
      attendanceLoading(false);
    } catch (e) {
      attendanceLoading(false);
      Get.rawSnackbar(message: e.toString());
    }
  }

  void getActiveCandidates() async {
    attendanceLoading(true);
    try {
      var result =
          await attendanceApi.getActiveCandidates(selectedCompany.value);
      attendanceLoading(false);
      employerReport['candidates'] = result.body['data']['candidates'];
    } catch (e) {
      Get.rawSnackbar(message: e.toString());
    }
  }

  deleteCompany(String id) {}
  deleteCandidate(String id) async {
    Get.back();
    showLoading();
    try {
      await attendanceApi.deleteCandidate(id, params['company_id']);
      getallCandidates();
      Get.back();
    } catch (e) {
      Get.back();
      Get.rawSnackbar(message: e.toString());
    }
  }

  changeEmployeeStatus(bool active, id) async {
    Get.back();
    showLoading();
    try {
      await attendanceApi.changeEmployeeStatus(
          params['company_id'] ?? "", id ?? '', active);
      getallCandidates();
      Get.back();
    } catch (e) {
      Get.back();
      Get.rawSnackbar(message: e.toString());
    }
  }
}

class EmployeeModel {
  int? id;
  String? name;

  EmployeeModel({this.id, this.name});

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

var employeeList = <EmployeeModel>[
  EmployeeModel(name: "Nitesh Shrestha"),
  EmployeeModel(name: "Ashish Shrestha"),
  EmployeeModel(name: "Gopal Shrestha"),
  EmployeeModel(name: "Suman Shrestha"),
  EmployeeModel(name: "Nitesh Shrestha"),
];
