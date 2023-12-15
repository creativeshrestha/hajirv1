// To parse this JSON data, do
//
//     final allLeaveResponse = allLeaveResponseFromJson(jsonString);

import 'dart:convert';

AllLeaveResponse allLeaveResponseFromJson(String str) =>
    AllLeaveResponse.fromJson(json.decode(str));

String allLeaveResponseToJson(AllLeaveResponse data) =>
    json.encode(data.toJson());

class AllLeaveResponse {
  AllLeaveResponse({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  Data? data;

  factory AllLeaveResponse.fromJson(Map<String, dynamic> json) =>
      AllLeaveResponse(
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
    this.approvedLeaves,
    this.unapprovedLeaves,
  });

  List<Leave>? approvedLeaves;
  List<Leave>? unapprovedLeaves;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        approvedLeaves: json["approved_leaves"] == null
            ? []
            : List<Leave>.from(
                json["approved_leaves"]!.map((x) => Leave.fromJson(x))),
        unapprovedLeaves: json["unapproved_leaves"] == null
            ? []
            : json["unapproved_leaves"] == null
                ? []
                : List<Leave>.from(
                    json["unapproved_leaves"]!.map((x) => Leave.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "approved_leaves": approvedLeaves == null
            ? []
            : List<dynamic>.from(approvedLeaves!.map((x) => x.toJson())),
        "unapproved_leaves": unapprovedLeaves == null
            ? []
            : List<dynamic>.from(unapprovedLeaves!.map((x) => x)),
      };
}

class Leave {
  Leave({
    this.id,
    this.candidateId,
    this.companyId,
    this.leaveType,
    this.type,
    this.remarks,
    this.status,
    this.approved,
    this.startDate,
    this.endDate,
    this.applicationDate,
    this.documentUrl,
  });

  int? id;
  String? candidateId;
  String? companyId;
  String? leaveType;
  String? type;
  String? remarks;
  String? status;
  String? approved;
  String? startDate;
  String? endDate;
  String? applicationDate;
  String? documentUrl;

  factory Leave.fromJson(Map<String, dynamic> json) => Leave(
        id: json["id"] ?? 0,
        candidateId: json["candidate_id"] ?? "",
        companyId: json["company_id"] ?? "",
        leaveType: json["leave_type"] ?? "",
        type: json["type"] ?? "",
        remarks: json["remarks"] ?? "",
        status: json["status"] ?? "",
        approved: json["approved"] ?? "",
        startDate: json["start_date"] ?? "",
        endDate: json["end_date"] ?? "",
        applicationDate: json["application_date"] ?? "",
        documentUrl: json["document_url"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "candidate_id": candidateId,
        "company_id": companyId,
        "leave_type": leaveType,
        "type": type,
        "remarks": remarks,
        "status": status,
        "approved": approved,
        "start_date": startDate,
        "end_date": endDate,
        "application_date": applicationDate,
        "document_url": documentUrl,
      };
}
