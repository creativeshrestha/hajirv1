import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:hajir/app/config/app_colors.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/modules/company_detail/controllers/company_detail_controller.dart';
import 'package:hajir/app/modules/language/views/language_view.dart';
import 'package:hajir/app/utils/shrimmerloading.dart';
import 'package:hajir/app/utils/validators.dart';
import 'package:hajir/core/localization/l10n/strings.dart';
import '../controllers/add_employee_controller.dart';

class AddEmployeeView extends GetView<AddEmployeeController> {
  const AddEmployeeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final CompanyDetailController companyDetailController = Get.find();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
        body: SafeArea(
            child: Obx(
      () => controller.loading.isTrue
          ? const Center(child: ShrimmerLoading())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        elevation: 0,
                        // leadingWidth: 10,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        iconTheme: const IconThemeData(color: Colors.black),
                        title: Text(
                          "${controller.isEdit.isTrue ? "Update" : "Add"} candidate",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 24.sp,
                              color: Colors.black),
                        ),
                        centerTitle: true,
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      // BackButton(),

                      // Text(
                      //   "${controller.isEdit.isTrue ? "Update" : "Add"} candidate",
                      //   style: Theme.of(context).textTheme.headline6!.copyWith(
                      //       fontSize: 28, fontWeight: FontWeight.w600),
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      if (companyDetailController.company.value.generateCode ??
                          false)
                        InputWithLabel(
                          controller: controller,
                        )
                      else
                        InputWithLabel(controller: controller, enabled: true),
                      const SizedBox(
                        height: 20,
                      ),

                      Text(
                        "Candidate details",
                        style: AppTextStyles.l1.copyWith(
                            color: AppColors.primary,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: controller.name,
                        validator: validateIsEmpty,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            hintText: strings.full_name,
                            hintStyle: AppTextStyles.l1
                                .copyWith(fontWeight: FontWeight.w500),
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
                        controller: controller.phone,
                        validator: (v) =>
                            GetUtils.isPhoneNumber(v!) ? null : 'Invalid Phone',
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () async {
                                final PhoneContact contact =
                                    await FlutterContactPicker
                                        .pickPhoneContact();
                                controller.phone.text = contact
                                    .phoneNumber!.number!
                                    .replaceAll('+977', "")
                                    .replaceAll(' ', '')
                                    .replaceAll('-', '');
                              },
                              child: Icon(
                                Icons.person,
                                color: AppColors.primary,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            hintText: strings.mobile_number,
                            hintStyle: AppTextStyles.l1
                                .copyWith(fontWeight: FontWeight.w500),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300)),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                      ),

                      Obx(() => Text(
                            controller.contactError.value,
                            style: const TextStyle(color: Colors.red),
                          )),

                      const SizedBox(
                        height: 20,
                      ),
                      // const Text("[Add from contact address]"),
                      // const SizedBox(
                      //   height: 8,
                      // ),
                      if (controller.isEdit.isFalse)
                        TextFormField(
                          enabled: true,
                          controller: controller.cphone,
                          autovalidateMode: AutovalidateMode.always,
                          keyboardType: TextInputType.number,
                          validator: (v) => confirmPassword(
                              password: v!,
                              cPassword: controller.phone.text,
                              value: "Phone does not match."),
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              hintText: "Confirm Phone",
                              hintStyle: AppTextStyles.l1
                                  .copyWith(fontWeight: FontWeight.w500),
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
                        controller: controller.designation,
                        // validator: validateIsEmpty,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            hintText: strings.designation,
                            hintStyle: AppTextStyles.l1
                                .copyWith(fontWeight: FontWeight.w500),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300)),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      CustomFormField(
                        hint: 'Email',
                        // validator: validateEmail,
                        // controller: controller.email,
                        // title: 'Email',
                      ),
                      Obx(() => Text(
                            controller.emailError.value,
                            style: const TextStyle(color: Colors.red),
                          )),
                      SizedBox(
                        height: 20.h,
                      ),
                      // SizedBox(
                      //   height: 10.h,
                      // ),
                      // Text(
                      //   strings.dob,
                      //   style:
                      //       AppTextStyles.l1.copyWith(color: AppColors.primary),
                      // ),
                      // const SizedBox(
                      //   height: 14,
                      // ),
                      InkWell(
                        onTap: () async {
                          var lastDate =
                              DateTime.now().subtract(Duration(days: 365 * 16));
                          var date = await showDatePicker(
                              context: context,
                              initialDate: lastDate,
                              firstDate: DateTime(1900),
                              lastDate: lastDate);
                          if (date != null) {
                            controller.dob.value =
                                date.toString().substring(0, 10);
                          }
                        },
                        child: Obx(
                          () => TextFormField(
                            controller: TextEditingController(
                                text: controller.dob.value),
                            enabled: false,
                            decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  color: AppColors.primary,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                hintText: "Date of birth",
                                hintStyle: AppTextStyles.l1,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300))),
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Text(
                      //   strings.office_hours,
                      //   style: AppTextStyles.l1.copyWith(color: AppColors.primary),
                      // ),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      // Container(
                      //   width: 191,
                      //   height: 46,
                      //   decoration: BoxDecoration(
                      //       border: Border.all(color: Colors.grey.shade300),
                      //       borderRadius: BorderRadius.circular(4)),
                      //   child: Row(children: [
                      //     Container(
                      //       height: 46,
                      //       width: 56,
                      //       decoration: BoxDecoration(
                      //         color: Colors.grey.withOpacity(.1),
                      //       ),
                      //       child: Icon(
                      //         Icons.remove,
                      //         color: AppColors.primary,
                      //       ),
                      //     ),
                      //     Container(
                      //       height: 46,
                      //       width: 1,
                      //       color: Colors.grey.shade300,
                      //     ),
                      //     Expanded(
                      //         child: Center(
                      //             child: Text(
                      //       "8:00",
                      //       style: AppTextStyles.l1.copyWith(color: Colors.black),
                      //     ))),
                      //     Container(
                      //       height: 56,
                      //       width: 1,
                      //       color: Colors.grey.shade300,
                      //     ),
                      //     Container(
                      //       height: 56,
                      //       width: 56,
                      //       decoration: BoxDecoration(
                      //         color: Colors.grey.withOpacity(.1),
                      //       ),
                      //       child: Icon(
                      //         Icons.add,
                      //         color: AppColors.primary,
                      //       ),
                      //     ),
                      //   ]),
                      // ),
                      SizedBox(
                        height: 20.h,
                      ),

                      Text(
                        "Office hours",
                        style: AppTextStyles.l1.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600),
                      ),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      // SizedBox(
                      //     // width: 191,
                      //     height: 56,
                      //     child: Row(
                      //       children: [
                      //         Expanded(
                      //           child: InkWell(
                      //             onTap: () async {
                      //               var time = await showTimePicker(
                      //                   context: context,
                      //                   initialTime: TimeOfDay.now());
                      //               if (time != null) {
                      //                 controller.officeHourStart(
                      //                     "${time.hour < 10 ? '0${time.hour}' : time.hour}:${time.minute < 10 ? '0${time.minute}' : time.minute}");
                      //               }
                      //             },
                      //             child: Obx(
                      //               () => TextFormField(
                      //                 enabled: false,
                      //                 controller: TextEditingController()
                      //                   ..text =
                      //                       controller.officeHourStart.value,
                      //                 decoration: const InputDecoration(
                      //                     hintText: 'Start time'),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         const SizedBox(width: 10),
                      //         Expanded(
                      //           child: InkWell(
                      //             onTap: () async {
                      //               var time = await showTimePicker(
                      //                   context: context,
                      //                   initialTime: TimeOfDay.now());
                      //               if (time != null) {
                      //                 controller.officeHourStart(
                      //                     "${time.hour < 10 ? '0${time.hour}' : time.hour}:${time.minute < 10 ? '0${time.minute}' : time.minute}");
                      //               }
                      //             },
                      //             child: Obx(
                      //               () => TextFormField(
                      //                 enabled: false,
                      //                 controller: TextEditingController()
                      //                   ..text = controller.officeHourEnd.value,
                      //                 decoration: const InputDecoration(
                      //                     hintText: 'End time'),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     )
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.grey.shade300),
                      //     borderRadius: BorderRadius.circular(4)),
                      // child: Row(children: [
                      //   Container(
                      //     height: 56,
                      //     width: 56,
                      //     decoration: BoxDecoration(
                      //       color: Colors.grey.withOpacity(.1),
                      //     ),
                      //     child: Icon(
                      //       Icons.remove,
                      //       color: AppColors.primary,
                      //     ),
                      //   ),
                      //   Container(
                      //     height: 56,
                      //     width: 1,
                      //     color: Colors.grey.shade300,
                      //   ),
                      //   Expanded(
                      //       child: Center(
                      //           child: Text(
                      //     "8:00",
                      //     style: AppTextStyles.l1.copyWith(color: Colors.black),
                      //   ))),
                      //   Container(
                      //     height: 56,
                      //     width: 1,
                      //     color: Colors.grey.shade300,
                      //   ),
                      //   Container(
                      //     height: 56,
                      //     width: 56,
                      //     decoration: BoxDecoration(
                      //       color: Colors.grey.withOpacity(.1),
                      //     ),
                      //     child: Icon(
                      //       Icons.add,
                      //       color: AppColors.primary,
                      //     ),
                      //   ),
                      // ]),
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 191,
                        height: 46,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(children: [
                          InkWell(
                            onTap: () {
                              var time =
                                  controller.officehours.value.split(':');
                              var hour = int.parse(time.first);
                              var minute = int.parse(time.last);

                              if ((minute) < 60 && minute != 0) {
                                controller.officehours(
                                    "${(hour) < 10 ? '0$hour' : hour}:${(minute - 10)}");
                              } else if ((hour) <= 12 && hour != 0) {
                                controller.officehours(
                                    "${(hour - 1) < 10 ? '0${hour - 1}' : hour - 1}:00");
                              } else {}
                            },
                            child: Container(
                              height: 46,
                              width: 56,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.1),
                              ),
                              child: Icon(
                                Icons.remove,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          Container(
                            height: 46,
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          Expanded(
                              child: Center(
                                  child: Obx(
                            () => Text(
                              controller.officehours.value,
                              style: AppTextStyles.l1
                                  .copyWith(color: Colors.black),
                            ),
                          ))),
                          Container(
                            height: 56,
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          InkWell(
                            onTap: () {
                              var time =
                                  controller.officehours.value.split(':');
                              var hour = int.parse(time.first);
                              var minute = int.parse(time.last);

                              if ((minute) < 60) {
                                controller.officehours(
                                    "${(hour) < 10 ? '0$hour' : hour}:${minute + 10}");
                              } else if ((hour) < 12) {
                                controller.officehours(
                                    "${(hour + 1) < 10 ? '0${hour + 1}' : hour + 1}:00");
                              } else {}
                            },
                            child: Container(
                              height: 56,
                              width: 56,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.1),
                              ),
                              child: Icon(
                                Icons.add,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ]),
                      ),
                      // const SizedBox(
                      //   height: 20,
                      // ),

                      // Text(
                      //   "Break hours",
                      //   style:
                      //       AppTextStyles.l1.copyWith(color: AppColors.primary),
                      // ),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      // Text(
                      //   "Office hours",
                      //   style: AppTextStyles.l1.copyWith(color: AppColors.primary),
                      // ),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      // SizedBox(
                      //     // width: 191,
                      //     height: 56,
                      //     child: Row(
                      //       children: [
                      //         Expanded(
                      //           child: InkWell(
                      //             onTap: () async {
                      //               var time = await showTimePicker(
                      //                   context: context,
                      //                   initialTime: TimeOfDay.now());
                      //               if (time != null) {
                      //                 controller.breakStart(
                      //                     "${time.hour < 10 ? '0${time.hour}' : time.hour}:${time.minute < 10 ? '0${time.minute}' : time.minute}");
                      //               }
                      //             },
                      //             child: Obx(
                      //               () => TextFormField(
                      //                 enabled: false,
                      //                 controller: TextEditingController()
                      //                   ..text = controller.breakStart.value,
                      //                 decoration: const InputDecoration(
                      //                     hintText: 'Break start'),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         const SizedBox(width: 10),
                      //         Expanded(
                      //           child: InkWell(
                      //             onTap: () async {
                      //               var time = await showTimePicker(
                      //                   context: context,
                      //                   initialTime: TimeOfDay.now());
                      //               if (time != null) {
                      //                 controller.breakEnd(
                      //                     "${time.hour < 10 ? '0${time.hour}' : time.hour}:${time.minute < 10 ? '0${time.minute}' : time.minute}");
                      //               }
                      //             },
                      //             child: Obx(
                      //               () => TextFormField(
                      //                 enabled: false,
                      //                 controller: TextEditingController()
                      //                   ..text = controller.breakEnd.value,
                      //                 decoration: const InputDecoration(
                      //                     hintText: 'Break end'),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     )
                      //     // decoration: BoxDecoration(
                      //     //     border: Border.all(color: Colors.grey.shade300),
                      //     //     borderRadius: BorderRadius.circular(4)),
                      //     // child: Row(children: [
                      //     //   Container(
                      //     //     height: 56,
                      //     //     width: 56,
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.grey.withOpacity(.1),
                      //     //     ),
                      //     //     child: Icon(
                      //     //       Icons.remove,
                      //     //       color: AppColors.primary,
                      //     //     ),
                      //     //   ),
                      //     //   Container(
                      //     //     height: 56,
                      //     //     width: 1,
                      //     //     color: Colors.grey.shade300,
                      //     //   ),
                      //     //   Expanded(
                      //     //       child: Center(
                      //     //           child: Text(
                      //     //     "8:00",
                      //     //     style: AppTextStyles.l1.copyWith(color: Colors.black),
                      //     //   ))),
                      //     //   Container(
                      //     //     height: 56,
                      //     //     width: 1,
                      //     //     color: Colors.grey.shade300,
                      //     //   ),
                      //     //   Container(
                      //     //     height: 56,
                      //     //     width: 56,
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.grey.withOpacity(.1),
                      //     //     ),
                      //     //     child: Icon(
                      //     //       Icons.add,
                      //     //       color: AppColors.primary,
                      //     //     ),
                      //     //   ),
                      //     // ]),
                      //     ),

                      // Container(
                      //   width: 191,
                      //   height: 46,
                      //   decoration: BoxDecoration(
                      //       border: Border.all(color: Colors.grey.shade300),
                      //       borderRadius: BorderRadius.circular(4)),
                      //   child: Row(children: [
                      //     Container(
                      //       height: 46,
                      //       width: 56,
                      //       decoration: BoxDecoration(
                      //         color: Colors.grey.withOpacity(.1),
                      //       ),
                      //       child: Icon(
                      //         Icons.remove,
                      //         color: AppColors.primary,
                      //       ),
                      //     ),
                      //     Container(
                      //       height: 46,
                      //       width: 1,
                      //       color: Colors.grey.shade300,
                      //     ),
                      //     Expanded(
                      //         child: Center(
                      //             child: Text(
                      //       "8:00",
                      //       style: AppTextStyles.l1.copyWith(color: Colors.black),
                      //     ))),
                      //     Container(
                      //       height: 56,
                      //       width: 1,
                      //       color: Colors.grey.shade300,
                      //     ),
                      //     Container(
                      //       height: 56,
                      //       width: 56,
                      //       decoration: BoxDecoration(
                      //         color: Colors.grey.withOpacity(.1),
                      //       ),
                      //       child: Icon(
                      //         Icons.add,
                      //         color: AppColors.primary,
                      //       ),
                      //     ),
                      //   ]),
                      // ),

                      SizedBox(
                        height: 20.h,
                      ),
                      CustomDropDownField(
                        value: controller.salaryType.text,
                        onChanged: (String? v) {
                          controller.salaryType.text = v!;
                        },
                        title: "Salary Type",
                        hint: "eg.2500",
                        items: const ['monthly', 'weekly', 'daily'],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomFormField(
                          num: true,
                          controller: controller.salaryAmount,
                          validator: validateIsEmpty,
                          title: "Salary Amount",
                          hint: "eg.2500"),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        "Joining Date",
                        style: AppTextStyles.l1.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      InkWell(
                        onTap: () async {
                          var date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(3000));
                          if (date != null) {
                            controller.joiningDate.value =
                                date.toString().substring(0, 10);
                          }
                        },
                        child: Obx(
                          () => TextFormField(
                            // initialValue: controller.joiningDate.value,
                            controller: TextEditingController()
                              ..text = controller.joiningDate.value,
                            // validator: validateIsEmpty,
                            enabled: false,
                            decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  color: AppColors.primary,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                hintText: "Please select",
                                hintStyle: AppTextStyles.l1,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300)),
                                border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey))),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Text("Duty Time"),
                          const Spacer(),
                          Container(
                            width: 191,
                            height: 46,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(4)),
                            child: Row(children: [
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: controller.dutyTime,
                                  validator: validateIsEmpty,
                                  inputFormatters: <TextInputFormatter>[
                                    HourMinsFormatter()
                                    // TimeTextInputFormatter() // This input formatter will do the job
                                  ],
                                  decoration: const InputDecoration(
                                      hintText: 'e.g. 08:00 AM',
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      border: InputBorder.none),
                                ),
                              ),
                              Container(
                                height: 46,
                                width: 1,
                                color: Colors.grey.shade300,
                              ),
                              // Container(
                              //   height: 56,
                              //   width: 56,
                              //   alignment: Alignment.center,
                              //   decoration: BoxDecoration(
                              //     color: Colors.grey.withOpacity(.1),
                              //   ),
                              //   child: const Text("AM"),
                              // ),
                            ]),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Overtime [Ratio]",
                        style: AppTextStyles.l1.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          // const Spacer(),
                          Obx(
                            () => Checkbox(
                                activeColor: AppColors.primary,
                                value: controller.hasOvertimerRatio.value,
                                onChanged: (bool? v) {
                                  controller.hasOvertimerRatio(v!);
                                }),
                          ),
                          Obx(
                            () => !controller.hasOvertimerRatio.value
                                ? const SizedBox()
                                : Container(
                                    width: 191,
                                    height: 46,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(4)),
                                    child: TextFormField(
                                      controller: controller.overTime,
                                      decoration: const InputDecoration(
                                          hintText: "eg.1,1.5,2",
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          border: InputBorder.none),
                                    )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Allow late attendance",
                        style: AppTextStyles.l1.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(
                              () => Checkbox(
                                  activeColor: AppColors.primary,
                                  value: controller.allowLateAttendance.value,
                                  onChanged: (bool? v) {
                                    controller.allowLateAttendance(v!);
                                  }),
                            ),
                            if (controller.allowLateAttendance.isTrue)
                              InkWell(
                                  onTap: () {
                                    var time =
                                        controller.allowlateBy.value.split(':');
                                    var hour = int.parse(time.first);
                                    var minute = int.parse(time.last);

                                    if ((minute) < 60 && minute != 0) {
                                      controller.allowlateBy(
                                          "${(hour) < 10 ? '0$hour' : hour}:${minute - 10}");
                                    } else if ((hour) <= 12 && hour != 0) {
                                      controller.allowlateBy(
                                          "${(hour - 1) < 10 ? '0${hour - 1}' : hour - 1}:00");
                                    } else {}
                                  },
                                  child: Container(
                                      width: 40.w,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4),
                                            bottomLeft: Radius.circular(4)),
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                      ),
                                      child: const Icon(Icons.remove))),
                            if (controller.allowLateAttendance.isTrue)
                              InkWell(
                                onTap: () {},
                                child: Container(
                                    width: 60.w,
                                    height: 46,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: TextFormField(
                                      enabled: false,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(9),
                                      ],
                                      onChanged: (String v) {
                                        // if (v.length <= 2) {
                                        // } else if (v.length == 4) {
                                        //   if (!v.contains(":")) {
                                        //     allowlateBy.text =
                                        //         "${v.substring(0, 2)}:${v.substring(2, 4)}";
                                        //   }
                                        //   controller.allowlateBy.value =
                                        //       allowlateBy.text;
                                        // }
                                      },
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: false),
                                      controller: TextEditingController()
                                        ..text = controller.allowlateBy.value,
                                      decoration: const InputDecoration(
                                          hintText: "00:30",
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          border: InputBorder.none),
                                    )),
                              ),
                            if (controller.allowLateAttendance.isTrue)
                              InkWell(
                                onTap: () {
                                  var time =
                                      controller.allowlateBy.value.split(':');
                                  var hour = int.parse(time.first);
                                  var minute = int.parse(time.last);

                                  if ((minute) < 60) {
                                    controller.allowlateBy(
                                        "${(hour) < 10 ? '0$hour' : hour}:${minute + 10}");
                                  } else if ((hour) < 12) {
                                    controller.allowlateBy(
                                        "${(hour + 1) < 10 ? '0${hour + 1}' : hour + 1}:00");
                                  } else {}
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(4),
                                          bottomRight: Radius.circular(4)),
                                    ),
                                    width: 40.w,
                                    height: 46,
                                    child: const Icon(Icons.add)),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        "Allowance",
                        style: AppTextStyles.l1.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                              activeColor: AppColors.primary,
                              value: controller.allowallowance.value,
                              // activeColor: AppColors.primary,
                              onChanged: (v) {
                                controller.allowallowance(v);
                              }),
                          if (controller.allowallowance.value)
                            Expanded(
                              child: CustomDropDownField(
                                  onChanged: (v) {
                                    controller.allowance(v);
                                  },
                                  value: controller.allowance.value,
                                  hint: 'Choose',
                                  items: const [
                                    'daily',
                                    'monthly',
                                    'weekly',
                                    'yearly'
                                  ]),
                            ),
                          const SizedBox(
                            width: 20,
                          ),
                          if (controller.allowallowance.value)
                            Expanded(
                                child: CustomFormField(
                              controller: controller.allowance_amount,
                              hint: '',
                            )),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        "Add casual leave",
                        style: AppTextStyles.l1.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                              activeColor: AppColors.primary,
                              value: controller.allowcasualleave.value,
                              onChanged: (v) {
                                controller.allowcasualleave(v);
                              }),
                          if (controller.allowcasualleave.value)
                            Expanded(
                              child: CustomDropDownField(
                                  onChanged: (String? v) {
                                    controller.casualleavetype(v);
                                  },
                                  value: controller.casualleavetype.value,
                                  title: '',
                                  hint: 'Choose',
                                  items: const ['monthly', 'weekly', 'yearly']),
                            ),
                          const SizedBox(
                            width: 20,
                          ),
                          if (controller.allowcasualleave.value)
                            Expanded(
                                child: CustomFormField(
                              controller: controller.casualleave,
                              hint: '',
                            )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // const Text("30 minutes laet)                                                                                         0"),
                      CustomButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (controller.loading.isFalse) {
                                controller.addCadidate();
                              }
                            }
                          },
                          label: controller.isEdit.isTrue ? "Update" : "Add"),
                      const SizedBox(
                        height: 20,
                      ),
                    ]),
              ),
            ),
    )));
  }
}

