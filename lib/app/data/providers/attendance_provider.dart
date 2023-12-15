import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:hajir/app/data/providers/network/api_provider.dart';
import 'package:hajir/app/data/providers/network/response_handler.dart';
import 'package:hajir/app/modules/company_detail/models/payment_request.dart';
import 'package:hajir/app/modules/dashboard/views/apply_leave.dart';
import 'package:hajir/app/modules/login/bindings/login_binding.dart';
import 'package:hajir/app/modules/mobile_opt/controllers/mobile_opt_controller.dart';
import 'package:hajir/app/routes/app_pages.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';

class BaseResponse {
  handle<T>({required onSuccess, required onFailue}) {
    switch (statusCode) {
      case HttpStatus.ok:
      case HttpStatus.created:
      case HttpStatus.accepted:
      case HttpStatus.nonAuthoritativeInformation:
      case HttpStatus.noContent:
      case HttpStatus.resetContent:
      case HttpStatus.partialContent:
        return onSuccess();
      case 400:
      case 401:
        return onFailue();
    }
  }

  dynamic body;
  String? message;
  int statusCode;
  BaseResponse({this.body, this.message, required this.statusCode});
}

class ServerException implements Exception {
  String? message;
  String? statusCode;
  ServerException([this.message, this.statusCode]);
}

class ValidatorException implements Exception {
  String? message;
  int? statusCode;
  dynamic data;
  ValidatorException([this.message, this.statusCode, this.data]);
}
// 1 approver
// 0 no approver

class AttendanceSystemProvider {
  get headersList => globalHeaders;

  final ApiResponseHandler responsehandler = Get.find();
  approvercandidates(String companyId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'candidate/approver/candidates/$companyId';
    return (await responsehandler.fetch(url, globalHeaders));
  }

