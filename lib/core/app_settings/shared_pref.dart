import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hajir/app/data/models/user.dart';
import 'package:hajir/app/modules/mobile_opt/controllers/mobile_opt_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferenceKeys {
  static const has_selected_english = "has_selected_english";
}

final AppSettings appSettings = Get.find();

class AppSettings {
  final SharedPreferences _sharedPref;

  AppSettings(this._sharedPref);

  String get token => _sharedPref.getString('token') ?? '';

  bool get isEmployed => _sharedPref.getBool('isEmployed') ?? false;
  String get companyId => _sharedPref.getString('companyId') ?? '';

  String get attendanceId => _sharedPref.getString('attendanceId') ?? '';

  String get breakId => _sharedPref.getString('breakId') ?? '';

  String get candidateId => _sharedPref.getString('candidate_id') ?? '';
  set candidateId(String id) => _sharedPref.setString('candidate_id', id);
  set breakId(String brk) => _sharedPref.setString('breakId', brk);
  set attendanceId(attendanceId) =>
      _sharedPref.setString('attendanceId', attendanceId);

  String get date => _sharedPref.getString('date') ?? '';
  set date(String today) => _sharedPref.setString('date', today);
  set companyId(String companyId) =>
      _sharedPref.setString('companyId', companyId);
  set isEmployed(bool employed) => _sharedPref.setBool('isEmployed', employed);
  set token(String tkn) => _sharedPref.setString('token', tkn);

  String get refresh => _sharedPref.getString('refresh') ?? '';
  set refresh(String rtoken) => _sharedPref.setString('refresh', rtoken);

  String get name => _sharedPref.getString('name') ?? '';
  String get email => _sharedPref.getString('eEmail') ?? '';
  String get phone => _sharedPref.getString('phone') ?? '';
  bool get employer => _sharedPref.getBool('emp') ?? false;
  String get selectedlanguage =>
      _sharedPref.getString('selected_language') ?? '';
  String get type => _sharedPref.getString('type') ?? 'candidate';

  ///setters
  set type(String tp) => _sharedPref.setString('type', tp);
  set name(String ename) => _sharedPref.setString('name', ename);
  set email(String eEmail) => _sharedPref.setString('eEmail', eEmail);
  set phone(String ephone) => _sharedPref.setString('phone', ephone);
  set employer(bool emp) => _sharedPref.setBool('emp', emp);
  set selectedlanguage(String lang) =>
      _sharedPref.setString('selected_language', lang);

  String get previousLoginDate =>
      _sharedPref.getString('previousLoginDate') ?? "";
  String get previousLoginTime =>
      _sharedPref.getString('previousLoginTime') ?? "00:))";
  String get breakStartTime => _sharedPref.getString('breakStartTime') ?? "";
  String get breakEndTime => _sharedPref.getString('breakEndTime') ?? "";
  String get logoutTime => _sharedPref.getString('breakEndTime') ?? "";

  set previousLoginDate(String loginDate) =>
      _sharedPref.setString('previousLoginDate', loginDate);
  set previousLoginTime(String loginDate) =>
      _sharedPref.setString('previousLoginTime', loginDate) ?? "";
  set breakStartTime(String loginDate) =>
      _sharedPref.setString('breakStartTime', loginDate) ?? "";
  set breakEndTime(String loginDate) =>
      _sharedPref.setString('breakEndTime', loginDate) ?? "";
  set logoutTime(String loginDate) =>
      _sharedPref.setString('breakEndTime', loginDate) ?? "";
  Locale getLocale() {
    bool isEnglish =
        _sharedPref.getBool(AuthPreferenceKeys.has_selected_english) ?? true;
    return Locale(isEnglish ? 'en' : 'ne');
  }

  clearLoginState() {
    previousLoginDate = '';
    previousLoginTime = '';
    breakEndTime = '';
    breakStartTime = '';
    logoutTime = '';
  }

  bool get isEnglish =>
      _sharedPref.getBool(AuthPreferenceKeys.has_selected_english) ?? true;

  void changeLang({bool en = true}) async {
    appSettings.selectedlanguage = en ? 'en' : 'ne';
    log(en.toString());
    _sharedPref.setBool(AuthPreferenceKeys.has_selected_english, en);
    Get.updateLocale(Locale(en ? 'en' : 'ne'));
  }

  saveUser(UserModel user) {
    name = user.name.toString();
    email = user.email.toString();
    phone = user.phone.toString();
    employer = user.type ?? false;
  }

  UserModel getuser() {
    return UserModel(name: name, email: email, phone: phone, type: employer);
  }

  void logout() {
    isEmployed = false;
    token = '';
    refresh = '';
    _sharedPref.clear();
  }

  bool isPreviouslyLoggedIn() {
    var result = false;
    if (previousLoginDate.isNotEmpty) {
      result = previousLoginDate.substring(0, 10).replaceAll(":", '-') ==
          DateTime.now().toString().substring(0, 10);
    }

    return result;
  }

  void saveLoginState() {
    var date;
    var loginTime;
    var breakStartTime;
    var breakEndTime;
    var logoutTime;
  }
}
