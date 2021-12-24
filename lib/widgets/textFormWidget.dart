import 'package:flutter/material.dart';

import '../utils/text_style.dart';

class TextFormWidget extends StatelessWidget {
  const TextFormWidget({
    Key key,
    @required this.textEditingController,
    this.height,
    this.hint,
    this.suffix,
    this.suffixIcons,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final num height;
  final String hint;
  final String suffix;
  final Widget suffixIcons;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height == null ? 40 : height,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(10.0)),
      child: TextField(
        controller: textEditingController,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          suffixText: suffix == null ? "" : suffix,
          suffixIcon: suffixIcons,
          contentPadding: EdgeInsets.only(bottom: 10.0, left: 10.0),
          hintStyle: textStyle(
            Colors.grey[600],
            12.0,
            FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
