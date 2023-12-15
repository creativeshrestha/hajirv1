import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/modules/add_employee/views/add_employee_view.dart';
import 'package:hajir/app/modules/company_detail/controllers/company_detail_controller.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/profile.dart';
import 'package:hajir/app/modules/employer_dashboard/controllers/employer_dashboard_controller.dart';
import 'package:hajir/app/modules/language/views/language_view.dart';
import 'package:hajir/app/modules/login/controllers/login_controller.dart';
import 'package:hajir/app/utils/shrimmerloading.dart';
import 'package:hajir/core/localization/l10n/strings.dart';
// To parse this JSON data, do
//
//     final approvers = approversFromJson(jsonString);

import 'dart:convert';

ApproversResponse approversFromJson(String str) =>
    ApproversResponse.fromJson(json.decode(str));

String approversToJson(ApproversResponse data) => json.encode(data.toJson());

class ApproversResponse {
  String? status;
  String? message;
  List<Approvers>? data;

  ApproversResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ApproversResponse.fromJson(Map<String, dynamic> json) =>
      ApproversResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Approvers>.from(
                json["data"]!.map((x) => Approvers.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Approvers {
  int? id;
  String? companyId;
  String? candidateId;
  String? name;
  String? phone;
  String? email;
  String? code;
  String? status;
  String? officeHourStart;
  String? officeHourEnd;

  Approvers({
    this.id,
    this.companyId,
    this.candidateId,
    this.name,
    this.phone,
    this.email,
    this.code,
    this.status,
    this.officeHourStart,
    this.officeHourEnd,
  });

  factory Approvers.fromJson(Map<String, dynamic> json) => Approvers(
        id: json["id"],
        companyId: json["company_id"],
        candidateId: json["candidate_id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        code: json["code"],
        status: json["status"],
        officeHourStart: json["office_hour_start"],
        officeHourEnd: json["office_hour_end"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "candidate_id": candidateId,
        "name": name,
        "phone": phone,
        "email": email,
        "code": code,
        "status": status,
        "office_hour_start": officeHourStart,
        "office_hour_end": officeHourEnd,
      };
}

class ApproverController extends GetxController {
  var candidateId = ''.obs;
  var approverlist = <Approvers>[].obs;
  final CompanyDetailController companyDetails = Get.find();
  final attendanceApi = Get.find<AttendanceSystemProvider>();
  var loading = false.obs;
  @override
  void onInit() {
    super.onInit();
    getApprover();
  }

  void addApprover() async {
    try {
      Get.closeAllSnackbars();
      showLoading();
      var result = await attendanceApi.storeApprover(
          companyDetails.selectedCompany.value, candidateId.value);
      Get.back();
      getApprover();
      Get.closeAllSnackbars();
      if (result.body != null) showSnackBar(result.body['message']);
    } catch (e) {
      Get.back();
      handleException(e);
    }
  }

  void getApprover() {
    try {
      loading(true);
      attendanceApi
          .getApproverlist(companyDetails.selectedCompany.value)
          .then((value) {
        approverlist(ApproversResponse.fromJson(value.body).data ?? []);
        loading(false);
      });
    } catch (e) {
      loading(false);
      handleException(e);
    }
  }

  void deleteApprover(String s) {
    try {
      showLoading();
      attendanceApi
          .deleteApprover(companyDetails.selectedCompany.value, s)
          .then((v) {
        Get.back();
        if (v.body != null) showSnackBar(v.body['message']);
        getApprover();
      });
    } catch (e) {
      Get.back();
      handleException(e);
    }
  }
}

class AddApprover extends StatelessWidget {
  AddApprover({super.key});
  final ApproverController approverController = Get.put(ApproverController());
  @override
  Widget build(BuildContext context) {
    final CompanyDetailController companyDetails = Get.find();
    final EmployerDashboardController controller = Get.find();
    return Scaffold(
      body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              AppBar(
                elevation: 1,
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.black),
                title: const Text(
                  "Add Approver",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Obx(
                () => approverController.loading.isTrue
                    ? const ShrimmerLoading()
                    : ListView.builder(
                        padding: REdgeInsets.symmetric(vertical: 20),
                        shrinkWrap: true,
                        itemCount: approverController.approverlist.length,
                        itemBuilder: (_, index) {
                          var approver = approverController.approverlist[index];
                          return Container(
                            margin: REdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            padding: REdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(children: [
                              Image.asset(
                                "assets/Mask group(1).png",
                                height: 40,
                                width: 40,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        approver.name ?? "",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Text(
                                        "Approver",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: Colors.grey),
                                      ),
                                    ]),
                              ),
                              InkWell(
                                onTap: () {
                                  approverController.deleteApprover(
                                      approver.candidateId ?? "");
                                },
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.grey.shade200,
                                  child: const Icon(
                                    CupertinoIcons.delete,
                                    size: 16,
                                  ),
                                ),
                              )
                            ]),
                          );
                        }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    CustomDropDownFieldWithDict(
                        title: "Add Users",
                        onChanged: (e) {
                          approverController.candidateId(e.toString());
                        },
                        hint: 'Select Approver',
                        values: [
                          ...companyDetails.emplist
                        ],
                        items: [
                          ...companyDetails.emplist
                              .map((element) => element['name'])
                              .toList()
                        ]),
                    // CustomFormField(
                    //   hint: strings.select_approver,
                    //   title: strings.add_approver,
                    // ),
                    SizedBox(
                      height: 20.h,
                    ),
                    // CustomFormField(
                    //   enabled: false,
                    //   hint: companyDetails.company.value.name ??
                    //       strings.select_approver,
                    //   title: "Selected Company" ?? strings.select_company,
                    // ),
                    // CustomDropDownField(
                    //     title: strings.select_company,
                    //     hint: strings.select_company,
                    //     items: controller.companyList
                    //         .map((e) => e.name ?? "")
                    //         .toList()),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomButton(
                        onPressed: () {
                          approverController.addApprover();
                        },
                        label: strings.add),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
