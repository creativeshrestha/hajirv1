import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/data/providers/network/api_provider.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/login/models/carousel_item.dart';
import 'package:hajir/app/modules/mobile_opt/controllers/mobile_opt_controller.dart';
import 'package:hajir/app/routes/app_pages.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';
import 'package:hajir/core/localization/l10n/strings.dart';

class LoginController extends GetxController {
  final _selectedItem = 0.obs;
  get selectedItem => _selectedItem.value;
  set selectedItem(value) => _selectedItem.value = value;
  var isEmployer = false.obs;
  var loading = false.obs;

  final TextEditingController phone = TextEditingController();

  final AttendanceSystemProvider attendanceApi = Get.find();
  var candidateItems = <LoginItem>[
    LoginItem(
        icon: "assets/Group 87.png", label: strings.login_candidate_item1),
    LoginItem(
        icon: "assets/Group 91.png", label: strings.login_candidate_item2),
    LoginItem(
        icon: "assets/Group 92.png", label: strings.login_candidate_item3),
  ];
  var employerItems = <LoginItem>[
    LoginItem(icon: "assets/Group 87.png", label: strings.login_employer_item1),
    LoginItem(icon: "assets/Group 91.png", label: strings.login_employer_item2),
    LoginItem(icon: "assets/Group 92.png", label: strings.login_employer_item3),
  ];
  @override
  void onInit() {
    super.onInit();
    isEmployer(Get.arguments);
    phone.text =
        appSettings.phone; // isEmployer.value ? '9823457889' : '9841463556';
  }

  void increment() => _selectedItem.value++;

  void registerPhone() async {
    // if (kDebugMode) {
    //   Get.toNamed(Routes.MOBILE_OPT, arguments: [isEmployer.value, phone.text]);
    // } else
    if (loading.isFalse) {
      try {
        showLoading();
        if (Get.isSnackbarOpen) {
          await Get.closeCurrentSnackbar();
        }
        if (isEmployer.isTrue) {
          // log('employer login');
          // log(phone.text);
          var result = await attendanceApi.registerEmployer(phone.text);

          Get.back();

          Get.toNamed(Routes.MOBILE_OPT,
              arguments: [isEmployer.value, phone.text]);
          Get.log(result.body['data']['otp']);
          Get.rawSnackbar(message: 'Your otp is ${result.body['data']['otp']}');
          loading(false);
        } else {
          // log('candidate login');
          loading(true);
          var result = await attendanceApi.register(phone.text);
          // print(result.body);
          Get.back();
          loading(false);
          Get.toNamed(Routes.MOBILE_OPT,
              arguments: [isEmployer.value, phone.text]);
          Get.log(result.body['data']['otp']);
          Get.rawSnackbar(message: 'Your otp is ${result.body['data']['otp']}');
        }
      }
      // on BadRequestException catch (e) {
      // loading(false);
      // Get.back();
      // if (e.details.contains('Phone No')) {
      //   var login = true;

      //   Get.toNamed(Routes.MOBILE_OPT,
      //       arguments: [isEmployer.value, phone.text, login]);
      // } else {
      //   Get.rawSnackbar(
      //     backgroundColor: Colors.red.shade800,
      //     title: e.message,
      //     message: e.details.toString(),
      //   );
      // }
      // } on ServerException catch (e) {
      //   loading(false);
      //   Get.back();
      //   Get.rawSnackbar(
      //     title: e.statusCode,
      //     message: e.message.toString(),
      //   );
      // }
      catch (e) {
        Get.back();

        loading(false);

        handleException(e);
      }
    }
  }
}

void showLoading() {
  Get.dialog(AlertDialog(
    content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [Center(child: CircularProgressIndicator())]),
  ));
}
