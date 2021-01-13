import '../utils/utils.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddClient extends StatefulWidget {
  @override
  _AddClientState createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  final AdminController adminC = Get.put(AdminController());
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController unitIncharge = TextEditingController();
  TextEditingController clientId = TextEditingController();
  var latitude;
  var longitude;

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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    phone.dispose();
    address.dispose();
    email.dispose();
    unitIncharge.dispose();
    clientId.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().innerScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Add Client',
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
                    MyTextField(
                      'Name',
                      name,
                      false,
                    ),
                    MyTextField(
                      'Phone Number',
                      phone,
                      false,
                    ),
                    MyTextField(
                      'Email',
                      email,
                      false,
                    ),
                    MyTextField(
                      'Client ID',
                      clientId,
                      false,
                    ),
                    MyTextField(
                      'Unit Incharge',
                      unitIncharge,
                      false,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: TextField(
                        controller: address,
                        readOnly: true,
                        onTap: () async {
                          var p = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: AppUtils.GKEY,
                            mode: Mode.overlay,
                            language: 'en',
                            components: [
                              Component(
                                Component.country,
                                'in',
                              ),
                            ],
                          );
                          // print('P: $p');
                          if (p != null) {
                            var places = GoogleMapsPlaces(
                              apiKey: AppUtils.GKEY,
                            );
                            var detail = await places.getDetailsByPlaceId(
                              p.placeId,
                            );
                            // print(p.placeId);
                            // print(p.description);
                            // print(detail.result.geometry.location.lat.toString());
                            // print(detail.result.geometry.location.lng.toString());
                            setState(() {
                              address.text = p.description.toString();
                              latitude = detail.result.geometry.location.lat;
                              longitude = detail.result.geometry.location.lng;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: 'Address',
                        ),
                      ),
                    ),
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
                            // print('Cancel');
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
                            if (name.text.isNullOrBlank || phone.text.isNullOrBlank || email.text.isNullOrBlank || unitIncharge.text.isNullOrBlank || address.text.isNullOrBlank || clientId.isNullOrBlank || latitude == null || longitude == null) {
                              Get.snackbar(
                                'Error',
                                'Please fill all fields',
                                colorText: Colors.white,
                                backgroundColor: Colors.black87,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 10.0,
                                ),
                              );
                            } else if (!GetUtils.isLengthEqualTo(phone.text, 10)) {
                              Get.snackbar(
                                'Error',
                                'Please provide 10 digit phone number',
                                colorText: Colors.white,
                                backgroundColor: Colors.black87,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 10.0,
                                ),
                              );
                            } else if (!GetUtils.isEmail(email.text)) {
                              Get.snackbar(
                                'Error',
                                'Please provide valid email',
                                colorText: Colors.white,
                                backgroundColor: Colors.black87,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 10.0,
                                ),
                              );
                            } else {
                              print('name: ${name.text}');
                              print('phone: ${phone.text}');
                              print('email: ${email.text}');
                              print('unitIncharge: ${unitIncharge.text}');
                              print('clientId: ${clientId.text}');
                              print('address: ${address.text}');
                              print('latitude: $latitude');
                              print('longitude: $longitude');
                              adminC.addClient(name.text, phone.text, clientId.text, unitIncharge.text, address.text, latitude, longitude);
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

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController inputController;
  final bool readOnly;
  MyTextField(this.hintText, this.inputController, this.readOnly);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0,
      ),
      child: TextField(
        controller: inputController,
        readOnly: readOnly,
        keyboardType: hintText == 'Phone Number'
            ? TextInputType.phone
            : hintText == 'Email'
                ? TextInputType.emailAddress
                : TextInputType.text,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(10),
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
