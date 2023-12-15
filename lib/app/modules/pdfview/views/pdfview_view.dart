import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';

import '../controllers/pdfview_controller.dart';

class PdfviewView extends GetView<PdfviewController> {
  const PdfviewView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Report'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Html(
            data: Get.arguments.toString(),
            // style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
