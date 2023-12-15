import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hajir/app/data/models/user.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/data/providers/network/api_provider.dart';
import 'package:hajir/app/data/services/firebase.dart';
import 'package:hajir/app/modules/candidate_login/controllers/candidate_login_controller.dart';
import 'package:hajir/app/modules/candidatecompanies/controllers/candidatecompanies_controller.dart';
import 'package:hajir/app/modules/login/bindings/login_binding.dart';
import 'package:hajir/app/modules/login/controllers/login_controller.dart';
import 'package:hajir/app/modules/mobile_opt/controllers/mobile_opt_controller.dart';
import 'package:hajir/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:hajir/app/routes/app_pages.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';

class DashboardController extends GetxController {
  final attendanceApi = Get.find<AttendanceSystemProvider>();
  final notificationController = Get.find<NotificationsController>();
  final loginController = Get.find<CandidateLoginController>();
  final count = 0.obs;

  final isEmployed = false.obs;
  // bool get isEmployed => _isEmployed.value;
  final selectedCompany = ''.obs;
  final isCompanySelected = false.obs;
  String get companySelected => selectedCompany.value;
  set companySelected(String id) => selectedCompany(id);
  // set isEmployed(bool userEmploymentStatus) =>
  //     _isEmployed(userEmploymentStatus);
  final _selectedIndex = 0.obs;
  get selectedIndex => _selectedIndex.value;
  set selectedIndex(value) => _selectedIndex.value = value;

  final _isInvited = false.obs;
  bool get isInvited => _isInvited.value;
  set isInvited(bool isUserInvited) => _isInvited(true);

  var selectedWeek = 0.obs;
  final CandidatecompaniesController candidatecompaniesController = Get.find();

  // var selectedReport = 0.obs;

  var selectedMonth = 0.obs;
  var selectedYear = 0.obs;
  final _dob = ''.obs;
  set dob(String db) => _dob(db);
  String get dob => _dob.value;
  var invitationlist = [].obs;
  var loading = false.obs;
  var user = UserModel().obs;

  updateProfile(String fname, String lname, String email, String phone,
      String image) async {
    try {
      showLoading();
      var body = {
        'firstname': fname,
        'lastname': lname,
        'email': email,
        'dob': dob.replaceAll('-', '/')
      };
      var formData = FormData(body);
      if (image.isNotEmpty) {
        formData.files.add(MapEntry('uploadfile',
            MultipartFile(File(image), filename: image.split('/').last)));
      }

      var result = await attendanceApi.updateProfile(formData);

      appSettings.name = fname;
      appSettings.email = email;
      user.value.email = email;
      user.value.name = fname;
      Get.back();
      Get.back(result: true);
      showSnackBar(result.message.toString());
    } catch (e) {
      Get.back(result: false);
      handleException(e);
    }
  }

  getInvitations() async {
    var token = await Get.find<PushNotification>().fireBaseToken;
    await attendanceApi.setDeviceToken(token).then((value) {
      print(value.body);
    });
    try {
      loading(true);
      if (Get.isSnackbarOpen) {
        await Get.closeCurrentSnackbar();
      }
      var res = await attendanceApi.candidateInvitations();

      // print(res.body);
      invitationlist(res.body['data']['candidateInvitations']);
      if (invitationlist.isEmpty) {
        // candidatecompaniesController.getCompanies();
      }
      loading(false);
      // var invitation = invitationlist
      //     .firstWhereOrNull((element) => element['status'] == 'Approved');
      // if (invitation != null) {
      //   isEmployed = true;
      //   appSettings.isEmployed = true;
      //   appSettings.companyId = invitation['company']['id'].toString();
      //   // print(invitation);
      // }
    } on BadRequestException catch (e) {
      loading(false);

      Get.rawSnackbar(title: e.message, message: e.details);
    } catch (e) {
      loading(true);

      Get.rawSnackbar(message: e.toString());
    }
  }

  deleteCompany(String id) async {
    await attendanceApi.candidateDeteteCompany(id);
    candidatecompaniesController.getCompanies();
    getInvitations();
  }

