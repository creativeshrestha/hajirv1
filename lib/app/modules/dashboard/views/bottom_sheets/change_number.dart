import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/modules/add_employee/views/add_employee_view.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/profile.dart';
import 'package:hajir/app/modules/employer_dashboard/controllers/employer_dashboard_controller.dart';
import 'package:hajir/app/modules/language/views/language_view.dart';
import 'package:hajir/app/modules/login/controllers/login_controller.dart';
import 'package:hajir/app/routes/app_pages.dart';
import 'package:hajir/app/utils/validators.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';
import 'package:hajir/core/localization/l10n/strings.dart';

class ChangeNumber extends StatelessWidget {
  const ChangeNumber({super.key});

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();

    final TextEditingController phone = TextEditingController();
    final cPhone = TextEditingController();
    if (appSettings.employer) {
      final controller = Get.find<EmployerDashboardController>();
      final currentPhone = TextEditingController()
        ..text = controller.user.value.phone ?? "";
      return AppBottomSheet(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TitleWidget(title: strings.settings),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: formkey,
              child: Column(
                children: [
                  CustomFormField(
                    controller: currentPhone,
                    hint: strings.current_number,
                    title: strings.change_number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomFormField(
                    controller: phone,
                    validator: validatePhone,
                    hint: strings.changed_number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomFormField(
                    validator: (v) => confirmPassword(
                        password: phone.text,
                        cPassword: v,
                        value: 'Phone does not match.'),
                    hint: strings.confirm_changed_number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          try {
                            final apiRepository =
                                Get.find<AttendanceSystemProvider>();
                            showLoading();
                            var result = await apiRepository
                                .changeEmployerPhone({
                              'old_phone': currentPhone.text,
                              'new_phone': phone.text
                            });
                            Get.back();
                            appSettings.phone = phone.text;
                            controller.user.value.phone = phone.text;
                            Get.back();
                            Get.back();
                            Get.rawSnackbar(message: result.message.toString());
                          } catch (e) {
                            Get.back();
                            handleException(e);
                          }
                        }
                      },
                      label: strings.update),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      );
    } else {
      final controller = Get.find<DashboardController>();
      final currentPhone = TextEditingController()
        ..text = controller.user.value.phone ?? "";
      return AppBottomSheet(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TitleWidget(title: strings.settings),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    CustomFormField(
                      controller: currentPhone,
                      hint: strings.current_number,
                      title: strings.change_number,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomFormField(
                      controller: phone,
                      validator: validatePhone,
                      hint: strings.changed_number,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomFormField(
                      validator: (v) => confirmPassword(
                          password: phone.text,
                          cPassword: v,
                          value: 'Phone does not match.'),
                      hint: strings.confirm_changed_number,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                        onPressed: () async {
                          if (formkey.currentState!.validate()) {
                            try {
                              final apiRepository =
                                  Get.find<AttendanceSystemProvider>();
                              var result = await apiRepository
                                  .changePhoneNumber({
                                'old_phone': currentPhone.text,
                                'new_phone': phone.text
                              });
                              controller.user.value.phone = phone.text;
                              Get.back();
                              Get.back();
                              Get.toNamed(Routes.MOBILE_OPT, arguments: [
                                appSettings.employer,
                                phone.text
                              ]);
                              Get.rawSnackbar(
                                  message: result.message.toString());
                            } catch (e) {
                              Get.rawSnackbar(message: e.toString());
                            }
                          }
                        },
                        label: strings.update),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}
