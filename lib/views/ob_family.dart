import '../widgets/ob_top_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/admin_controller.dart';
import '../utils/utils.dart';
import 'ob_photos.dart';

class OBFamily extends StatefulWidget {
  @override
  _OBFamilyState createState() => _OBFamilyState();
}

class _OBFamilyState extends State<OBFamily> {
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
          'Family Details',
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
            OBTopNavigation('family'),
            SizedBox(
              height: 15.0,
            ),
            Obx(() {
              return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: adminC.familyDetail.length,
                itemBuilder: (context, index) {
                  var fam = adminC.familyDetail[index];
                  return fam ?? Container();
                },
              );
            }),
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    adminC.setupFamily(adminC.famIndex.value);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 50.0,
                    ),
                    child: Text(
                      'Add Family Member',
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
            SizedBox(
              height: 15.0,
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
                      adminC.step5(false);
                      var error = false;
                      adminC.empFamilyMembers.clear();
                      for (var i = 0; i < adminC.familyDetail.length; i++) {
                        if (adminC.familyDetail[i] != null) {
                          if (AppUtils.checkTextisNull(
                              adminC.famName[i], 'Member Name') &&
                              adminC.mandateList['mandateFields']
                              ['nameOfMember']) {
                              error = true;
                              Get.snackbar(
                                null,
                                'Please provide Member Name',
                                colorText: Colors.white,
                                backgroundColor: Colors.black87,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 10.0),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 18.0),
                                borderRadius: 5.0,
                              );
                          } else if (AppUtils.checkTextisNull(
                              adminC.famDob[i], 'Member Dob') &&
                              adminC.mandateList['mandateFields']
                              ['dobOfMember']) {
                              error = true;
                              Get.snackbar(
                                null,
                                'Please provide Member Dob',
                                colorText: Colors.white,
                                backgroundColor: Colors.black87,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 10.0),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 18.0),
                                borderRadius: 5.0,
                              );
                          } else if (AppUtils.checkTextisNull(
                              adminC.famAge[i], 'Member Age') &&
                              adminC.mandateList['mandateFields']['age']) {
                              error = true;
                              Get.snackbar(
                                null,
                                'Please provide Member Age',
                                colorText: Colors.white,
                                backgroundColor: Colors.black87,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 10.0),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 18.0),
                                borderRadius: 5.0,
                              );
                          } else if (AppUtils.checkTextisNull(
                              adminC.famRelation[i], 'Member Relation') &&
                              adminC.mandateList['mandateFields']
                              ['selectMember']) {
                              error = true;
                              Get.snackbar(
                                null,
                                'Please provide Member Relation',
                                colorText: Colors.white,
                                backgroundColor: Colors.black87,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 10.0),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 18.0),
                                borderRadius: 5.0,
                              );
                          } else {
                            // done
                            error = false;
                            var familyMember = {
                              'relName': adminC.famName[i].text,
                              'relType': adminC.famRelation[i].text,
                              'age': adminC.famAge[i].text,
                              'empId': adminC.addedEmpId.toString(),
                              'relAadhaarNo': adminC.famAadhar[i].text,
                              // 'dofBirth': adminC.famDob[i].text,
                              'dofBirth':
                                  adminC.famDob[i].isNullOrBlank?'':'${adminC.famDob[i].text.split('-')[2]}-${adminC.famDob[i].text.split('-')[1]}-${adminC.famDob[i].text.split('-')[0]}',
                              'nomineePercent': adminC.famPercent[i].text,
                              'pfNominee': adminC.famNominee[i] ? 'Y' : 'N',
                              'esiNominee': adminC.famNominee[i] ? 'Y' : 'N',
                            };
                            print('familyMember: $familyMember');
                            adminC.empFamilyMembers.add(familyMember);
                          }
                        }
                      }
                      if (!error) {
                        Get.to(OBPhotos());
                        adminC.step5(true);
                      }
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
      ),
    );
  }
}
