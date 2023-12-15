import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hajir/app/config/app_colors.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/modules/add_employee/views/add_employee_view.dart';
import 'package:hajir/app/modules/language/views/language_view.dart';
import 'package:hajir/app/utils/shrimmerloading.dart';
import 'package:hajir/app/utils/validators.dart';
import 'package:intl/intl.dart';

import '../controllers/create_company_controller.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CreateCompanyView extends StatefulWidget {
  const CreateCompanyView({Key? key}) : super(key: key);

  @override
  State<CreateCompanyView> createState() => _CreateCompanyViewState();
}

class _CreateCompanyViewState extends State<CreateCompanyView> {
  final CreateCompanyController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
        body: SafeArea(
      child: Obx(
        () => controller.editLoading.isFalse
            ? SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        elevation: 0,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        iconTheme: const IconThemeData(color: Colors.black),
                        title: Text(
                          controller.isEdit.isTrue
                              ? "Update Company"
                              : "Create a company",
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
                      Text(
                        "Company Name",
                        style: AppTextStyles.l1.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: controller.name,
                        validator: validateIsEmpty,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            hintText: "Eg. Rasan Technologies [KTM]",
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
                      // CustomFormField(
                      //   hint: '',
                      //   title: "Email",
                      //   validator: validateEmail,
                      //   controller: controller.email,
                      // ),
                      CustomFormField(
                        num: true,
                        hint: '',
                        title: "Phone",
                        validator: validatePhone,
                        controller: controller.phone,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomFormField(
                        hint: '',
                        title: "Address",
                        validator: validateIsEmpty,
                        controller: controller.address,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        "Staff code",
                        style: AppTextStyles.l1.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Obx(() => Row(
                            children: [
                              SelectionItem(
                                label: "Auto generated",
                                hint: "Eg. R001, R002, R003",
                                onTap: () {
                                  controller.code("auto");
                                },
                                value: "auto",
                                // isSelected: true,
                                isSelected: controller.code.value != "custom",
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              SelectionItem(
                                label: "Custom",
                                hint: "Eg. 021, 022 or 0100, 0101 ",
                                onTap: () {
                                  controller.code("custom");
                                },
                                value: "custom",
                                isSelected: controller.code.value == "custom",
                              ),
                            ],
                          )),
                      // SelectionItem(
                      // firstItem: "Auto generated",
                      // firstHint: "Eg. R001, R002, R003",
                      // secondItem: "Custom",
                      // secondHint: "Eg. 021, 022 or 0100, 0101 "),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Salary calculation day",
                        style: AppTextStyles.l1.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Obx(() => Row(
                            children: [
                              SelectionItem(
                                label: "Calendar Days",
                                hint: "eg. Jan 31 Feb 29, Mar 31",
                                onTap: () {
                                  controller.calculation_type("calendar_days");
                                },
                                value: "calendar_days",
                                // isSelected: true,
                                isSelected: controller.calculation_type.value ==
                                    "calendar_days",
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              SelectionItem(
                                label: "30 days",
                                hint: "eg. Jan 31 Feb 29, Mar 31",
                                onTap: () {
                                  controller.calculation_type("30_days");
                                },
                                value: "30_days",
                                isSelected: controller.calculation_type.value ==
                                    "30_days",
                              ),
                            ],
                          )),
                      // SelectionItem(
                      //     firstItem: "Calendar Days",
                      //     firstItemValue: "auto",
                      //     secondItemValue: "calendar_days",
                      //     selectedValue: controller.calculation_type.value,
                      //     firstHint: "eg. Jan 31 Feb 29, Mar 31",
                      //     secondItem: "30 days",
                      //     secondHint: "Eg. Jan 30, Feb 30, Mar 30"),
                      // Container(
                      //   height: 56,
                      //   decoration: BoxDecoration(
                      //       border: Border.all(color: Colors.grey.shade300),
                      //       borderRadius: BorderRadius.circular(4)),
                      //   child: Row(children: [
                      //     Container(
                      //       width: 46,
                      //       height: 56,
                      //       color: Colors.grey.shade200,
                      //       child: Obx(
                      //         () => Radio(
                      //           toggleable: true,
                      //           groupValue: controller.calculation_type.value,
                      //           value: "calendar_days",
                      //           activeColor: AppColors.primary,
                      //           onChanged: (String? value) {
                      //             controller.calculation_type(value!);
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      //     Container(
                      //       height: 56,
                      //       width: 1,
                      //       color: Colors.grey.shade300,
                      //     ),
                      //     const SizedBox(
                      //       width: 8,
                      //     ),
                      //     Column(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: const [
                      //         Text(
                      //           "Calendar Days",
                      //           style: TextStyle(fontSize: 12),
                      //         ),
                      //         SizedBox(
                      //           height: 4,
                      //         ),
                      //         Text(
                      //           "Eg, Feb 28, Mar 31",
                      //           style: TextStyle(fontSize: 7, color: Colors.grey),
                      //         )
                      //       ],
                      //     )
                      //   ]),
                      // ),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      // Container(
                      //   height: 56,
                      //   decoration: BoxDecoration(
                      //       border: Border.all(color: Colors.grey.shade300),
                      //       borderRadius: BorderRadius.circular(4)),
                      //   child: Row(children: [
                      //     Container(
                      //       width: 46,
                      //       height: 56,
                      //       color: Colors.grey.shade200,
                      //       child: Obx(
                      //         () => Radio(
                      //           groupValue: controller.calculation_type.value,
                      //           value: "30_days",
                      //           activeColor: AppColors.primary,
                      //           onChanged: (String? value) {
                      //             controller.calculation_type(value!);
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      //     Container(
                      //       height: 56,
                      //       width: 1,
                      //       color: Colors.grey.shade300,
                      //     ),
                      //     const SizedBox(
                      //       width: 8,
                      //     ),
                      //     Column(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: const [
                      //         Text(
                      //           "30 days",
                      //           style: TextStyle(fontSize: 12),
                      //         ),
                      //         SizedBox(
                      //           height: 4,
                      //         ),
                      //         Text(
                      //           "Eg, Feb 30,Mar 30",
                      //           style: TextStyle(fontSize: 7, color: Colors.grey),
                      //         )
                      //       ],
                      //     )
                      //   ]),
                      // ),

                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Business Leave Days",
                        style: AppTextStyles.l1.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ...List.generate(
                          7,
                          (i) => Container(
                              height: 44,
                              margin: REdgeInsets.only(bottom: 10),
                              padding: REdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(4)),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                      DateFormat("EEEE").format(DateTime.now()
                                          .subtract(Duration(
                                              days:
                                                  DateTime.now().weekday - i))),
                                      style: AppTextStyles.normal),
                                  const Spacer(),
                                  // if (i == 0 || i == 6)
                                  // if (controller.companyWorkingDays.contains(
                                  //     DateFormat("EEEE").format(DateTime.now()
                                  //         .subtract(Duration(
                                  //             days: DateTime.now().weekday - i)))))
                                  Obx(
                                    () => SizedBox(
                                      height: 24.spMin,
                                      width: 24.spMin,
                                      child: Checkbox(
                                          activeColor: AppColors.primary,
                                          value: controller.businessLeaveDays
                                                  .contains(i + 1)
                                              ? true
                                              : false,
                                          onChanged: (bool? v) {
                                            if (v == true) {
                                              controller.businessLeaveDays
                                                  .add(i + 1);
                                            } else {
                                              controller.businessLeaveDays
                                                  .remove(i + 1);
                                            }
                                          }),
                                    ),
                                  )
                                ],
                              ))),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Add government leave days",
                        style: AppTextStyles.l1.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary),
                      ),
                      const SizedBox(
                        height: 14,
                      ),

                      InkWell(
                        onTap: () async {
                          pickDate(
                            (e) {
                              if (e != null) {
                                List<DateTime> dates = e as List<DateTime>;
                                controller.governmentLeaveDates.addAll(
                                    List.generate(
                                        dates.length,
                                        (index) => DateFormat('yyyy-MM-dd')
                                            .format(dates[index])));
                              }
                              // controller.governmentLeaveDates.addAll();
                              Get.back();
                            },
                          );
                          // var date = await showDatePicker(
                          //     context: context,
                          //     initialDate: DateTime.now(),
                          //     firstDate: DateTime(2000),
                          //     lastDate: DateTime(3000));
                          // if (date != null) {
                          //   if (!controller.governmentLeaveDates
                          //       .contains(date.toString())) {
                          //     controller.governmentLeaveDates
                          //         .add(date.toString().substring(0, 10));
                          //   }
                          // }
                        },
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                              isDense: true,
                              suffixIcon: Icon(
                                Icons.calendar_month,
                                color: AppColors.primary,
                              ),
                              // contentPadding:
                              //     const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              hintText: "Please select",
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
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Obx(
                        () => Column(
                          children: controller.governmentLeaveDates
                              .map((element) => ListTile(
                                    title: Text(element.toString()),
                                    trailing: IconButton(
                                        onPressed: () => controller
                                            .governmentLeaveDates
                                            .remove(element),
                                        icon: const Icon(Icons.close)),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Add official holiday",
                        style: AppTextStyles.l1.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      InkWell(
                        onTap: () async {
                          pickDate(
                            (e) {
                              if (e != null) {
                                List<DateTime> dates = e as List<DateTime>;
                                controller.specialLeaveDates.addAll(
                                    List.generate(
                                        dates.length,
                                        (index) => DateFormat('yyyy-MM-dd')
                                            .format(dates[index])));
                              }
                              // controller.governmentLeaveDates.addAll();
                              Get.back();
                            },
                          );
                          // var date = await showDatePicker(
                          //     context: context,
                          //     initialDate: DateTime.now(),
                          //     firstDate: DateTime(2000),
                          //     lastDate: DateTime(3000));
                          // if (date != null) {
                          //   if (!controller.specialLeaveDates
                          //       .contains(date.toString())) {
                          //     controller.specialLeaveDates
                          //         .add(date.toString().substring(0, 10));
                          //   }
                          // }
                        },
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.calendar_month,
                                color: AppColors.primary,
                              ),
                              // contentPadding:
                              //     const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              hintText: "Please select",
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
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Obx(
                        () => Column(
                          children: controller.specialLeaveDates
                              .map((element) => ListTile(
                                    title: Text(element.toString()),
                                    trailing: IconButton(
                                        onPressed: () => controller
                                            .specialLeaveDates
                                            .remove(element),
                                        icon: const Icon(Icons.close)),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Office Working hours",
                        style: AppTextStyles.l1.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                          // width: 191,
                          height: 56,
                          child: Row(
                            children: [
                              // Expanded(
                              //   child: InkWell(
                              //     onTap: () async {
                              //       var time = await showTimePicker(
                              //           context: context,
                              //           initialTime: TimeOfDay.now());
                              //       if (time != null) {
                              //         controller.officeHourStart(
                              //             "${time.hour < 10 ? '0${time.hour}' : time.hour}:${time.minute < 10 ? '0${time.minute}' : time.minute}");
                              //       }
                              //     },
                              //     child: Obx(
                              //       () => TextFormField(
                              //         enabled: false,
                              //         controller: TextEditingController()
                              //           ..text =
                              //               controller.officeHourStart.value,
                              //         decoration: InputDecoration(
                              //             focusedBorder: OutlineInputBorder(
                              //                 borderSide: BorderSide(
                              //                     color: Colors.grey.shade400)),
                              //             disabledBorder: OutlineInputBorder(
                              //                 borderSide: BorderSide(
                              //                     color: Colors.grey.shade300)),
                              //             border: const OutlineInputBorder(
                              //               borderSide:
                              //                   BorderSide(color: Colors.grey),
                              //             ),
                              //             hintText: 'Start time'),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(width: 10),
                              Container(
                                width: 191,
                                height: 46,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Row(children: [
                                  InkWell(
                                    onTap: () {
                                      var time = controller.officehours.value
                                          .split(':');
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
                                      var time = controller.officehours.value
                                          .split(':');
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

                              // Expanded(
                              //   child: InkWell(
                              //     onTap: () async {
                              //       var time = await showTimePicker(
                              //           context: context,
                              //           initialTime: TimeOfDay.now());
                              //       if (time != null) {
                              //         controller.officeHourEnd(
                              //             "${time.hour < 10 ? '0${time.hour}' : time.hour}:${time.minute < 10 ? '0${time.minute}' : time.minute}");
                              //       }
                              //     },
                              //     child: Obx(
                              //       () => TextFormField(
                              //         enabled: false,
                              //         controller: TextEditingController()
                              //           ..text = controller.officeHourEnd.value,
                              //         decoration: InputDecoration(
                              //             focusedBorder: OutlineInputBorder(
                              //                 borderSide: BorderSide(
                              //                     color: Colors.grey.shade400)),
                              //             disabledBorder: OutlineInputBorder(
                              //                 borderSide: BorderSide(
                              //                     color: Colors.grey.shade300)),
                              //             border: const OutlineInputBorder(
                              //                 borderSide: BorderSide(
                              //                     color: Colors.grey)),
                              //             hintText: 'End time'),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          )
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
                          //     style: AppTextStyles.l1.copyWith(fontWeight:FontWeight.w600,color: Colors.black),
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
                          ),

                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: CustomDropDownField(
                                icon: const Icon(
                                    Icons.keyboard_arrow_down_outlined),
                                onChanged: (String? v) {
                                  controller.sickLeaveAllowed(v!);
                                },
                                title: 'Sick leave allowed',
                                hint: 'Please select',
                                value: controller.sickLeaveAllowed.value,
                                items: const ['Weekly', 'Monthly', 'Yearly']),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: 60,
                            child: CustomFormField(
                                num: true,
                                hint: '1',
                                controller: controller.sickleavedays,
                                onChanged: (String? v) =>
                                    controller.sickLeaveDays(v!)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomDropDownField(
                          value: controller.probationPeroid.value,
                          onChanged: (String? v) {
                            controller.probationPeroid(v);
                            // controller.probationPeroid((v == '1 Month'
                            //         ? 1
                            //         : v == '3 Months'
                            //             ? 3
                            //             : 6)
                            //     .toString());
                          },
                          title: 'Probation peroid',
                          hint: 'Please select',
                          items: const ['1 Month', '3 Months', '6 Months']),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Access network",
                        style: AppTextStyles.l1.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(children: [
                          Container(
                            width: 46,
                            height: 56,
                            color: Colors.grey.shade200,
                            child: Obx(
                              () => Radio(
                                groupValue: controller.networkType.value,
                                value: "any",
                                activeColor: AppColors.primary,
                                onChanged: (String? value) {
                                  controller.networkType(value);
                                },
                              ),
                            ),
                          ),
                          Container(
                            height: 56,
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Any network",
                                style: AppTextStyles.l1,
                              ),
                            ],
                          )
                        ]),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 46,
                                height: 56,
                                color: Colors.grey.shade200,
                                child: Obx(
                                  () => Radio(
                                    groupValue: controller.networkType.value,
                                    value: 'private',
                                    activeColor: AppColors.primary,
                                    onChanged: (String? value) {
                                      controller.networkType(value);
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                height: 56,
                                width: 1,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   "Private office IP [ 192.168.1.10 ]",
                                    //   style: AppTextStyles.l1,
                                    // ),
                                    Expanded(
                                        child: TextFormField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: AppTextStyles.l1,
                                          hintText:
                                              "Private office IP [ 192.168.1.10 ]"),
                                    )),
                                  ],
                                ),
                              )
                            ]),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (controller.loading.isFalse) {
                                controller.addCompany();
                              }
                            }
                            // EmployerDashboardController controller = Get.find();
                            // controller.getCompanies();
                            // Get.back();
                          },
                          label: controller.isEdit.isTrue
                              ? "Update Company"
                              : "Add"),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              )
            : const Center(child: ShrimmerLoading()),
      ),
    ));
  }

  void pickDate(onSubmit) {
    Get.to(() => SafeArea(
          child: Material(
            child: SfDateRangePicker(
                controller: DateRangePickerController(),
                showActionButtons: true,
                confirmText: "Confirm",
                onCancel: () => Get.back(),
                view: DateRangePickerView.month,
                selectionMode: DateRangePickerSelectionMode.multiple,
                onSubmit: onSubmit),
          ),
        ));
  }
}

class SelectionItem extends StatelessWidget {
  const SelectionItem({
    super.key,
    required this.label,
    required this.onTap,
    required this.value,
    required this.isSelected,
    required this.hint,
    // required this.firstItem,
    // this.firstHint = '',
    // required this.secondItem,
    // this.selectedValue,
    // this.firstItemValue,
    // this.secondItemValue,
    // this.secondHint = ''
  });
  final String label;
  final String hint;
  final String value;

  final Function() onTap;
  final bool isSelected;
  // final String firstItem;
  // final String firstHint;
  // final String secondItem;
  // final String secondHint;
  // final selectedValue;
  // final firstItemValue;
  // final secondItemValue;
  @override
  Widget build(BuildContext context) {
    return
        // Row(children: [
        Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: 56.h,
          width: 165.w,
          decoration: BoxDecoration(
              color: isSelected ? const Color.fromRGBO(0, 128, 0, 0.05) : null,
              border: isSelected
                  ? Border.all(color: const Color(0xff008000).withOpacity(.3))
                  : Border.all(color: const Color(0xffDDDDDD).withOpacity(.3)),
              borderRadius: BorderRadius.circular(4)),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      hint,
                      style: TextStyle(fontSize: 7.sp, color: Colors.grey),
                    )
                  ],
                ),
              ),
              if (isSelected)
                Positioned(
                    top: 4.r,
                    left: 4.r,
                    child: Icon(
                      Icons.check_circle,
                      color: Theme.of(context).primaryColor,
                      size: 16.r,
                    )),
            ],
          ),
        ),
      ),
      // ),
      // SizedBox(
      //   width: 15.w,
      // ),
      // Expanded(
      //   child: Container(
      //     height: 56.h,
      //     width: 165.w,
      //     decoration: BoxDecoration(
      //         border: Border.all(color: Colors.grey.shade300),
      //         borderRadius: BorderRadius.circular(4)),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         Text(
      //           secondItem,
      //           style: TextStyle(
      //             fontSize: 15.sp,
      //             fontWeight: FontWeight.w400,
      //           ),
      //         ),
      //         SizedBox(
      //           height: 4,
      //         ),
      //         Text(
      //           secondHint,
      //           style: TextStyle(fontSize: 7.sp, color: Colors.grey),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
      // ]
    );
  }
}
