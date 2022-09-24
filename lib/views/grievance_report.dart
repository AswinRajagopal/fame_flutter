import 'package:fame/connection/remote_services.dart';
import 'package:fame/controllers/grie_controller.dart';
import 'package:fame/widgets/grie_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/broadcast_controller.dart';
import '../utils/utils.dart';
import '../widgets/broadcast_list_widget.dart';
import 'new_broadcast.dart';

class GrievanceReport extends StatefulWidget {
  @override
  _GrievanceReport createState() => _GrievanceReport();
}

class _GrievanceReport extends State<GrievanceReport> {
  final GrieController bC = Get.put(GrieController());
  TextEditingController grieCont = TextEditingController();

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
      bC.getGrie,
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
      backgroundColor: AppUtils().greyScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Grievance Report',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            if (bC.isLoading.value) {
              return Column();
            } else {
              if (bC.grieList.isEmpty || bC.grieList.isNull) {
                return Container(
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MyTextField(
                        'Grievance',
                        grieCont,
                      ),
                      RaisedButton(
                        onPressed: () {
                          print('Submit');
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (grieCont.text == null ||
                              grieCont.text == '') {
                            Get.snackbar(
                              null,
                              'Please provide Grievance',
                              colorText: Colors.white,
                              backgroundColor: Colors.black87,
                              snackPosition: SnackPosition.BOTTOM,
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.0,
                                vertical: 4.0,
                              ),
                              borderRadius: 5.0,
                            );
                          } else {
                            print(grieCont.text);
                            bC.newGrie(grieCont.text);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 20.0,
                          ),
                          child: Text(
                            'Send',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'No message found',
                          style: TextStyle(
                            fontSize: 18.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyTextField(
                      'Grievance',
                      grieCont,
                    ),
                    RaisedButton(
                      onPressed: () {
                        print('Submit');
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (grieCont.text == null ||
                            grieCont.text == '') {
                          Get.snackbar(
                            null,
                            'Please provide Grievance',
                            colorText: Colors.white,
                            backgroundColor: Colors.black87,
                            snackPosition: SnackPosition.BOTTOM,
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.0,
                              vertical: 4.0,
                            ),
                            borderRadius: 5.0,
                          );
                        } else {
                          print(grieCont.text);
                          bC.newGrie(grieCont.text);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 20.0,
                        ),
                        child: Text(
                          'Send',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      primary: true,
                      padding: EdgeInsets.only(bottom: 12),
                      physics: ScrollPhysics(),
                      itemCount: bC.grieList.length,
                      itemBuilder: (context, index) {
                        var broadcast = bC.grieList[index];
                        return GrieListWidget(broadcast);
                      },
                    )
                  ]);
            }
          }),
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
        maxLines: 2,
        maxLength: 160,
        maxLengthEnforced: true,
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
