// To parse this JSON data, do
//
//     final candidatesResponse = candidatesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hajir/app/modules/add_employee/candidate_model.dart';

CandidatesResponse candidatesResponseFromJson(String str) =>
    CandidatesResponse.fromJson(json.decode(str));

String candidatesResponseToJson(CandidatesResponse data) =>
    json.encode(data.toJson());

class CandidatesResponse {
  CandidatesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  CandidateList data;

  factory CandidatesResponse.fromJson(Map<String, dynamic> json) =>
      CandidatesResponse(
        status: json["status"],
        message: json["message"],
        data: CandidateList.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class CandidateList {
  CandidateList({
    required this.candidate,
  });

  List<Candidate> candidate;

  factory CandidateList.fromJson(Map<String, dynamic> json) => CandidateList(
        candidate: List<Candidate>.from(
            json["candidate"].map((x) => Candidate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "candidate": List<dynamic>.from(candidate.map((x) => x.toJson())),
      };
}

// class Candidate {
//   Candidate({
//     this.id,
//     this.name,
//     this.code,
//     this.contact,
//     this.email,
//     this.address,
//     this.joiningDate,
//   });

//   String? id;
//   String? name;
//   String? code;
//   String? contact;
//   String? email;
//   String? address;
//   DateTime? joiningDate;

//   factory Candidate.fromJson(Map<String, dynamic> json) => Candidate(
//         id: json["id"],
//         name: json["name"],
//         code: json["code"],
//         contact: json["contact"],
//         email: json["email"],
//         address: json["address"],
//         joiningDate: DateTime.parse(json["joining_date"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "code": code,
//         "contact": contact,
//         "email": email,
//         "address": address,
//         "joining_date": joiningDate?.toIso8601String(),
//       };
// }
