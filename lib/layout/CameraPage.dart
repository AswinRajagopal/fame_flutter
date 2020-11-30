import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:fame_mobile_flutter/utility/sharedPref.dart';
import 'package:fame_mobile_flutter/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http_parser/http_parser.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPage createState() => _CameraPage();
}

class _CameraPage extends State<CameraPage> {
  CameraController controller;
  List<CameraDescription> cameras;
  ProgressDialog pr;
  File imgfile;

  @override
  void initState() {
    super.initState();
    initCam();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Stack(
          children: <Widget>[
            CameraPreview(controller),
            Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                  height: 50,
                  minWidth: 150,
                  child: Container(
                      height:50,
                      width: 100
                      ,child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                    Text(
                      "Capture",
                      style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ])),
                  onPressed: () {
                    takePicture();
                  },
                  color: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: Colors.red)),
                ))
          ],
        ));
  }

  initCam() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[1], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  networkcall(File imageFile) async {
    MyPref myPref = new MyPref();
    Uri url = Uri.parse(Utility.guiseUrl() + "upload_image");
    var stream = new http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    stream.cast();
    var request = new http.MultipartRequest("POST", url);
    request.fields['access_key'] = 'diyos2020';
    request.fields['companyID'] = '6';
    request.files.add(MultipartFile("image", stream, length,
        contentType: new MediaType('application', 'octet-stream'),filename: "image.jpg"));
    request.send().then((response) async {
      print(await response.stream.transform(utf8.decoder).join());
      if (response.statusCode == 200) print("Uploaded!");
    });
  }

  onError(error) {
    pr.hide();
    Utility.showToast("Server error");
  }

   takePicture() async {
    if (!controller.value.isInitialized) {
      Utility.showToast('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/image.jpg';
    var dir = Directory(filePath);
    try {
      dir.deleteSync(recursive: true);
    }catch(e){
      print(e.toString());
    }
    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    File file = new File(filePath);
    networkcall(file);
  }

  void _showCameraException(CameraException e) {
    print(e.code + e.description);
    Utility.showToast('Error: ${e.code}\n${e.description}');
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        Utility.showToast('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }
}