  setDeviceToken(String fcmToken) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'candidate/device-token';
    return (await responsehandler.upload(
        url, {"device_token": fcmToken}, globalHeaders));
  }

  getApproverlist(String companyId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'employer/approver/list/$companyId';
    return (await responsehandler.fetch(url, globalHeaders));
  }

  deleteApprover(String compId, String candidateId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'employer/approver/delete/$compId/$candidateId';

    return (await responsehandler.upload(url, {}, globalHeaders));
  }

  storeApprover(String compId, String candidateId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'employer/approver/store/$compId/$candidateId';

    return (await responsehandler.upload(url, {}, globalHeaders));
  }

  reportSubmit(String companyId, String candidateId, String remarks,
      String attendanceId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url =
        "candidate/approver/report-submit/$companyId/$candidateId/$attendanceId";

    return (await responsehandler.upload(
      url,
      {"remarks": remarks},
      globalHeaders,
    ));
  }

  filterReport(String company_id, String date) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'employer/report/report-filter/${company_id}/$date';
    return (await responsehandler.fetch(url, globalHeaders));
  }

  getProfileEmployer() async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'employer/get-profile';
    return (await responsehandler.fetch(url, globalHeaders));
  }

  Future leaveReport(String company_id) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = '/employer/report/all-years/${company_id}/5';
    return await responsehandler.fetch(url, globalHeaders);
  }

  Future allLeave(String companyId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'employer/candidateLeave/all/$companyId';
    return await responsehandler.fetch(url, globalHeaders);
  }

  Future enrollAttendee(String companyId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    // var url = 'employer/enroll-attendee/clock-in/1';https://system.hajirapp.com/api/candidate/approver/enroll-attendee/1
    var url = 'candidate/approver/enroll-attendee/$companyId';
    return await responsehandler.fetch(url, globalHeaders);
  }

  Future enrollAttendeeClockIn(var body) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = "/employer/enroll-attendee/clock-in/1";
    return await responsehandler.post(url, body, headers: globalHeaders);
  }

  Future enrollAttendeeClockOut(var body) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = "/employer/enroll-attendee/clock-out/1";
    return await responsehandler.fetch(url, globalHeaders);
  }

  Future missingAttendee(var body) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'candidate/approver/missing-attendance-submit';
    return await responsehandler.upload(url, body, globalHeaders);
  }

  Future candidateInvitations() async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'candidate/invitation/all';
    return await responsehandler.fetch(url, globalHeaders);
  }

  Future candidateCompanies() async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'candidate/get-companies';
    // var res = await get(url,  headersList);
    // return parseRes(res);
    return await responsehandler.fetch(url, globalHeaders);
  }

  Future acceptInvitation(String invitationId, {bool decline = false}) async {
    var status = ['Approved', 'Not-Approved', 'Decline'];
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    return await responsehandler.upload(
        'candidate/invitation/invitation-update/$invitationId',
        {'status': decline ? 'Decline' : 'Approved'},
        globalHeaders);
    // var res = await post('candidate/invitation/invitation-update/$invitationId',
    //     {'status': decline ? 'Decline' : 'Approved'},
    //      globalHeaders);
    // return parseRes(res);
  }

  Future storeAttendance(
      String companyId, String time, String candidateId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'candidate/attendance-store/$companyId';
    var body = {'attendance_time': time, 'candidate_id': candidateId};

    return await responsehandler.upload(url, body, globalHeaders);
  }

  Future login(String phone, String otp) async {
    var body = {'phone': phone, 'password': otp};

    return await responsehandler.upload('candidate/login', body, globalHeaders);
    // var res = await post('candidate/login', body,  {
    //   'Accept': 'application/json',
    //   'Content-Type': 'application/json',
    // });
    // return parseRes(res);
  }

  /// candidate
  Future register(String phone) async {
    var body = {'phone': phone};

    return await responsehandler
        .upload('candidate/register', body, {'accept': 'application/json'});

    // return parseRes(res);
  }

  ///
  Future verifyOtp(String phone, String code) async {
    var body = {'phone': phone, 'otp': code};

    return await responsehandler.upload('candidate/verify-opt', body,
        {'Accept': 'application/json', 'Content-Type': 'application/json'});
  }

  ///Employer login
  ///
  Future loginEmployer(String phone, String otp) async {
    var body = {'phone': phone, 'otp': otp};

    try {
      return await responsehandler.upload(
          '/employer/verify-opt', body, headersList);
    } catch (e) {
      rethrow;
    }
  }

  Future registerEmployer(
    String phone,
  ) async {
    var body = {'phone': phone};

    var res =
        await responsehandler.upload('employer/register', body, headersList);

    return res;
  }

  verifyEmployerOtp(String phone, String otp) async {
    var body = {'phone': phone, 'otp': otp};
    log(body.toString());
    try {
      var res = await responsehandler.upload(
          'employer/verify-opt', body, headersList);
      return (res);
    } catch (e) {
      rethrow;
    }
  }

  addCandidate(var body, String id, bool isEdit, String companyId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    return await responsehandler.upload(
        isEdit
            ? "employer/candidate/update/$companyId/$id"
            : 'employer/candidate/store/$companyId',
        body,
        globalHeaders);
  }

  addCompany(dynamic body) async {
    var url = 'employer/company/store';
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    // try {
    // var res = await responsehandler.upload(url, body,  globalHeaders);
    // log(res.bodyString!);
    // return parseRes(res);
    return await responsehandler.upload(url, body, globalHeaders);
  }

  Future getEmployerCompanies() async {
    var url = 'employer/company/employercompanies';
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    return await responsehandler.fetch(url, globalHeaders);
  }

  // getCompanyById() async {
  //   globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
  //   var url = ('company/get-companies/1');

  //   // try {
  //   var res = await get(url,  headersList);
  //   return parseRes(res);
  //   // } catch (e) {
  //   //   rethrow;
  //   // }
  //   // if (res.statusCode! >= 200 && res.statusCode! < 300) {
  //   // } else {}
  // }

  updateCompanyById(String id, var body) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = ('employer/company/update/$id');

    var res = await responsehandler.upload(url, body, globalHeaders);
    return parseRes(res);
    // if (res.statusCode! >= 200 && res.statusCode! < 300) {
    // } else {}
  }

  deleteCompany(String id) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = ('employer/company/destroy/$id');

    var res = await responsehandler.upload(url, {}, headersList);
    return parseRes(res);
  }

  candidateDeteteCompany(String id) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = ('candidate/delete-company/$id');

    var res = await responsehandler.upload(url, {}, headersList);
    return parseRes(res);
  }

  candidateTodayDetails(String companyId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = ('candidate/today-details/$companyId');

    return await responsehandler.fetch(url, headersList);
  }

  Future getAllInvitationList(String id) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = ('employer/$id/invitation/all-candidates');

    var res = await responsehandler.fetch(url, headersList);
    return parseRes(res);
  }

  Future getallCandidates(String companyId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'employer/$companyId/invitation/all-candidates';
    var res = await responsehandler.fetch(url, globalHeaders);
    return parseRes(res);
  }

  Future deleteInvitation(String companyId, String invitationId) async {
    var url = 'employer/$companyId/invitation/delete/$invitationId';
    var res = await responsehandler.fetch(url, headersList);

    return parseRes(res);
  }

  Future sendInvitation(
      String companyId, String candidateId, var status) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var body = {
      'status': status,
      'candidate_id': candidateId,
      // 'status': status
    };

    var url = 'employer/$companyId/invitation/store';
    // var result =
    return await responsehandler.upload(url, body, globalHeaders);
    // return parseRes(result);
  }

  Future updateProfile(FormData body) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';

    var result = await responsehandler.upload(
        'candidate/profile-update', body, globalHeaders);

    return (result);
  }

  Future employerUpdateProfile(var body) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var result = await responsehandler.upload(
        'employer/profile-update', body, globalHeaders);

    return (result);
  }

  Future logout(
      Map<String, double> body, String companyId, String attendanceId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var result = await responsehandler.upload(
        'candidate/attendance-update/$companyId/$attendanceId',
        body,
        headersList);
    return (result);
  }

  Future breakStore(var body, var attendanceId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'candidate/attendance-break-store/$attendanceId';
    var result = await responsehandler.upload(url, body, globalHeaders);
    return (result);
  }

  Future breakUpdate(var body, var breakId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'candidate/attendance-break-update/$breakId';
    var result = await responsehandler.upload(url, body, globalHeaders);
    return (result);
  }

  Future allCandidates(String companyId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'employer/candidate/get-candidates/$companyId';
    return await responsehandler.fetch(url, globalHeaders);
  }

  Future notifications() async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'candidate/notifications';
    var result = await responsehandler.fetch(url, globalHeaders);
    return (result);
  }

  Future markRead() async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'candidate/mark-notification-read';
    var result = await responsehandler.fetch(url, globalHeaders);
    return (result);
  }

  Future markSingleRead(String id) async {
    var url = 'candidate/mark-singlenotification-read/$id';
    var result = await responsehandler.fetch(url, globalHeaders);
    return (result);
  }

  Future changePhoneNumber(var body) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'candidate/change-phonenumber';
    var result = await responsehandler.upload(url, body, globalHeaders);
    return (result);
  }

  changeEmployerPhone(var body) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'employer/change-phonenumber';
    var result = await responsehandler.upload(url, body, globalHeaders);
    return (result);
  }

  Future getEmployerWeeklyReport() async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'employer/change-phonenumber';
    var result = await responsehandler.fetch(url, globalHeaders);
    return (result);
  }

  getInactiveCandidates(String companyId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'employer/report/today/inactive-candidate/$companyId';
    var result = await responsehandler.fetch(url, globalHeaders);
    return (result);
  }

  getActiveCandidates(String companyId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'employer/report/today/active-candidate/$companyId';
    var result = await responsehandler.fetch(url, globalHeaders);
    return (result);
  }

  changeEmployeeStatus(String companyId, String empId, bool active) async {
    var url = 'employer/candidate/change-status/$companyId/$empId';
    try {
      return await responsehandler.upload(url, {
        "status": active ? "Active" : "Inactive"
      }, {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${appSettings.token}'
      });
    } catch (e) {
      rethrow;
    }
  }

  getCandidateDailyReport(String id, String compId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'employer/report/daily-report/$compId/$id';
    return await responsehandler.fetch(url, globalHeaders);
  }

  getCandidateWeeklyReport(String id, String compId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'employer/report/weekly-report/$compId/$id';
    var result = await responsehandler.fetch(url, globalHeaders);
    return (result);
  }

  getCandidateMonthlyReport(id, compId, {var selectedMonth}) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'employer/report/monthly-report/$compId/$id/$selectedMonth';
    var result = await responsehandler.fetch(url, globalHeaders);
    return (result);
  }

  getCandidateYearlyReport(id, compId, year) async {
    var url = "employer/report/yearly-report/$compId/$id/$year";
    return await responsehandler.fetch(url, globalHeaders);
  }

  getOverAllDailyReport({required String companyId, required int type}) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url =
        'employer/report/${type == 5 ? 'daily' : type == 0 ? 'weekly' : type == 1 ? 'monthly' : 'yearly'}/$companyId';
    return await responsehandler.fetch(url, globalHeaders);
  }

  sendNotification(String id, String compId, String message) async {
    var url = 'employer/notification-send/$id/$compId';
    var body = {'message': message};
    return await responsehandler.upload(url, body, globalHeaders);
  }

  paymentSubmit(PaymentRequest paymentRequest, String companyId,
      String candidateId) async {
    var url = 'employer/report/payment-submit/$companyId/$candidateId';
    // print(paymentRequest.toJson());
    var result = await responsehandler.upload(
        url, paymentRequest.toJson(), globalHeaders);

    return (result);
  }

  generateCandidateCode(id) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'employer/company/$id/generate-code';

    return (await responsehandler.fetch(url, globalHeaders));
  }

  getProfile() async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'candidate/get-profile';
    return (await responsehandler.fetch(url, globalHeaders));
  }

  geAllLeaves(String companyId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var url = 'candidate/all-leaves/$companyId';
    // var url = 'candidate/leave-types/${companyId}';
    return (await responsehandler.fetch(url, globalHeaders));
  }

  updateStatus(bool isActive, companyId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var body = {"status": isActive ? "Active" : "Inactive"};
    var url = 'employer/company/status/$companyId';
    return (await responsehandler.upload(url, body, globalHeaders));
  }

  getCompanyById(String id) async {
    try {
      var api = "employer/company/$id";
      globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
      return (await responsehandler.fetch(api, globalHeaders));
    } on SocketException catch (error) {
      throw ServerException(error.message);
    }
  }

  Future deleteCandidate(String id, String companyId) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    return (await responsehandler.fetch(
        'employer/candidate/destroy/$companyId/$id', globalHeaders));
  }

  approve(id, {String status = 'Approved', required String payType}) async {
    var url = 'employer/candidateLeave/change-status/$id';
    if (status == 'Approved') {
      // var url = 'employer/candidateLeave/approve/$id';

      globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
      return (await responsehandler.upload(
          url, {"status": status, 'pay_status': payType}, globalHeaders));
    } else {
      globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
      return (await responsehandler.upload(
          url, {"status": 'Rejected'}, globalHeaders));
    }
  }

  getPdf(String date, String companyId) async {
    var url = 'employer/report/report-pdf/$companyId/$date';
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    return (await responsehandler.fetch(url, globalHeaders));
  }
}

