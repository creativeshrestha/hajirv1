import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/data/providers/attendance_provider.dart';
import 'package:hajir/app/data/providers/network/api_endpoint.dart';
import 'package:hajir/app/data/providers/network/response_handler.dart';
import 'package:hajir/app/modules/dashboard/views/bottom_sheets/profile.dart';
import 'package:hajir/app/modules/language/views/language_view.dart';
import 'package:hajir/app/modules/login/controllers/login_controller.dart';
import 'package:hajir/app/modules/mobile_opt/controllers/mobile_opt_controller.dart';
import 'package:hajir/app/utils/validators.dart';
import 'package:hajir/core/app_settings/shared_pref.dart';
import 'package:hajir/core/localization/l10n/strings.dart';

var baseUrl = APIEndpoint.baseUrl;
var globalHeaders = {
  'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
  'Accept': 'application/json',
  // 'Content-Type': 'application/json',
};

class ApplyLeaveProvider extends GetConnect {
  final ApiResponseHandler responsehandler = Get.find();

  @override
  void onInit() {
    var baseUrl = APIEndpoint.baseUrl;
    httpClient.baseUrl = baseUrl;
    httpClient.timeout = 300.seconds;
  }

  Future<BaseResponse> getAllLeaveTypes() async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var res = await get('candidate/leave-types/${appSettings.companyId}',
        headers: globalHeaders);
    return parseRes(res);
  }

  Future<BaseResponse> applyLeave(FormData body) async {
    globalHeaders['Authorization'] = 'Bearer ${appSettings.token}';
    var res = await post('candidate/store-leave/${appSettings.companyId}', body,
        headers: globalHeaders);
    // print(res.statusCode);
    // print(res.request!.url);
    log(res.body.toString());
    return parseRes(res);
  }
}

class ApplyLeaveController extends GetxController {
  final ApplyLeaveProvider repository = Get.find();
  final start_date = TextEditingController();
  final end_date = TextEditingController();
  final image = ''.obs;
  final start_time = TextEditingController();
  final remarks = TextEditingController();
  final leave_type = ''.obs;
  final _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;
  var selected_leave = ''.obs;
  var allLeaveTypes = [].obs;
  var available_leave = {}.obs;
  var leave_options = [
    {
      'id': 'Full',
      'title': 'Full Day',
    },
    {'id': "Half", 'title': 'Half Day'}
  ];
  @override
  onInit() {
    super.onInit();
    getAllLeaveTypes();
  }

  getAllLeaveTypes() async {
    try {
      var result = await repository.getAllLeaveTypes();

      allLeaveTypes(result.body['data']['leaveTypes']);
      available_leave(result.body['data']['avaliable_leave']);
    } catch (e) {
      Get.rawSnackbar(message: e.toString());
    }
  }

  onSubmit() async {
    try {
      var body = {
        'leave_type_id': selected_leave.value,
        'remarks': remarks.text,
        'start_date': start_date.text,
        'end_date': end_date.text,
        'type': leave_type.value
      };

      var formData = FormData(body);
      if (image.value.isNotEmpty) {
        formData.files.add(MapEntry(
            'document',
            MultipartFile(File(image.value),
                filename: image.value.split('/').last)));
      }
      for (var e in formData.files) {
        print(e.key.toString());
      }
      print(formData.files.toString());
      showLoading();
      var result = await repository.applyLeave(formData);
      // print(result.body);
      // clearAll();
      Get.back();
      Get.back();
      Get.dialog(const AlertDialog(
        content: ApplySuccess(),
      ));
    } catch (e) {
      log(e.toString());
      Get.back();
      Get.rawSnackbar(message: e.toString());
    }
  }

  void clearAll() {
    leave_type.value = '';
    remarks.clear();
    image('');
    start_date.clear();
    end_date.clear();
  }
}

