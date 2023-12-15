import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// AppTextStyle format as follows:
/// [fontWeight][fontSize][colorName][opacity]
/// Example: bold18White05
///
class AppTextStyles {
  static TextStyle title = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static TextStyle body = const TextStyle(
    fontSize: 13,
    color: Colors.grey,
  );
  TextStyle large = TextStyle(
      fontSize: 33.95.sp, fontWeight: FontWeight.w700, color: Colors.white);
  static TextStyle medium = const TextStyle(fontSize: 14, color: Colors.grey);
  static TextStyle regular =
      const TextStyle(fontSize: 19, fontWeight: FontWeight.w400);
  static TextStyle l1 = TextStyle(
      fontSize: 14.sp, color: Colors.grey, fontWeight: FontWeight.normal);
  static TextStyle l2 = const TextStyle(fontSize: 10, color: Colors.grey);
  static TextStyle b1 =
      const TextStyle(fontWeight: FontWeight.w700, fontSize: 16);
  static TextStyle b2 =
      const TextStyle(fontWeight: FontWeight.w600, fontSize: 14);

  static var normal =
      const TextStyle(fontSize: 15, fontWeight: FontWeight.w400);
  static var accountStyle =
      const TextStyle(fontSize: 15, fontWeight: FontWeight.w500);
}
