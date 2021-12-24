import 'package:flutter/material.dart';

class RecipeDetailChip extends StatelessWidget {
  final String labelText;

  const RecipeDetailChip({
    Key key,
    @required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Container(
        width: 70,
        child: Text(
          labelText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 12,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      shape: StadiumBorder(
        side: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
