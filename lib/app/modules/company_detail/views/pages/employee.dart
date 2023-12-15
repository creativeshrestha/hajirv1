import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

// import 'package:easyqrimage/easyqrimage.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hajir/app/config/app_text_styles.dart';
import 'package:hajir/app/modules/candidatecompanies/views/candidatecompanies_view.dart';
import 'package:hajir/app/modules/company_detail/controllers/company_detail_controller.dart';
import 'package:hajir/app/modules/language/views/language_view.dart';
import 'package:hajir/app/utils/shrimmerloading.dart';
import 'package:hajir/core/localization/l10n/strings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

Future<String?> _scan() async {
  await Permission.camera.request();
  String? barcode = await scanner.scan();
  if (barcode == null) {
    print('nothing return.');
  } else {
    return barcode;
  }
  return null;
}

Future<String?> _scanPhoto() async {
  await Permission.storage.request();
  String barcode = await scanner.scanPhoto();
  return barcode;
}

Future<String?> _scanPath(String path) async {
  await Permission.storage.request();
  String barcode = await scanner.scanPath(path);
  return barcode;
}

Future<File?> _scanBytes() async {
  File file = await ImagePicker.platform
      .pickImage(source: ImageSource.camera)
      .then((picked) {
    if (picked == null) {}
    return File(picked!.path);
  });
  Uint8List bytes = file.readAsBytesSync();
  String barcode = await scanner.scanBytes(bytes);
  barcode;
  return null;
}

Future<Uint8List> generateBarCode(String inputCode) async {
  Uint8List result = await scanner.generateBarCode(inputCode);
  return result;
}

Future<void> captureAndDownload(key) async {
  await Future.delayed(const Duration(milliseconds: 20));
  RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
  var image = await boundary.toImage(pixelRatio: 2);
  ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
  Uint8List? pngBytes = byteData?.buffer.asUint8List();
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  var dir = Platform.isAndroid
      ? '/storage/emulated/0/Download'
      : (await getApplicationDocumentsDirectory()).path;

// Create the file and write the data to it
  var file = File('$dir/report-${DateTime.now().millisecondsSinceEpoch}.png');

  bool alreadyDownloaded = await file.exists();
  if (!alreadyDownloaded) {
    await file.writeAsBytes(pngBytes!);
  }
  // saveFileToDevice('report', pngBytes!);
}

Future<void> captureAndSharePng(key) async {
  await Future.delayed(const Duration(milliseconds: 20));
  try {
    RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
    var image = await boundary.toImage(pixelRatio: 3);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/image.png').create();
    await file.writeAsBytes(pngBytes!);
    // var res = await _scanPath(file.path);
    // print(res);
    await Share.file(
        "Employee Info",
        'emp-${DateTime.now().millisecondsSinceEpoch}.png',
        pngBytes,
        'image/png');
  } catch (e) {
    Get.rawSnackbar(message: e.toString());
  }
}

class EmployeeList extends StatelessWidget {
  const EmployeeList({super.key});

