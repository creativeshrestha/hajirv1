import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:hajir/app/config/app_colors.dart';
import 'package:hajir/app/config/app_constants.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/modules/language/views/language_view.dart';
import 'package:hajir/core/localization/l10n/strings.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 50.h,
            ),
            Hero(tag: 'logo', child: const HajirLogo()),
            SizedBox(
              height: 50.h,
            ),
            SizedBox(
              height: 236,
              width: double.infinity,
              child: CarouselSlider(
                  items: List.generate(
                      controller.isEmployer.value
                          ? controller.employerItems.length
                          : controller.candidateItems.length,
                      (index) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                controller.candidateItems[index].icon,
                                height: 160.r,
                                width: 160.r,
                              ),
                              RPadding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0),
                                child: Text(
                                  controller.isEmployer.value
                                      ? controller.employerItems[index].label
                                      : controller.candidateItems[index].label,
                                  style: AppTextStyles.medium.copyWith(
                                      fontSize: 14.spMin,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          )),
                  options: CarouselOptions(
                      pageSnapping: true,
                      onPageChanged: (index, reason) =>
                          controller.selectedItem = index,
                      aspectRatio: 1,
                      viewportFraction: 1,
                      autoPlay: true)),
            ),
            SizedBox(
              height: 12.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  controller.candidateItems.length,
                  (index) => Obx(
                        () => AnimatedContainer(
                          duration: 300.milliseconds,
                          height: 12.r,
                          width: 12.r,
                          decoration: BoxDecoration(
                              color: controller.selectedItem == index
                                  ? AppColors.primary
                                  : Colors.grey.shade200,
                              shape: BoxShape.circle),
                          margin: const EdgeInsets.only(right: 8),
                        ),
                      )),
            ),
            SizedBox(
              height: 40.h,
            ),
            Form(
              key: formKey,
              child: TextFormField(
                controller: controller.phone,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (!GetUtils.isPhoneNumber(v!)) {
                    return 'Enter a valid phone';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: REdgeInsets.all(8.0),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            SvgPicture.asset(
                              "assets/twemoji_flag-nepal.svg",
                              height: 22.r,
                              width: 22.r,
                            ),
                            Text(
                              strings.country_code,
                              style: AppTextStyles.l1,
                            ),
                          ]),
                        ),
                        Container(
                          height: 40.r,
                          color: Colors.grey.shade300,
                          width: 1.r,
                        ),
                        const SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                    hintText: strings.mobile_number,
                    hintStyle: AppTextStyles.l1,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300)),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            CustomButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    controller.registerPhone();
                  }
                },
                label: strings.get_otp),
            const SizedBox(
              height: 20,
            ),
            Text(
              strings.will_send_otp,
              style: AppTextStyles.l2,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 5.h,
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: strings.read_and_agree,
                style: AppTextStyles.l2
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
              ),
              TextSpan(
                  text: strings.terms_and_services, style: AppTextStyles.l2)
            ])),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    ));
  }
}

class HajirLogo extends StatelessWidget {
  const HajirLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.logo,
      height: 36.h,
      width: 106.w,
    );
  }
}
