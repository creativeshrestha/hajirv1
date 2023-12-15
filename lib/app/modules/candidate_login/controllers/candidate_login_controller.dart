import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/data/providers/network/api_provider.dart';
import 'package:hajir/app/modules/candidate_login/models/today_details.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/login/controllers/login_controller.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';
import 'package:hajir/main_paint.dart';
import 'package:local_auth/local_auth.dart';

parseWorkingHour(value) {
  var data = value.split(":");
  return Duration(
      hours: int.tryParse(data.first) ?? 0,
      minutes: int.tryParse(data.last) ?? 0);
}

void showSnackbar({String? title, required String message}) {
  Get.closeAllSnackbars();
  customSnackbar(message: message);
}

enum AuthStatus { Uninitialized, Authenticated, Unauthenticated }

class BreakList {
  int startPercent;
  int? endPercent;

  BreakList(this.startPercent, this.endPercent);
}

enum BreakStatus { NotStarted, Started, Running, Ended }

class CandidateLoginController extends GetxController {
  var breakList = <BreakList>[].obs;
  var todayDetailsResponse = TodayDetailResponse.fromJson({}).obs;
  var attendanceId = ''.obs;
  var details;
  var duty_time = const Duration(hours: 0, minutes: 0);
  var angle = 0.0.obs;
  var total_working_hours = 8.obs;
  var todayDetails = {}.obs;
  var companyCode = ''.obs;
  var loading = false.obs;
  final count = 0.obs;
  var total_earning = 0.0.obs;
  var breakSubmitting = false.obs;
  late Timer timer;
  var timerInit = false.obs;
  var dailyEarning = 0.0.obs;
  var now = DateTime.now().obs;
  var breakStarted = BreakStatus.NotStarted.obs;
  var breaklimit = 4;
  final _totalbreaks = 0.obs;
  var percentage = 0.0.obs;
  var breakStartedPercentage = 0.0.obs;
  var breakEndPercentage = 0.0.obs;
  var loggedInTime = 0.0.obs;
  final authStatusd = AuthStatus.Unauthenticated.obs;
  final _isloggedIn = false.obs;
  final _isloggedOut = false.obs;
  var d1 = 0.obs;
  var d2 = 0.obs;
  var d3 = 0.obs;
  var d4 = 0.obs;
  var d5 = 0.obs;

  var d6 = 0.obs;
  var earning = 0.00.obs;

  var loggedInDateAndTime = "".obs;
  var imageInitilized = false.obs;
  final localAuth = LocalAuthentication();
  //
  final attendaceApi = Get.find<AttendanceSystemProvider>();
  var totalHours = 8 * 60 * 60;
  late ui.Image image;
  var elapsedTime = const Duration(seconds: 0).obs;
  get duration =>
      Duration(minutes: ((percentage.value / 100) * 8 * 60 * 60).toInt());
  get isAuthenticated => AuthStatus.Authenticated == authStatusd.value;
  bool get isloggedIn => _isloggedIn.value;
  set isloggedIn(bool userloginStatus) => _isloggedIn(userloginStatus);
  bool get isLoggedOut => _isloggedOut.value;
  set isLoggedOut(bool v) => _isloggedOut(v);
  double get newangle => (360 - now.value.second / 60 * 360);
  get percent => percent.value;
  get selected => count.value;
  set selected(value) => count(value);
  double get testangel => (now.value.second / 60 * 300);
  int get totalbreaks => _totalbreaks.value;
  set totalbreaks(int i) => i;
  void apilogout() async {
    showLoading();
    try {
      var body = {'earning': earning.value};
      var attendanceID = attendanceId.value ?? appSettings.attendanceId;
      var companyId = appSettings.companyId;
      appSettings.logoutTime = DateTime.now().toString();

      var result = await attendaceApi.logout(body, companyId, attendanceID);
      Get.back();
      appSettings.logoutTime = DateTime.now().toString();
      authStatusd.value = AuthStatus.Unauthenticated;
      _isloggedIn(false);
      _isloggedOut(true);
      timer.cancel();
      timerInit(true);
      d1(0);
      d2(0);
      timer = Timer.periodic(1.seconds, (timer) {
        now(DateTime.now());

        if (!isLoggedOut && isloggedIn) updatePercentage();
      });
      showSnackbar(message: '${result.message}');
    } catch (e) {
      Get.back();
      showSnackbar(message: e.toString());
    }
  }

