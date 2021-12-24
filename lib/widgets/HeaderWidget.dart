import 'dart:ui';

import 'package:eattlystefan/utils/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar header(
  context, {
  bool isAppTitle = false,
  String strTitle,
  disappearedBackButton = false,
}) {
  return AppBar(
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: Theme.of(context).primaryColor,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    iconTheme: IconThemeData(
      color: Colors.green,
    ),
    automaticallyImplyLeading: disappearedBackButton ? false : true,
    title: Text(
      isAppTitle ? "Eattly" : strTitle,
      style: textStyle(Theme.of(context).primaryColor, isAppTitle ? 45.0 : 22.0,
          FontWeight.w500),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Colors.white,
  );
}