class InputWithLabel extends StatelessWidget {
  const InputWithLabel({
    Key? key,
    required this.controller,
    this.enabled = false,
  }) : super(key: key);

  final AddEmployeeController controller;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.staff_code,
          style: AppTextStyles.l1.copyWith(
              color: AppColors.primary,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          enabled: enabled,
          controller: controller.code,
          decoration: InputDecoration(
              fillColor: Colors.grey.shade200,
              filled: !enabled,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              hintText: "RT001",
              hintStyle: AppTextStyles.l1.copyWith(),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))),
        ),
      ],
    );
  }
}

class CustomDropDownField extends StatelessWidget {
  const CustomDropDownField(
      {super.key,
      this.title = '',
      this.icon,
      this.value,
      required this.hint,
      this.color,
      this.onChanged,
      required this.items});
  final Color? color;
  final String title;
  final List<String> items;
  final String hint;
  final String? value;
  final Widget? icon;
  final onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != '')
          Text(
            title,
            style: AppTextStyles.l1.copyWith(
                color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
        if (title != '')
          const SizedBox(
            height: 10,
          ),
        DropdownButtonFormField(
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
          ),
          validator: (value) => validateIsEmpty(value.toString() ?? ""),
          value: value,
          items: (items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.capitalize ?? "NA"),
                  ))
              .toList()),
          decoration: InputDecoration(
              fillColor: color,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              hintText: hint,
              hintStyle: AppTextStyles.l1.copyWith(fontWeight: FontWeight.w500),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class CustomDropDownFieldWithDict extends StatelessWidget {
  const CustomDropDownFieldWithDict(
      {super.key,
      this.title = '',
      this.icon,
      this.value,
      required this.hint,
      this.color,
      this.onChanged,
      this.values,
      required this.items});
  final Color? color;
  final String title;
  final String hint;
  final String? value;
  final Widget? icon;
  final onChanged;
  final List<String> items;
  final List? values;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != '')
          Text(
            title,
            style: AppTextStyles.l1.copyWith(
                color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
        if (title != '')
          const SizedBox(
            height: 10,
          ),
        DropdownButtonFormField(
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
          ),
          validator: (value) => validateIsEmpty(value.toString() ?? ""),
          value: value,
          items: (values
              ?.map((e) => DropdownMenuItem(
                  value: e['candidate_id'] ?? e['id'],
                  child: Text((e['name'] ?? "NA").toString())))
              .toList()),
          decoration: InputDecoration(
              fillColor: color,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              hintText: hint,
              hintStyle: AppTextStyles.l1.copyWith(fontWeight: FontWeight.w500),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class CustomFormField extends StatelessWidget {
  CustomFormField(
      {super.key,
      this.title = "",
      required this.hint,
      this.validator,
      this.isMultiline = false,
      this.num = false,
      this.onChanged,
      this.titlecolor,
      this.onTap,
      this.controller,
      this.enabled = true});
  final String title;
  final bool enabled;
  final String hint;
  final bool isMultiline;
  final controller;
  final validator;
  final Color? titlecolor;
  void Function(String)? onChanged;
  final bool num;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: title == ""
          ? InkWell(
              onTap: onTap,
              child: TextFormField(
                enabled: onTap != null ? false : enabled,
                onChanged: ((value) => onChanged),
                validator: validator,
                controller: controller,
                maxLines: isMultiline ? 5 : 1,
                keyboardType: num ? TextInputType.number : TextInputType.text,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    hintText: hint,
                    hintStyle:
                        AppTextStyles.l1.copyWith(fontWeight: FontWeight.w500),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300)),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))),
              ),
            )
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                title,
                style: AppTextStyles.l1.copyWith(
                    color: titlecolor ?? AppColors.primary,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10.h,
              ),
              TextFormField(
                enabled: enabled,
                onChanged: ((value) => onChanged),
                keyboardType: num ? TextInputType.number : TextInputType.text,
                validator: validator,
                controller: controller,
                maxLines: isMultiline ? 5 : 1,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    hintText: hint,
                    hintStyle:
                        AppTextStyles.l1.copyWith(fontWeight: FontWeight.w500),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300)),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))),
              ),
            ]),
    );
  }
}