class ApplyLeave extends GetView<ApplyLeaveController> {
  ApplyLeave({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // controller.getAllLeaveTypes();
    return SafeArea(
      child: SingleChildScrollView(
        child: AppBottomSheet(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleWidget(title: strings.apply_for_leave),
                // Center(
                //   child: Row(
                //     // mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Align(
                //         alignment: Alignment.topLeft,
                //         child: InkWell(
                //             onTap: () {
                //               Get.back();
                //             },
                //             child: Icon(Icons.close)),
                //       ),
                //       Center(
                //         child: Text(
                //           strings.apply_for_leave,
                //           style: Theme.of(context).textTheme.headline6,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Available leave",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      'Sick ',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    Obx(() => Text(
                          "[${controller.available_leave['sick_leave'] ?? ""}]",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                    const SizedBox(
                      width: 16,
                    ),
                    const Text(
                      'Casual ',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    Obx(() => Text(
                          "[${controller.available_leave['casual_leave'] ?? ""}]",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Obx(
                  () => DropdownButtonFormField(
                    validator: validateIsEmpty,
                    isDense: true,
                    style:
                        AppTextStyles.l1.copyWith(fontWeight: FontWeight.w600),
                    // style:
                    //     TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        hintText: controller.allLeaveTypes.isEmpty
                            ? 'Loading ...'
                            : strings.leave_type,
                        // hintStyle: TextStyle(
                        //     fontSize: 15.sp, fontWeight: FontWeight.w600),
                        hintStyle: AppTextStyles.l1
                            .copyWith(fontWeight: FontWeight.w600),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                    items: controller.allLeaveTypes.isEmpty
                        ? null
                        : controller.allLeaveTypes
                            .map((element) => DropdownMenuItem(
                                value: element['id'].toString(),
                                child: Text(element['title'].toString())))
                            .toList(),
                    onChanged: (String? value) {
                      controller.selected_leave(value!);
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField(
                  validator: validateIsEmpty,
                  // value: controller.leave_type.value,
                  isDense: true,
                  style: AppTextStyles.l1.copyWith(fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      hintText: 'Type',
                      hintStyle: AppTextStyles.l1
                          .copyWith(fontWeight: FontWeight.w600),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300)),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                  items: controller.leave_options
                      .map((element) => DropdownMenuItem(
                          value: element['id'].toString(),
                          child: Text(element['title'].toString())))
                      .toList(),
                  onChanged: (String? value) {
                    controller.leave_type(value!);
                  },
                ),
                // Obx(() => controller.leave_type.value ==
                //             controller.leave_options[0]['id'] ||
                //         controller.leave_type.value.isEmpty
                //     ? const SizedBox()
                //     : const SizedBox(
                //         height: 20,
                //       )),
                // Obx(
                //   () => controller.leave_type.value ==
                //               controller.leave_options[0]['id'] ||
                //           controller.leave_type.value.isEmpty
                //       ? const SizedBox()
                //       : InkWell(
                //           onTap: () async {
                //             var now = DateTime.now();
                //             var date = await showTimePicker(
                //               context: context,
                //               initialTime: TimeOfDay.now(),
                //             );
                //             if (date != null) {
                //               // print(date);
                //               {
                //                 controller.start_time.text =
                //                     date.format(context);
                //               }
                //               // controller.start_date.text = date.format(context).substring(0, 10);
                //             }
                //           },
                //           child: TextFormField(
                //             enabled: false,
                //             controller: controller.start_time,
                //             decoration: InputDecoration(
                //                 labelText: "Leave Start Time",
                //                 hintText: strings.duration,
                //                 contentPadding: const EdgeInsets.symmetric(
                //                     horizontal: 8, vertical: 8),
                //                 hintStyle: AppTextStyles.l1,
                //                 focusedBorder: OutlineInputBorder(
                //                     borderSide: BorderSide(
                //                         color: Colors.grey.shade400)),
                //                 disabledBorder: OutlineInputBorder(
                //                     borderSide: BorderSide(
                //                         color: Colors.grey.shade300)),
                //                 enabledBorder: OutlineInputBorder(
                //                     borderSide: BorderSide(
                //                         color: Colors.grey.shade300)),
                //                 border: const OutlineInputBorder(
                //                     borderSide:
                //                         BorderSide(color: Colors.grey))),
                //           ),
                //         ),
                // ),

                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    var now = DateTime.now();
                    var date = await showDatePicker(
                        context: context,
                        initialDate: now,
                        firstDate: now,
                        lastDate: now.add(365.days));
                    if (date != null) {
                      controller.start_date.text =
                          date.toString().substring(0, 10);
                    }
                  },
                  child: TextFormField(
                    enabled: false,
                    controller: controller.start_date,
                    style:
                        AppTextStyles.l1.copyWith(fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                        labelText: "Leave Start Date",
                        hintText: strings.duration,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        hintStyle: AppTextStyles.l1
                            .copyWith(fontWeight: FontWeight.w600),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        disabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    var now = DateTime.now();
                    var date = await showDatePicker(
                        context: context,
                        initialDate: now,
                        firstDate: now,
                        lastDate: now.add(365.days));
                    if (date != null) {
                      controller.end_date.text =
                          date.toString().substring(0, 10);
                    }
                  },
                  child: TextFormField(
                    enabled: false,
                    style:
                        AppTextStyles.l1.copyWith(fontWeight: FontWeight.w600),
                    validator: validateIsEmpty,
                    controller: controller.end_date,
                    decoration: InputDecoration(
                        labelText: 'Leave End Date',
                        hintText: strings.duration,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        hintStyle: AppTextStyles.l1,
                        disabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    // var image = await ImagePicker().pickImage(
                    //     source: ImageSource.gallery, imageQuality: 50);
                    var image = (await FilePicker.platform.pickFiles(
                      allowCompression: true,
                      allowMultiple: false,
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'pdf', 'doc'],
                    ));
                    if (image != null) {
                      controller.image(image.files.first.path);
                    }
                  },
                  child: Obx(
                    () => Container(
                      // height: 48.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DottedBorder(
                        color: Colors.grey.shade300,
                        borderType: BorderType.RRect,
                        padding: const EdgeInsets.all(6),
                        radius: const Radius.circular(4),
                        child: TextFormField(
                          enabled: false,
                          style: AppTextStyles.l1.copyWith(
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // maxLength: 20,
                          // maxLines: 2,
                          controller: TextEditingController(
                              text: controller.image.value
                                          .split('/')
                                          .last
                                          .length >
                                      50
                                  ? '${controller.image.value.split('/').last.toString().substring(0, 50)}...'
                                  : controller.image.value
                                      .split('/')
                                      .last
                                      // .length
                                      .toString()),

                          decoration: InputDecoration(
                              fillColor:
                                  Colors.grey.shade200, //Color(0xffDDDDDD),
                              filled: true,
                              labelText: ' + Upload Docs [ jpeg/pdf ]',
                              isDense: true,
                              hintText: strings.upload_image,
                              hintStyle: AppTextStyles.l1.copyWith(
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis,
                              ),
                              disabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade200)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300)),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey))),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: AppTextStyles.l1.copyWith(fontWeight: FontWeight.w600),
                  controller: controller.remarks,
                  validator: validateIsEmpty,
                  maxLines: 4,
                  decoration: InputDecoration(
                      hintText: strings.remarks,
                      hintStyle: AppTextStyles.l1
                          .copyWith(fontWeight: FontWeight.w600),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300)),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                ),
                const SizedBox(
                  height: 40,
                ),
                CustomButton(
                    onPressed: () {
                      if (controller.end_date.text == '') {
                        if (!Get.isSnackbarOpen) {
                          Get.rawSnackbar(message: '* Complete All Fields');
                        }
                      } else if (formKey.currentState!.validate()) {
                        controller.onSubmit();
                      }
                      // Get.bottomSheet(
                      //     const Material(
                      //         color: Colors.white, child: ApplySuccess()),
                      //     isScrollControlled: true);
                    },
                    label: "Submit"),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ApplySuccess extends StatelessWidget {
  const ApplySuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     // const CloseButton(),
            //     // const SizedBox(
            //     //   width: 16,
            //     // ),
            //     Text(
            //       "Apply For Leave",
            //       style: Theme.of(context).textTheme.headline6,
            //       textAlign: TextAlign.center,
            //     ),
            //     // const Spacer()
            //   ],
            // ),
            // const SizedBox(
            //   height: 40,
            // ),
            const Text(
              """Successfully 
sent your request.""",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              """We’ve received your request. 
We will get back to you""",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            ),
            const SizedBox(
              height: 40,
            ),
            CustomButton(
                onPressed: () {
                  Get.back();
                },
                label: "Close"),
            const SizedBox(
              height: 20,
            ),
          ]),
    ));
  }
}
