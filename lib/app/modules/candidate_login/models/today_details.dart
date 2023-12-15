// To parse this JSON data, do
//
//     final todayDetails = todayDetailsFromJson(jsonString);

import 'dart:convert';

TodayDetailResponse todayDetailsFromJson(String str) =>
    TodayDetailResponse.fromJson(json.decode(str));

String todayDetailsToJson(TodayDetailResponse data) =>
    json.encode(data.toJson());

class TodayDetailResponse {
  String? status;
  String? message;
  TodayDetail? data;

  TodayDetailResponse({
    this.status,
    this.message,
    this.data,
  });

  factory TodayDetailResponse.fromJson(Map<String, dynamic> json) =>
      TodayDetailResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : TodayDetail.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class TodayDetail {
  int? id;
  String? attendanceId;
  String? candidateId;
  String? companyId;
  dynamic candidateCode;
  String? startTime;
  String? endTime;
  double? todayEarning;
  String? status;
  double? todayHourWork;
  double? perMinuteSalary;
  int? breakLimit;
  double? totalEarning;
  String? dutyTime;
  List<Break>? breaks;
  Break? currentBreak;

  TodayDetail({
    this.id,
    this.candidateId,
    this.companyId,
    this.candidateCode,
    this.startTime,
    this.endTime,
    this.todayEarning,
    this.status,
    this.todayHourWork,
    this.perMinuteSalary,
    this.breakLimit,
    this.totalEarning,
    this.dutyTime,
    this.breaks,
    this.attendanceId,
    this.currentBreak,
  });

  factory TodayDetail.fromJson(Map<String, dynamic> json) => TodayDetail(
        id: json["id"],
        attendanceId: json['attendance_id'].toString(),
        candidateId: json["candidate_id"],
        companyId: json["company_id"],
        candidateCode: json["candidate_code"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        todayEarning: double.parse((json["today_earning"] ?? 0).toString()),
        status: json["status"],
        todayHourWork: double.parse(json["today_hour_work"].toString()),
        perMinuteSalary: json["per_minute_salary"]?.toDouble(),
        breakLimit: json["break_limit"],
        totalEarning: json["total_earning"]?.toDouble(),
        dutyTime: json["duty_time"].toString(),
        breaks: json["breaks"] == null
            ? []
            : List<Break>.from(json["breaks"]!.map((x) => Break.fromJson(x))),
        currentBreak: json["current_break"] == null
            ? null
            : Break.fromJson(json["current_break"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "candidate_id": candidateId,
        "company_id": companyId,
        "candidate_code": candidateCode,
        "start_time": startTime,
        "end_time": endTime,
        "today_earning": todayEarning,
        "status": status,
        "today_hour_work": todayHourWork,
        "per_minute_salary": perMinuteSalary,
        "break_limit": breakLimit,
        "total_earning": totalEarning,
        "duty_time": dutyTime,
        "breaks": breaks == null
            ? []
            : List<dynamic>.from(breaks!.map((x) => x.toJson())),
        "current_break": currentBreak?.toJson(),
      };
}

class Break {
  int? id;
  String? startTime;
  String? endTime;

  Break({
    this.id,
    this.startTime,
    this.endTime,
  });

  factory Break.fromJson(Map<String, dynamic> json) => Break(
        id: json["id"],
        startTime: json["start_time"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_time": startTime,
        "end_time": endTime,
      };
}
