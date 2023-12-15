import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/change_number.dart';
import 'package:hajir/app/modules/dashboard/views/my_account.dart';
import 'package:hajir/app/modules/employer_dashboard/controllers/employer_dashboard_controller.dart';
import 'package:hajir/app/modules/language/views/language_view.dart';
import 'package:hajir/app/utils/shrimmerloading.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';
import 'package:hajir/core/localization/l10n/strings.dart';
import 'package:image_picker/image_picker.dart';

var dob = '';

class Profile extends StatefulWidget {
  final profileData;
  // final Function() onSuccess;
  const Profile({
    super.key,
    required this.profileData,
    // required this.onSuccess
  }); //required this.onSuccess

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController fname;
  TextEditingController lname = TextEditingController();
  late TextEditingController email;
  late TextEditingController mobile;
  final image = TextEditingController();
  var profileData;
  getProfile({bool employer = false}) async {
    final AttendanceSystemProvider attendanceApi = Get.find();
    var response = await attendanceApi.getProfile();
    if (response.body != null) {
      profileData = response.body;

      setState(() {});
    }
  }

  @override
  void initState() {
    profileData = widget.profileData;
    super.initState();

    // getProfile();
  }

  @override
  Widget build(BuildContext context) {
    profileData = widget.profileData;
    final formKey = GlobalKey<FormState>();

    if (appSettings.employer) {
      EmployerDashboardController employerDashboardController;
      employerDashboardController = Get.find();
      fname = TextEditingController()
        ..text = widget.profileData['data']['name'] ??
            employerDashboardController.user.value.name ??
            '';
      dob = widget.profileData['data']['dob'];
      employerDashboardController.dob = dob;
      email = TextEditingController()
        ..text = employerDashboardController.user.value.email ?? '';
      mobile = TextEditingController(
          text: employerDashboardController.user.value.phone ?? "");
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 16),
          child: AppBottomSheet(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TitleWidget(title: strings.profile),
                  const SizedBox(
                    height: 10,
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: image.text.isEmpty
                          ? profileData != null
                              ? CachedNetworkImage(
                                  imageUrl: profileData['data']
                                      ['profile_image'],
                                  height: 118,
                                  width: 118,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder: (_, i, download) =>
                                      Center(
                                    child: CircularProgressIndicator(
                                      value: download.progress,
                                    ),
                                  ),
                                  errorWidget: (_, __, ___) =>ImagePlaceholder()?? Image.asset(
                                    "assets/Avatar Profile.png",
                                    height: 50,
                                    width: 50,
                                  ),
                                )
                              :ImagePlaceholder()?? Image.asset(
                                  "assets/Avatar Profile.png",
                                  height: 118,
                                  width: 118,
                                  fit: BoxFit.cover,
                                )
                          : Image.file(
                              File(image.text),
                              height: 118,
                              width: 118,
                              fit: BoxFit.cover,
                            )),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    strings.change,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: fname,
                          decoration: InputDecoration(
                              // labelText: strings.firstname,
                              hintText: strings.firstname,
                              hintStyle: AppTextStyles.l1,
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300)),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: email,
                          validator: (v) {
                            if (GetUtils.isEmail(v!)) {
                              return null;
                            } else if (v.isEmpty) {
                              return '* Email required';
                            } else {
                              return 'Enter a valid email.';
                            }
                          },
                          decoration: InputDecoration(
                              hintText: 'E-mail',
                              hintStyle: AppTextStyles.l1,
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300)),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            // Get.bottomSheet(const ChangeNumber(),
                            //     isScrollControlled: true);
                          },
                          child: TextFormField(
                            enabled: false,
                            controller: mobile,
                            decoration: InputDecoration(
                                hintText: strings.mobile_number,
                                hintStyle: AppTextStyles.l1,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400)),
                                disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300)),
                                border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey))),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            try {
                              var date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now());

                              if (appSettings.employer) {
                                employerDashboardController.dob = '';
                                if (date == null) {
                                } else {
                                  employerDashboardController.dob =
                                      date.toString().substring(0, 10);
                                  dob = employerDashboardController.dob;
                                }
                              } else {}
                            } catch (e) {
                              employerDashboardController.dob = '';
                            }
                          },
                          child: Obx(() => TextFormField(
                                controller: TextEditingController()
                                  ..text = employerDashboardController.dob,
                                enabled: false,
                                decoration: InputDecoration(
                                    hintText: strings.dob,
                                    hintStyle: AppTextStyles.l1,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade400)),
                                    disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300)),
                                    border: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey))),
                              )),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        CustomButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                if (employerDashboardController.dob.isEmpty) {
                                  Get.rawSnackbar(
                                      message: 'Date of birth requried.');
                                } else {
                                  if (appSettings.employer) {
                                    employerDashboardController.updateProfile(
                                      fname.text,
                                      email.text,
                                      mobile.text,
                                    );
                                  } else {}
                                }
                              }
                            },
                            label: strings.update),
                        const SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      DashboardController dashboardController = Get.find();

      dashboardController.dob =
          profileData != null ? profileData['data']['dob'] ?? "" : '';
      fname = TextEditingController()
        ..text = profileData != null
            ? profileData['data']['firstname'] ??
                dashboardController.user.value.name ??
                ''
            : "";
      lname = TextEditingController()
        ..text = profileData != null
            ? profileData['data']['lastname'] ??
                dashboardController.user.value.name ??
                ''
            : "";
      email = TextEditingController()
        ..text = dashboardController.user.value.email ?? '';
      mobile =
          TextEditingController(text: dashboardController.user.value.phone);
      return SafeArea(
        child: AppBottomSheet(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TitleWidget(title: strings.profile),
                const SizedBox(
                  height: 10,
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: image.text.isEmpty
                        ? profileData != null
                            ? CachedNetworkImage(
                                imageUrl:
                                    profileData['data']['profile_image'] ?? "",
                                height: 118,
                                width: 118,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) =>ImagePlaceholder()?? Image.asset(
                                  "assets/Avatar Profile.png",
                                  height: 50,
                                  width: 50,
                                ),
                              )
                            : const ShrimmerLoading()
                        : Image.file(
                            File(image.text),
                            height: 118,
                            width: 118,
                            fit: BoxFit.cover,
                          )),
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () async {
                    var file = await ImagePicker().pickImage(
                        source: ImageSource.gallery, imageQuality: 6);
                    if (file != null) {
                      image.text = file.path!;
                      setState(() {});
                    }
                  },
                  child: Text(
                    strings.change,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: fname,
                        decoration: InputDecoration(
                            // labelText: strings.firstname,
                            hintText: strings.firstname,
                            hintStyle: AppTextStyles.l1,
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300)),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: lname,
                        decoration: InputDecoration(
                            // labelText: strings.lastname,
                            hintText: strings.lastname,
                            hintStyle: AppTextStyles.l1,
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300)),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: email,
                        validator: (v) {
                          if (GetUtils.isEmail(v!)) {
                            return null;
                          } else if (v.isEmpty) {
                            return '* Email required';
                          } else {
                            return 'Enter a valid email.';
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'E-mail',
                            hintStyle: AppTextStyles.l1,
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300)),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Get.bottomSheet(const ChangeNumber(),
                              isScrollControlled: true);
                        },
                        child: TextFormField(
                          enabled: false,
                          controller: mobile,
                          decoration: InputDecoration(
                              hintText: strings.mobile_number,
                              hintStyle: AppTextStyles.l1,
                              disabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300)),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey))),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          try {
                            var date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now());

                            if (date == null) {
                              dashboardController.dob = '';
                            } else {
                              dashboardController.dob =
                                  date.toString().substring(0, 10);
                            }
                          } catch (e) {
                            dashboardController.dob = '';
                          }
                        },
                        child: Obx(() => TextFormField(
                              controller: TextEditingController()
                                ..text = dashboardController.dob,
                              enabled: false,
                              decoration: InputDecoration(
                                  hintText: strings.dob,
                                  hintStyle: AppTextStyles.l1,
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300)),
                                  border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey))),
                            )),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (dashboardController.dob.isEmpty) {
                                Get.rawSnackbar(
                                    message: 'Date of birth requried.');
                              } else {
                                if (appSettings.employer) {
                                } else {
                                  await dashboardController.updateProfile(
                                      fname.text,
                                      lname.text,
                                      email.text,
                                      mobile.text,
                                      image.text);
                                }
                              }
                            }
                          },
                          label: strings.update),
                      const SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                Get.back(result: false);
              },
              child: Icon(Icons.close)),
          // const Flexible(child: CloseButton()),
          const Spacer(),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            width: 24.w,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: REdgeInsets.only(top: 40),
        padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: child,
      ),
    );
  }
}
