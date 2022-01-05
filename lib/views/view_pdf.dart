import 'dart:convert';
import 'dart:io';

import 'package:fame/connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewPdf extends StatefulWidget {
  @override
  _ViewPdf createState() => _ViewPdf();
}

class _ViewPdf extends State<ViewPdf> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  var month = DateTime.now().month;
  var year = DateTime.now().year;
  var url;
  var month_year;

  String monthString;

  @override
  void initState() {
    super.initState();
    month_year = ((month-1)*100)+(year%1000);
    url = jsonDecode(RemoteServices().box.get('appFeature'))['paySlipUrl'] +
        '?Empid='+RemoteServices().box.get('empid').toString()+'&month='+month_year.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Payslip'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.date_range,
                color: Colors.white,
                semanticLabel: 'Date Range',
              ),
              onPressed: () {
                showMonthPicker(
                  context: context,
                  firstDate:
                      DateTime(DateTime.now().year-1, DateTime.now().month),
                  lastDate:
                      DateTime(DateTime.now().year, DateTime.now().month),
                  // initialDate: selectedDate ?? widget.initialDate,
                  initialDate: DateTime(year, month),
                  locale: Locale('en'),
                ).then((date) {
                  if (date != null) {
                    print(date);
                    print(DateFormat('MMMM').format(date));
                    print(date.year);
                    month = date.month;
                    year = date.year;
                    var month_year = (month*100)+(year%1000);
                    print(month_year);
                    setState(() {
                      url = jsonDecode(RemoteServices().box.get('appFeature'))['paySlipUrl'] +
                          '?Empid='+RemoteServices().box.get('empid').toString()+
                          '&month='+month_year.toString();
                    });
                  }
                });
              }),
    IconButton(
    icon: const Icon(
    Icons.download_sharp,
    color: Colors.white,
    semanticLabel: 'Download',
    ),
    onPressed: () async {
      var url = jsonDecode(RemoteServices().box.get('appFeature'))['paySlipUrl'] +
      '?Empid='+RemoteServices().box.get('empid').toString()+'&month='+month_year.toString();
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    })
        ],
      ),
      body: SfPdfViewer.network(
        url,
        key: _pdfViewerKey,
      ),
    );
  }
}
