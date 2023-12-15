import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/data/providers/network/api_endpoint.dart';
import 'package:hajir/app/data/providers/network/response_handler.dart';
import 'package:hajir/app/modules/dashboard/views/apply_leave.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';

class EmployerReportProvider extends GetConnect {
  final ApiResponseHandler responsehandler = Get.find();

  @override
  onInit() {
    super.onInit();
    httpClient.baseUrl = APIEndpoint.baseUrl;
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
  }

  getEmployerReport(String companyId) async {
    return parseRes(await get("${APIEndpoint.employerReport}$companyId",
        headers: globalHeaders));
  }
}
