import 'package:flutter/material.dart';

import './recipe_label.dart';

class RecipeDropdownFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String value;
  final Function(String value) onChanged;
  final List<String> items;

  const RecipeDropdownFormField({
    Key key,
    @required this.labelText,
    @required this.hintText,
    @required this.value,
    @required this.onChanged,
    @required this.items,
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
          DropdownButtonFormField(
            value: value,
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
            onChanged: onChanged,
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    child: Text(item),
                    value: item,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
