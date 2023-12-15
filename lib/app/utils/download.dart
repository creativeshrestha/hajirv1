import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

var count = 0;

Future<String?> saveFileToDevice(String filename, Uint8List data) async {
// Get the path to the app's documents directory
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }

  var dir = Platform.isAndroid
      ? '/storage/emulated/0/Download'
      : (await getApplicationDocumentsDirectory()).path;

// Create the file and write the data to it
  var file = File('$dir/$filename');

  bool alreadyDownloaded = await file.exists();

  String incrementCount(String fileName) {
    int dotIndex = fileName.lastIndexOf('.');
    String newFileName =
        "${fileName.substring(0, dotIndex)}(${count += 1})${fileName.substring(dotIndex)}";

    return newFileName;
  }

  if (alreadyDownloaded) {
    String newFileName = incrementCount(file.path);

    var newFile = File(newFileName);
    await newFile.writeAsBytes(data, flush: true);

    String subStringFileName = newFileName.substring(29);
    // CommonWidgets.makeToast(
    //     fontSize: 14,
    //     toastMsg: '${subStringFileName} saved to Downloads Folder');

    file = newFile;
    print('modified updating ....--> $file');
  } else {
    await file.writeAsBytes(data, flush: true);

    // CommonWidgets.makeToast(
    //     fontSize: 14, toastMsg: '${filename} saved to Downloads Folder');
  }

  return 'file://${file.path}';
}
