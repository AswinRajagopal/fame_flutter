import '../widgets/ob_top_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/admin_controller.dart';
import '../utils/utils.dart';
import 'ob_family.dart';

class OBAddress extends StatefulWidget {
  @override
  _OBAddressState createState() => _OBAddressState();
}

class _OBAddressState extends State<OBAddress> {
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
          'Address',
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
                    OBTopNavigation('address'),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Text(
                        'Present Address',
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
                      child: TextField(
                        controller: adminC.presenthouseNo,
                        maxLength: 160,
                        maxLengthEnforced: true,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          labelText: 'House No.',labelStyle: TextStyle(color:Colors.grey[600],fontSize: 18.0),
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/home.png',
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
                        controller: adminC.presentStreet,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          labelText: 'Street',labelStyle: TextStyle(color:Colors.grey[600],fontSize: 18.0),
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/street.png',
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
                        controller: adminC.presentColony,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          labelText: 'Colony',labelStyle: TextStyle(color:Colors.grey[600],fontSize: 18.0),
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/colony.png',
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
                        controller: adminC.presentPincode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          labelText: 'Pincode',labelStyle: TextStyle(color:Colors.grey[600],fontSize: 18.0),
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/address.png',
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
                      child: DropdownButtonFormField<dynamic>(
                        hint: Text(
                          'Select State',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        isExpanded: false,
                        value: adminC.presentState,
                        items: adminC.statesList.map((item) {
                          //print('item: $item');
                          return DropdownMenuItem(
                            child: Text(
                              item['state'],
                            ),
                            value: item['stateID'].toString(),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/state.png',
                                color: Colors.grey[400],
                                scale: 2.0,
                              ),
                            ],
                          ),
                        ),
                        onChanged: (value) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          adminC.presentState = value;
                          setState(() {});
                          adminC.getCities(int.parse(value), 'present');
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: DropdownButtonFormField<dynamic>(
                        hint: Text(
                          'Select City',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        isExpanded: false,
                        value: adminC.presentCity,
                        items: adminC.citiesList.map((item) {
                          //print('item: $item');
                          return DropdownMenuItem(
                            child: Text(
                              item['city'],
                            ),
                            value: item['cityID'].toString(),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/city.png',
                                color: Colors.grey[400],
                                scale: 2.0,
                              ),
                            ],
                          ),
                        ),
                        onChanged: (value) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          adminC.presentCity = value;
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
                        children: [
                          Checkbox(
                            value: adminC.copyAdd,
                            onChanged: (value) {
                              print(value);
                              if (adminC.presenthouseNo.text.isNullOrBlank || adminC.presentStreet.text.isNullOrBlank || adminC.presentColony.text.isNullOrBlank || adminC.presentPincode.text.isNullOrBlank || adminC.presentState == null || adminC.presentCity == null) {
                                Get.snackbar(
                                  null,
                                  'Please provide present address first',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              } else {
                                if (value) {
                                  adminC.permanenthouseNo.text = adminC.presenthouseNo.text;
                                  adminC.permanentStreet.text = adminC.presentStreet.text;
                                  adminC.permanentColony.text = adminC.presentColony.text;
                                  adminC.permanentPincode.text = adminC.presentPincode.text;
                                  adminC.permanentState = adminC.presentState;
                                  adminC.permanentCity = adminC.presentCity;
                                  adminC.percitiesList.addAll(adminC.citiesList);
                                } else {
                                  adminC.permanenthouseNo.clear();
                                  adminC.permanentStreet.clear();
                                  adminC.permanentColony.clear();
                                  adminC.permanentPincode.clear();
                                  adminC.permanentState = null;
                                  adminC.permanentCity = null;
                                  adminC.percitiesList.clear();
                                }
                                adminC.copyAdd = value;
                                setState(() {});
                              }
                            },
                          ),
                          Text(
                            'Copy to Permanent Address',
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
                      child: Text(
                        'Permanent Address',
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
                      child: TextField(
                        controller: adminC.permanenthouseNo,
                        maxLength: 160,
                        maxLengthEnforced: true,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          labelText: 'House No.*',labelStyle: TextStyle(color:Colors.grey[600],fontSize: 18.0),
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/home.png',
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
                        controller: adminC.permanentStreet,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          labelText: 'Street',labelStyle: TextStyle(color:Colors.grey[600],fontSize: 18.0),
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/street.png',
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
                        controller: adminC.permanentColony,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          labelText: 'Colony',labelStyle: TextStyle(color:Colors.grey[600],fontSize: 18.0),
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/colony.png',
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
                        controller: adminC.permanentPincode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          labelText: 'Pincode',labelStyle: TextStyle(color:Colors.grey[600],fontSize: 18.0),
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/address.png',
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
                      child: DropdownButtonFormField<dynamic>(
                        hint: Text(
                          'Select State',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        isExpanded: false,
                        value: adminC.permanentState,
                        items: adminC.statesList.map((item) {
                          //print('item: $item');
                          return DropdownMenuItem(
                            child: Text(
                              item['state'],
                            ),
                            value: item['stateID'].toString(),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/state.png',
                                color: Colors.grey[400],
                                scale: 2.0,
                              ),
                            ],
                          ),
                        ),
                        onChanged: (value) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          adminC.permanentState = value;
                          setState(() {});
                          adminC.getCities(int.parse(value), 'permanent');
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: DropdownButtonFormField<dynamic>(
                        hint: Text(
                          'Select City',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        isExpanded: false,
                        value: adminC.permanentCity,
                        items: adminC.percitiesList.map((item) {
                          //print('item: $item');
                          return DropdownMenuItem(
                            child: Text(
                              item['city'],
                            ),
                            value: item['cityID'].toString(),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/city.png',
                                color: Colors.grey[400],
                                scale: 2.0,
                              ),
                            ],
                          ),
                        ),
                        onChanged: (value) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          adminC.permanentCity = value;
                          setState(() {});
                        },
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
                              adminC.step4(false);
                              if (AppUtils.checkTextisNull(adminC.permanenthouseNo, 'House Number')) {
                                Get.snackbar(
                                  null,
                                  'Please provide House Number',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              } else {
                                Get.to(OBFamily());
                                adminC.step4(true);
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
              );
            }),
          ],
        ),
      ),
    );
  }
}
