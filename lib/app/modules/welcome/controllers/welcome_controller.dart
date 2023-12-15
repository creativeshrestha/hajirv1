import 'package:get/get.dart';
import 'package:hajir/core/localization/l10n/strings.dart';

class WelcomeController extends GetxController {
  //TODO: Implement WelcomeController

  final count = 0.obs;
  final selectedItem = 0.obs;
  final carouselItems = [
    strings.manage_time_and_track,
    strings.login_with_candidate,
    strings.live_attendance
  ];



  void increment() => count.value++;
}