  authenticated() async {
    return await localAuth.authenticate(
        localizedReason: "Employee Identity Verification",
        options: const AuthenticationOptions(biometricOnly: false));
  }

  int calculatePercent(String? startTime) {
    // print(startTime);
    var time = startTime?.split(':') ?? [];
    var hour = int.parse(time[0]);
    var minutes = int.parse(time[1]);
    var percent = ((hour >= 12 ? (hour - 12) * 30 : (hour * 30)) +
            (minutes * 30 / 60) +
            1)
        .toInt();
    return percent;
  }

  clearStates() {
    timer.cancel();
    authStatusd.value = AuthStatus.Unauthenticated;
    loggedInTime(0);
    earning(0);
    totalbreaks = 0;
    breakStarted(BreakStatus.NotStarted);
    _isloggedIn(false);
    isLoggedOut = (false);
    timer.cancel();
    timerInit(true);
    d1(0);
    d2(0);

    timer = Timer.periodic(1.seconds, (timer) {
      now(DateTime.now());
      if (!isLoggedOut && isloggedIn) updatePercentage();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  getTodayDetails() async {
    loading(true);
    var hasData = false;
    authStatusd.value = AuthStatus.Uninitialized;
    _isloggedOut(false);
    _isloggedIn(false);
    loggedInDateAndTime("");
    angle(0);
    details = null;
    try {
      var selectedCompany = appSettings.companyId;
      details = await attendaceApi.candidateTodayDetails(selectedCompany);
      todayDetailsResponse(todayDetailsFromJson(jsonEncode(details.body)));
      attendanceId(
          todayDetailsResponse.value.data!.attendanceId?.toString() ?? "");
      loading(true);
      Get.back();
      hasData = true;
      loading(false);
      for (var breakData in todayDetailsResponse.value.data!.breaks!) {
        if (breakData.startTime != null &&
            breakData.endTime != null &&
            breakData.endTime != '') {
          var startPercent = calculatePercent(breakData.startTime);
          var endPercent = calculatePercent(breakData.endTime);

          endPercent = (((endPercent - startPercent) > 20)
              ? startPercent + 15
              : endPercent);
          breakList.add(BreakList(startPercent, endPercent));
        } else if (breakData.endTime != null) {
          int endPercent;
          var startPercent = calculatePercent(breakData.startTime);
          if (breakData.endTime!.isNotEmpty) {
            endPercent = calculatePercent(breakData.endTime);
          } else {
            endPercent = startPercent;
            // angle.value.toInt();
          }
          breakList.add(BreakList(startPercent, endPercent));
        }
      }
      duty_time = parseDuration(details.body['data']['duty_time']);

      if (details.body['data']['start_time'] != null &&
          details.body['data']['start_time'].isEmpty) {
      } else {
        authStatusd.value = AuthStatus.Authenticated;
        appSettings.previousLoginDate = (now.value.toString());

        isloggedIn = true;
        _isloggedOut(false);
        _isloggedIn(true);

        if (details.body['data']['start_time'] != null) {
          updateIfPreviouslyLoggedIn();
          if (appSettings.previousLoginTime.isNotEmpty) {
            appSettings.previousLoginTime =
                details.body['data']['start_time'].toString().substring(0, 5);
            // appSettings.previousLoginTime = '09:00';
          }

          if (details.body['data']['breaks'] != []) {
            if (details.body['data']['current_break'] != null) {
              var breaksStart =
                  (details.body['data']['current_break']['start_time']);
              breakStarted.value = BreakStatus.Started;
              var time = breaksStart.split(":");
              appSettings.breakId =
                  details.body['data']['current_break']['id'].toString();
              var hour = int.parse(time[0]);
              var minutes = int.parse(time[1]);
              breakStartedPercentage(
                  ((hour >= 12 ? (hour - 12) * 30 : (hour * 30)) +
                          (minutes * 30 / 60) +
                          1)
                      .toInt()
                      .toDouble());
              var breakend = (details.body['data']['current_break']['end_time'])
                  .toString();

              if (breakend != 'null' && breakend.isNotEmpty) {
                breakStarted.value = BreakStatus.Ended;
                var time = breakend.split(":");

                var hour = int.parse(time[0]);
                var minutes = int.parse(time[1]);

                breakStarted.value = BreakStatus.Ended;
                breakEndPercentage(
                    ((hour >= 12 ? (hour - 12) * 30 : (hour * 30)) +
                            (minutes * 30 / 60) +
                            1)
                        .toInt()
                        .toDouble());
              }
            }
          }
        }
        if (details.body['data']['end_time'] != null) {
          _isloggedOut(true);
          var time = details.body['data']['end_time']
              .toString()
              .substring(0, 5)
              .split(':');
          var hour = int.parse(time.first);
          var min = int.parse(time.last);
          appSettings.logoutTime = DateTime(
                  now.value.year, now.value.month, now.value.day, hour, min)
              .toString();
        } else {
          appSettings.logoutTime = '';
        }
      }

      dailyEarning(details.body['data']['per_minute_salary'] *
          60 *
          total_working_hours.value.toDouble());
      total_earning(
          double.parse(details.body['data']['total_earning'].toString()));
      if (details.body['data']['start_time'] != null) {
        updateIfPreviouslyLoggedIn();
      } else {
        clearStates();
      }
    } catch (e) {
      loading(false);
      Get.back();
      Get.snackbar('Error', e.toString(),
          margin: const EdgeInsets.all(20),
          colorText: Colors.red,
          backgroundColor: Colors.white,
          duration: 4.seconds);
    }
    loading(false);
    return hasData;
  }

  void increment() => count.value++;

  void initImage() async {
    image = await loadImage('Group 105.png');

    imageInitilized(true);
  }

  // login
  login() async {
    loading(true);
    update();
    _isloggedOut(false);

    var isSupported = false;
    var availbaleBiometrics = [];
    try {
      if (Platform.isAndroid) {
        isSupported = await localAuth.isDeviceSupported();
        availbaleBiometrics = await localAuth.getAvailableBiometrics();
        if (isSupported && availbaleBiometrics.isNotEmpty) {
          try {
            var isAuthenticated = await localAuth.authenticate(
                localizedReason: "Employee Identity Verification",
                options: const AuthenticationOptions(biometricOnly: false));
            if (isAuthenticated) {
              updateLogin();
            } else {
              authStatusd.value = AuthStatus.Unauthenticated;
              loading(false);
              showSnackbar(message: "Authentication Failed");
            }
          } on PlatformException catch (e) {
            showSnackbar(message: e.message!);
          }
        } else {
          updateLogin();
          // loading(false);
          // Get.dialog(AlertDialog(
          //   titlePadding: const EdgeInsets.only(top: 10, left: 16, right: 16),
          //   title: const Text("Alert Security Measure not setup on device!!!"),
          //   actions: [
          //     const Text(
          //       "Your device does not have security setup.Please setup security measures to continue.",
          //       textAlign: TextAlign.center,
          //     ),
          //     Center(
          //       child: SizedBox(
          //         width: 200,
          //         child: ElevatedButton(
          //             style:
          //                 ElevatedButton.styleFrom(backgroundColor: Colors.red),
          //             onPressed: () {
          //               openAppSettings();
          //             },
          //             child: const Text("Setup Now")),
          //       ),
          //     )
          //   ],
          // ));

          // showSnackbar(
          //     message:
          //         "Authentication not available on device.Please setup security measures to continue.");
        }
      } else {
        if (kDebugMode) {
          await updateLogin();
          // authStatus = AuthStatus.Authenticated;
          // // timerInit(true);
          // loggedInDateAndTime.value = DateTime.now().toString();
          // print(loggedInDateAndTime.value);
          // timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          //   now(DateTime.now());
          //   updatePercentage();
          // });
        }
      }
    } catch (e) {}
  }

  logout() async {
    if (Platform.isAndroid) {
      var isAuthenticated = await localAuth.authenticate(
          localizedReason: "Employee Identity Verification",
          options: const AuthenticationOptions(biometricOnly: false));
      if (isAuthenticated) {
        apilogout();
      } else {
        showSnackbar(message: "Authentication Failed.");
      }
    } else {
      apilogout();

      authStatusd.value = AuthStatus.Unauthenticated;
      _isloggedIn(false);
      _isloggedOut(true);
      timer.cancel();
      timerInit(true);
    }
  }

  @override
  void onInit() {
    super.onInit();
    timerInit(true);
    timer = Timer.periodic(1.seconds, (timer) {
      now(DateTime.now());
    });
    if (appSettings.companyId != '') {
      getTodayDetails();
    }
  }

  parseDuration(body) {
    if (body.toString().contains(":")) {
      var time = body.split(':');
      return Duration(hours: int.parse(time[0]), minutes: int.parse(time[1]));
    } else {
      // Get.log(body.toString() + "TEST");
      return const Duration(hours: 1);
    }
  }

  void startBreakSubmit() async {
    if (totalbreaks < 4) {
      try {
        var res = await attendaceApi.breakStore({}, attendanceId.value);
        breakStarted(BreakStatus.Started);
        Get.back();
        breakStartedPercentage(angle.value);
        breakList.add(BreakList(breakStartedPercentage.value.toInt(), null));
        breakSubmitting(false);
        appSettings.breakId = res.body['data']['break_id'].toString();
        appSettings.breakStartTime = DateTime.now().toString();
        showSnackbar(message: 'Break Start Submitted.${res.message} ');
      } catch (e) {
        breakSubmitting(false);
        Get.back();
        showSnackbar(message: 'Break Start Submit Failed. ');
      }
    } else {
      breakSubmitting(false);
      Get.back();
      Future.delayed(Duration.zero,
          (() => showSnackbar(message: 'Break Limit Exceeded. ')));
    }
  }

  startorStopBreak() async {
    if (!breakSubmitting.value) {
      breakSubmitting(true);
      if (totalbreaks < breaklimit) {
        totalbreaks = totalbreaks + 1;
        if (Platform.isAndroid) {
          if (await authenticated()) {
            showLoading();
            if (BreakStatus.NotStarted == breakStarted.value ||
                BreakStatus.Ended == breakStarted.value) {
              startBreakSubmit();
            } else if (breakStarted.value == BreakStatus.Started) {
              stopBrakSubmit();
            } else {}
          } else {
            showSnackbar(message: "Authentication Failed.");
          }
        } else {
          if (BreakStatus.NotStarted == breakStarted.value ||
              BreakStatus.Ended == breakStarted.value) {
            startBreakSubmit();
          } else if (breakStarted.value == BreakStatus.Started) {
            stopBrakSubmit();
          } else {}
          // if (BreakStatus.NotStarted == breakStarted.value ||
          //     BreakStatus.Ended == breakStarted.value) {
          //   breakStartedPercentage(percentage.value);
          //   breakStarted(BreakStatus.Started);
          //   appSettings.breakStartTime = DateTime.now().toString();
          //   breakSubmitting(false);
          // } else if (breakStarted.value == BreakStatus.Started) {
          //   breakEndPercentage(percentage.value);
          //   breakSubmitting(false);
          //   appSettings.breakEndTime = DateTime.now().toString();
          //   breakStarted(BreakStatus.Ended);
          // }
        }
      } else {
        showSnackbar(message: "Break Exceeded.");
      }
    }
  }

  void stopBrakSubmit() async {
    if (totalbreaks < 4) {
      var breakId = appSettings.breakId;
      try {
        var res = await attendaceApi.breakUpdate({}, breakId);
        appSettings.breakEndTime = DateTime.now().toString();
        breakStarted(BreakStatus.NotStarted);
        breakEndPercentage(angle.value);
        breakList.last.endPercent = breakEndPercentage.value.toInt();
        Get.back();
        breakSubmitting(false);
        showSnackbar(message: 'Break end Submitted. ');
      } catch (e) {
        breakSubmitting(false);
        Get.back();
        showSnackbar(message: 'Break Submit Failed. ');
      }
    } else {
      breakSubmitting(false);
      Get.back();
    }
  }

  void updateIfPreviouslyLoggedIn() {
    if (appSettings.isPreviouslyLoggedIn()) {
      var hour =
          int.tryParse(appSettings.previousLoginTime.split(':').first) ?? 0;
      var min =
          int.tryParse(appSettings.previousLoginTime.split(':').last) ?? 0;
      // print(hour);
      if (appSettings.logoutTime.isNotEmpty) {
        loggedInDateAndTime(
            DateTime(now.value.year, now.value.month, now.value.day, hour, min)
                .toString());
      } else {
        loggedInDateAndTime.value =
            DateTime(now.value.year, now.value.month, now.value.day, hour, min)
                .toString();
        var percentage = now.value
                .difference(DateTime(
                    now.value.year, now.value.month, now.value.day, hour, min))
                .inSeconds /
            (8 * 60 * 60);
        loggedInTime(percentage);
      }
      updatePercentage();
      _isloggedIn(true);
      timerInit(true);
      if (appSettings.breakStartTime != "") {
        if (percentage > 50) {}
      }
      if (appSettings.breakEndTime != "") {
        if (percentage > 50) {}
      }
      authStatusd.value = AuthStatus.Authenticated;
      timer.cancel();
      if (!appSettings.logoutTime
          .contains(DateTime.now().toString().substring(0, 10))) {
        timer = Timer.periodic(1.seconds, (timer) {
          now(DateTime.now());
          if (!isLoggedOut && isloggedIn) updatePercentage();
        });
      } else {
        authStatusd.value = AuthStatus.Unauthenticated;
        _isloggedIn(false);
        _isloggedOut(true);

        timer.cancel();
        timerInit(true);
        timer = Timer.periodic(1.seconds, (timer) {
          now(DateTime.now());
        });
      }
    }
  }

  Future<void> updateLogin() async {
    loading(true);
    showLoading();

    try {
      var hour = DateTime.now().hour;
      var minute = DateTime.now().minute;
      var time =
          "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";

      var result = await attendaceApi.storeAttendance(
          appSettings.companyId, time, appSettings.candidateId);

      Get.back();
      showSnackbar(message: 'Login Successful.${result.body['message']}');
      if (result.body['data'] != null) {
        loggedInDateAndTime(DateTime.now().toString());

        appSettings.previousLoginDate =
            DateTime.now().toString().substring(0, 10);
        appSettings.previousLoginTime = time;
        appSettings.breakStartTime = '';
        appSettings.breakEndTime = '';
        appSettings.logoutTime = '';
        appSettings.attendanceId =
            result.body['data']['attendance_id'].toString();

        appSettings.date = now.value.toString().substring(0, 10);
        _isloggedIn(true);
        timerInit(true);
        authStatusd.value = AuthStatus.Authenticated;
        timer.cancel();
        _isloggedIn(true);
        timerInit(true);
        loading(false);
        timer = Timer.periodic(1.seconds, (timer) {
          now(DateTime.now());
          if (!isLoggedOut && isloggedIn) updatePercentage();
        });
        Future.delayed(700.milliseconds, () {
          getTodayDetails();
        });
      }
    } on BadRequestException catch (e) {
      loading(false);
      Get.back();
      showSnackbar(title: e.message, message: e.details.toString());
    } on UnauthorisedException catch (e) {
      loading(false);
      Get.back();
      showSnackbar(title: e.message, message: e.details['message']);
    } catch (e) {
      loading(false);
      Get.back();
      showSnackbar(message: e.toString());
    }
  }

  updatePercentage() {
    elapsedTime(
        DateTime.now().difference(DateTime.parse(loggedInDateAndTime.value)));

    loggedInTime(elapsedTime.value.inSeconds / (8 * 60 * 60) * 100);
    angle(((now.value.hour >= 12
                ? (now.value.hour - 12) * 30
                : (now.value.hour * 30)) +
            (now.value.minute * 30 / 60) +
            1)
        .toInt()
        .toDouble());
    // angle(360);
    var hour =
        int.tryParse(appSettings.previousLoginTime.split(':').first) ?? 0;
    var min = int.tryParse(appSettings.previousLoginTime.split(':').last) ?? 0;
    // print(hour);
    var differenceInHours = now.value.hour - (hour);
    earning((elapsedTime.value.inSeconds *
        double.parse((details.body['data']['per_minute_salary'].toString())) /
        60));

    if (true) {
      var value = 0.0;
      if (dailyEarning.value > 0) {
      } else {}
      var values = (value.toPrecision(4));
      var decimal = (values.toString().split('.').last);

      d1.value = int.parse(decimal.split('').last);
      d2.value = int.parse(decimal.split('').first);
    }
  }
}
