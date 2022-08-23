import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/broadcast_controller.dart';
import '../utils/utils.dart';

class Broadcast extends StatefulWidget {
  @override
  _BroadcastState createState() => _BroadcastState();
}

class _BroadcastState extends State<Broadcast> {
  final BroadcastController bC = Get.put(BroadcastController());
  TextEditingController message = TextEditingController();
  var empId;
  var manpowerList = {};

  @override
  void initState() {
    bC.pr = ProgressDialog(
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
    bC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(
      Duration(milliseconds: 100),
      bC.getClient,
    );
    super.initState();
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
          'Broadcast',
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
                  children: [
                    Obx(() {
                      if (bC.isLoading.value) {
                        return MyTextField(
                          'Select Client',
                          message,
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 15.0,
                        ),
                        child: DropdownSearch<String>(
                          mode: Mode.MENU,
                          showSearchBox: true,
                          isFilteredOnline: true,
                          dropDownButton: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                            size: 18,
                          ),
                          hint: 'All Clients',
                          showSelectedItem: true,
                          items: bC.clientList.map((item) {
                            var sC = item['name'].toString().replaceAll('-', '~') + ' - ' + item['id'];
                            return sC.toString();
                          }).toList(),
                          onChanged: (value) {
                            var splitIt = value.split('-');
                            empId = splitIt[1].trim();
                            setState(() {});
                          },
                        ),
                      );
                    }),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: TextField(
                            controller: message,
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 10.0, bottom: 60.0),
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.0,
                                ),
                                hintText: 'Broadcast Message',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1),
                                )),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
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
                            if (message.text == null ||
                                message.text == '') {
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
                            } else {
                              if(empId==null){
                                empId = 'all';
                              }
                              print(empId);
                              print(message.text);
                              bC.newBroadcast(empId, message.text);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 50.0,
                            ),
                            child: Text(
                              'Send',
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
        maxLines: 3,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(10),
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 18.0,
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
