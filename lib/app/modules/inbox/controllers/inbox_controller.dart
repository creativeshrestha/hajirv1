import 'package:get/get.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/modules/company_detail/controllers/company_detail_controller.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/inbox/models/inbox_response.dart';
import 'package:hajir/app/modules/login/controllers/login_controller.dart';

class InboxController extends GetxController {
  final attendanceSystemProvider = Get.find<AttendanceSystemProvider>();
  final CompanyDetailController controller = Get.find();
  var leaves = {}.obs;
  var inboxResponse = InboxResponse.fromJson({}).obs;
  var loading = false.obs;
  getAllLeaves() async {
    loading(true);
    var data = await attendanceSystemProvider
        .allLeave(controller.company.value.id.toString());
    inboxResponse(InboxResponse.fromJson(data.body));
    leaves(data.body['data']);
    loading(false);
  }

  // approveLeave(id) async {
  //   try {
  //     loading(true);

  //     var data = await attendanceSystemProvider.approve(id);
  //     inboxResponse.value.data!.candidates!
  //         .firstWhere((e) => e.leaveId == id)
  //         .status = 'Approved';

  //     showSnackBar(data.body['message']);

  //     loading(false);
  //   } catch (e) {
  //     loading(false);
  //     Get.back();
  //     handleException(e);
  //   }
  // }

  // rejectLeave(id) async {
  //   try {
  //     loading(true);
  //     showLoading();
  //     var data = await attendanceSystemProvider.approve(id, status: 'Rejected');
  //     inboxResponse.value.data!.candidates!
  //         .firstWhere((e) => e.leaveId == id)
  //         .status = 'Approved';
  //     Get.back();
  //     showSnackBar(data.body['message']);

  //     loading(false);
  //   } catch (e) {
  //     Get.back();
  //     handleException(e);
  //   }
  // }

  @override
  void onInit() {
    super.onInit();
    getAllLeaves();
  }
}
