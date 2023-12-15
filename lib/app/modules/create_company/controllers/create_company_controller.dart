import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/data/providers/network/api_provider.dart';
import 'package:hajir/app/modules/create_company/models/company.dart';
import 'package:hajir/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hajir/app/modules/employer_dashboard/controllers/employer_dashboard_controller.dart';
import 'package:hajir/app/modules/login/controllers/login_controller.dart';
import 'package:intl/intl.dart';

var prop = ['1 Month', '3 Months', '6 Months'];

class CreateCompanyController extends GetxController {
  final AttendanceSystemProvider attendanceApi = Get.find();
  var isEdit = false.obs;
  var editLoading = false.obs;
  var officehours = "08:00".obs;

  final count = 0.obs;
  final name = TextEditingController();
  final sickleavedays = TextEditingController();
  final email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();
  final workingDays = TextEditingController();
  final officeHourStart = '8:00'.obs;
  var businessLeaveDays = <int>[].obs;
  final officeHourEnd = '18:00'.obs;
  final code = ''.obs;
  final calculation_type = '30_days'.obs;
  final networkIp = TextEditingController();
  final salaryType = 'monthly'.obs;
  final governmentLeaveDates = <String>[].obs;
  final specialLeaveDates = <String>[].obs;
  final networkType = ''.obs;
  final company = Company().obs;

  var codeType = 'auto'.obs;
  var loading = false.obs;

  var sickLeaveAllowed = "Monthly".obs;
  var sickLeaveDays = "".obs;

  var probationPeroid = prop[0].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.parameters['id'] != null) {
      getCompanyById(Get.parameters['id'] ?? '0');
    }
  }

  getCompanyById(String id) async {
    try {
      isEdit.value = true;
      editLoading(true);
      var result = await attendanceApi.getCompanyById(id);
      company(CompanyData.fromJson((result.body)).data?.company);
      print(result.body);
      setValuesformCompany(company.value);
      editLoading(false);
    } catch (e) {
      editLoading(false);
      Get.rawSnackbar(message: e.toString());
    }
  }

  setValuesformCompany(Company company) {
    name.text = company.name ?? '';
    phone.text = company.phone ?? "";
    address.text = company.address ?? "";
    sickleavedays.text = company.sickLeaveDays ?? "0";
    // officeHourStart(company.officeHourStart);
    // officeHourEnd(company.officeHourEnd);
    officehours(company.workingHours);
    salaryType(company.salaryType);
    businessLeaveDays([
      ...company.companyBusinessLeaves!
          .map((e) => int.parse(e.businessLeave.toString()))
    ]);
    governmentLeaveDates(company.companyGovermentLeaves!
        .map((e) =>
            DateFormat('y-MM-dd').format(e.leaveDate ?? DateTime(0)).toString())
        .toList());
    specialLeaveDates([
      ...company.companySpecialLeaves!
          .map((e) => DateFormat('y-MM-dd').format(e.leaveDate ?? DateTime(0)))
    ]);
    sickLeaveAllowed(company.sickLeaveType);
    sickLeaveDays(company.sickLeaveDays);
    print(company.probationDuration);
    probationPeroid(company.probationDuration == 1
        ? prop[0]
        : company.probationDuration == 6
            ? prop[2]
            : prop[1]);

    // email.text=company.email!;
  }

  addCompany() async {
//   var data=  {
//     "name": "playstation1111111",
//     "office_hour_start": "10:00",
//     "office_hour_end": "18:00",
//     "calculation_type": "calendar_days", // value = calendar_days, 30_days
//     "network_ip": "192.168.10.1",
//     "government_leavedates": [
//        {
//            "leave_date" : "04/04/2017"
//        },
//        {
//             "leave_date" : "04/04/2018"
//        }
//     ],
//     "special_leavedates": [
//        {
//            "leave_date" : "04/04/2017"
//        },
//        {
//             "leave_date" : "04/04/2018"
//        }
//     ],
//     "business_leave": [1,2] , // sunday = 1, monday=2, tuesday = 3, wednesday = 5 so on
//     "leave_duration_type": "Yearly",  // value = Monthly, Yearly, Weekly
//     "leave_duration": 20,
//     "probation_period": 1 // show value like 1 Month = 1, 3 Months =  3, 6 Months = 6

// };
    var body = {
      "name": name.text,
      "email": email.text,
      "phone": phone.text,
      "address": address.text,
      "working_days": 7 - businessLeaveDays.length,

      "office_hour": officehours.value,
      // "office_hour_start": officeHourStart.value,
      // "office_hour_end": officeHourEnd.value,
      "calculation_type": calculation_type.value,
      "network_ip": networkIp.text,
      "salary_type": salaryType.value,
      "leave_duartion_type": sickLeaveAllowed.value,
      "leave_duration": sickleavedays.text,
      "probation_peroid": probationPeroid.value,
      "government_leavedates": [
        ...governmentLeaveDates.map((e) => {"leave_date": e})
      ],
      "special_leavedates": [
        ...specialLeaveDates.map((e) => {"leave_date": e})

        // {"leave_date": "04/04/2017"},
        // {"leave_date": "04/04/2018"}
      ],
      "business_leave": businessLeaveDays
    };
    if (calculation_type.value == 'calendar_days') {
      // "code": "C-0967",
      body["calculation_type"] = "calendar_days";
    }
    if (code.value != '' && codeType.value == 'custom') {
      body["code"] = 0;
    } else {
      body["code"] = 1;
    }

    loading(true);

    print(body);
    try {
      showLoading();

      isEdit.value
          ? await attendanceApi.updateCompanyById(
              Get.parameters['id'].toString(), body)
          : await attendanceApi.addCompany(body);
      Get.back();
      EmployerDashboardController controller = Get.find();
      controller.getCompanies();
      Get.back();
    }
    // on BadRequestException catch (e) {
    //   Get.back();

    //   Get.rawSnackbar(title: e.message, message: e.details);
    // }
    catch (e) {
      Get.back();
      handleException(e);
      // Get.rawSnackbar(message: e.toString());
    }
    loading(false);
  }

  void increment() => count.value++;
}
