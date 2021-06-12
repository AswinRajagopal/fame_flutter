import 'package:cached_network_image/cached_network_image.dart';
import 'package:fame/connection/remote_services.dart';
import 'package:fame/controllers/grie_controller.dart';
import 'package:fame/controllers/policy_doc_controller.dart';
import 'package:fame/widgets/doc_list_widget.dart';
import 'package:fame/widgets/grie_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/broadcast_controller.dart';
import '../utils/utils.dart';
import '../widgets/broadcast_list_widget.dart';
import 'new_broadcast.dart';
import 'new_policy_doc.dart';

class PolicyDocs extends StatefulWidget {
  @override
  _GrievanceReport createState() => _GrievanceReport();
}

class _GrievanceReport extends State<PolicyDocs> {
  final PolicyDocController bC = Get.put(PolicyDocController());
  var roleId = RemoteServices().box.get('role');

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
      bC.getPolicies,
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
          'Policy Documents',
        ),
      ),
      floatingActionButton: roleId == AppUtils.ADMIN
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Get.to(NewPolicyDoc());
                  },
                  child: Icon(
                    Icons.add,
                    size: 32.0,
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ],
            )
          : Container(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            if (bC.isLoading.value) {
              return Column();
            } else {
              if (bC.docList.isEmpty || bC.docList.isNull) {
                return Container(
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'No Documents found',
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
                    ListView.builder(
                      shrinkWrap: true,
                      primary: true,
                      padding: EdgeInsets.only(bottom: 12),
                      physics: ScrollPhysics(),
                      itemCount: bC.docList.length,
                      itemBuilder: (context, index) {
                        var doc = bC.docList[index];
                        return GestureDetector(
                        child: DocListWidget(doc),
                          onTap: () => Get.to(
                              DetailScreen(RemoteServices.baseURL+'/company/get-image?id='+doc['companyPolicyId'])),
                        );
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
class DetailScreen extends StatelessWidget {
  final String url;
  DetailScreen(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => PhotoView(
      imageProvider: imageProvider,
    ),)
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}