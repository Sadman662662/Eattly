import 'package:flutter/material.dart';

import '../../utils/text_style.dart';

class DrawerList extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback callback;

  DrawerList({
    this.icon,
    this.title,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Icon(icon, color: whiteColor),
          Container(width: 15.0),
          GestureDetector(
            onTap: callback,
            child: Text(
              title,
              style: textStyle(whiteColor, 17.0, FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
