import 'package:get/get.dart';
import 'package:hajir/app/data/models/user.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/data/providers/network/api_provider.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/employer_dashboard/models/company.dart';
import 'package:hajir/app/modules/login/controllers/login_controller.dart';
import 'package:hajir/app/modules/mobile_opt/controllers/mobile_opt_controller.dart';
import 'package:hajir/app/routes/app_pages.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';

class EmployerDashboardController extends GetxController {
  //TODO: Implement EmployerDashboardController
  final AttendanceSystemProvider attendanceApi = Get.find();
  var isEmployed = true;
  var loading = false.obs;

  final selectedIndex = 0.obs;
  var companyList = <Company>[].obs;
  var inactiveCompanies = <Company>[].obs;
  final _selected = 0.obs;

  var selected_payments_options = 0.obs;

  var isActive = true.obs;
  int get selected => _selected.value;
  set selected(int value) => _selected(value);
  var selectedWeek = 0.obs;
  var selectedDay = 0.obs;
  var selectedYear = 0.obs;
  var selectedMonth = 0.obs;
  var selectedReport = 0.obs;
  var myPlan = "Free(Forever)".obs;

  final _dob = ''.obs;
  set dob(String db) => _dob(db);
  String get dob => _dob.value;
  var user = UserModel().obs;
  var loadingFailed = false.obs;
  deleteCompany(String id) async {
    try {
      showLoading();
      await attendanceApi.deleteCompany(id);
      Get.back();
    } catch (e) {
      Get.back();
      Get.rawSnackbar(message: e.toString());
    }
  }

  updateProfile(String fname, String email, String phone) async {
    try {
      showLoading();
      var result = await attendanceApi.employerUpdateProfile({
        'firstname': fname,
        'lastname': fname.split(' ').last,
        'email': email,
        'dob': dob.replaceAll('-', '/')
      });

      appSettings.name = fname;
      appSettings.email = email;
      user.value.email = email;
      user.value.name = fname;
      Get.back();
      Get.back(result: true);
      user(UserModel(name: fname, email: email, phone: phone));
      showSnackBar('Update Successful.');
    } catch (e) {
      Get.back();
      loading(false);
      handleException(e);
    }
  }

  updateStatus(bool isActive, String id) async {
    showLoading();
    try {
      var result = await attendanceApi.updateStatus(isActive, id);
      Get.back();
    } catch (e) {
      Get.rawSnackbar(
          message: e.toString() + "Something Went Wrong".toString());
    }
  }

  getCompanies() async {
    loading(true);

    try {
      var result = await attendanceApi.getEmployerCompanies();
      companyList.clear();
      inactiveCompanies.clear();
      result.body['data']['active_companies']
          .forEach((e) => companyList.add(Company.fromJson(e)));
      result.body['data']['inactive_companies']
          .forEach((e) => inactiveCompanies.add(Company.fromJson(e)));
      loadingFailed(false);
    } on BadRequestException catch (e) {
      loading(false);
      Get.back();

      Get.rawSnackbar(title: e.message, message: e.details);
    } catch (e) {
      log(e.toString());
      loading(false);
      loadingFailed(true);
      Get.back();
      handleException(e);
      // Get.rawSnackbar(message: "Something Went Wrong".toString());
    }
    loading(false);
    // companyList(companies);
  }

  @override
  void onInit() {
    super.onInit();
    user(appSettings.getuser());
    getCompanies();
  }

  void increment() => selectedIndex.value++;

  void logout() {
    appSettings.logout();
    Get.toNamed(Routes.WELCOME);
  }
}
