import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BroadcastListWidget extends StatelessWidget {
  final broadcast;
  BroadcastListWidget(this.broadcast);

  String convertDate(date) {
    return DateFormat('dd').format(DateTime.parse(date)).toString() + '-' + DateFormat('MM').format(DateTime.parse(date)).toString() + '-' + DateFormat.y().format(DateTime.parse(date)).toString() + ' @ ' + DateFormat('hh:mm').format(DateTime.parse(date)).toString() + '' + DateFormat('a').format(DateTime.parse(date)).toString().toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  convertDate(broadcast['createdOn']),
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              broadcast['bmsg'],
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
