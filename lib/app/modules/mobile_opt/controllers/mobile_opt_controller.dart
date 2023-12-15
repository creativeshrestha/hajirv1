import 'dart:async';

import 'package:get/get.dart';
import 'package:hajir/app/data/models/user.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/data/providers/network/api_provider.dart';
import 'package:hajir/app/data/services/firebase.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/login/controllers/login_controller.dart';
import 'package:hajir/app/routes/app_pages.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';

class MobileOptController extends GetxController {
  final count = 0.obs;
  final args = <dynamic>[].obs;
  var code = ''.obs;
  var loading = false.obs;
  var time = 180;
  var elapsedTime = 0.obs;
  late Timer timer;
  var phone = '';
  var employer = false;
  final AttendanceSystemProvider attendanceSystemProvider = Get.find();
  @override
  void onInit() {
    super.onInit();
    args(Get.arguments);
    phone = args[1];
    employer = args[0];
    // code('8087');
    initTimer();
  }

  initTimer() {
    timer = Timer.periodic(1.seconds, (timer) {
      if (elapsedTime <= 0) {
        timer.cancel();
        //resend code
        // resendCode();
        elapsedTime(time);
        initTimer();
      } else {
        // print(timer.tick);
        elapsedTime(time - timer.tick);
      }
    });
  }

  @override
  void onClose() {
    timer.cancel();
    log("timer canceled");
    super.onClose();
  }

  void increment() => count.value++;

  verifyOtp() async {
    if (loading.isFalse) {
      try {
        loading(true);
        showLoading();
        if (Get.isSnackbarOpen) {
          await Get.closeCurrentSnackbar();
        }
        if (employer) {
          var result = await attendanceSystemProvider.verifyEmployerOtp(
              phone, code.value);
         
          timer.cancel();

          appSettings.saveUser(UserModel.fromJson(result.body['data']['user']));
          // appSettings.token = result.body['data']['token'];
          appSettings.candidateId =
              result.body['data']['user']['id'].toString();
          timer.cancel();
          appSettings.saveUser(UserModel.fromJson(result.body['data']['user']));
          appSettings.token = result.body['data']['token'];
          // appSettings.type = 'employee';
          appSettings.type = 'employer';
          Get.back();
          Get.offAllNamed(Routes.EMPLOYER_DASHBOARD);
          Get.delete<MobileOptController>();
          // Get.log(result.body.toString());
          // Get.rawSnackbar(message: result.body['message'].toString());
          loading(false);
        } else {
          var result =
              await attendanceSystemProvider.verifyOtp(phone, code.value);

          appSettings.candidateId =
              result.body['data']['user']['id'].toString();
          timer.cancel();
          appSettings.saveUser(UserModel.fromJson(result.body['data']['user']));
          appSettings.token = result.body['data']['token'];
          appSettings.type = 'employee';
          await Future.delayed(1.seconds);
          Get.back();
          Get.offAllNamed(Routes.DASHBOARD);
          // Get.rawSnackbar(message: result.body['message'].toString());
          loading(false);
        }
        // if (args[0]) {
        //   Get.toNamed(Routes.EMPLOYER_DASHBOARD);
        // } else {
        //   Get.toNamed(Routes.DASHBOARD);
        // }
      }

      //  on BadRequestException catch (e) {
      //   loading(false);
      //   Get.back();

      //   Get.rawSnackbar(title: e.message, message: e.details);
      // }
      catch (e) {
        loading(false);

        Get.back();
        handleException(e);
        // Get.rawSnackbar(message: e.toString().toString());
      }
    }
  }

  void resendCode() async {
    try {
      await attendanceSystemProvider.register(phone);
    } catch (e) {
      handleException(e);
    }
  }
}

log(String abc) {
  Get.log(abc);
}
