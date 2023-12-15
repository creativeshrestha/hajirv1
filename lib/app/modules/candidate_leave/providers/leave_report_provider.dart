import 'package:get/get.dart';
import 'package:hajir/app/data/providers/network/api_endpoint.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';

import '../leave_report_model.dart';

class LeaveReportProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return LeaveReport.fromJson(map);
      if (map is List)
        return map.map((item) => LeaveReport.fromJson(item)).toList();
    };
    httpClient.baseUrl = APIEndpoint.baseUrl;
  }

  Future<LeaveReport?> getLeaveReport(String id) async {
    final response = await get('employer/candidateLeave/detail/$id',
        headers: {'Authorization': 'Bearer ${appSettings.token}'});
    print(id);
    print(response.request!.url);
    print(response.bodyString);
    return response.body;
  }

  Future<Response<LeaveReport>> postLeaveReport(
          LeaveReport leavereport) async =>
      await post('leavereport', leavereport);
  Future<Response> deleteLeaveReport(int id) async =>
      await delete('leavereport/$id');
}
