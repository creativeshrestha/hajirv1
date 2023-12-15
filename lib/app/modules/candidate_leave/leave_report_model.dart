class LeaveReport {
  String? status;
  String? message;
  Data? data1;

  LeaveReport({this.status, this.message, this.data1});

  LeaveReport.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data1 = json['data'] != null ? Data?.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (data != null) {
      data['data'] = data1?.toJson();
    }
    return data;
  }
}

class Data {
  Leavedetail? leavedetail;

  Data({this.leavedetail});

  Data.fromJson(Map<String, dynamic> json) {
    leavedetail = json['leavedetail'] != null
        ? Leavedetail?.fromJson(json['leavedetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (leavedetail != null) {
      data['leavedetail'] = leavedetail?.toJson();
    }
    return data;
  }
}

class Leavedetail {
  int? id;
  int? candidateId;
  String? remarks;
  String? status;
  String? payStatus;
  LeaveType? leaveType;
  String? startDate;
  String? endDate;
  String? type;
  dynamic file;

  Leavedetail(
      {this.id,
      this.candidateId,
      this.remarks,
      this.status,
      this.payStatus,
      this.leaveType,
      this.startDate,
      this.endDate,
      this.type,
      this.file});

  Leavedetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    candidateId = json['candidate_id'];
    remarks = json['remarks'];
    status = json['status'];
    payStatus = json['pay_status'];
    leaveType = json['leave_type'] != null
        ? LeaveType?.fromJson(json['leave_type'])
        : null;
    startDate = json['start_date'];
    endDate = json['end_date'];
    type = json['type'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['candidate_id'] = candidateId;
    data['remarks'] = remarks;
    data['status'] = status;
    data['pay_status'] = payStatus;
    if (leaveType != null) {
      data['leave_type'] = leaveType?.toJson();
    }
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['type'] = type;
    data['file'] = file;
    return data;
  }
}

class LeaveType {
  int? id;
  String? title;
  String? status;
  dynamic desc;

  LeaveType({this.id, this.title, this.status, this.desc});

  LeaveType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['status'] = status;
    data['desc'] = desc;
    return data;
  }
}
