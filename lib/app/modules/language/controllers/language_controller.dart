import 'package:get/get.dart';
import 'package:hajir/app/routes/app_pages.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';

class LanguageController extends GetxController {
  final AppSettings appSettings = Get.find();
  var loading = false.obs;
  final count = 0.obs;
  @override
  void onInit() {
    loading(true);
    super.onInit();
    loading(false);
    appSettings.token == '' ? null : Get.toNamed(Routes.HOME);
  }

  void increment() => count.value++;
}
