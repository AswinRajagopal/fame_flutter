import 'dart:convert';

import 'package:fame/connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdf extends StatefulWidget {
  @override
  _ViewPdf createState() => _ViewPdf();
}

class _ViewPdf extends State<ViewPdf> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  var month = DateTime.now().month;
  var year = DateTime.now().year;
  var url;

  String monthString;

  @override
  void initState() {
    super.initState();
    var month_year = ((month-1)*100)+(year%1000);
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
                semanticLabel: 'Bookmark',
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
