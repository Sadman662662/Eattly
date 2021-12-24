import 'package:flutter/material.dart';

class RecipeDetailAppbarButton extends StatelessWidget {
  // final IconData icon;
  final String imagePath;
  final String labelText;
  final Function onPressed;

  const RecipeDetailAppbarButton({
    Key key,
    this.imagePath,
    this.labelText,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 60,
      child: RaisedButton.icon(
        color: Colors.white,
        icon: ImageIcon(
          AssetImage(imagePath),
          color: Theme.of(context).primaryColor,
          size: 18,
        ),
        shape: StadiumBorder(),
        label: Text(
          labelText,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
