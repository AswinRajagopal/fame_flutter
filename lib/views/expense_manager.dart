import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fame/controllers/expense_controller.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:number_to_character/number_to_character.dart';
import '../connection/remote_services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;

class Expenses extends StatefulWidget {
  final String details;
  Expenses({this.details});

  @override
  _ExpensesState createState() => _ExpensesState(this.details);
}

class _ExpensesState extends State<Expenses> {
  final ExpenseController expC = Get.put(ExpenseController());
  CameraController controller;
  final TextEditingController date = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController attach = TextEditingController();
  final TextEditingController attachOne = TextEditingController();
  final TextEditingController attachTwo = TextEditingController();
  final TextEditingController expense = TextEditingController();
  final TextEditingController remarks = TextEditingController();
  var empId;
  var expenseTypeId;
  File attachment, attachment2, attachment3;
  var passDate;
  var amountInWords = '';

  var details;
  _ExpensesState(this.details);

  @override
  void initState() {
    date.text = DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
    passDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    expC.pr = ProgressDialog(
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
    expC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(
      Duration(milliseconds: 100),
      expC.getExpenses,
    );
    super.initState();
  }


  Future<Null> getDate(BuildContext context) async {
    int attendanceDaysPermitted = jsonDecode(
        RemoteServices().box.get('appFeature'))['attendanceDaysPermitted'];
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(
        passDate.toString(),
      ),
      firstDate:
          DateTime.now().add(Duration(days: -(attendanceDaysPermitted - 1))),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        date.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        passDate = DateFormat('yyyy-MM-dd').format(picked).toString();
      });
    }
  }

  Future<Null> getWord(amount) {
    var converter = NumberToCharacterConverter('en');
    var amtInWords = int.parse(amount);
    if (amtInWords != null) {
      setState(() {
        amountInWords = converter.convertInt(amtInWords).capitalizeFirst;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().innerScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Expense Management',
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
            setState(() {
              expC.exp.clear();
            });
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          setState(() {
            expC.exp.clear();
          });
          return true;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: RemoteServices().box.get('role') != '3'
                      ? MediaQuery.of(context).size.height / 1.20
                      : MediaQuery.of(context).size.height / 1.35,
                  child: ListView(
                    shrinkWrap: true,
                    primary: true,
                    physics: ScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Text(
                              'Add Expense',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 5.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(color: Colors.black38)),
                                color: Colors.grey[200],
                                child: Container(
                                  width: 200,
                                  height: 55,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        date.text,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Flexible(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(color: Colors.black38)),
                                color: Colors.grey[200],
                                child: Container(
                                  width: 200,
                                  height: 55,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        RemoteServices()
                                            .box
                                            .get('empid')
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.black38)),
                          color: Colors.grey[200],
                          child: Container(
                            width: 200,
                            height: 55,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  RemoteServices().box.get('empName'),
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.black54),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 5.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(color: Colors.black38)),
                                child: Container(
                                  width: double.infinity,
                                  height: 60,
                                  child: TextField(
                                    controller: amount,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(10),
                                      hintStyle: TextStyle(
                                        fontSize: 18.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                      labelText: 'Amount',
                                      labelStyle: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 18.0),
                                    ),
                                    onChanged: (val) {
                                      getWord(amount.text);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Visibility(
                              visible:amount.text.isNotEmpty,
                              maintainSize: false,
                              child: Flexible(
                                child:DropdownSearch(
                                    mode: Mode.MENU,
                                    showSearchBox: true,
                                    isFilteredOnline: true,
                                    dropDownButton: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey,
                                      size: 18.0,
                                    ),
                                    hint: 'Expenses Type',
                                    showSelectedItem: true,
                                    items: expC.exp.map((item) {
                                      var sC = item['expenseType'].toString();
                                      return sC.toString();
                                    }).toList(),
                                    onChanged: (value) {
                                      print('value:$value');
                                      for (var e in expC.exp) {
                                        if (e['expenseType'] == value) {
                                          expenseTypeId = e['expenseTypeId'];
                                          break;
                                        }
                                      }
                                      setState(() {});
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 5.0),
                        child: Row(
                          children: [
                            Text(
                              'Amount In Words:',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 5.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                amountInWords != null ? amountInWords : '',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.black38)),
                          child: Container(
                            child: TextField(
                              controller: remarks,
                              maxLength: 160,
                              maxLengthEnforced: true,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                                hintText: 'Remarks...',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0,
                        ),
                        child: Row(children: [
                          Flexible(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(color: Colors.black38)),
                              child: Container(
                                width: 400,
                                height: 60,
                                child: TextField(
                                  controller: attach,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(
                                      left: 10,
                                      top: 18,
                                    ),
                                    hintStyle: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 18.0,
                                    ),
                                    hintText: 'Attachment',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                    ),
                                  ),
                                  readOnly: true,
                                  keyboardType: null,
                                  onTap: () async {
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
                                                    var pickedFile =
                                                        await ImagePicker()
                                                            .getImage(
                                                      source:
                                                          ImageSource.camera,
                                                      imageQuality: 50,
                                                    );
                                                    if (pickedFile != null) {
                                                      attachment = new File(
                                                          pickedFile.path);
                                                      String dir = path.dirname(
                                                          pickedFile.path);
                                                      attach.text = path.join(
                                                          '', 'image1.jpg');
                                                      setState(() {});
                                                    } else {
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
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                TextButton(
                                                  onPressed: () async {
                                                    Get.back();
                                                    var pickedFile =
                                                        await ImagePicker()
                                                            .getImage(
                                                      source:
                                                          ImageSource.gallery,
                                                      imageQuality: 50,
                                                    );
                                                    if (pickedFile != null) {
                                                      attachment = new File(
                                                          pickedFile.path);
                                                      String dir = path.dirname(
                                                          pickedFile.path);
                                                      attach.text = path.join(
                                                          '', 'image1.jpg');
                                                      setState(() {});
                                                    } else {
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
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
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
                            ),
                          ),
                          attachment2 != null
                              ? GestureDetector(
                                  onTap: () async {
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
                                                    var pickedFile =
                                                        await ImagePicker()
                                                            .getImage(
                                                      source:
                                                          ImageSource.camera,
                                                      imageQuality: 50,
                                                    );
                                                    if (pickedFile != null) {
                                                      attachment3 = new File(
                                                          pickedFile.path);
                                                      String dir = path.dirname(
                                                          pickedFile.path);
                                                      attachTwo.text =
                                                          path.join(
                                                              '', 'image3.jpg');
                                                      setState(() {});
                                                    } else {
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
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                TextButton(
                                                  onPressed: () async {
                                                    Get.back();
                                                    var pickedFile =
                                                        await ImagePicker()
                                                            .getImage(
                                                      source:
                                                          ImageSource.gallery,
                                                      imageQuality: 50,
                                                    );
                                                    if (pickedFile != null) {
                                                      attachment3 = new File(
                                                          pickedFile.path);
                                                      attachTwo.text =
                                                          path.join(
                                                              '', 'image3.jpg');
                                                      setState(() {});
                                                    } else {
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
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
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
                                  child: Icon(
                                    Icons.add_circle,
                                    color: AppUtils().blueColor,
                                    size: 40.0,
                                  ),
                                )
                              : attachment != null
                                  ? GestureDetector(
                                      onTap: () async {
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
                                                        var pickedFile =
                                                            await ImagePicker()
                                                                .getImage(
                                                          source: ImageSource
                                                              .camera,
                                                          imageQuality: 50,
                                                        );
                                                        if (pickedFile !=
                                                            null) {
                                                          attachment2 =
                                                              new File(
                                                                  pickedFile
                                                                      .path);
                                                          attachOne.text =
                                                              path.join('',
                                                                  'image2.jpg');
                                                          setState(() {});
                                                        } else {
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
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    TextButton(
                                                      onPressed: () async {
                                                        Get.back();
                                                        var pickedFile =
                                                            await ImagePicker()
                                                                .getImage(
                                                          source: ImageSource
                                                              .gallery,
                                                          imageQuality: 50,
                                                        );
                                                        if (pickedFile !=
                                                            null) {
                                                          attachment2 =
                                                              new File(
                                                                  pickedFile
                                                                      .path);
                                                          attachOne.text =
                                                              path.join('',
                                                                  'image2.jpg');
                                                          setState(() {});
                                                        } else {
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
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
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
                                      child: Icon(
                                        Icons.add_circle,
                                        color: AppUtils().blueColor,
                                        size: 40.0,
                                      ),
                                    )
                                  : Column(),
                        ]),
                      ),
                      Row(
                        children: [
                          attachment != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0, vertical: 10.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 150,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black54,
                                        width: 1,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        attach.text,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )
                              : Column(),
                          attachment2 != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 150,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black54,
                                        width: 1,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        attachOne.text,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )
                              : Column(),
                        ],
                      ),
                      Row(
                        children: [
                          attachment3 != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0,
                                    vertical: 10.0,
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 150,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black54,
                                        width: 1,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        attachTwo.text,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )
                              : Column(),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: RaisedButton(
                          onPressed: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (attachment == null) {
                              Get.snackbar(
                                null,
                                'Please provide Attachment',
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
                            if (amount.text == null ||
                                amount.text == '' ||
                                remarks.text == null ||
                                remarks.text == '') {
                              Get.snackbar(
                                null,
                                'Please provide all the details',
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
                            } else if (expC.exp.isEmpty) {
                              Get.snackbar(
                                null,
                                'Please select at least one Expense Type',
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
                            } else {
                              expC.newExpenses(amount.text, expenseTypeId, remarks.text, attachment, attachment2, attachment3);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
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
                          color: AppUtils().blueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: AppUtils().blueColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController inputController;
  MyTextField(this.hintText, this.inputController);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0,
      ),
      child: TextField(
        controller: inputController,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(10),
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 18.0,
            // fontWeight: FontWeight.bold,
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
