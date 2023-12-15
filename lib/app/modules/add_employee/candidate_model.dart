// To parse this JSON data, do
//
//     final candidate = candidateFromJson(jsonString);

import 'dart:convert';

Candidate candidateFromJson(String str) => Candidate.fromJson(json.decode(str));

String candidateToJson(Candidate data) => json.encode(data.toJson());

class Candidate {
  Candidate({
    this.name,
    this.address,
    this.contact,
    this.email,
    this.salaryType,
    this.dutyTime,
    this.dob,
    this.salaryAmount,
    this.joiningDate,
    this.overTime,
    this.designation,
    this.code,
    this.workingHours,
    this.allowLateAttendance,
    this.allowanceAmount,
    this.allowanceType,
    this.casualLeave,
    this.casualLeaveType,
  });

  String? name;
  String? address;
  String? contact;
  String? email;
  String? salaryType;
  String? dutyTime;
  String? dob;
  String? salaryAmount;
  String? joiningDate;
  String? overTime;
  String? designation;
  String? code;
  String? workingHours;
  String? allowLateAttendance;
  String? allowanceAmount;
  String? allowanceType;
  String? casualLeave;
  String? casualLeaveType;

  factory Candidate.fromJson(Map<String, dynamic> json) => Candidate(
        name: json["name"],
        address: json["address"],
        contact: json["phone"],
        email: json["email"],
        salaryType: json["salary_type"],
        dutyTime: json["duty_time"],
        dob: json["dob"],
        salaryAmount: json["salary_amount"],
        joiningDate: json["joining_date"],
        overTime: json["over_time"],
        designation: json["designation"],
        code: json["code"],
        workingHours: json["working_hours"],
        allowLateAttendance: json["allow_late_attendance"],
        allowanceAmount: json["allowance_amount"],
        allowanceType: json["allowance_type"],
        casualLeave: json["casual_leave"],
        casualLeaveType: json["casual_leave_type"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "address": address,
        "contact": contact,
        "email": email,
        "salary_type": salaryType,
        "duty_time": dutyTime,
        "dob": dob,
        "salary_amount": salaryAmount,
        "joining_date": joiningDate,
        "over_time": overTime,
        "designation": designation,
        "working_hours": workingHours,
        "allow_late_attendance": allowLateAttendance,
        "allowance_amount": allowanceAmount,
        "allowance_type": allowanceType,
        "casual_leave": casualLeave,
        "casual_leave_type": casualLeaveType,
      };
}
