// // To parse this JSON data, do
// //
// //     final candidateResponse = candidateResponseFromJson(jsonString);

// import 'dart:convert';

// CandidateResponse candidateResponseFromJson(String str) =>
//     CandidateResponse.fromJson(json.decode(str));

// String candidateResponseToJson(CandidateResponse data) =>
//     json.encode(data.toJson());

// class CandidateResponse {
//   CandidateResponse({
//     this.status,
//     this.message,
//     this.data,
//   });

//   String? status;
//   String? message;
//   Candidate? data;

//   factory CandidateResponse.fromJson(Map<String, dynamic> json) =>
//       CandidateResponse(
//         status: json["status"],
//         message: json["message"],
//         data: json["data"] == null ? null : Candidate.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "data": data?.toJson(),
//       };
// }

// class Candidate {
//   Candidate({
//     this.id,
//     this.companyId,
//     this.candidateId,
//     this.name,
//     this.phone,
//     this.email,
//     this.joiningDate,
//     this.designation,
//     this.dutyTime,
//     this.salaryAmount,
//     this.salaryType,
//     this.overtime,
//     this.allowLateAttendance,
//     this.workingHours,
//     this.allowanceAmount,
//     this.allowanceType,
//     this.casualLeave,
//     this.casualLeaveType,
//   });

//   int? id;
//   String? companyId;
//   String? candidateId;
//   String? name;
//   String? phone;
//   String? email;
//   DateTime? joiningDate;
//   String? designation;
//   String? dutyTime;
//   String? salaryAmount;
//   String? salaryType;
//   String? overtime;
//   dynamic allowLateAttendance;
//   String? workingHours;
//   String? allowanceAmount;
//   String? allowanceType;
//   String? casualLeave;
//   String? casualLeaveType;

//   factory Candidate.fromJson(Map<String, dynamic> json) => Candidate(
//         id: json["id"],
//         companyId: json["company_id"],
//         candidateId: json["candidate_id"],
//         name: json["name"],
//         phone: json["phone"],
//         email: json["email"],
//         joiningDate: json["joining_date"] == null
//             ? null
//             : DateTime.parse(json["joining_date"]),
//         designation: json["designation"],
//         dutyTime: json["duty_time"],
//         salaryAmount: json["salary_amount"],
//         salaryType: json["salary_type"],
//         overtime: json["overtime"],
//         allowLateAttendance: json["allow_late_attendance"],
//         workingHours: json["working_hours"],
//         allowanceAmount: json["allowance_amount"],
//         allowanceType: json["allowance_type"],
//         casualLeave: json["casual_leave"],
//         casualLeaveType: json["casual_leave_type"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "company_id": companyId,
//         "candidate_id": candidateId,
//         "name": name,
//         "phone": phone,
//         "email": email,
//         "joining_date":
//             "${joiningDate!.year.toString().padLeft(4, '0')}-${joiningDate!.month.toString().padLeft(2, '0')}-${joiningDate!.day.toString().padLeft(2, '0')}",
//         "designation": designation,
//         "duty_time": dutyTime,
//         "salary_amount": salaryAmount,
//         "salary_type": salaryType,
//         "overtime": overtime,
//         "allow_late_attendance": allowLateAttendance,
//         "working_hours": workingHours,
//         "allowance_amount": allowanceAmount,
//         "allowance_type": allowanceType,
//         "casual_leave": casualLeave,
//         "casual_leave_type": casualLeaveType,
//       };
// }