  @override
  Widget build(BuildContext context) {
    final CompanyDetailController controller = Get.find();
    controller.selected = controller.selected == 0 ? 1 : controller.selected;
    // print(controller.emplist.length);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 17,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.employee_list,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 24),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    controller.company.value.name ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.grey.shade600),
                  ),
                ],
              ),
              const Spacer(),
              // IconButton(
              //     onPressed: () async {
              //       var resp = await _scanPhoto();
              //       var candidateInfo = jsonDecode(resp!);
              //       Get.dialog(AlertDialog(
              //         content: Column(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             const SizedBox(
              //               height: 12,
              //             ),
              //             const Text("Name"),
              //             Text(candidateInfo['name'] ?? "NA"),
              //             const SizedBox(
              //               height: 12,
              //             ),
              //             const Text("Phone"),
              //             Text(candidateInfo['phone'] ?? "NA"),
              //             const SizedBox(
              //               height: 12,
              //             ),
              //             const Text("Email"),
              //             Text(candidateInfo['email'] ?? "NA"),
              //             const SizedBox(
              //               height: 12,
              //             ),
              //             CustomButton(
              //                 onPressed: () {
              //                   var candidateId =
              //                       candidateInfo['id'].toString();

              //                   controller.sendInvitation(candidateId);
              //                   Get.back();
              //                 },
              //                 label: "Send Invitation"),
              //           ],
              //         ),
              //       ));
              //     },
              //     icon: const Icon(CupertinoIcons.barcode_viewfinder))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 38.h,
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.r),
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromRGBO(236, 237, 240, 1), blurRadius: 2)
                ],
                color: const Color.fromRGBO(236, 237, 240, 1)),
            child: Obx(
              () => Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        controller.selected = 1;
                      },
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.r),
                              color: controller.selected == 1
                                  ? Colors.white
                                  : Colors.transparent),
                          height: 34.h,
                          width: double.infinity,
                          child: Text(
                            strings.active,
                            style: AppTextStyles.b2,
                          )),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        controller.selected = 2;
                      },
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.r),
                              color: controller.selected == 2
                                  ? Colors.white
                                  : Colors.transparent),
                          height: 32.h,
                          width: double.infinity,
                          child: Text(
                            strings.inactive,
                            style: AppTextStyles.b2,
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Obx(
              () => controller.loading.value
                  ? const Center(child: ShrimmerLoading())
                  : (controller.selected == 2
                              ? controller.invitationlist
                              : controller.emplist)
                          .isEmpty
                      ? Center(
                          child: Text(
                              "No ${controller.selected == 1 ? "Active" : "Inactive"} Employee"),
                        )
                      : RefreshIndicator(
                          onRefresh: () async => controller.getallCandidates(),
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: controller.selected == 2
                                ? controller.invitationlist.length
                                : controller.emplist.length,
                            itemBuilder: ((context, index) => EmployeeWidget(
                                controller: controller,
                                index: index,
                                isEmployee:
                                    controller.selected == 2 ? false : true)),
                          ),
                        ),
            ),
          ),
          //   const SizedBox(
          //     height: 40,
          //   ),
          //   const Text(
          //     "All Candidates", // strings.employee_list,
          //     style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
          //   ),
          //   const SizedBox(
          //     height: 8,
          //   ),
          //   // Text(
          //   //   controller.company.value.name ?? "",
          //   //   style: TextStyle(
          //   //       fontWeight: FontWeight.w400,
          //   //       fontSize: 16,
          //   //       color: Colors.grey.shade600),
          //   // ),

          //   Expanded(
          //     child: Obx(
          //       () => controller.loading.value
          //           ? const Center(child: CircularProgressIndicator())
          //           : ListView.builder(
          //               physics: const AlwaysScrollableScrollPhysics(),
          //               itemCount: controller.invitationlist.length,
          //               itemBuilder: ((context, index) =>
          //                   EmployeeWidget(controller: controller, index: index)),
          //             ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}

class EmployeeWidget extends StatefulWidget {
  const EmployeeWidget(
      {Key? key,
      required this.controller,
      required this.index,
      this.isEmployee = false})
      : super(key: key);

  final CompanyDetailController controller;
  final int index;
  final bool isEmployee;
  @override
  State<EmployeeWidget> createState() => _EmployeeWidgetState();
}

