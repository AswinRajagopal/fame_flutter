import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/admin_controller.dart';
import 'ob_bank.dart';

class OBVaccine extends StatefulWidget {
  @override
  _OBVaccineState createState() => _OBVaccineState();
}

class _OBVaccineState extends State<OBVaccine> {
  final AdminController adminC = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vaccination Info',
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
                    SizedBox(
                      height: 10.0,
                    ),
                    Obx(() {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10.0,
                        ),
                        child: DropdownButtonFormField<dynamic>(
                          hint: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Select Vaccine Taken',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 18.0,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          isExpanded: false,
                          value: adminC.vaccineName,
                          items: adminC.vaccineType.map((item) {
                            //print('item: $item');
                            return DropdownMenuItem(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  item['vaccineName'],
                                ),
                              ),
                              value: item['vaccineId'].toString(),
                            );
                          }).toList(),
                          onChanged: (value) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            adminC.vaccineName = value;
                          },
                        ),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TextField(
                        controller: adminC.dtOfVaccine,
                        readOnly: true,
                        keyboardType: null,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          hintText: 'Last Vaccinated Date',
                          prefixIcon: Image.asset(
                            'assets/images/icon_calender.png',
                            color: Colors.grey,
                            scale: 1.2,
                          ),
                        ),
                        onTap: () {
                          adminC.getDateVaccine(context);
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
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            'Dose Taken',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Radio(
                            value: '1',
                            groupValue: adminC.dose,
                            onChanged: (sVal) {
                              setState(() {
                                adminC.dose = sVal;
                              });
                            },
                          ),
                          Text(
                            '1st',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Radio(
                            value: '2',
                            groupValue: adminC.dose,
                            onChanged: (sVal) {
                              setState(() {
                                adminC.dose = sVal;
                              });
                            },
                          ),
                          Text(
                            '2nd',
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              adminC.dtOfVaccine.clear();
                              adminC.dov = null;
                              adminC.vaccineName = null;
                              adminC.dose = '';
                              setState(() {});
                            },
                            child: Text(
                              'Clear Data',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FlatButton(
                            onPressed: () {
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
                              if (adminC.vaccineName != null && !adminC.dtOfVaccine.text.isNullOrBlank && adminC.dose != null && adminC.dose != '') {
                                Get.to(OBBank());
                              } else if (adminC.vaccineName == null && adminC.dtOfVaccine.text.isNullOrBlank && (adminC.dose == null || adminC.dose == '')) {
                                Get.to(OBBank());
                              } else {
                                Get.snackbar(
                                  null,
                                  'Please provide all data or clear the data',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              }
                              // if (!adminC.dtOfVaccine.text.isNullOrBlank && (adminC.dose == null || adminC.dose == '')) {
                              //   Get.snackbar(
                              //     null,
                              //     'Please select dose taken or clear the data',
                              //     colorText: Colors.white,
                              //     backgroundColor: Colors.black87,
                              //     snackPosition: SnackPosition.BOTTOM,
                              //     margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                              //     padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                              //     borderRadius: 5.0,
                              //   );
                              // } else if (adminC.dose != null && adminC.dose != '' && adminC.dtOfVaccine.text.isNullOrBlank) {
                              //   Get.snackbar(
                              //     null,
                              //     'Please select last vaccinated date or clear the data',
                              //     colorText: Colors.white,
                              //     backgroundColor: Colors.black87,
                              //     snackPosition: SnackPosition.BOTTOM,
                              //     margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                              //     padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                              //     borderRadius: 5.0,
                              //   );
                              // } else {
                              //   Get.to(OBBank());
                              // }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 50.0,
                              ),
                              child: Text(
                                'Next',
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