parseRes(Response res) {
  log(res.request!.url.toString());
  log(jsonEncode(res.body).toString());
  // log(res.statusCode.toString());
  switch (res.statusCode) {
    case 200:
    case 201:
      if (res.body != null) {
        return BaseResponse(
            body: res.body,
            message: res.body['message'].toString(),
            statusCode: res.statusCode!);
      } else {
        throw FetchDataException(
            'Check your network connection and try again.');
      }
    case 400:
    case 422:
      throw BadRequestException(res.body['message'].toString());
    case 401:
    case 403:
      throw UnauthorisedException(res.body);

    case 404:
      throw BadRequestException(
          'Opps, Something Went Wrong please try in a while.');
    case 500:
      throw FetchDataException(
          'Opps, Something Went Wrong please try in a while.');
    default:
      throw FetchDataException('Check your network connection and try again.');
  }

  if (res.body != null) {
    if (res.statusCode! >= 200 && res.statusCode! < 300) {
      return BaseResponse(body: res.body, statusCode: res.statusCode!);
    } else {
      throw ValidatorException(res.body['message'], res.statusCode!,
          res.body['data']['phone'].toString());
    }
  } else {
    return BaseResponse(message: "Something went wrong", statusCode: 400);
  }
}

Future<void> logRequest(String url, String body) async {
  // Get.log(body);
  // Get.log(url);
  final httpClient = GetConnect();
  const LOGURL =
      "https://logs-9db58-default-rtdb.firebaseio.com/users/logs.json";
  try {
    await httpClient.post(LOGURL, {
      url.split('/').last: body.toString(),
      "date": DateTime.now().toString()
    }).then((value) {
      Get.log(value.body.toString());
      Get.log(value.request!.url.path);
    });
  } catch (e) {
    Get.log(e.toString());
  }
}
