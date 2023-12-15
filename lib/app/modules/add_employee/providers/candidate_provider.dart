import 'dart:io';

import 'package:get/get.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/data/providers/network/api_endpoint.dart';
import 'package:hajir/app/modules/dashboard/views/apply_leave.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';

import '../candidate_model.dart';

class CandidateProvider extends GetConnect {
  // final ApiResponseHandler responsehandler = Get.find();

  @override
  void onInit() {
    httpClient.baseUrl = APIEndpoint.baseUrl;
    httpClient.timeout = 1500.seconds;
    httpClient.defaultDecoder = (map) {
      try {
        if (map is Map<String, dynamic>) {
          if (map['data'] != null) {
            return Candidate.fromJson(map['data'] ?? {});
          } else {
            throw ServerException("Something went wrong");
          }
        } else if (map is List) {
          return map.map((item) => Candidate.fromJson(item)).toList();
        }
      } catch (e) {
        rethrow;
      }
    };
  }

  Future<Candidate?> getCandidate(String companyId, String id) async {
    var headers = globalHeaders;
    globalHeaders['Authorization'] = "Bearer ${appSettings.token}";
    Get.log(headers.toString());
    try {
      final response = await get(
          'employer/candidate/get-candidate/$companyId/$id',
          headers: headers);
      Get.log('employer/candidate/get-candidate/$companyId/$id');

      // Get.log(response.request!.url.toString());
      return (response.body);

      throw ServerException("Something went wrong");
    } on SocketException catch (e) {
      throw ServerException("Something went wrong");
    } catch (e) {
      throw ServerException("Something went wrong");
    }
  }

  Future<Response<Candidate>> postCandidate(
      Candidate candidate, String companyId) async {
    try {
      var res = await post('/candidate/store/$companyId', candidate.toJson(),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${appSettings.token}'
          });

      return parseRes(res);
    } on SocketException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteCandidate(String id, String companyId) async =>
      await delete('employer/candidate/destroy/$companyId/$id');
}
