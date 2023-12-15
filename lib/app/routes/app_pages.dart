import 'package:get/get.dart';

import '../modules/add_employee/bindings/add_employee_binding.dart';
import '../modules/add_employee/views/add_employee_view.dart';
import '../modules/candidate_leave/bindings/candidate_leave_binding.dart';
import '../modules/candidate_leave/views/candidate_leave_view.dart';
import '../modules/candidate_login/bindings/candidate_login_binding.dart';
import '../modules/candidate_login/views/candidate_login_view.dart';
import '../modules/candidatecompanies/bindings/candidatecompanies_binding.dart';
import '../modules/candidatecompanies/views/candidatecompanies_view.dart';
import '../modules/company_detail/bindings/company_detail_binding.dart';
import '../modules/company_detail/views/company_detail_view.dart';
import '../modules/create_company/bindings/create_company_binding.dart';
import '../modules/create_company/views/create_company_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/employer_dashboard/bindings/employer_dashboard_binding.dart';
import '../modules/employer_dashboard/views/employer_dashboard_view.dart';
import '../modules/enroll_attendee/bindings/enroll_attendee_binding.dart';
import '../modules/enroll_attendee/views/enroll_attendee_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/inbox/bindings/inbox_binding.dart';
import '../modules/inbox/views/inbox_view.dart';
import '../modules/initial/bindings/initial_binding.dart';
import '../modules/initial/views/initial_view.dart';
import '../modules/language/bindings/language_binding.dart';
import '../modules/language/views/language_view.dart';
import '../modules/leave_report/bindings/leave_report_binding.dart';
import '../modules/leave_report/views/leave_report_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/missing_attendance/bindings/missing_attendance_binding.dart';
import '../modules/missing_attendance/views/missing_attendance_view.dart';
import '../modules/mobile_opt/bindings/mobile_opt_binding.dart';
import '../modules/mobile_opt/views/mobile_opt_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/pdfview/bindings/pdfview_binding.dart';
import '../modules/pdfview/views/pdfview_view.dart';
import '../modules/welcome/bindings/welcome_binding.dart';
import '../modules/welcome/views/welcome_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LANGUAGE;
  static const DASHBOARD = Routes.DASHBOARD;
  static const WELCOME = Routes.WELCOME;
  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LANGUAGE,
      page: () => const LanguageView(),
      binding: LanguageBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => const WelcomeView(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.MOBILE_OPT,
      page: () => const MobileOptView(),
      binding: MobileOptBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.CANDIDATE_LOGIN,
      page: () => const CandidateLoginView(),
      binding: CandidateLoginBinding(),
    ),
    GetPage(
      name: _Paths.EMPLOYER_DASHBOARD,
      page: () => const EmployerDashboardView(),
      binding: EmployerDashboardBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_COMPANY,
      page: () => const CreateCompanyView(),
      binding: CreateCompanyBinding(),
    ),
    GetPage(
      name: _Paths.COMPANY_DETAIL,
      page: () => const CompanyDetailView(),
      binding: CompanyDetailBinding(),
    ),
    GetPage(
      name: _Paths.ADD_EMPLOYEE,
      page: () => const AddEmployeeView(),
      binding: AddEmployeeBinding(),
    ),
    GetPage(
      name: _Paths.INBOX,
      page: () => const InboxView(),
      binding: InboxBinding(),
    ),
    GetPage(
      name: _Paths.ENROLL_ATTENDEE,
      page: () => const EnrollAttendeeView(),
      binding: EnrollAttendeeBinding(),
    ),
    GetPage(
      name: _Paths.MISSING_ATTENDANCE,
      page: () => const MissingAttendanceView(),
      binding: MissingAttendanceBinding(),
    ),
    GetPage(
      name: _Paths.INITIAL,
      page: () => const InitialView(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: _Paths.CANDIDATECOMPANIES,
      page: () => const CandidatecompaniesView(),
      binding: CandidatecompaniesBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.LEAVE_REPORT,
      page: () => const LeaveReportView(),
      binding: LeaveReportBinding(),
    ),
    GetPage(
      name: _Paths.PDFVIEW,
      page: () => const PdfviewView(),
      binding: PdfviewBinding(),
    ),
    GetPage(
      name: _Paths.CANDIDATE_LEAVE,
      page: () => const CandidateLeaveView(),
      binding: CandidateLeaveBinding(),
    ),
  ];
}
