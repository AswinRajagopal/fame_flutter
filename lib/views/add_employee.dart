import 'package:intl/intl.dart';

import '../connection/remote_services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../utils/utils.dart';
import '../controllers/admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEmployee extends StatefulWidget {
  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final AdminController adminC = Get.put(AdminController());
  TextEditingController name = TextEditingController();
  TextEditingController empid = TextEditingController();
  TextEditingController designation = TextEditingController();
  TextEditingController dtOfBirth = TextEditingController();
  TextEditingController empPhone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController shift = TextEditingController();
  TextEditingController clientName = TextEditingController();
  TextEditingController email = TextEditingController();
  var gender = 'M';
  var sitePostedTo;
  var dob;

  @override
  void initState() {
    adminC.pr = ProgressDialog(
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
    adminC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(
      Duration(milliseconds: 100),
      adminC.getDesignation,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  var curDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

  Future<Null> getDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(
        curDate.toString(),
      ),
      firstDate: DateTime.now().add(Duration(days: -36500)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      print('Date selected ${dtOfBirth.text.toString()}');
      setState(() {
        dtOfBirth.text = DateFormat('dd-MM-yyyy').format(picked).toString();
        dob = DateFormat('yyyy-MM-dd').format(picked).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().innerScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Add Employee',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 1.20,
                child: ListView(
                  shrinkWrap: true,
                  primary: true,
                  physics: ScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TextField(
                        controller: name,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          hintText: 'Name',
                          prefixIcon: Column(
                            children: [
                              Image.asset(
                                'assets/images/person_male.png',
                                color: Colors.grey[600],
                                scale: 1.3,
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
                        controller: empid,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          hintText: 'Emp ID',
                          prefixIcon: Column(
                            children: [
                              Image.asset(
                                'assets/images/emp_id_icon.png',
                                color: Colors.grey[600],
                                scale: 1.2,
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
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          hintText: 'Email Address',
                          prefixIcon: Column(
                            children: [
                              Image.asset(
                                'assets/images/email.png',
                                color: Colors.grey,
                                scale: 1.3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 10.0,
                    //     vertical: 10.0,
                    //   ),
                    //   child: TextField(
                    //     controller: designation,
                    //     decoration: InputDecoration(
                    //       isDense: true,
                    //       contentPadding: EdgeInsets.all(10),
                    //       hintStyle: TextStyle(
                    //         color: Colors.grey[600],
                    //         fontSize: 18.0,
                    //       ),
                    //       hintText: 'Designation',
                    //       prefixIcon: Column(
                    //         children: [
                    //           Image.asset(
                    //             'assets/images/designation.png',
                    //             color: Colors.grey[400],
                    //             scale: 2.0,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Obx(() {
                      if (adminC.isLoading.value) {
                        return Column();
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 10.0,
                          ),
                          child: DropdownButtonFormField<dynamic>(
                            hint: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Select Designation',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            isExpanded: true,
                            // value: json.encode(aC.clientList.first.clientManpowerList),
                            items: adminC.desList.map((item) {
                              // print('item: ${item.client.id}');
                              return DropdownMenuItem(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    item['design'],
                                  ),
                                ),
                                value: item['designId'],
                              );
                            }).toList(),
                            onChanged: (value) {
                              designation.text = value;
                              setState(() {});
                            },
                          ),
                        );
                      }
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            'Gender',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Radio(
                            value: 'M',
                            groupValue: gender,
                            onChanged: (sVal) {
                              // chkDate(sVal);
                              setState(() {
                                gender = sVal;
                              });
                            },
                          ),
                          Text(
                            'Male',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Radio(
                            value: 'F',
                            groupValue: gender,
                            onChanged: (sVal) {
                              // chkDate(sVal);
                              setState(() {
                                gender = sVal;
                              });
                            },
                          ),
                          Text(
                            'Female',
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
                      child: TextField(
                        controller: dtOfBirth,
                        readOnly: true,
                        keyboardType: null,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          hintText: 'Date of Birth',
                          prefixIcon: Column(
                            children: [
                              Image.asset(
                                'assets/images/dob.png',
                                color: Colors.grey[400],
                                scale: 2.2,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          getDate(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TextField(
                        controller: empPhone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          hintText: 'Phone No.',
                          prefixIcon: Column(
                            children: [
                              Image.asset(
                                'assets/images/phone.png',
                                color: Colors.grey[400],
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
                        controller: address,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          hintText: 'Address',
                          prefixIcon: Column(
                            children: [
                              Image.asset(
                                'assets/images/address.png',
                                color: Colors.grey[400],
                                scale: 2.0,
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
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: clientName,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0,
                            ),
                            hintText: 'Select Client',
                            prefixIcon: Column(
                              children: [
                                Image.asset(
                                  'assets/images/siteposted.png',
                                  color: Colors.grey[400],
                                  scale: 1.8,
                                ),
                              ],
                            ),
                          ),
                        ),
                        suggestionsCallback: (pattern) async {
                          // print(pattern);
                          if (pattern.isNotEmpty) {
                            return await RemoteServices().getClientsSugg(pattern);
                          } else {
                            sitePostedTo = null;
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
                          clientName.text = suggestion['name'].toString().trimRight() + ' - ' + suggestion['id'];
                          sitePostedTo = suggestion['id'];
                          adminC.getShift(suggestion['id']);
                        },
                        autoFlipDirection: true,
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 10.0,
                    //     vertical: 10.0,
                    //   ),
                    //   child: TextField(
                    //     controller: shift,
                    //     decoration: InputDecoration(
                    //       isDense: true,
                    //       contentPadding: EdgeInsets.all(10),
                    //       hintStyle: TextStyle(
                    //         color: Colors.grey[600],
                    //         fontSize: 18.0,
                    //       ),
                    //       hintText: 'Shift',
                    //       prefixIcon: Column(
                    //         children: [
                    //           Image.asset(
                    //             'assets/images/branch.png',
                    //             color: Colors.grey[400],
                    //             scale: 2.0,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Obx(() {
                      if (adminC.isLoading.value) {
                        return Column();
                      } else if (adminC.shiftList.isNullOrBlank) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 10.0,
                          ),
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(10),
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 18.0,
                              ),
                              hintText: 'Select client to see available shift',
                              prefixIcon: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/branch.png',
                                    color: Colors.grey[400],
                                    scale: 2.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 10.0,
                          ),
                          child: DropdownButtonFormField<dynamic>(
                            hint: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Select Shift',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            isExpanded: true,
                            // value: json.encode(aC.clientList.first.clientManpowerList),
                            items: adminC.shiftList.map((item) {
                              // print('item: ${item.client.id}');
                              return DropdownMenuItem(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    item['shift'],
                                  ),
                                ),
                                value: item['shift'].toString(),
                              );
                            }).toList(),
                            onChanged: (value) {
                              shift.text = value;
                              setState(() {});
                            },
                          ),
                        );
                      }
                    }),
                  ],
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
                          onPressed: () {
                            print('Submit');
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (name.text.isNullOrBlank || empid.text.isNullOrBlank || designation.text.isNullOrBlank || gender == '' || dtOfBirth.text.isNullOrBlank || empPhone.text.isNullOrBlank || address.text.isNullOrBlank || shift.text.isNullOrBlank || sitePostedTo == null || email.text.isNullOrBlank) {
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
                            } else if (!GetUtils.isEmail(email.text)) {
                              Get.snackbar(
                                null,
                                'Please provide valid email',
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
                            } else if (empPhone.text != '' && empPhone.text.length != 10) {
                              Get.snackbar(
                                null,
                                'Please provide valid 10 digit mobile',
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
                              print('name: ${name.text}');
                              print('address: ${address.text}');
                              print('email: ${email.text}');
                              print('phone: ${empPhone.text}');
                              print('empId: ${empid.text}');
                              print('sitePostedTo: $sitePostedTo');
                              print('gender: $gender');
                              print('dob: $dob');
                              print('design: ${designation.text}');
                              print('shift: ${shift.text}');
                              adminC.addEmployee(name.text, address.text, email.text, empPhone.text, empid.text.toUpperCase(), sitePostedTo, gender, dob, designation.text, shift.text);
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
      ),
    );
  }
}
