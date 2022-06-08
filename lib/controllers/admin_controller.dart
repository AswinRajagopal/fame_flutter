import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../connection/remote_services.dart';
import '../utils/utils.dart';
import '../views/dashboard_page.dart';

class AdminController extends GetxController {
  var isLoading = true.obs;
  var isLoadingData = true.obs;
  var draftLoded = false.obs;
  var disabledName = false.obs;
  var disabledDob = false.obs;
  var disabledAadhar = false.obs;
  var aadharScan = false;
  var reload = true;
  ProgressDialog pr;
  var resAddShift;
  var resAddClient;
  var resAddEmployee;
  var getDataRes;
  var updatingData = [].obs;
  final List clientList = [].obs;
  final List desList = [].obs;
  final List shiftList = [].obs;
  final List departmentsList = [].obs;
  final List bloodGroupsList = [].obs;
  final List designationsList = [].obs;
  final List bankNamesList = [].obs;
  final List branchList = [].obs;
  final List statesList = [].obs;
  final List citiesList = [].obs;
  final List percitiesList = [].obs;
  final List checkList = [];

  final shirtSizes = {'30', '32', '34', '36', '38', '40', '42', '44'};
  final pantSizes = {'26', '28', '30', '32', '34', '36', '38', '40'};
  final shoeSizes = {'6', '7', '8', '9', '10', '11'};
  final relationShip = {'Father', 'Husband', 'Sister', 'Wife', 'Daughter', 'Uncle', 'Aunty', 'Mother', 'Son', 'Brother', 'Other'};
  final proofList = {'AadharCard', 'DrivingLicense', 'VoterID', 'RationCard', 'PanCard', 'PassBook', 'ElectricityBill', 'ESICCard', 'Others'};

  // List of Family
  var famIndex = 0.obs;
  List<TextEditingController> famName = [];
  List<TextEditingController> famDob = [];
  List<TextEditingController> famAge = [];
  List<TextEditingController> famAadhar = [];
  List<TextEditingController> famRelation = [];
  List<TextEditingController> famPercent = [];
  List famNominee = [];
  var familyDetail = [].obs;
  TextEditingController name = TextEditingController();
  TextEditingController aadhar = TextEditingController();
  TextEditingController dtOfBirth = TextEditingController();
  TextEditingController dtOfVaccine = TextEditingController();
  TextEditingController dtOfJoin = TextEditingController();
  TextEditingController language = TextEditingController();
  TextEditingController empPhone = TextEditingController();
  TextEditingController empUANNumber = TextEditingController();
  TextEditingController empESINumber = TextEditingController();
  TextEditingController qualification = TextEditingController();
  TextEditingController reporting = TextEditingController();
  TextEditingController presenthouseNo = TextEditingController();
  TextEditingController presentStreet = TextEditingController();
  TextEditingController presentColony = TextEditingController();
  TextEditingController presentPincode = TextEditingController();
  TextEditingController permanenthouseNo = TextEditingController();
  TextEditingController permanentStreet = TextEditingController();
  TextEditingController permanentColony = TextEditingController();
  TextEditingController permanentPincode = TextEditingController();
  TextEditingController accountNo = TextEditingController();
  TextEditingController ifsc = TextEditingController();
  TextEditingController fatherName = TextEditingController();
  TextEditingController ageFather = TextEditingController();
  TextEditingController aadharNumberFather = TextEditingController();
  TextEditingController dobFather = TextEditingController();
  TextEditingController familyName = TextEditingController();
  TextEditingController ageFamily = TextEditingController();
  TextEditingController aadharNumberFamily = TextEditingController();
  TextEditingController dobFamily = TextEditingController();
  TextEditingController proofAadharNumber = TextEditingController();
  TextEditingController proofAadharNumberConfirm = TextEditingController();
  TextEditingController proofNumber2 = TextEditingController();
  TextEditingController proofNumber3 = TextEditingController();
  TextEditingController empRemarks = TextEditingController();
  TextEditingController clientAu = TextEditingController();
  TextEditingController desigAu = TextEditingController();
  TextEditingController deptAu = TextEditingController();
  TextEditingController proof1 = TextEditingController();
  TextEditingController proof2 = TextEditingController();
  TextEditingController proof3 = TextEditingController();
  TextEditingController proof4 = TextEditingController();
  TextEditingController proof5 = TextEditingController();
  TextEditingController proof6 = TextEditingController();
  var empFamilyMembers = [];
  var addedEmpId;
  File aadhar1;
  File aadhar2;
  File proof11;
  File profile;
  File proof12;
  File proof21;
  File proof22;
  TabController tabController;
  var gender = 'M';
  var dose = '';
  var mStatus = 'S';
  var department;
  var client;
  var blood;
  var designation;
  var sitePostedTo;
  var dob;
  var dov;
  var doj;
  var presentState;
  var bank;
  var presentCity;
  var permanentState;
  var permanentCity;
  var shirtSize;
  var vaccineName;
  var pantSize;
  var shoeSize;
  var dobFatherVal;
  var dobFamilyVal = '1999-01-01';
  var idProof1;
  var idProof = 'AadharCard';
  var idProof2;
  var relFather = 'Father';
  var relFamily;
  var profileLink = 'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_960_720.png';
  var currentTabIndex = 0;
  bool copyAdd = false;
  bool profileAdd = false;
  bool nominee1 = false;
  bool nominee2 = false;
  final List vaccineType = [].obs;
  var step1 = false.obs;
  var step2 = false.obs;
  var step3 = false.obs;
  var step4 = false.obs;
  var step5 = false.obs;
  var step6 = false.obs;
  // final vaccineType = {'Covaxin', 'Covishield', 'Sputnik v'};

