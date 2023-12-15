// To parse this JSON data, do
//
//     final companies = companiesFromJson(jsonString);

import 'dart:convert';

Companies companiesFromJson(String str) => Companies.fromJson(json.decode(str));

String companiesToJson(Companies data) => json.encode(data.toJson());

class Companies {
  Companies({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  Data data;

  factory Companies.fromJson(Map<String, dynamic> json) => Companies(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.companies,
  });

  List<Company> companies;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        companies: List<Company>.from(
            json["companies"].map((x) => Company.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "companies": List<dynamic>.from(companies.map((x) => x.toJson())),
      };
}

class Company {
  Company(
      {this.id,
      this.name,
      this.generateCode,
      this.phone,
      this.address,
      this.workingHours,
      this.officeHourStart,
      this.officeHourEnd,
      this.salaryType,
      this.sickLeaveType,
      this.sickLeaveDays,
      this.probationDuration,
      this.employeeCount,
      this.approverCount,
      this.companyCode,
      this.createdAt});
  String? createdAt;
  int? id;
  String? name;
  bool? generateCode;
  String? phone;
  String? address;
  dynamic workingHours;
  String? officeHourStart;
  String? officeHourEnd;
  String? salaryType;
  String? sickLeaveType;
  String? sickLeaveDays;
  String? probationDuration;
  String? employeeCount;
  String? companyCode;
  int? approverCount;
  factory Company.empty() => Company.fromJson({});
  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        createdAt: json['created_at'],
        name: json["name"],
        generateCode: json["generate_code"] ?? false,
        phone: json["phone"],
        address: json["address"],
        workingHours: json["working_hours"],
        officeHourStart: json["office_hour_start"],
        officeHourEnd: json["office_hour_end"],
        salaryType: json["salary_type"],
        companyCode: json['company_code'].toString(),
        sickLeaveType: json["sick_leave_type"],
        sickLeaveDays: json["sick_leave_days"],
        probationDuration: json["probation_duration"],
        employeeCount: json["employee_count"],
        approverCount: json["approver_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "generate_code": generateCode,
        "phone": phone,
        "address": address,
        "working_hours": workingHours,
        "office_hour_start": officeHourStart,
        "office_hour_end": officeHourEnd,
        "salary_type": salaryType,
        "sick_leave_type": sickLeaveType,
        "sick_leave_days": sickLeaveDays,
        "probation_duration": probationDuration,
        "employee_count": employeeCount,
        "approver_count": approverCount,
        'created_at': createdAt
      };
}
