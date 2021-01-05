import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        children: [
          FloatingActionButton(
            onPressed: () {},
            child: SvgPicture.asset(
              'assets/images/navicon-dashboard.svg',
            ),
            backgroundColor: HexColor('386eff'),
          ),
          SizedBox(
            height: 15.0,
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
