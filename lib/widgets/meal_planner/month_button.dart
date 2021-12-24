import 'package:flutter/material.dart';

class MonthButton extends StatelessWidget {
  /// Constructs a [MonthButton] widget to change the month.
  ///
  /// [onPressed] is the function that will execute when the
  /// button is tapped
  ///
  /// [icon] is an IconData object (has to be chevron_right
  /// or chevron_left)
  final Function() onPressed;
  final IconData icon;

  const MonthButton({
    Key key,
    @required this.onPressed,
    @required this.icon,
  })  : assert(onPressed != null),
        assert(icon != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 25,
        width: 25,
        decoration: _buttonDecoration(),
        child: Icon(
          icon,
          size: 18,
          color: Color.fromRGBO(31, 107, 0, 1),
        ),
      ),
    );
  }

  Decoration _buttonDecoration() {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: Color.fromRGBO(31, 107, 0, 0.29),
    );
  }
}