class TimeTextInputFormatter extends TextInputFormatter {
  late RegExp _exp;
  TimeTextInputFormatter() {
    _exp = RegExp(r'^[0-9:]+$');
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_exp.hasMatch(newValue.text)) {
      TextSelection newSelection = newValue.selection;

      String value = newValue.text;
      String newText;

      String leftChunk = '';
      String rightChunk = '';

      if (value.length >= 8) {
        if (value.substring(0, 7) == '00:00:0') {
          leftChunk = '00:00:';
          rightChunk = value.substring(leftChunk.length + 1, value.length);
        } else if (value.substring(0, 6) == '00:00:') {
          leftChunk = '00:0';
          rightChunk = value.substring(6, 7) + ":" + value.substring(7);
        } else if (value.substring(0, 4) == '00:0') {
          leftChunk = '00:';
          rightChunk = value.substring(4, 5) +
              value.substring(6, 7) +
              ":" +
              value.substring(7);
        } else if (value.substring(0, 3) == '00:') {
          leftChunk = '0';
          rightChunk = value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7) +
              ":" +
              value.substring(7, 8) +
              value.substring(8);
        } else {
          leftChunk = '';
          rightChunk = value.substring(1, 2) +
              value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7) +
              ":" +
              value.substring(7);
        }
      } else if (value.length == 7) {
        if (value.substring(0, 7) == '00:00:0') {
          leftChunk = '';
          rightChunk = '';
        } else if (value.substring(0, 6) == '00:00:') {
          leftChunk = '00:00:0';
          rightChunk = value.substring(6, 7);
        } else if (value.substring(0, 1) == '0') {
          leftChunk = '00:';
          rightChunk = value.substring(1, 2) +
              value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7);
        } else {
          leftChunk = '';
          rightChunk = value.substring(1, 2) +
              value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7) +
              ":" +
              value.substring(7);
        }
      } else {
        leftChunk = '00:00:0';
        rightChunk = value;
      }

      if (oldValue.text.isNotEmpty && oldValue.text.substring(0, 1) != '0') {
        if (value.length > 7) {
          return oldValue;
        } else {
          leftChunk = '0';
          rightChunk = value.substring(0, 1) +
              ":" +
              value.substring(1, 2) +
              value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7);
        }
      }

      newText = leftChunk + rightChunk;

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(newText.length, newText.length),
        extentOffset: math.min(newText.length, newText.length),
      );

      return TextEditingValue(
        text: newText,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return oldValue;
  }
}

