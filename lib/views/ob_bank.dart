import 'package:fame/utils/utils.dart';
import 'package:flutter/services.dart';

import '../widgets/ob_top_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/admin_controller.dart';
import 'ob_address.dart';

class OBBank extends StatefulWidget {
  @override
  _OBBankState createState() => _OBBankState();
}

class _OBBankState extends State<OBBank> {
  final AdminController adminC = Get.put(AdminController());

  @override
  void initState() {
    print(adminC.name.text);
    print(adminC.dtOfBirth.text);
    print(adminC.empPhone.text);
    print(adminC.client);
    print(adminC.designation);
    print(adminC.dtOfJoin.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bank & Uniform',
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
                    OBTopNavigation('bank'),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: DropdownButtonFormField<dynamic>(
                        hint: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Select Bank*',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        isExpanded: false,
                        value: adminC.bank,
                        items: adminC.bankNamesList.map((item) {
                          print('item: $item');
                          print('adminC.bank: ${adminC.bank ?? 'it is null'}');
                          return DropdownMenuItem(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                item['bankname'],
                              ),
                            ),
                            value: item['bankId'].toString(),
                          );
                        }).toList(),
                        onChanged: (value) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          adminC.bank = value;
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TextField(
                        controller: adminC.accountNo,
                        maxLength: 160,
                        maxLengthEnforced: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          labelText: 'Account No*',labelStyle: TextStyle(color:Colors.grey[600],fontSize: 18.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TextField(
                        controller: adminC.ifsc,
                        maxLength: 160,
                        maxLengthEnforced: true,
                        keyboardType:TextInputType.text,
                        inputFormatters: [ FilteringTextInputFormatter.allow(RegExp("[a-zA-Z|0-9]")), ],
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                          labelText: 'IFSC*',labelStyle: TextStyle(color:Colors.grey[600],fontSize: 18.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Text(
                        'Uniform Details',
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
                        hint: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Select Shirt Size',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        isExpanded: false,
                        value: adminC.shirtSize,
                        items: adminC.shirtSizes.map((item) {
                          //print('item: $item');
                          return DropdownMenuItem(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                item,
                              ),
                            ),
                            value: item,
                          );
                        }).toList(),
                        onChanged: (value) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          adminC.shirtSize = value;
                          // setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: DropdownButtonFormField<dynamic>(
                        hint: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Select Pant Size',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        isExpanded: false,
                        value: adminC.pantSize,
                        items: adminC.pantSizes.map((item) {
                          //print('item: $item');
                          return DropdownMenuItem(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                item,
                              ),
                            ),
                            value: item,
                          );
                        }).toList(),
                        onChanged: (value) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          adminC.pantSize = value;
                          // setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: DropdownButtonFormField<dynamic>(
                        hint: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Select Shoe Size',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        isExpanded: false,
                        value: adminC.shoeSize,
                        items: adminC.shoeSizes.map((item) {
                          //print('item: $item');
                          return DropdownMenuItem(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                item,
                              ),
                            ),
                            value: item,
                          );
                        }).toList(),
                        onChanged: (value) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          adminC.shoeSize = value;
                          // setState(() {});
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
                              if (adminC.bank ==null) {
                                Get.snackbar(
                                  null,
                                  'Please provide Bank Name',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              }else if (AppUtils.checkTextisNull(adminC.accountNo, 'Account Number')) {
                                Get.snackbar(
                                  null,
                                  'Please provide Account Number',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              }
                             else if (AppUtils.checkTextisNull(adminC.ifsc, 'IFSC')) {
                                Get.snackbar(
                                  null,
                                  'Please provide IFSC',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black87,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                                  borderRadius: 5.0,
                                );
                              }else{
                                FocusScope.of(context).requestFocus(FocusNode());
                                adminC.step3(true);
                                Get.to(OBAddress());
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