class _EmployeeWidgetState extends State<EmployeeWidget> {
  var isExpanded = false;
  final GlobalKey globalKey = GlobalKey();
  changeCardState() {
    isExpanded = !isExpanded;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEmployee) {
      isExpanded = false;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onLongPress: () {
          Get.dialog(CustomDialogCompanyDetail(
            e: widget.isEmployee
                ? widget.controller.emplist[widget.index]
                : widget.controller.invitationlist[widget.index],
            isEmployer: widget.isEmployee,
          ));
        },
        onTap: () {
          if (widget.isEmployee) {
          } else {
            changeCardState();
          }
        },
        child: Container(
          alignment: Alignment.center,
          height: isExpanded ? 142 : 70,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300)),
          // margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const Icon(
                  CupertinoIcons.profile_circled,
                  color: Colors.grey,
                ),
                // Image.asset(
                //   "assets/Mask group(1).png",
                //   height: 40,
                //   width: 40,
                // ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        widget.isEmployee
                            ? widget.controller.emplist[widget.index]['name'] ??
                                "NA"
                            : widget.controller.invitationlist[widget.index]
                                    ['name'] ??
                                'NA',
                        style: const TextStyle(
                          fontSize: 15,
                        )),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      widget.isEmployee
                          ? widget.controller.emplist[widget.index]['email'] ??
                              "NA".toString() ??
                              "NA"
                          : widget.controller.invitationlist[widget.index]
                                  ['email'] ??
                              "NA".toString() ??
                              'NA',
                      // "RT00${widget.index + 1}",
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                    onPressed: () async {
                      // print(widget.isEmployee);
                      // print(widget.controller.emplist[widget.index]);
                      launchUrlString(
                          'tel:${widget.isEmployee ? widget.controller.emplist[widget.index]['phone'] : widget.controller.invitationlist[widget.index]['phone']}');
                    },
                    icon: SvgPicture.asset("assets/Phone.svg"))
              ]),
              if (isExpanded) ...[
                Row(
                  children: const [
                    // SizedBox(
                    //   width: 64,
                    // ),
                    // Text(
                    //   "Co Founder",
                    //   style:
                    //       TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    // ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(4),
                        onTap: () {
                          if (widget.isEmployee) {
                          } else {
                            var candidateId = (widget.controller
                                .invitationlist[widget.index]['candidate_id']
                                .toString());
                            if (widget.controller.loading.isFalse) {
                              widget.controller.sendInvitation(candidateId);
                            }
                          }
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                                child:
                                    SvgPicture.asset("assets/Vector(2).svg")),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text("Send Invitation"),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            var data = await generateBarCode(jsonEncode(widget
                                .controller.invitationlist[widget.index]));
                            Get.bottomSheet(
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(18),
                                    topRight: Radius.circular(18)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0),
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      RepaintBoundary(
                                          key: globalKey,
                                          child: Image.memory(data)),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0),
                                        child: CustomButton(
                                            onPressed: () {
                                              captureAndSharePng(globalKey);
                                            },
                                            label: "Share"),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              isScrollControlled: true,
                              // ClipRRect(
                              //   borderRadius: const BorderRadius.only(
                              //       topLeft: Radius.circular(18),
                              //       topRight: Radius.circular(18)),
                              //   child: QrGenerator(
                              //       globalKey: globalKey,
                              //       data: jsonEncode(widget.controller
                              //           .invitationlist[widget.index])),
                              // ),
                            );
                            // _captureAndSharePng(globalKey);
                          },
                          icon: SvgPicture.asset(
                              "assets/material-symbols_qr-code-2.svg")),
                      InkWell(
                        borderRadius: BorderRadius.circular(4),
                        onTap: () {
                          var candidateId = (widget
                              .controller
                              .invitationlist[widget.index]['candidatedetails']
                                  ['id']
                              .toString());
                          widget.controller.removeEmployee(candidateId);
                        },
                        child: Row(
                          children: [
                            const Text("Remove"),
                            const SizedBox(
                              width: 8,
                            ),
                            CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                                child:
                                    SvgPicture.asset("assets/Vector(5).svg")),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

// class QrGenerator extends StatelessWidget {
//   const QrGenerator({Key? key, required this.globalKey, required this.data})
//       : super(key: key);

//   final GlobalKey<State<StatefulWidget>> globalKey;
//   final String data;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: AppBottomSheet(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             const SizedBox(
//               height: 20,
//             ),
//             RepaintBoundary(
//               key: globalKey,
//               child: EasyQRImage(
//                 data: data, //Required
//                 size: 280, //Optional
//                 color: Colors.black, //Optional
//                 backgroundColor: Colors.white, //Optional
//                 margin: 5, //Optional
//                 quietZone: 4, //Optional
//                 format: Formats.png, //Optional
//                 charsetSource: Charsets.UTF8, //Optional
//                 charsetTarget: Charsets.UTF8, //Optional
//                 ECC: Ecc.High, //Optional
//               ),
//             ),
            // const SizedBox(
            //   height: 20,
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
            //   child: CustomButton(
            //       onPressed: () {
            //         _captureAndSharePng(globalKey);
            //       },
            //       label: "Share"),
            // ),
            // const SizedBox(
            //   height: 20,
            // )
//           ],
//         ),
//       ),
//     );
//   }
// }
