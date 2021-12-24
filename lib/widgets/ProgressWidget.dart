import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

Widget circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Color(0xFF1B5E20)),
    ),
  );
}

linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10.0),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Color(0xFF1B5E20)),
    ),
  );
}
