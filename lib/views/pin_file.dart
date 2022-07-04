import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';
import '../controllers/my_pin_controller.dart';
import '../utils/utils.dart';
import 'package:path/path.dart' as path;

class AttachImg extends StatefulWidget {
  @override
  _AttachImgState createState() => _AttachImgState();
}

class _AttachImgState extends State<AttachImg> {
  final MyPinController mpC = Get.put(MyPinController());
  CameraController controller;
  List<CameraDescription> cameras;
  var currentTime = DateFormat().add_jm().format(DateTime.now()).toString();
  File attachment;
  var clientId;
  final TextEditingController remarks = TextEditingController();
  final TextEditingController clientText = TextEditingController();
  final TextEditingController attach = TextEditingController();
  var size;
  var deviceRatio;
  var xScale;
  var faceApi;
  var activity;

  @override
  void initState() {
    super.initState();
    if (RemoteServices().box.get('faceApi') == 1) {
      initCam();
    } else {
      mpC.getCurrentLocation();
    }
    mpC.pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: false,
      customBody: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 15.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              width: 20.0,
            ),
            Text(
              'Processing please wait...',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
    mpC.pr.style(
      backgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void initCam() async {
    cameras = await availableCameras();
    controller = CameraController(
      cameras[1],
      ResolutionPreset.medium,
    );
    await controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    mpC.getCurrentLocation();
  }

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

  void _showCameraException(CameraException e) {
    print(e.code + e.description);
    Get.snackbar(
      null,
      '${e.code}\n${e.description}',
      colorText: Colors.white,
      backgroundColor: Colors.black87,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 10.0,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 18.0,
      ),
      borderRadius: 5.0,
    );
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
        Get.snackbar(
          null,
          '${controller.value.errorDescription}',
          colorText: Colors.white,
          backgroundColor: Colors.black87,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 10.0,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 18.0,
          ),
          borderRadius: 5.0,
        );
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

  void takePicture(type) async {
    var file;
    var res;
    if (type == 1) {
      if (!controller.value.isInitialized) {
        Get.snackbar(
          null,
          'select a camera first.',
          colorText: Colors.white,
          backgroundColor: Colors.black87,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 10.0,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 18.0,
          ),
          borderRadius: 5.0,
        );
        return null;
      }
      final extDir = await getApplicationDocumentsDirectory();
      final dirPath = '${extDir.path}/Pictures/flutter_test';
      await Directory(dirPath).create(recursive: true);
      final filePath = '$dirPath/image.jpg';
      var dir = Directory(filePath);
      try {
        dir.deleteSync(recursive: true);
      } catch (e) {
        print(e.toString());
      }
      if (controller.value.isTakingPicture) {
        return null;
      }

      try {
        await controller.takePicture(filePath);
      } on CameraException catch (e) {
        _showCameraException(e);
        return null;
      }
      file = File(filePath);
      res = await mpC.uploadImage(file);
    } else {
      res = true;
    }

    print(res);
    if (res != null && res) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().innerScaffoldBg,
      appBar: AppBar(
          title: Text(
        'Pin My Visit',
      )),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 18.0,
              ),
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: clientText,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18.0,
                    ),
                    hintText: 'Enter client name',
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  if (pattern.isNotEmpty) {
                    return await RemoteServices().getBranchClientsSugg(pattern);
                  } else {
                    clientId = null;
                  }
                  return null;
                },
                hideOnEmpty: true,
                noItemsFoundBuilder: (context) {
                  return Text('No client found');
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(
                      suggestion['name'],
                    ),
                    subtitle: Text(
                      suggestion['id'],
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  print(suggestion);
                  print(suggestion['name']);
                  clientId = suggestion['id'];
                  clientText.text = suggestion['name'].toString().trimRight() +
                      ' - ' +
                      suggestion['id'];
                },
                autoFlipDirection: true,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5.0,
              ),
              child: DropdownButtonFormField<dynamic>(
                hint: Text(
                  'Select activity',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18.0,
                  ),
                ),
                isExpanded: false,
                value: activity,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10.0),
                ),
                items: mpC.activityList.map((item) {
                  //print('item: $item');
                  return DropdownMenuItem(
                    child: Text(
                      item['activityName'],
                    ),
                    value: item['activityName'].toString(),
                  );
                }).toList(),
                onChanged: (value) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  activity = value;
                  setState(() {});
                },
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5.0,
              ),
              child: TextField(
                controller: attach,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(10),
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18.0,
                  ),
                  hintText: 'Attachment',
                  suffixIcon: Image.asset(
                    'assets/images/uplode_proof.png',
                    scale: 2.2,
                  ),
                ),
                readOnly: true,
                keyboardType: null,
                onTap: () async {
                  var pickedFile = await ImagePicker().getImage(
                    source: ImageSource.camera,
                    imageQuality: 50,
                  );
                  if (pickedFile != null) {
                    attachment = new File(pickedFile.path);
                    attach.text = path.basename(pickedFile.path);
                    setState(() {});
                  } else {
                    print('No image selected.');
                    setState(() {});
                  }
                },
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 18.0,
              ),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 8,
                maxLength: 1000,
                controller: remarks,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.all(
                    10.0,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18.0,
                  ),
                  hintText: 'Enter remarks',
                ),
              ),
            ),
            Flexible(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 70.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey[300],
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlatButton(
                        onPressed: () {
                          print('Cancel');
                          Get.back();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () async {
                          print('Submit');
                          FocusScope.of(context).requestFocus(FocusNode());
                          await mpC.pr.show();
                          var base64String = '';
                          if (attachment != null) {
                            final bytes =
                                await File(attachment.path).readAsBytes();
                            // print(base64.encode(bytes));
                            base64String = base64.encode(bytes);
                          }
                          var pinVisit = await RemoteServices().pinMyVisit(
                              empId: RemoteServices().box.get('empid'),
                              checkinLat: mpC.currentPosition.latitude,
                              checkinLng: mpC.currentPosition.longitude,
                              empRemarks: remarks.text,
                              attachment: base64String,
                              address: mpC.currentAddress,
                              clientID: clientId,
                              activity: activity);
                          print(pinVisit);
                          if (pinVisit != null && pinVisit['success'] == true) {
                            await mpC.pr.hide();
                            Get.snackbar(
                              null,
                              'PinMyVisit created successfully',
                              colorText: Colors.white,
                              duration: Duration(seconds: 2),
                              backgroundColor: AppUtils().greenColor,
                              snackPosition: SnackPosition.BOTTOM,
                              margin: EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 10.0,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 18.0,
                              ),
                              borderRadius: 5.0,
                            );
                            Timer(Duration(seconds: 2), Get.back);
                          } else {
                            await mpC.pr.hide();
                            Get.snackbar(
                              null,
                              'Something went wrong! Please try again later',
                              colorText: Colors.white,
                              backgroundColor: Colors.black87,
                              snackPosition: SnackPosition.BOTTOM,
                              margin: EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 18.0,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 18.0,
                              ),
                              borderRadius: 5.0,
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 40.0,
                          ),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        color: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
