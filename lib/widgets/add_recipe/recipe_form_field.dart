import 'package:flutter/material.dart';

import './recipe_label.dart';

class RecipeFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final int maxLines;
  final FocusNode focusNode;
  final String suffixText;
  final TextInputType keyboardType;
  final Function(String val) onFieldSubmitted;
  final Function(String val) validator;
  final Function(String val) onSaved;

  const RecipeFormField({
    Key key,
    @required this.labelText,
    @required this.hintText,
    @required this.onSaved,
    this.keyboardType = TextInputType.name,
    this.maxLines = 1,
    this.onFieldSubmitted,
    this.focusNode,
    this.validator,
    this.suffixText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RecipeLabel(label: labelText),
          SizedBox(height: 5),
          TextFormField(
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              hintText: hintText,
              hintStyle: TextStyle(
                color: Color(0x2A2A2A2A),
                fontSize: 12,
              ),
              suffixText: suffixText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              fillColor: Color(0xF3F3F3F3),
            ),
            onFieldSubmitted: onFieldSubmitted,
            focusNode: focusNode,
            validator: validator,
            onSaved: onSaved,
          ),
        ],
      ),
    );
  }
}
