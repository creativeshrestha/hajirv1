import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:hajir/app/config/app_colors.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/modules/language/views/language_view.dart';
import 'package:hajir/app/modules/login/views/login_view.dart';
import 'package:hajir/core/localization/l10n/strings.dart';
import '../controllers/mobile_opt_controller.dart';

class MobileOptView extends GetView<MobileOptController> {
  const MobileOptView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // controller.resendCode();
    // var p1 = TextEditingController().text =
    //     controller.code.value.split(RegExp(r"[0-9]"))[0];
    // var p2 = TextEditingController().text = controller.code.value.split('')[1];
    // var p4 = TextEditingController().text = controller.code.value.split('')[2];
    // var p3 =
    //     TextEditingController().text = controller.code.value.split('').last;
    // print(controller.code.value.split('')[0]);
    // controller.onClose();
    // controller.dispose();
    // controller.onInit();
    return Scaffold(
        body: SingleChildScrollView(
      padding: REdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            height: 50.h,
          ),
          const HajirLogo(),
          SizedBox(
            height: 84.h,
          ),
          SizedBox(
            height: 170,
            width: 170,
            child: Stack(children: [
              Image.asset("assets/Group 89.png"),
              Positioned(
                top: 36,
                left: 33,
                right: 32.38,
                bottom: 36.77,
                child: SvgPicture.asset(
                  "assets/Device.svg",
                  width: 104.62,
                  height: 97.23,
                ),
              ),
              Positioned(
                  top: 99,
                  right: 11.05,
                  bottom: 36.29,
                  child: SvgPicture.asset("assets/Plant.svg")),
            ]),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            strings.otp_verification,
            style: AppTextStyles.regular.copyWith(color: AppColors.primary),
          ),
          const SizedBox(
            height: 18,
          ),
          Text(
            strings.enter_oto_sent_to,
            textAlign: TextAlign.center,
            style: AppTextStyles.medium,
          ),
          Text(
            "${strings.country_code}-${controller.args[1]}",
            textAlign: TextAlign.center,
            style: AppTextStyles.medium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 50,
          ),
          OtpTextField(
            // handleControllers: (controllers) => [p1, p2, p3, p4],
            borderWidth: 1,
            fieldWidth: 48,
            numberOfFields: 4,
            // filled: true,
            borderColor: Colors.grey.shade300,
            //set to true to show as box or false to show as dash
            showFieldAsBox: true,
            //runs when a code is typed in
            onCodeChanged: (String code) {
              //handle validation or checks here
            },
            //runs when every textfield is filled
            onSubmit: (String verificationCode) {
              if (kDebugMode) {
                print(verificationCode);
              }
              controller.code(verificationCode);
              // showDialog(
              //     context: context,
              //     builder: (context) {
              //       return AlertDialog(
              //         title: Text("Verification Code"),
              //         content: Text('Code entered is $verificationCode'),
              //       );
              //     });
            }, // end onSubmit
          ),
          const SizedBox(
            height: 44,
          ),
          CustomButton(
              onPressed: () {
                if (controller.code.isEmpty) {
                  Get.rawSnackbar(message: "Enter a valid code.");
                } else if (controller.loading.isTrue) {
                } else {
                  controller.verifyOtp();
                }
              },
              label: strings.verify),
          const SizedBox(
            height: 25,
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: strings.did_not_receive_otp, style: AppTextStyles.l2),
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Obx(
                    () => Text(
                      "  ${strings.resent_otp_in.replaceFirst("12:02", controller.elapsedTime.value.toString())}",
                      style: AppTextStyles.l2.copyWith(color: Colors.red),
                    ),
                  ))
            ]),
          ),
          const SizedBox(
            height: 94,
          ),
        ],
      ),
    ));
  }
}
