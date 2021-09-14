import 'dart:io';

import 'package:checkdigit/checkdigit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../controllers/admin_controller.dart';
import '../widgets/ob_top_navigation.dart';

class OBPhotos extends StatefulWidget {
  @override
  _OBPhotosState createState() => _OBPhotosState();
}

class _OBPhotosState extends State<OBPhotos> {
  final AdminController adminC = Get.put(AdminController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Photos',
        ),
        actions: [
          Column(
            children: [
              FlatButton(
                onPressed: () {
                  adminC.saveEmployeeAsDraft();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    'Save as Draft',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            Obx(() {
              print(adminC.updatingData);

              return SingleChildScrollView(
                reverse: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OBTopNavigation('photos'),
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          var pickedFile;
                          await Get.bottomSheet(
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 15.0,
                              ),
                              child: ListView(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                children: [
                                  Text(
                                    'Please choose from...',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          Get.back();
                                          pickedFile = await ImagePicker().getImage(
                                            source: ImageSource.camera,
                                            imageQuality: 50,
                                          );
                                          if (pickedFile != null) {
                                            adminC.profile = File(pickedFile.path);
                                            adminC.profileAdd = true;
                                            // profileLink = 'https://cdn.iconscout.com/icon/premium/png-256-thumb/done-36-832708.png';
                                            setState(() {});
                                          } else {
                                            print('No image selected.');
                                            adminC.profile = null;
                                            adminC.profileAdd = false;
                                            adminC.profileLink = 'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_960_720.png';
                                            setState(() {});
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.camera,
                                              size: 30.0,
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              'Camera',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      TextButton(
                                        onPressed: () async {
                                          Get.back();
                                          pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                                          if (pickedFile != null) {
                                            adminC.profile = File(pickedFile.path);
                                            adminC.profileAdd = true;
                                            // profileLink = 'https://cdn.iconscout.com/icon/premium/png-256-thumb/done-36-832708.png';
                                            setState(() {});
                                          } else {
                                            print('No image selected.');
                                            adminC.profile = null;
                                            adminC.profileAdd = false;
                                            adminC.profileLink = 'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_960_720.png';
                                            setState(() {});
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.image,
                                              size: 30.0,
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              'Gallery',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            isDismissible: true,
                            backgroundColor: Colors.white,
                          );
                        },
                        child: Stack(
                          children: [
                            adminC.profile != null
                                ? Image.file(
                                    adminC.profile,
                                    height: 100.0,
                                    width: 100.0,
                                  )
                                : Image.network(
                                    adminC.profileLink,
                                    // fit: BoxFit.cover,
                                    height: 100.0,
                                    width: 100.0,
                                  ),
                            Image.asset(
                              'assets/images/uplode_proof.png',
                              // color: Colors.grey,
                              scale: 2.2,
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'ID Proof 1*',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: DropdownButtonFormField<dynamic>(
                        hint: Text(
                          'Select ID Proof',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        isExpanded: false,
                        value: adminC.idProof,
                        items: adminC.proofList.map((item) {
                          //print('item: $item');
                          return DropdownMenuItem(
                            child: Text(
                              item,
                            ),
                            value: item,
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/aadhar.png',
                                color: Colors.grey,
                                scale: 2.2,
                              ),
                            ],
                          ),
                        ),
                        onChanged: (value) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          adminC.idProof = value;
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: TextField(
                              controller: adminC.proof1,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                                hintText: 'Upload ID Proof Front*',
                                suffixIcon: Image.asset(
                                  'assets/images/uplode_proof.png',
                                  // color: Colors.grey,
                                  scale: 2.2,
                                ),
                              ),
                              readOnly: true,
                              keyboardType: null,
                              onTap: () async {
                                var pickedFile;
                                await Get.bottomSheet(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                      vertical: 15.0,
                                    ),
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      children: [
                                        Text(
                                          'Please choose from...',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Row(
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                Get.back();
                                                pickedFile = await ImagePicker().getImage(
                                                  source: ImageSource.camera,
                                                  imageQuality: 50,
                                                );
                                                if (pickedFile != null) {
                                                  adminC.aadhar1 = File(pickedFile.path);
                                                  adminC.proof1.text = path.basename(pickedFile.path);
                                                  setState(() {});
                                                } else {
                                                  print('No image selected.');
                                                  adminC.aadhar1 = null;
                                                  adminC.proof1.clear();
                                                  setState(() {});
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.camera,
                                                    size: 30.0,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                    'Camera',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                            TextButton(
                                              onPressed: () async {
                                                Get.back();
                                                pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                                                if (pickedFile != null) {
                                                  adminC.aadhar1 = File(pickedFile.path);
                                                  adminC.proof1.text = path.basename(pickedFile.path);
                                                  setState(() {});
                                                } else {
                                                  print('No image selected.');
                                                  adminC.aadhar1 = null;
                                                  adminC.proof1.clear();
                                                  setState(() {});
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.image,
                                                    size: 30.0,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                    'Gallery',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  isDismissible: true,
                                  backgroundColor: Colors.white,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Flexible(
                            child: TextField(
                              controller: adminC.proof2,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                                hintText: 'Upload ID Proof Back*',
                                suffixIcon: Image.asset(
                                  'assets/images/uplode_proof.png',
                                  // color: Colors.grey,
                                  scale: 2.2,
                                ),
                              ),
                              readOnly: true,
                              keyboardType: null,
                              onTap: () async {
                                var pickedFile;
                                await Get.bottomSheet(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                      vertical: 15.0,
                                    ),
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      children: [
                                        Text(
                                          'Please choose from...',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Row(
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                Get.back();
                                                pickedFile = await ImagePicker().getImage(
                                                  source: ImageSource.camera,
                                                  imageQuality: 50,
                                                );
                                                if (pickedFile != null) {
                                                  adminC.aadhar2 = File(pickedFile.path);
                                                  adminC.proof2.text = path.basename(pickedFile.path);
                                                  setState(() {});
                                                } else {
                                                  print('No image selected.');
                                                  adminC.aadhar2 = null;
                                                  adminC.proof2.clear();
                                                  setState(() {});
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.camera,
                                                    size: 30.0,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                    'Camera',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                            TextButton(
                                              onPressed: () async {
                                                Get.back();
                                                pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                                                if (pickedFile != null) {
                                                  adminC.aadhar2 = File(pickedFile.path);
                                                  adminC.proof2.text = path.basename(pickedFile.path);
                                                  setState(() {});
                                                } else {
                                                  print('No image selected.');
                                                  adminC.aadhar2 = null;
                                                  adminC.proof2.clear();
                                                  setState(() {});
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.image,
                                                    size: 30.0,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                    'Gallery',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  isDismissible: true,
                                  backgroundColor: Colors.white,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Obx(() {
                        return TextField(
                          controller: adminC.proofAadharNumber,
                          keyboardType: TextInputType.number,
                          enabled: !adminC.disabledAadhar.value,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0,
                            ),
                            hintText: 'Aadhar Number*',
                            prefixIcon: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/aadhar.png',
                                  color: Colors.grey,
                                  scale: 2.2,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Obx(() {
                        return TextField(
                          controller: adminC.proofAadharNumberConfirm,
                          keyboardType: TextInputType.number,
                          enabled: !adminC.disabledAadhar.value,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0,
                            ),
                            hintText: 'Re-enter Aadhar Number',
                            prefixIcon: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/aadhar.png',
                                  color: Colors.grey,
                                  scale: 2.2,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Text(
                        'ID Proof 2',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: DropdownButtonFormField<dynamic>(
                        hint: Text(
                          'Select ID Proof',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        isExpanded: false,
                        value: adminC.idProof1,
                        items: adminC.proofList.map((item) {
                          //print('item: $item');
                          return DropdownMenuItem(
                            child: Text(
                              item,
                            ),
                            value: item,
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/aadhar.png',
                                color: Colors.grey,
                                scale: 2.2,
                              ),
                            ],
                          ),
                        ),
                        onChanged: (value) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          adminC.idProof1 = value;
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: TextField(
                              controller: adminC.proof3,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                                hintText: 'Upload ID Proof Front',
                                suffixIcon: Image.asset(
                                  'assets/images/uplode_proof.png',
                                  // color: Colors.grey,
                                  scale: 2.2,
                                ),
                              ),
                              readOnly: true,
                              keyboardType: null,
                              onTap: () async {
                                var pickedFile;
                                await Get.bottomSheet(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                      vertical: 15.0,
                                    ),
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      children: [
                                        Text(
                                          'Please choose from...',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Row(
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                Get.back();
                                                pickedFile = await ImagePicker().getImage(
                                                  source: ImageSource.camera,
                                                  imageQuality: 50,
                                                );
                                                if (pickedFile != null) {
                                                  adminC.proof11 = File(pickedFile.path);
                                                  adminC.proof3.text = path.basename(pickedFile.path);
                                                  setState(() {});
                                                } else {
                                                  print('No image selected.');
                                                  adminC.proof11 = null;
                                                  adminC.proof3.clear();
                                                  setState(() {});
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.camera,
                                                    size: 30.0,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                    'Camera',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                            TextButton(
                                              onPressed: () async {
                                                Get.back();
                                                pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                                                if (pickedFile != null) {
                                                  adminC.proof11 = File(pickedFile.path);
                                                  adminC.proof3.text = path.basename(pickedFile.path);
                                                  setState(() {});
                                                } else {
                                                  print('No image selected.');
                                                  adminC.proof11 = null;
                                                  adminC.proof3.clear();
                                                  setState(() {});
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.image,
                                                    size: 30.0,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                    'Gallery',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  isDismissible: true,
                                  backgroundColor: Colors.white,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Flexible(
                            child: TextField(
                              controller: adminC.proof4,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                                hintText: 'Upload ID Proof Back',
                                suffixIcon: Image.asset(
                                  'assets/images/uplode_proof.png',
                                  // color: Colors.grey,
                                  scale: 2.2,
                                ),
                              ),
                              readOnly: true,
                              keyboardType: null,
                              onTap: () async {
                                var pickedFile;
                                await Get.bottomSheet(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                      vertical: 15.0,
                                    ),
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      children: [
                                        Text(
                                          'Please choose from...',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Row(
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                Get.back();
                                                pickedFile = await ImagePicker().getImage(
                                                  source: ImageSource.camera,
                                                  imageQuality: 50,
                                                );
                                                if (pickedFile != null) {
                                                  adminC.proof12 = File(pickedFile.path);
                                                  adminC.proof4.text = path.basename(pickedFile.path);
                                                  setState(() {});
                                                } else {
                                                  print('No image selected.');
                                                  adminC.proof12 = null;
                                                  adminC.proof4.clear();
                                                  setState(() {});
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.camera,
                                                    size: 30.0,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                    'Camera',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                            TextButton(
                                              onPressed: () async {
                                                Get.back();
                                                pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                                                if (pickedFile != null) {
                                                  adminC.proof12 = File(pickedFile.path);
                                                  adminC.proof4.text = path.basename(pickedFile.path);
                                                  setState(() {});
                                                } else {
                                                  print('No image selected.');
                                                  adminC.proof12 = null;
                                                  adminC.proof4.clear();
                                                  setState(() {});
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.image,
                                                    size: 30.0,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                    'Gallery',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  isDismissible: true,
                                  backgroundColor: Colors.white,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TextField(
                        controller: adminC.proofNumber2,
                        // keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          hintText: 'Enter Selected ID Proof Number',
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/aadhar.png',
                                color: Colors.grey,
                                scale: 2.2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Text(
                        'ID Proof 3',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: DropdownButtonFormField<dynamic>(
                        hint: Text(
                          'Select ID Proof',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        isExpanded: false,
                        value: adminC.idProof2,
                        items: adminC.proofList.map((item) {
                          //print('item: $item');
                          return DropdownMenuItem(
                            child: Text(
                              item,
                            ),
                            value: item,
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/aadhar.png',
                                color: Colors.grey,
                                scale: 2.2,
                              ),
                            ],
                          ),
                        ),
                        onChanged: (value) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          adminC.idProof2 = value;
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: TextField(
                              controller: adminC.proof5,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                                hintText: 'Upload ID Proof Front',
                                suffixIcon: Image.asset(
                                  'assets/images/uplode_proof.png',
                                  // color: Colors.grey,
                                  scale: 2.2,
                                ),
                              ),
                              readOnly: true,
                              keyboardType: null,
                              onTap: () async {
                                var pickedFile;
                                await Get.bottomSheet(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                      vertical: 15.0,
                                    ),
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      children: [
                                        Text(
                                          'Please choose from...',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Row(
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                Get.back();
                                                pickedFile = await ImagePicker().getImage(
                                                  source: ImageSource.camera,
                                                  imageQuality: 50,
                                                );
                                                if (pickedFile != null) {
                                                  adminC.proof21 = File(pickedFile.path);
                                                  adminC.proof5.text = path.basename(pickedFile.path);
                                                  setState(() {});
                                                } else {
                                                  print('No image selected.');
                                                  adminC.proof21 = null;
                                                  adminC.proof5.clear();
                                                  setState(() {});
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.camera,
                                                    size: 30.0,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                    'Camera',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                            TextButton(
                                              onPressed: () async {
                                                Get.back();
                                                pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                                                if (pickedFile != null) {
                                                  adminC.proof21 = File(pickedFile.path);
                                                  adminC.proof5.text = path.basename(pickedFile.path);
                                                  setState(() {});
                                                } else {
                                                  print('No image selected.');
                                                  adminC.proof21 = null;
                                                  adminC.proof5.clear();
                                                  setState(() {});
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.image,
                                                    size: 30.0,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                    'Gallery',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  isDismissible: true,
                                  backgroundColor: Colors.white,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Flexible(
                            child: TextField(
                              controller: adminC.proof6,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                                hintText: 'Upload ID Proof Back',
                                suffixIcon: Image.asset(
                                  'assets/images/uplode_proof.png',
                                  // color: Colors.grey,
                                  scale: 2.2,
                                ),
                              ),
                              readOnly: true,
                              keyboardType: null,
                              onTap: () async {
                                var pickedFile;
                                await Get.bottomSheet(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                      vertical: 15.0,
                                    ),
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      children: [
                                        Text(
                                          'Please choose from...',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Row(
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                Get.back();
                                                pickedFile = await ImagePicker().getImage(
                                                  source: ImageSource.camera,
                                                  imageQuality: 50,
                                                );
                                                if (pickedFile != null) {
                                                  adminC.proof22 = File(pickedFile.path);
                                                  adminC.proof6.text = path.basename(pickedFile.path);
                                                  setState(() {});
                                                } else {
                                                  print('No image selected.');
                                                  adminC.proof22 = null;
                                                  adminC.proof6.clear();
                                                  setState(() {});
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.camera,
                                                    size: 30.0,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                    'Camera',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                            TextButton(
                                              onPressed: () async {
                                                Get.back();
                                                pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                                                if (pickedFile != null) {
                                                  adminC.proof22 = File(pickedFile.path);
                                                  adminC.proof6.text = path.basename(pickedFile.path);
                                                  setState(() {});
                                                } else {
                                                  print('No image selected.');
                                                  adminC.proof22 = null;
                                                  adminC.proof6.clear();
                                                  setState(() {});
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.image,
                                                    size: 30.0,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                    'Gallery',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  isDismissible: true,
                                  backgroundColor: Colors.white,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TextField(
                        controller: adminC.proofNumber3,
                        // keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          hintText: 'Enter Selected ID Proof Number',
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/aadhar.png',
                                color: Colors.grey,
                                scale: 2.2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FlatButton(
                            onPressed: () {
                              print('Back');
                              Get.back();
                            },
                            child: Text(
                              'Back',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          RaisedButton(
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              adminC.step6(false);
                              if (adminC.proofAadharNumber.isNullOrBlank) {
                                Get.snackbar(
                                  null,
                                  'Please enter Aadhar Number',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              } else if (adminC.proofNumber2.isNullOrBlank) {
                                Get.snackbar(
                                  null,
                                  'Select Proof Number 2',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              } else if (adminC.aadhar1 == null) {
                                Get.snackbar(
                                  null,
                                  'Upload Aadhar',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              } else if (adminC.aadhar2 == null) {
                                Get.snackbar(
                                  null,
                                  'Upload Aadhar',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              } else if (adminC.proofAadharNumber.text != adminC.proofAadharNumberConfirm.text) {
                                Get.snackbar(
                                  null,
                                  'Aadhar number and confirm aadhar number are not matching',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              } else if (!verhoeff.validate(adminC.proofAadharNumber.text)) {
                                Get.snackbar(
                                  null,
                                  'Please add valid aadhar number',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              } else {
                                // done
                                adminC.step6(true);
                                adminC.addEmployeeDataNew();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 50.0,
                              ),
                              child: Text(
                                'Send For Approval',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