  var curDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

  Future<Null> getDate(BuildContext context) async {
    await DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now().add(Duration(days: -36500)),
      maxTime: DateTime.now(),
      onChanged: (date) {
        print('change $date');
      },
      onConfirm: (date) {
        print('confirm $date');
        if (date != null) {
          dtOfBirth.text = DateFormat('dd-MM-yyyy').format(date).toString();
          dob = DateFormat('yyyy-MM-dd').format(date).toString();
        }
      },
      currentTime: dob != null ? DateTime.parse(dob.toString()) : DateTime.parse(curDate.toString()),
      // locale: LocaleType.en,
    );
    // final picked = await showDatePicker(
    //   context: context,
    //   initialDate: dob != null
    //       ? DateTime.parse(
    //           dob.toString(),
    //         )
    //       : DateTime.parse(
    //           curDate.toString(),
    //         ),
    //   firstDate: DateTime.now().add(Duration(days: -36500)),
    //   lastDate: DateTime.now(),
    // );

    // if (picked != null) {
    //   dtOfBirth.text = DateFormat('dd-MM-yyyy').format(picked).toString();
    //   dob = DateFormat('yyyy-MM-dd').format(picked).toString();
    // }
  }

  Future<Null> getDateVaccine(BuildContext context) async {
    await DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now().add(Duration(days: -36500)),
      maxTime: DateTime.now(),
      onChanged: (date) {
        print('change $date');
      },
      onConfirm: (date) {
        print('confirm $date');
        if (date != null) {
          dtOfVaccine.text = DateFormat('dd-MM-yyyy').format(date).toString();
          dov = DateFormat('yyyy-MM-dd').format(date).toString();
        }
      },
      currentTime: dov != null ? DateTime.parse(dov.toString()) : DateTime.parse(curDate.toString()),
      // locale: LocaleType.en,
    );
    // final picked = await showDatePicker(
    //   context: context,
    //   initialDate: dov != null
    //       ? DateTime.parse(
    //           dov.toString(),
    //         )
    //       : DateTime.parse(
    //           curDate.toString(),
    //         ),
    //   firstDate: DateTime.now().add(Duration(days: -36500)),
    //   lastDate: DateTime.now(),
    // );

    // if (picked != null) {
    //   dtOfVaccine.text = DateFormat('dd-MM-yyyy').format(picked).toString();
    //   dov = DateFormat('yyyy-MM-dd').format(picked).toString();
    // }
  }

  Future<Null> getFatherDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dobFatherVal != null
          ? DateTime.parse(
              dobFatherVal.toString(),
            )
          : DateTime.parse(
              curDate.toString(),
            ),
      firstDate: DateTime.now().add(Duration(days: -36500)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dobFather.text = DateFormat('dd-MM-yyyy').format(picked).toString();
      dobFatherVal = DateFormat('yyyy-MM-dd').format(picked).toString();
    }
  }

  Future<Null> getFamilyDate(BuildContext context, TextEditingController setValue) async {
    await DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now().add(Duration(days: -36500)),
      maxTime: DateTime.now(),
      onChanged: (date) {
        print('change $date');
      },
      onConfirm: (date) {
        print('confirm $date');
        if (date != null) {
          setValue.text = DateFormat('dd-MM-yyyy').format(date).toString();
        }
      },
      currentTime: setValue != null && setValue.text.isNotEmpty ? DateTime.parse('${setValue.text.toString().split('-')[2]}-${setValue.text.toString().split('-')[1]}-${setValue.text.toString().split('-')[0]}') : DateTime.parse(curDate.toString()),
      // locale: LocaleType.en,
    );
    // final picked = await showDatePicker(
    //   context: context,
    //   initialDate: setValue != null && setValue.text.isNotEmpty
    //       ? DateTime.parse(
    //           '${setValue.text.toString().split('-')[2]}-${setValue.text.toString().split('-')[1]}-${setValue.text.toString().split('-')[0]}',
    //         )
    //       : DateTime.parse(
    //           curDate.toString(),
    //         ),
    //   firstDate: DateTime.now().add(Duration(days: -36500)),
    //   lastDate: DateTime.now(),
    // );

    // if (picked != null) {
    //   setValue.text = DateFormat('dd-MM-yyyy').format(picked).toString();
    //   // dobFamilyVal = DateFormat('yyyy-MM-dd').format(picked).toString();
    // }
  }

  Future<Null> getJoiningDate(BuildContext context) async {
    await DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now().add(Duration(days: -60)),
      maxTime: DateTime.now().add(Duration(days: 120)),
      onChanged: (date) {
        print('change $date');
      },
      onConfirm: (date) {
        print('confirm $date');
        if (date != null) {
          dtOfJoin.text = DateFormat('dd-MM-yyyy').format(date).toString();
          doj = DateFormat('yyyy-MM-dd').format(date).toString();
        }
      },
      currentTime: doj != null ? DateTime.parse(doj.toString()) : DateTime.parse(curDate.toString()),
      // locale: LocaleType.en,
    );
    // final picked = await showDatePicker(
    //   context: context,
    //   initialDate: doj != null
    //       ? DateTime.parse(
    //           doj.toString(),
    //         )
    //       : DateTime.parse(
    //           curDate.toString(),
    //         ),
    //   firstDate: DateTime.now().add(Duration(days: -60)),
    //   lastDate: DateTime.now().add(Duration(days: 120)),
    // );

    // if (picked != null) {
    //   dtOfJoin.text = DateFormat('dd-MM-yyyy').format(picked).toString();
    //   doj = DateFormat('yyyy-MM-dd').format(picked).toString();
    // }
  }

  void addShift(shiftName, startTime, endTime) async {
    try {
      await pr.show();
      resAddShift = await RemoteServices().addShift(shiftName, startTime, endTime);
      if (resAddShift != null) {
        await pr.hide();
        // print('res valid: $res');
        if (resAddShift['success']) {
          Get.snackbar(
            null,
            'Shift created successfully',
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
          Get.snackbar(
            null,
            'Shift not created',
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
      }
    } catch (e) {
      print(e);
      await pr.hide();
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
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
  }

  void addClient(name, phone, clientId, inchargeId, address, lat, lng) async {
    try {
      await pr.show();
      resAddClient = await RemoteServices().addClient(name, phone, clientId, inchargeId, address, lat, lng);
      if (resAddClient != null) {
        await pr.hide();
        // print('res valid: $res');
        if (resAddClient['success']) {
          Get.snackbar(
            null,
            'Client created successfully',
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
          Get.snackbar(
            null,
            'Client not created',
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
      }
    } catch (e) {
      print(e);
      await pr.hide();
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
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
  }

  void getClient() async {
    clientList.clear();
    try {
      isLoading(true);
      await pr.show();
      var getClientRes = await RemoteServices().getClients();
      if (getClientRes != null) {
        await pr.hide();
        isLoading(false);
        // print('getClientRes valid: $getClientRes');
        if (getClientRes['success']) {
          for (var i = 0; i < getClientRes['clientsList'].length; i++) {
            clientList.add(getClientRes['clientsList'][i]);
          }
          // print('clientsList: $clientList');
        } else {
          // Get.snackbar(
          //   null,
          //   'Client not found',
          //   colorText: Colors.white,
          //   backgroundColor: Colors.black87,
          //   snackPosition: SnackPosition.BOTTOM,
          //   margin: EdgeInsets.symmetric(
          //     horizontal: 8.0,
          //     vertical: 10.0,
          //   ),
          // );
        }
      }
    } catch (e) {
      print(e);
      isLoading(false);
      await pr.hide();
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
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
  }

  void getDesignation() async {
    desList.clear();
    try {
      isLoading(true);
      await pr.show();
      var getDesRes = await RemoteServices().getDesignation();
      if (getDesRes != null) {
        await pr.hide();
        isLoading(false);
        // print('getClientRes valid: $getClientRes');
        if (getDesRes['success']) {
          for (var i = 0; i < getDesRes['designationsList'].length; i++) {
            desList.add(getDesRes['designationsList'][i]);
          }
          // print('clientsList: $clientList');
        }
      }
    } catch (e) {
      print(e);
      isLoading(false);
      await pr.hide();
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
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
  }

  void getShift(clientId) async {
    shiftList.clear();
    checkList.clear();
    try {
      isLoading(true);
      await pr.show();
      var getShiftRes = await RemoteServices().getShiftByClient(clientId);
      if (getShiftRes != null) {
        await pr.hide();
        isLoading(false);
        // print('getClientRes valid: $getClientRes');
        if (getShiftRes['success']) {
          for (var i = 0; i < getShiftRes['manpowerReqList'].length; i++) {
            if (!checkList.contains(getShiftRes['manpowerReqList'][i]['shift'])) {
              shiftList.add(getShiftRes['manpowerReqList'][i]);
              checkList.add(getShiftRes['manpowerReqList'][i]['shift']);
            }
          }
          // print('clientsList: $clientList');
        }
      }
    } catch (e) {
      print(e);
      isLoading(false);
      await pr.hide();
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
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
  }

  void addEmployee(name, address, email, phone, empid, sitePostedTo, gender, dob, design, shift) async {
    try {
      await pr.show();
      resAddEmployee = await RemoteServices().addEmployee(name, address, email, phone, empid, sitePostedTo, gender, dob, design, shift);
      if (resAddEmployee != null) {
        await pr.hide();
        // print('res valid: $res');
        if (resAddEmployee['success']) {
          Get.snackbar(
            null,
            'Employee created successfully',
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
          Get.snackbar(
            null,
            'Employee not created',
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
      }
    } catch (e) {
      print(e);
      await pr.hide();
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
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
  }

  void setupFamilyDraft(index, data) {
    print('index: $index');
    famName.insert(index, TextEditingController(text: data['relName']));
    if (data['dofBirth'] != '') {
      famDob.insert(index, TextEditingController(text: '${data['dofBirth'].split('-')[2]}-${data['dofBirth'].split('-')[1]}-${data['dofBirth'].split('-')[0]}'));
    } else {
      famDob.insert(index, TextEditingController());
    }
    famAge.insert(index, TextEditingController(text: data['age']));
    famAadhar.insert(index, TextEditingController(text: data['relAadhaarNo']));
    famRelation.insert(index, TextEditingController(text: data['relType']));
    famPercent.insert(index, TextEditingController(text: data['nomineePercent']));
    famNominee.insert(index, data['pfNominee'] == 'N' ? false : true);

    familyDetail.insert(
      famIndex.value,
      Obx(() {
        print(familyDetail.length);
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Text(
                      'Family Member',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        FocusScope.of(Get.context).requestFocus(FocusNode());
                        // famName.removeAt(index);
                        // famDob.removeAt(index);
                        // famAge.removeAt(index);
                        // famAadhar.removeAt(index);
                        // famRelation.removeAt(index);
                        // famNominee.removeAt(index);
                        // familyDetail.removeAt(index);
                        // famIndex--;
                        // familyDetail.refresh();
                        var chkFamily = [];
                        chkFamily.addAll(familyDetail);
                        chkFamily.removeWhere((item) => item == null);
                        if (chkFamily.length > 1) {
                          familyDetail.removeAt(index);
                          familyDetail.insert(index, null);
                          if (famIndex > 0) famIndex--;
                        }
                        familyDetail.refresh();
                      },
                      child: Visibility(
                        visible: index == 0 ? false : true,
                        child: Icon(
                          Icons.delete_outline,
                          size: 35.0,
                          color: Colors.red,
                        ),
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
                    'Select Relation*',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18.0,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  isExpanded: false,
                  value: famRelation[index].text.isEmpty ? null : famRelation[index].text,
                  items: relationShip.map((item) {
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
                          'assets/images/relation.png',
                          color: Colors.grey[400],
                          scale: 2.0,
                        ),
                      ],
                    ),
                  ),
                  onChanged: (value) {
                    FocusScope.of(Get.context).requestFocus(FocusNode());
                    famRelation[index].text = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: Row(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 8.0),
                    //   child: Image.asset(
                    //     'assets/images/nominee.png',
                    //     color: Colors.grey[400],
                    //     scale: 2.2,
                    //   ),
                    // ),
                    Checkbox(
                      value: famNominee[index],
                      onChanged: (value) {
                        print(value);
                        famNominee[index] = value;
                        familyDetail.refresh();
                      },
                    ),
                    Text(
                      'Nominee',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 17.0,
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
                  controller: famName[index],
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18.0,
                    ),
                    hintText: 'Name*',
                    prefixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/user.png',
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
                child: TextField(
                  controller: famDob[index],
                  readOnly: true,
                  keyboardType: null,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18.0,
                    ),
                    hintText: 'Date of Birth*',
                    prefixIcon: Image.asset(
                      'assets/images/icon_calender.png',
                      color: Colors.grey,
                      scale: 1.2,
                    ),
                  ),
                  onTap: () {
                    getFamilyDate(Get.context, famDob[index]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: TextField(
                  controller: famAge[index],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18.0,
                    ),
                    hintText: 'Age*',
                    prefixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/age.png',
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
                child: TextField(
                  controller: famAadhar[index],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18.0,
                    ),
                    hintText: 'Aadhar Number',
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
                child: TextField(
                  controller: famPercent[index],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18.0,
                    ),
                    hintText: 'Nominee Percentage',
                    prefixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/nominee.png',
                          color: Colors.grey,
                          scale: 2.2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
            ],
          ),
        );
      }),
    );

    famIndex++;
    print('famName: $famName');
    print('famDob: $famDob');
    print('famAge: $famAge');
    print('famAadhar: $famAadhar');
    print('famRelation: $famRelation');
    print('famNominee: $famNominee');
    print('famIndex: $famIndex');

    // familyDetail.refresh();
  }

  void setupFamily(index) {
    print('index: $index');
    famName.insert(index, TextEditingController());
    famDob.insert(index, TextEditingController());
    famAge.insert(index, TextEditingController());
    famAadhar.insert(index, TextEditingController());
    famRelation.insert(index, TextEditingController());
    famPercent.insert(index, TextEditingController());
    famNominee.insert(index, false);

    familyDetail.insert(
      famIndex.value,
      Obx(() {
        print(familyDetail.length);
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Text(
                      'Family Member',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        FocusScope.of(Get.context).requestFocus(FocusNode());
                        // famName.removeAt(index);
                        // famDob.removeAt(index);
                        // famAge.removeAt(index);
                        // famAadhar.removeAt(index);
                        // famRelation.removeAt(index);
                        // famNominee.removeAt(index);
                        // familyDetail.removeAt(index);
                        // famIndex--;
                        // familyDetail.refresh();
                        var chkFamily = [];
                        chkFamily.addAll(familyDetail);
                        chkFamily.removeWhere((item) => item == null);
                        if (chkFamily.length > 1) {
                          familyDetail.removeAt(index);
                          familyDetail.insert(index, null);
                          if (famIndex > 0) famIndex--;
                        }
                        familyDetail.refresh();
                      },
                      child: Visibility(
                        visible: index == 0 ? false : true,
                        child: Icon(
                          Icons.delete_outline,
                          size: 35.0,
                          color: Colors.red,
                        ),
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
                    'Select Relation*',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18.0,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  isExpanded: false,
                  value: famRelation[index].text.isEmpty ? null : famRelation[index].text,
                  items: relationShip.map((item) {
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
                          'assets/images/relation.png',
                          color: Colors.grey[400],
                          scale: 2.0,
                        ),
                      ],
                    ),
                  ),
                  onChanged: (value) {
                    FocusScope.of(Get.context).requestFocus(FocusNode());
                    famRelation[index].text = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: Row(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 8.0),
                    //   child: Image.asset(
                    //     'assets/images/nominee.png',
                    //     color: Colors.grey[400],
                    //     scale: 2.2,
                    //   ),
                    // ),
                    Checkbox(
                      value: famNominee[index],
                      onChanged: (value) {
                        print(value);
                        famNominee[index] = value;
                        familyDetail.refresh();
                      },
                    ),
                    Text(
                      'Nominee',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 17.0,
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
                  controller: famName[index],
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18.0,
                    ),
                    hintText: 'Name*',
                    prefixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/user.png',
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
                child: TextField(
                  controller: famDob[index],
                  readOnly: true,
                  keyboardType: null,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18.0,
                    ),
                    hintText: 'Date of Birth*',
                    prefixIcon: Image.asset(
                      'assets/images/icon_calender.png',
                      color: Colors.grey,
                      scale: 1.2,
                    ),
                  ),
                  onTap: () {
                    getFamilyDate(Get.context, famDob[index]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: TextField(
                  controller: famAge[index],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18.0,
                    ),
                    hintText: 'Age*',
                    prefixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/age.png',
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
                child: TextField(
                  controller: famAadhar[index],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18.0,
                    ),
                    hintText: 'Aadhar Number',
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
                child: TextField(
                  controller: famPercent[index],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18.0,
                    ),
                    hintText: 'Nominee Percentage',
                    prefixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/nominee.png',
                          color: Colors.grey,
                          scale: 2.2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
            ],
          ),
        );
      }),
    );

    famIndex++;
    print('famName: $famName');
    print('famDob: $famDob');
    print('famAge: $famAge');
    print('famAadhar: $famAadhar');
    print('famRelation: $famRelation');
    print('famNominee: $famNominee');
    print('famIndex: $famIndex');

    // familyDetail.refresh();
  }

  void getData() async {
    try {
      isLoadingData(true);
      await pr.show();
      clientList.clear();
      statesList.clear();
      vaccineType.clear();
      bloodGroupsList.clear();
      departmentsList.clear();
      designationsList.clear();
      bankNamesList.clear();
      branchList.clear();
      getDataRes = await RemoteServices().getData();
      var getClientRes = await RemoteServices().getClients();
      var stateRes = await RemoteServices().getStates();

      if (getClientRes != null) {
        // print('getClientRes valid: $getClientRes');
        if (getClientRes['success']) {
          for (var i = 0; i < getClientRes['clientsList'].length; i++) {
            clientList.add(getClientRes['clientsList'][i]);
          }
          // print('clientsList: $clientList');
        }
      }
      if (stateRes != null) {
        if (stateRes['statesList'] != null) {
          statesList.addAll(stateRes['statesList']);
        }
      }
      if (getDataRes != null) {
        getClient();
        // print('getClientRes valid: $getClientRes');
        // print('vaccineDetailList: ${getClientRes['vaccineDetailList']}');
        if (getDataRes['success']) {
          // print('getDataRes: $getDataRes');
          if (getDataRes['vaccineDetailList'] != null) {
            vaccineType.addAll(getDataRes['vaccineDetailList']);
          }
          if (getDataRes['bloodGroups'] != null) {
            bloodGroupsList.addAll(getDataRes['bloodGroups']);
          }
          if (getDataRes['departmentsList'] != null) {
            departmentsList.addAll(getDataRes['departmentsList']);
          }
          if (getDataRes['designationsList'] != null) {
            designationsList.addAll(getDataRes['designationsList']);
          }
          if (getDataRes['bankNamesList'] != null) {
            bankNamesList.addAll(getDataRes['bankNamesList']);
          }
          if (getDataRes['branchList'] != null) {
            branchList.addAll(getDataRes['branchList']);
          }
        }
      }
      isLoadingData(false);
      await pr.hide();
      await Future.delayed(Duration(milliseconds: 200), checkDraft);
    } catch (e) {
      print(e);
      isLoadingData(false);
      await pr.hide();
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
        colorText: Colors.white,
        backgroundColor: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        borderRadius: 5.0,
      );
    }
  }

  void checkDraft() {
    if (RemoteServices().box.get('employeeDraft') != null) {
      showDialog(
        context: Get.context,
        builder: (context) => AlertDialog(
          title: Text('Draft Available!'),
          content: Text(
            'You have saved a draft last time. You want to load that data?',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Get.back();
              },
              child: Text('No'),
            ),
            FlatButton(
              onPressed: () {
                draftLoded(true);
                loadEmployeeFromDraft();
                Get.back();
              },
              child: Text('Yes'),
            ),
          ],
        ),
      );
    }
  }

  void getCities(stateId, listType, {showDialogue}) async {
    try {
      if (showDialogue == null) await pr.show();
      var citiesRes = await RemoteServices().getCities(stateId);

      if (citiesRes != null) {
        if (citiesRes['citiesList'] != null) {
          if (listType == 'present') {
            citiesList.addAll(citiesRes['citiesList']);
          } else {
            percitiesList.addAll(citiesRes['citiesList']);
          }
        }
      }
      if (showDialogue == null) await pr.hide();
    } catch (e) {
      print(e);
      if (showDialogue == null) await pr.hide();
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
        colorText: Colors.white,
        backgroundColor: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        borderRadius: 5.0,
      );
    }
  }

  Future addEmployeeNew(empdetails) async {
    await pr.show();
    try {
      var addNewEmp = await RemoteServices().newEmpRec(empdetails);

      if (addNewEmp != null) {
        print('addNewEmp: $addNewEmp');
        if (addNewEmp['success']) {
          return addNewEmp['empId'];
        } else {
          showError(addNewEmp['msg'] ?? '');
        }
      } else {
        showError('');
      }
      // await pr.hide();
    } catch (e) {
      print(e);
      await pr.hide();
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
        colorText: Colors.white,
        backgroundColor: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        borderRadius: 5.0,
      );
    }
  }

  void addEmployeeData(empRelationshipList, proofDetails, aadharFront, aadharBack, passbookFront, passbookBack, proof3Front, proof3Back, profile, empId) async {
    try {
      var addNewEmpRel = await RemoteServices().newRecRel(empRelationshipList, empId);

      if (addNewEmpRel != null) {
        // print('addNewEmp: $addNewEmp');
        if (addNewEmpRel['success']) {
          var addNewEmpProof = await RemoteServices().newRecProof(proofDetails, empId);
          if (addNewEmpProof != null) {
            if (addNewEmpProof['success']) {
              var uploadNewEmpProof = await RemoteServices().newRecUploadProof(empId, aadharFront, aadharBack, passbookFront, passbookBack, proof3Front, proof3Back, profile);
              if (uploadNewEmpProof != null) {
                if (uploadNewEmpProof['success']) {
                  await pr.hide();
                  Get.snackbar(
                    null,
                    'New employee added successfully',
                    colorText: Colors.white,
                    duration: Duration(seconds: 2),
                    backgroundColor: AppUtils().greenColor,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                    borderRadius: 5.0,
                  );
                  // Timer(Duration(seconds: 2), Get.back);
                  Timer(Duration(seconds: 2), () {
                    draftLoded(false);
                    RemoteServices().box.delete('employeeDraft');
                    reload = true;
                    Get.offAll(DashboardPage());
                  });
                } else {
                  showError(uploadNewEmpProof['msg'] ?? '');
                }
              } else {
                showError(uploadNewEmpProof['msg'] ?? '');
              }
            } else {
              showError(addNewEmpProof['msg'] ?? '');
            }
          } else {
            showError(addNewEmpProof['msg'] ?? '');
          }
        } else {
          showError(addNewEmpRel['msg'] ?? '');
        }
      } else {
        showError(addNewEmpRel['msg'] ?? '');
      }
      // await pr.hide();
    } catch (e) {
      print(e);
      await pr.hide();
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
        colorText: Colors.white,
        backgroundColor: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        borderRadius: 5.0,
      );
    }
  }

  void showError(msg) async {
    await pr.hide();
    Get.snackbar(
      null,
      msg == '' ? 'Something went wrong! Please try again later' : msg.toString(),
      colorText: Colors.white,
      backgroundColor: Colors.black87,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
      borderRadius: 5.0,
    );
  }

  void addEmployeeDataNew() async {
    var pehouse = permanenthouseNo.text.isEmpty ? '' : '${permanenthouseNo.text}';
    var pestreet = permanentStreet.text.isEmpty ? '' : '${permanentStreet.text}';
    var pecolony = permanentColony.text.isEmpty ? '' : '${permanentColony.text}';
    var peAdd = pehouse +', '+ pestreet +', ' +pecolony;
    var prhouse = presenthouseNo.text.isEmpty ? '' : '${presenthouseNo.text}';
    var prstreet = presentStreet.text.isEmpty ? '' : '${presentStreet.text}';
    var prcolony = presentColony.text.isEmpty ? '' : '${presentColony.text}';
    var prAdd = prhouse + ', ' + prstreet +', '+ prcolony;
    var empdetails = {
      'empFName': name.text,
      'aadharScanned': aadharScan,
      'empSex': gender,
      'empMaritalStatus': mStatus,
      'empDtofBirth': dob.toString(),
      'motherTongue': language.text,
      'empRemarks': empRemarks.text,
      'empPhone': empPhone.text,
      'vaccineName': vaccineName,
      'vaccineDate': dov.toString(),
      'vaccineDose': dose,
      'branch': '1',
      'employeeType': '',
      'empFatherName': fatherName.text,
      'title': '',
      'unitId': client.toString(),
      'empBloodGroup': AppUtils.checkStr(blood.toString()),
      'department': AppUtils.checkStr(department.toString()),
      'empDesgn': AppUtils.checkStr(designation.toString()),
      'empUANNumber': empUANNumber.text,
      'empESINumber': empESINumber.text,
      'empQualification': qualification.text,
      'empbankname': bank.toString(),
      'empBankAcNo': AppUtils.checkStr(accountNo.text),
      'empIFSCcode': ifsc.text,
      'shirtSize': shirtSize,
      'pantSize': pantSize,
      'shoeSize': shoeSize,
      'doj': doj.toString(),
      'empPermanentAddress': peAdd,
      'peCity': permanentCity.toString(),
      'peState': permanentState.toString(),
      'pepincode': permanentPincode.text,
      'peTown': '',
      'peHno': pehouse,
      'prHno': prhouse,
      'peStreet': pestreet,
      'prStreet': prstreet,
      'peColony': pecolony,
      'prColony': presentColony.text,
      'empPresentAddress': prAdd,
      'prCity': presentCity.toString(),
      'prState': presentState.toString(),
      'prPincode': presentPincode.text,
      'prTown': '',
    };
    var empId = await addEmployeeNew(empdetails);
    addedEmpId = empId;
    print('empId: $empId');
    if (empId != null) {
      var proofDetails = {
        'empId': empId.toString(),
        'aadharCardNo': proofAadharNumber.text,
        'passBookNo': idProof1 == 'PassBook'
            ? proofNumber2.text
            : idProof2 == 'PassBook'
                ? proofNumber3.text
                : '',
        'rationCardNo': idProof1 == 'RationCard'
            ? proofNumber2.text
            : idProof2 == 'RationCard'
                ? proofNumber3.text
                : '',
        'esicCardNo': idProof1 == 'ESICCard'
            ? proofNumber2.text
            : idProof2 == 'ESICCard'
                ? proofNumber3.text
                : '',
        'drivingLicenseNo': idProof1 == 'DrivingLicense'
            ? proofNumber2.text
            : idProof2 == 'DrivingLicense'
                ? proofNumber3.text
                : '',
        'panCardNo': idProof1 == 'PanCard'
            ? proofNumber2.text
            : idProof2 == 'PanCard'
                ? proofNumber3.text
                : '',
        'electricityBillNo': idProof1 == 'ElectricityBill'
            ? proofNumber2.text
            : idProof2 == 'ElectricityBill'
                ? proofNumber3.text
                : '',
        'voterIDNo': idProof1 == 'VoterID'
            ? proofNumber2.text
            : idProof2 == 'VoterID'
                ? proofNumber3.text
                : '',
      };
      print('empdetails: $empdetails');
      print('empFamilyMembers: $empFamilyMembers');
      print('proofDetails: $proofDetails');
      addEmployeeData(empFamilyMembers, proofDetails, aadhar1, aadhar2, proof11, proof12, proof21, proof22, profile, empId);
    }
  }

  void saveEmployeeAsDraft() {
    showDialog(
      context: Get.context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text(
          'If you have any previous draft saved, it will be override. Images will not be stored in draft.',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Get.back();
            },
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () {
              Get.back();
              saveDraftNow();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  void saveDraftNow() async {
    await RemoteServices().box.delete('employeeDraft');
    empFamilyMembers.clear();
    for (var i = 0; i < familyDetail.length; i++) {
      if (familyDetail[i] != null) {
        var familyMember = {
          'relName': famName[i].text,
          'relType': famRelation[i].text,
          'age': famAge[i].text,
          'relAadhaarNo': famAadhar[i].text,
          'dofBirth': famDob[i].text.isEmpty ? '' : '${famDob[i].text.split('-')[2]}-${famDob[i].text.split('-')[1]}-${famDob[i].text.split('-')[0]}',
          'nomineePercent': famPercent[i].text,
          'pfNominee': famNominee[i] ? 'Y' : 'N',
          'esiNominee': famNominee[i] ? 'Y' : 'N',
        };
        print('familyMember: $familyMember');
        empFamilyMembers.add(familyMember);
      }
    }
    var proofDetails = {
      'idProof': idProof,
      'proofAadharNumber': proofAadharNumber.text,
      'proofAadharNumberConfirm': proofAadharNumberConfirm.text,
      'idProof1': idProof1,
      'proofNumber2': proofNumber2.text,
      'idProof2': idProof2,
      'proofNumber3': proofNumber3.text,
    };
    var empdetails = {
      'empFName': name.text,
      'aadharScanned': aadharScan,
      'aadhar': aadhar.text,
      'empSex': gender,
      'empMaritalStatus': mStatus,
      'empDtofBirth': dob == null ? '' : dob.toString(),
      'motherTongue': language.text,
      'empPhone': empPhone.text,
      'vaccineName': vaccineName,
      'vaccineDate': dov == null ? '' : dov.toString(),
      'vaccineDose': dose,
      'branch': '1',
      'employeeType': '',
      'empFatherName': '',
      'title': '',
      'unitId': client == null ? '' : client.toString(),
      'unitIdText': clientAu.text,
      'sitePostedTo': sitePostedTo == null ? '' : sitePostedTo.toString(),
      'empBloodGroup': blood == null ? '' : blood.toString(),
      'department': department == null ? '' : department.toString(),
      'departmentText': deptAu.text,
      'empDesgn': designation == null ? '' : designation.toString(),
      'empDesgnText': desigAu.text,
      'empUANNumber': empUANNumber.text,
      'empESINumber': empESINumber.text,
      'empQualification': qualification.text,
      'empbankname': bank == null ? null : bank.toString(),
      'empBankAcNo': AppUtils.checkStr(accountNo.text),
      'empIFSCcode': ifsc.text,
      'shirtSize': shirtSize == null ? '' : shirtSize.toString(),
      'pantSize': pantSize == null ? '' : pantSize.toString(),
      'shoeSize': shoeSize == null ? '' : shoeSize.toString(),
      'doj': doj == null ? '' : doj.toString(),
      'presenthouseNo': presenthouseNo.text,
      'presentStreet': presentStreet.text,
      'presentColony': presentColony.text,
      'presentPincode': presentPincode.text,
      'empRemarks': empRemarks.text,
      'presentState': presentState == null ? '' : presentState.toString(),
      'presentCity': presentCity == null ? '' : presentCity.toString(),
      'copyAdd': copyAdd,
      'permanenthouseNo': permanenthouseNo.text,
      'permanentStreet': permanentStreet.text,
      'permanentColony': permanentColony.text,
      'permanentPincode': permanentPincode.text,
      'permanentState': permanentState == null ? '' : permanentState.toString(),
      'permanentCity': permanentCity == null ? '' : permanentCity.toString(),
      'empFamilyMembers': empFamilyMembers,
      'proofDetails': proofDetails,
    };
    await RemoteServices().box.put('employeeDraft', jsonEncode(empdetails));
    Get.snackbar(
      null,
      'Draft Saved',
      colorText: Colors.white,
      duration: Duration(seconds: 2),
      backgroundColor: AppUtils().greenColor,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
      borderRadius: 5.0,
    );
    Timer(Duration(seconds: 2), () {
      reload = true;
      Get.offAll(DashboardPage());
    });
  }

  void loadEmployeeFromDraft() async {
    if (RemoteServices().box.get('employeeDraft') != null) {
      print(RemoteServices().box.get('employeeDraft'));
      print('employeeDraft: ${jsonDecode(RemoteServices().box.get('employeeDraft'))}');
      var draftEmployee = jsonDecode(RemoteServices().box.get('employeeDraft'));
      // personal info
      name.text = draftEmployee['empFName'];
      aadharScan = draftEmployee['aadharScanned'];
      aadhar.text = draftEmployee['aadhar'];
      gender = draftEmployee['empSex'];
      mStatus = draftEmployee['empMaritalStatus'];
      if (draftEmployee['empDtofBirth'] != null && draftEmployee['empDtofBirth'] != '') {
        dob = draftEmployee['empDtofBirth'];
        dtOfBirth.text = DateFormat('dd-MM-yyyy').format(DateTime.parse(draftEmployee['empDtofBirth'].toString())).toString();
      }
      language.text = draftEmployee['motherTongue'];
      empPhone.text = draftEmployee['empPhone'];
      empESINumber.text = draftEmployee['empESINumber'];
      empUANNumber.text = draftEmployee['empUANNumber'];
      department = draftEmployee['department'];
      deptAu.text = draftEmployee['departmentText'];
      client = draftEmployee['unitId'];
      clientAu.text = draftEmployee['unitIdText'];
      sitePostedTo = draftEmployee['unitId'];
      if (draftEmployee['empBloodGroup'] != null && draftEmployee['empBloodGroup'] != '') blood = draftEmployee['empBloodGroup'].toString();
      designation = draftEmployee['empDesgn'];
      desigAu.text = draftEmployee['empDesgnText'];
      if (draftEmployee['doj'] != null && draftEmployee['doj'] != '') {
        doj = draftEmployee['doj'];
        dtOfJoin.text = DateFormat('dd-MM-yyyy').format(DateTime.parse(draftEmployee['doj'].toString())).toString();
      }
      qualification.text = draftEmployee['empQualification'];
      // vaccine info
      if (draftEmployee['vaccineName'] != null && draftEmployee['vaccineName'] != '') vaccineName = draftEmployee['vaccineName'];
      dose = draftEmployee['vaccineDose'];
      if (draftEmployee['vaccineDate'] != null && draftEmployee['vaccineDate'] != '') {
        dov = draftEmployee['vaccineDate'];
        dtOfVaccine.text = DateFormat('dd-MM-yyyy').format(DateTime.parse(draftEmployee['vaccineDate'].toString())).toString();
      }
      // bank & uniform info
      if (draftEmployee['empbankname'] != null && draftEmployee['empbankname'] != '' && draftEmployee['empbankname'] != 'null') bank = draftEmployee['empbankname'];
      accountNo.text = draftEmployee['empBankAcNo'];
      ifsc.text = draftEmployee['empIFSCcode'];
      if (draftEmployee['shirtSize'] != null && draftEmployee['shirtSize'] != '') shirtSize = draftEmployee['shirtSize'];
      if (draftEmployee['pantSize'] != null && draftEmployee['pantSize'] != '') pantSize = draftEmployee['pantSize'];
      if (draftEmployee['shoeSize'] != null && draftEmployee['shoeSize'] != '') shoeSize = draftEmployee['shoeSize'];
      // address info
      // adminC.getCities(int.parse(value), 'present');
      // adminC.getCities(int.parse(value), 'permanent');
      presenthouseNo.text = draftEmployee['presenthouseNo'];
      presentStreet.text = draftEmployee['presentStreet'];
      presentColony.text = draftEmployee['presentColony'];
      presentPincode.text = draftEmployee['presentPincode'];
      if (draftEmployee['presentState'] != null && draftEmployee['presentState'] != '') presentState = draftEmployee['presentState'];
      if (draftEmployee['presentState'] != null && draftEmployee['presentState'] != '') {
        await getCities(int.parse(draftEmployee['presentState']), 'present', showDialogue: false);
      }
      if (draftEmployee['presentCity'] != null && draftEmployee['presentCity'] != '') presentCity = draftEmployee['presentCity'];
      copyAdd = draftEmployee['copyAdd'];
      permanenthouseNo.text = draftEmployee['permanenthouseNo'];
      permanentStreet.text = draftEmployee['permanentStreet'];
      permanentColony.text = draftEmployee['permanentColony'];
      permanentPincode.text = draftEmployee['permanentPincode'];
      if (draftEmployee['permanentState'] != null && draftEmployee['permanentState'] != '') permanentState = draftEmployee['permanentState'];
      if (draftEmployee['permanentState'] != null && draftEmployee['permanentState'] != '') {
        await getCities(int.parse(draftEmployee['permanentState']), 'permanent', showDialogue: false);
      }
      if (draftEmployee['permanentCity'] != null && draftEmployee['permanentCity'] != '') permanentCity = draftEmployee['permanentCity'];
      // family info
      var familyData = draftEmployee['empFamilyMembers'];
      if (familyData != null && familyData.length > 0) {
        famName.clear();
        famDob.clear();
        famAge.clear();
        famAadhar.clear();
        famRelation.clear();
        famNominee.clear();
        famPercent.clear();
        familyDetail.clear();
        famIndex(0);
        for (var i = 0; i < familyData.length; i++) {
          print('familyData[i]: ${familyData[i]}');
          setupFamilyDraft(i, familyData[i]);
        }
      }
      // photos/proof info
      var proofData = draftEmployee['proofDetails'];
      if (proofData['idProof'] != null && proofData['idProof'] != '') idProof = proofData['idProof'];
      proofAadharNumber.text = proofData['proofAadharNumber'];
      proofAadharNumberConfirm.text = proofData['proofAadharNumberConfirm'];
      if (proofData['idProof1'] != null && proofData['idProof1'] != '') idProof1 = proofData['idProof1'];
      proofNumber2.text = proofData['proofNumber2'];
      if (proofData['idProof2'] != null && proofData['idProof2'] != '') idProof2 = proofData['idProof2'];
      proofNumber3.text = proofData['proofNumber3'];
      updatingData.refresh();
    }
  }
}