class HourMinsFormatter extends TextInputFormatter {
  late RegExp pattern;
  HourMinsFormatter() {
    pattern = RegExp(r'^[0-9:]+$');
  }

  String pack(String value) {
    if (value.length != 4) return value;
    return value.substring(0, 2) + ':' + value.substring(2, 4);
  }

  String unpack(String value) {
    return value.replaceAll(':', '');
  }

  String complete(String value) {
    if (value.length >= 4) return value;
    final multiplier = 4 - value.length;
    return ('0' * multiplier) + value;
  }

  String limit(String value) {
    if (value.length <= 4) return value;
    return value.substring(value.length - 4, value.length);
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!pattern.hasMatch(newValue.text)) return oldValue;

    TextSelection newSelection = newValue.selection;

    String toRender;
    String newText = newValue.text;

    toRender = '';
    if (newText.length < 5) {
      if (newText == '00:0')
        toRender = '';
      else
        toRender = pack(complete(unpack(newText)));
    } else if (newText.length == 6) {
      toRender = pack(limit(unpack(newText)));
    }

    newSelection = newValue.selection.copyWith(
      baseOffset: math.min(toRender.length, toRender.length),
      extentOffset: math.min(toRender.length, toRender.length),
    );

    return TextEditingValue(
      text: toRender,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}
