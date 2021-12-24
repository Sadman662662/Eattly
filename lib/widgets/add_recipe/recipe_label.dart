import 'package:flutter/material.dart';

class RecipeLabel extends StatelessWidget {
  final String label;

  const RecipeLabel({
    Key key,
    @required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        label,
        style: TextStyle(
          color: Color(0x9E1E1E1E),
          fontSize: 12,
        ),
      ),
    );
  }
}
