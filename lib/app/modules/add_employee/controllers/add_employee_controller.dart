import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/data/providers/network/api_provider.dart';
import 'package:hajir/app/modules/add_employee/candidate_model.dart';
import 'package:hajir/app/modules/add_employee/providers/candidate_provider.dart';
import 'package:hajir/app/modules/company_detail/controllers/company_detail_controller.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/employer_dashboard/controllers/employer_dashboard_controller.dart';
import 'package:hajir/app/modules/login/controllers/login_controller.dart';

/// candidate id=['candidate_id']
class AddEmployeeController extends GetxController {
  final candidateProvider = Get.find<CandidateProvider>();
  final AttendanceSystemProvider attendaceApi = Get.find();
  var candidate = Candidate.fromJson({}).obs;
  final name = TextEditingController();
  final code = TextEditingController();
  final contact = TextEditingController();
  final address = TextEditingController();
  final salaryAmount = TextEditingController();
  final dob = ''.obs;
  final count = 0.obs;
  final email = TextEditingController();
  var officeHourStart = '08:00'.obs;
  var officeHourEnd = '18:00'.obs;
  final salaryType = TextEditingController()..text = 'monthly';
  final joiningDate = DateTime.now().toString().substring(0, 10).obs;
  final dutyTime = TextEditingController()..text = '08:00';
  final overTime = TextEditingController();
  final breakStart = '13:00'.obs;
  final breakEnd = '13:45'.obs;
  var hasOvertimerRatio = false.obs;
  var allowLateAttendance = false.obs;
  var designation = TextEditingController();
  final allowlateBy = '00:30'.obs;
  var phone = TextEditingController();
  var params;
  var loading = false.obs;
  var args = ''.obs;

  var officehours = "08:00".obs;

  var casualleavetype = "monthly".obs;
  var allowcasualleave = false.obs;
  var casualleave = TextEditingController();
  var allowallowance = false.obs;
  var allowance = "monthly".obs;
  var allowance_amount = TextEditingController();
  var isEdit = false.obs;

  var cphone = TextEditingController();

  ////errors
  ///
  var emailError = "".obs;
  var contactError = "".obs;
  // var candidateId = ''.obs;
  addCadidate() async {
    loading(true);
    final candidate = Candidate()
      ..name = name.text
      ..address = address.text
      ..code = code.text
      ..contact = phone.text
      // ..officeHourStart = officeHourStart.value
      // ..officeHourEnd = officeHourEnd.value
      ..email = email.text
      ..address = "test"
      ..workingHours = officehours.value
      ..allowanceType = allowance.value
      // ..allowanceAmount = allowance_amount.text
      ..casualLeave = casualleave.text
      ..casualLeaveType = allowcasualleave.isTrue ? casualleavetype.value : null
      ..dob = dob.value
      ..designation = designation.text
      ..salaryType = salaryType.text
      ..salaryAmount = salaryAmount.text
      ..joiningDate = joiningDate.value
      ..dutyTime = dutyTime.text
      ..overTime = overTime.text
      ..allowanceAmount = allowallowance.isTrue ? allowance_amount.text : null
      ..allowanceType = allowallowance.isTrue ? allowance.value : null
      ..allowLateAttendance =
          allowLateAttendance.isTrue ? allowlateBy.value : null;

    try {
      showLoading();
      Get.log(candidate.toJson().toString());
      var result = isEdit.value
          ? await attendaceApi.addCandidate(jsonEncode(candidate.toJson()),
              params['id'], isEdit.value, params['companyId'])
          : await attendaceApi.addCandidate(
              jsonEncode(candidate.toJson()), "", isEdit.value, args.value);
      // Get.log(candidate.toJson().toString());
      Get.back();
      Get.back();
      Get.find<CompanyDetailController>().getallCandidates();
      showSnackBar((result.body['message'] ?? "").toString());
    } on UnauthorisedException catch (e) {
      Get.back();
      contactError((e.details['data']['contact'][0] ?? "").toString());
      emailError((e.details['data']['email'][0] ?? "").toString());
      showSnackBar((e.details['message'] ?? '').toString());
      // Get.rawSnackbar(message: e.details['message'].toString());
    } catch (e) {
      Get.back();
      handleException(e);
      // Get.rawSnackbar(message: e.toString());
      // log(e.toString());
    }
    loading(false);
  }

  @override
  void onInit() {
    super.onInit();
    params = Get.parameters;
    if (params['id'] != null) {
      isEdit(true);
      getCandidate(params['companyId'] ?? "", params['id'] ?? '');
    } else {
      loading(true);
      args(Get.arguments);

      var company = Get.find<EmployerDashboardController>().isActive.isTrue
          ? Get.find<EmployerDashboardController>()
              .companyList
              .firstWhere((p0) => p0.id.toString() == Get.arguments)
          : Get.find<EmployerDashboardController>()
              .inactiveCompanies
              .firstWhere((p0) => p0.id.toString() == Get.arguments);

      if (company.generateCode ?? false) {
        generateCandidateCode();
      } else {
        code.text = "";
      }
      loading(false);
    }
  }

  void increment() => count.value++;

  void generateCandidateCode() async {
    loading(true);
    var result = await attendaceApi.generateCandidateCode(Get.arguments);
    code.text = result.body['data']['code'].toString();
    loading(false);
  }

  getCandidate(String companyId, String id) async {
    loading(true);
    try {
      var result = await candidateProvider.getCandidate(companyId, id);
      if (result != null) {
        var compcandidate = candidate.value;

        /// populate data
        ///
        candidate(result);
        name.text = candidate.value.name ?? "";
        code.text = result.code ?? "";
        phone.text = candidate.value.contact ?? "";

        dutyTime.text = result.dutyTime ?? "08:00";
        address.text = candidate.value.address ?? "";
        designation.text = candidate.value.designation ?? '';
        email.text = candidate.value.email ?? '';
        dob.value = candidate.value.dob ?? "";
        hasOvertimerRatio(result.overTime?.isNotEmpty ?? false ? true : false);
        // officeHourStart(candidate.value.officeHourStart);
        // officeHourEnd(candidate.value.officeHourEnd);
        salaryType.text = result.salaryType ?? 'monthly';
        salaryAmount.text = result.salaryAmount ?? "";
        joiningDate(result.joiningDate ?? '');
        dutyTime.text = result.dutyTime ?? '';
        overTime.text = compcandidate.overTime ?? "";
        allowlateBy.value = compcandidate.allowLateAttendance ?? "00:00";
        casualleavetype.value = compcandidate.casualLeaveType ?? "monthly";
        casualleave.text = compcandidate.casualLeave ?? "";
        allowcasualleave(
            compcandidate.casualLeave?.isNotEmpty ?? false ? false : true);
        joiningDate.value = result.joiningDate ?? "";
        loading(false);
        // allowLateAttendance=compcandidate.allowLateAttendance
      }
    } catch (e) {
      loading(false);
      handleException(e);
    }
  }
}
