import 'package:flutter/material.dart';

class CustomFab extends StatelessWidget {
  final String page;
  CustomFab(this.page);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 6.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {},
            child: Icon(
              Icons.widgets_sharp,
              size: 32.0,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
