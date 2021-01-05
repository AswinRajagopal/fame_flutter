import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  CustomAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundImage: AssetImage(
            'assets/images/tm_logo.png',
          ),
          backgroundColor: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          // icon: Icon(
          //   Icons.notifications_none_outlined,
          //   color: Colors.white,
          //   size: 30.0,
          // ),
          icon: Image.asset(
            'assets/images/bell_icon.png',
            height: 22.0,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
