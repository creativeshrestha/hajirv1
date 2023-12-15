import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hajir/app/config/app_colors.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hajir/app/data/services/firebase.dart';
import 'package:hajir/app/initial_bindings.dart';
import 'package:hajir/app/modules/dashboard/views/apply_leave.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/reports.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/data/providers/network/response_handler.dart';
import 'app/routes/app_pages.dart';
 
void main() async {
  await appInit();
  runApp(
    GetMaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.primary,
      ),
      title: "Hajir",
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: AppSettings(Get.find()).getLocale(),
      supportedLocales: const [Locale("en", "US"), Locale('ne', "NE")],
      initialRoute: appSettings.selectedlanguage == ''
          ? AppPages.INITIAL
          : appSettings.token == ''
              ? Routes.WELCOME
              : appSettings.type == 'employer' //appSettings.employer
                  ? Routes.EMPLOYER_DASHBOARD
                  : Routes.DASHBOARD,
      initialBinding: InitialBindings(),
      getPages: AppPages.routes,
    ),
  );
}

appInit() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Get.putAsync((() => SharedPreferences.getInstance()));
  Get.lazyPut<AppSettings>(() => AppSettings(Get.find()), fenix: true);
  // appSettings.logout();
  Get.lazyPut(() => ApiResponseHandler(), fenix: true);
  Get.find<ApiResponseHandler>();
  Get.lazyPut(() => AttendanceSystemProvider(), fenix: true);
  Get.lazyPut(() => ApplyLeaveProvider(), fenix: true);
  Get.lazyPut(() => ResultProvider(), fenix: true);
  // Get.lazyPut(() => PusherService());

  if (Platform.isAndroid) {
    final firebaseService = FirebaseService();
    await firebaseService.init();
    Get.put<FirebaseService>(firebaseService, permanent: true);
    final pushNotification = PushNotificationManager();
    await pushNotification.initialise();
    Get.put<PushNotification>(pushNotification);
  }
  // await ScreenUtil.ensureScreenSize();
}

// PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

// class PusherService {
//   static init() async {
//     // Platform messages are asynchronous, so we initialize in an async method.
//   }
// }
