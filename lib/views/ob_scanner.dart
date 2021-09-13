import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:xml/xml.dart';

import '../controllers/admin_controller.dart';

class OBScanner extends StatefulWidget {
  @override
  _OBScannerState createState() => _OBScannerState();
}

class _OBScannerState extends State<OBScanner> {
  final AdminController adminC = Get.put(AdminController());
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;
  var showQR = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      print('scanData: ${scanData.code}');
      if (scanData.code != null && scanData.code.isNotEmpty) {
        controller.stopCamera();
        showQR = false;
        var document = XmlDocument.parse(scanData.code);
        var barcodeData = document.getElement('PrintLetterBarcodeData');
        var barcodeList = barcodeData.attributes;
        // var decList = barcodeData.descendants;
        // var uid = document.getElement('uid');
        // var name = document.getElement('name');
        // var gender = document.getElement('gender');
        // var pincode = document.getElement('pc');
        for (var i = 0; i < barcodeList.length; i++) {
          // print('$i: ${barcodeList[i]}');
          if (barcodeList[i].toString().contains('uid')) {
            var uidrep = barcodeList[i].toString().replaceAll('"', '').replaceAll("'", '');
            var uid = uidrep.split('=')[1];
            print('uid: $uid');
            adminC.proofAadharNumber.text = uid;
            adminC.proofAadharNumberConfirm.text = uid;
          }
          if (barcodeList[i].toString().contains('name') && !barcodeList[i].toString().contains('gname')) {
            var namerep = barcodeList[i].toString().replaceAll('"', '').replaceAll("'", '');
            var name = namerep.split('=')[1];
            print('name: $name');
            adminC.name.text = name;
          }
          if (barcodeList[i].toString().contains('house')) {
            var houserep = barcodeList[i].toString().replaceAll('"', '').replaceAll("'", '');
            var house = houserep.split('=')[1];
            print('house: $house');
            adminC.permanenthouseNo.text = house;
          }
          if (barcodeList[i].toString().contains('dob')) {
            var dobrep = barcodeList[i].toString().replaceAll('"', '').replaceAll("'", '');
            var dob = dobrep.split('=')[1];
            print('dob: $dob');
            adminC.dtOfBirth.text = '${dob.toString().split('/')[0]}-${dob.toString().split('/')[1]}-${dob.toString().split('/')[2]}';
            adminC.dob = DateFormat('yyyy-MM-dd').format(DateTime.parse('${dob.toString().split('/')[2]}-${dob.toString().split('/')[1]}-${dob.toString().split('/')[0]}')).toString();
          }
          if (barcodeList[i].toString().contains('gender')) {
            var genderrep = barcodeList[i].toString().replaceAll('"', '').replaceAll("'", '');
            var gender = genderrep.split('=')[1];
            print('gender: $gender');
            if (gender.trim().toUpperCase() == 'MALE' || gender.trim().toUpperCase() == 'M') {
              adminC.gender = 'M';
            } else if (gender.trim().toUpperCase() == 'FEMALE' || gender.trim().toUpperCase() == 'F') {
              adminC.gender = 'F';
            }
          }
          if (barcodeList[i].toString().contains('pc')) {
            var pcrep = barcodeList[i].toString().replaceAll('"', '').replaceAll("'", '');
            var pc = pcrep.split('=')[1];
            print('pc: $pc');
            adminC.permanentPincode.text = pc;
            adminC.presentPincode.text = pc;
          }
        }
        adminC.updatingData.refresh();
        setState(() {});
        Get.back();
      } else {
        Get.snackbar(
          null,
          'No data found',
          colorText: Colors.white,
          backgroundColor: Colors.black87,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
          borderRadius: 5.0,
        );
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 150.0 : 400.0;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan Aadhar',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Theme.of(context).primaryColor,
                  borderRadius: 10.0,
                  borderLength: 30.0,
                  borderWidth: 8.0,
                  cutOutSize: scanArea,
                ),
                formatsAllowed: [BarcodeFormat.qrcode],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
