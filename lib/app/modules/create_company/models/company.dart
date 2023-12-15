// To parse this JSON data, do
//
//     final companyData = companyDataFromJson(jsonString);

import 'dart:convert';

CompanyData companyDataFromJson(String str) =>
    CompanyData.fromJson(json.decode(str));

String companyDataToJson(CompanyData data) => json.encode(data.toJson());

class CompanyData {
  CompanyData({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  Data? data;

  factory CompanyData.fromJson(Map<String, dynamic> json) => CompanyData(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.company,
  });

  Company? company;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "company": company?.toJson(),
      };
}

class Company {
  Company({
    this.id,
    this.name,
    this.generateCode,
    this.phone,
    this.address,
    this.workingHours,
    // this.officeHourStart,
    // this.officeHourEnd,
    this.salaryType,
    this.sickLeaveType,
    this.sickLeaveDays,
    this.probationDuration,
    this.employeeCount,
    this.approverCount,
    this.companyBusinessLeaves,
    this.companyGovermentLeaves,
    this.companySpecialLeaves,
  });

  int? id;
  String? name;
  bool? generateCode;
  String? phone;
  String? address;
  String? workingHours;
  // String? officeHourStart;
  // String? officeHourEnd;
  String? salaryType;
  String? sickLeaveType;
  String? sickLeaveDays;
  dynamic probationDuration;
  int? employeeCount;
  int? approverCount;
  List<CompanyBusinessLeave>? companyBusinessLeaves;
  List<CompanyLeave>? companyGovermentLeaves;
  List<CompanyLeave>? companySpecialLeaves;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        name: json["name"],
        generateCode: json["generate_code"],
        phone: json["phone"],
        address: json["address"],
        workingHours: json["office_hour"],
        // officeHourStart: json["office_hour_start"],
        // officeHourEnd: json["office_hour_end"],
        salaryType: json["salary_type"],
        sickLeaveType: json["sick_leave_type"],
        sickLeaveDays: json["sick_leave_days"],
        probationDuration: json["probation_period"],
        employeeCount: json["employee_count"],
        approverCount: json["approver_count"],
        companyBusinessLeaves: json["company_business_leaves"] == null
            ? []
            : List<CompanyBusinessLeave>.from(json["company_business_leaves"]!
                .map((x) => CompanyBusinessLeave.fromJson(x))),
        companyGovermentLeaves: json["company_goverment_leaves"] == null
            ? []
            : List<CompanyLeave>.from(json["company_goverment_leaves"]!
                .map((x) => CompanyLeave.fromJson(x))),
        companySpecialLeaves: json["company_special_leaves"] == null
            ? []
            : List<CompanyLeave>.from(json["company_special_leaves"]!
                .map((x) => CompanyLeave.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "generate_code": generateCode,
        "phone": phone,
        "address": address,
        "working_hours": workingHours,
        // "office_hour_start": officeHourStart,
        // "office_hour_end": officeHourEnd,
        "salary_type": salaryType,
        "sick_leave_type": sickLeaveType,
        "sick_leave_days": sickLeaveDays,
        "probation_duration": probationDuration,
        "employee_count": employeeCount,
        "approver_count": approverCount,
        "company_business_leaves": companyBusinessLeaves == null
            ? []
            : List<dynamic>.from(companyBusinessLeaves!.map((x) => x.toJson())),
        "company_goverment_leaves": companyGovermentLeaves == null
            ? []
            : List<dynamic>.from(
                companyGovermentLeaves!.map((x) => x.toJson())),
        "company_special_leaves": companySpecialLeaves == null
            ? []
            : List<dynamic>.from(companySpecialLeaves!.map((x) => x.toJson())),
      };
}

class CompanyBusinessLeave {
  CompanyBusinessLeave({
    this.id,
    this.businessLeave,
  });

  int? id;
  String? businessLeave;

  factory CompanyBusinessLeave.fromJson(Map<String, dynamic> json) =>
      CompanyBusinessLeave(
        id: json["id"],
        businessLeave: json["business_leave"] ?? [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "business_leave": businessLeave,
      };
}

class CompanyLeave {
  CompanyLeave({
    this.id,
    this.leaveDate,
  });

  int? id;
  DateTime? leaveDate;

  factory CompanyLeave.fromJson(Map<String, dynamic> json) => CompanyLeave(
        id: json["id"],
        leaveDate: json["leave_date"] == null
            ? null
            : DateTime.parse(json["leave_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "leave_date":
            "${leaveDate!.year.toString().padLeft(4, '0')}-${leaveDate!.month.toString().padLeft(2, '0')}-${leaveDate!.day.toString().padLeft(2, '0')}",
      };
}
