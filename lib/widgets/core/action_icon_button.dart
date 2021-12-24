import 'package:eattlystefan/utils/text_style.dart';
import 'package:flutter/material.dart';

class ActionIconButton extends StatelessWidget {
  final IconData icon;
  final Function() onPressed;

  const ActionIconButton({
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
        child: Icon(
          icon,
          color: greenColor,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
