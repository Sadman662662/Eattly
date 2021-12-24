import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class BadgeIconButton extends StatelessWidget {
  final IconData icon;
  final String badgeText;
  final Function() onPressed;

  const BadgeIconButton({
    Key key,
    @required this.icon,
    @required this.badgeText,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Badge(
      padding: const EdgeInsets.all(3),
      position: BadgePosition.topEnd(top: 11, end: 11),
      badgeContent: Text(
        badgeText,
        style: TextStyle(
          fontSize: 8,
          color: Colors.white,
        ),
      ),
      child: IconButton(
        color: Colors.white,
        icon: Icon(icon),
        onPressed: onPressed,
      ),
    );
  }
}
