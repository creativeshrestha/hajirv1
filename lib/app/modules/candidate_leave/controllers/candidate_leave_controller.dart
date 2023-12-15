import 'package:get/get.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/modules/candidate_leave/leave_report_model.dart';
import 'package:hajir/app/modules/candidate_leave/providers/leave_report_provider.dart';
import 'package:hajir/app/modules/company_detail/controllers/company_detail_controller.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/inbox/models/inbox_response.dart';
import 'package:hajir/app/modules/login/controllers/login_controller.dart';

class CandidateLeaveController extends GetxController
    with StateMixin<LeaveReport> {
  //TODO: Implement CandidateLeaveController
// employer/candidateLeave/detail/35
  final LeaveReportProvider leaveReportProvider;
  final attendanceSystemProvider = Get.find<AttendanceSystemProvider>();
  final CompanyDetailController controller = Get.find();
  var leaves = {}.obs;
  var inboxResponse = InboxResponse.fromJson({}).obs;
  var loading = false.obs;
  final count = 0.obs;
  var leaveId = "0".obs;
  var payType = "Paid".obs;
  var leaveDetail = <String, dynamic>{}.obs;
  LeaveRequest get leave => LeaveRequest.fromJson(leaveDetail);
  CandidateLeaveController(this.leaveReportProvider);

  approveLeave(id) async {
    try {
      loading(true);
      showLoading();
      var data =
          await attendanceSystemProvider.approve(id, payType: payType.value);
      // inboxResponse.value.data?.candidates!
      //     .firstWhere((e) => e.leaveId == id)
      //     .status = 'Approved';
      Get.back();
      getLeaveDetail();
      showSnackBar(data.body['message']);

      loading(false);
    } catch (e) {
      loading(false);
      Get.back();
      handleException(e);
    }
  }

  rejectLeave(id) async {
    try {
      change(state, status: RxStatus.loading());
      showLoading();
      var data = await attendanceSystemProvider.approve(id,
          status: 'Rejected', payType: payType.value);
      // inboxResponse.value.data!.candidates!
      //     .firstWhere((e) => e.leaveId == id)
      //     .status = 'Approved';
      Get.back();
      showSnackBar(data.body['message']);
      getLeaveDetail();

      loading(false);
    } catch (e) {
      Get.back();
      handleException(e);
    }
  }

  @override
  void onInit() {
    super.onInit();
    print(Get.arguments);
    leaveId(Get.arguments['leave_id'].toString());
    leaveDetail(Get.arguments);
    getLeaveDetail();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void getLeaveDetail() {
    change(state, status: RxStatus.loading());
    try {
      leaveReportProvider.getLeaveReport(leaveId.value).then((value) {
        change(value, status: RxStatus.success());
      });
    } catch (e) {
      change(state, status: RxStatus.error(e.toString()));
    }
  }
}
