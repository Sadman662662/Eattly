import 'package:flutter/material.dart';

import '../../utils/text_style.dart';

class AppBarIconButton extends StatelessWidget {
  final Function() onPressed;
  final IconData icon;

  const AppBarIconButton({
    Key key,
    @required this.icon,
    @required this.onPressed,
  })  : assert(icon != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.green[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Icon(
          icon,
          color: greenColor,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
