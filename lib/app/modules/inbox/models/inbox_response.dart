// To parse this JSON data, do
//
//     final inboxResponse = inboxResponseFromJson(jsonString);

import 'dart:convert';

InboxResponse inboxResponseFromJson(String str) =>
    InboxResponse.fromJson(json.decode(str));

String inboxResponseToJson(InboxResponse data) => json.encode(data.toJson());

class InboxResponse {
  String? status;
  String? message;
  Data? data;

  InboxResponse({
    this.status,
    this.message,
    this.data,
  });

  factory InboxResponse.fromJson(Map<String, dynamic> json) => InboxResponse(
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
  List<LeaveRequest>? candidates;

  Data({
    this.candidates,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        candidates: json["candidates"] == null
            ? []
            : List<LeaveRequest>.from(
                json["candidates"]!.map((x) => LeaveRequest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "candidates": candidates == null
            ? []
            : List<dynamic>.from(candidates!.map((x) => x.toJson())),
      };
}

class LeaveRequest {
  int? leaveId;
  int? candidateId;
  LeaveType? leaveType;
  String? startDate;
  String? status;
  String? endDate;
  DateTime? createdAt;
  String? name;
  String? attachment;

  LeaveRequest({
    this.leaveId,
    this.candidateId,
    this.leaveType,
    this.startDate,
    this.status,
    this.endDate,
    this.createdAt,
    this.name,
    this.attachment,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) => LeaveRequest(
        leaveId: json["leave_id"],
        candidateId: json["candidate_id"],
        leaveType: json["leave_type"] == null
            ? null
            : LeaveType.fromJson(json["leave_type"]),
        startDate: json["start_date"],
        status: json["status"].toString(),
        endDate: json["end_date"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        name: json["name"],
        attachment: json["attachment"],
      );

  Map<String, dynamic> toJson() => {
        "leave_id": leaveId,
        "candidate_id": candidateId,
        "leave_type": leaveType?.toJson(),
        "start_date": startDate,
        "status": status,
        "end_date": endDate,
        "created_at": createdAt?.toIso8601String(),
        "name": name,
        "attachment": attachment,
      };
}

class LeaveType {
  int? id;
  String? title;
  String? status;
  dynamic desc;

  LeaveType({
    this.id,
    this.title,
    this.status,
    this.desc,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) => LeaveType(
        id: json["id"],
        title: json["title"],
        status: json["status"],
        desc: json["desc"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
        "desc": desc,
      };
}
