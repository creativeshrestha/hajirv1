import 'dart:io';

import 'package:get/get.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/data/providers/network/api_endpoint.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/dashboard/views/apply_leave.dart';

class ApiResponseHandler extends GetConnect {
  get headersList => globalHeaders;

  @override
  void onInit() {
    httpClient.baseUrl = APIEndpoint.baseUrl;
    httpClient.timeout = 1500.seconds;
  }

  Future fetch(url, headers, {query}) async {
    try {
      return parseRes(await get(url, headers: headers, query: query));
    } on SocketException catch (e) {
      rethrow;
    }
  }

  Future upload(url, body, headers, {query}) async {
    try {
      return parseRes(await post(url, body, headers: headers));
    } on SocketException catch (e) {
      rethrow;
    }
  }
}
