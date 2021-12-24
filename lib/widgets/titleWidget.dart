import 'package:flutter/material.dart';

import '../utils/text_style.dart';

Widget textTitle(title) {
  return Text(
    title,
    style: textStyle(Colors.black, 13.0, FontWeight.w400),
  );
}