  acceptInvitation(String companyId,
      {String invitationId = '', bool decline = false}) async {
    try {
      loading(true);
      if (Get.isSnackbarOpen) {
        await Get.closeCurrentSnackbar();
      }

      await attendanceApi.acceptInvitation(invitationId, decline: decline);
      candidatecompaniesController.getCompanies();

      await getInvitations();
      isEmployed.value = true;
      if (!decline) {
        appSettings.isEmployed = true;
      }
      appSettings.companyId = companyId;

      loading(false);
    } on BadRequestException catch (e) {
      loading(false);
      // Get.back();

      Get.rawSnackbar(title: e.message, message: e.details);
    } catch (e) {
      log(e.toString());
      loading(false);

      Get.rawSnackbar(message: "Something Went Wrong".toString());
    }
  }

  @override
  void onInit() {
    super.onInit();
    appSettings.employer = false;

    user(appSettings.getuser());
    isEmployed.value = appSettings.isEmployed;

    var now = DateTime.now();
    selectedYear(now.year);
    selectedMonth(now.month);
    selectedWeek(now.day ~/ 7);
    getInvitations();
    if (!appSettings.isEmployed) {}
    checkIfPreviouslyLoggedIn();
  }

  logout() async {
    appSettings.logout();
    // Get.closeAllSnackbars();
    // Get.clearTranslations();
    // Get.clearRouteTree();
    // Get.deleteAll();
    Get.offNamed(Routes.LANGUAGE);
  }

  void increment() => count.value++;

  void changeCompany(String id) {
    loading(true);
    selectedCompany(id);
    appSettings.companyId = id;
    loading(false);
  }

  checkIfPreviouslyLoggedIn() {
    // if (appSettings.isPreviouslyLoggedIn()) {
    //   log("true");
    //   companySelected = (appSettings.companyId);
    //   isCompanySelected(true);

    //   /// TODO : NAvigate to login page
    //   /// set login time
    //   /// set percentage update
    //   /// set break start
    //   /// set break end
    // }
  }
}

showSnackBar(msg) {
  Get.rawSnackbar(
      borderRadius: 10.r,
      // borderWidth: 1,
      margin: REdgeInsets.all(10),
      backgroundColor: Colors.white,
      // overlayColor: Colors.red,
      // backgroundColor: Colors.white,
      borderColor: Colors.grey.shade200,
      messageText: Text(
        msg.toString(),
        style: const TextStyle(),
      ),
      snackPosition: SnackPosition.TOP);
}

void handleException(Object e) {
  if (Get.isSnackbarOpen) Get.closeAllSnackbars();
  switch (e) {
    case ServerException:
      e as ServerException;

      showSnackBar(e.message.toString());
      break;
    case UnauthorisedException:
      e as UnauthorisedException;
      // Get.to(() => Routes.LOGIN, binding: LoginBinding());
      // Get.toNamed(Routes.LOGIN);
      showSnackBar(e.details['message'] ?? "");

      break;
    case BadRequestException:
      e as BadRequestException;
      customSnackbar(message: e.details);

      break;
    case FetchDataException:
      e as FetchDataException;
      showSnackBar(e.message);

      break;
    default:
      // e as ServerException;
      showSnackBar(e.toString());
  }
}

customSnackbar({String? title, message}) {
  showSnackBar(message);
  // Get.snackbar(message ?? "", "".toString(),
  //     margin: const EdgeInsets.all(20),
  //     colorText: Colors.red,
  //     backgroundColor: Colors.white,
  //     duration: 4.seconds);
}

// showSnackBar(msg) {
//   Get.rawSnackbar(
//       borderRadius: 10.r,
//       // borderWidth: 1,
//       margin: REdgeInsets.all(10),
//       backgroundColor: Colors.white,
//       // overlayColor: Colors.red,
//       // backgroundColor: Colors.white,
//       borderColor: Colors.grey.shade200,
//       messageText: Text(
//         msg.toString(),
//         style: const TextStyle(),
//       ),
//       snackPosition: SnackPosition.TOP);
// }
