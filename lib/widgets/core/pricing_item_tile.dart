import 'package:flutter/material.dart';

class PricingItemTile extends StatelessWidget {
  final Color iconContainerColor;
  final Color iconColor;
  final String itemText;
  final Color itemTextColor;

  const PricingItemTile({
    Key key,
    this.iconContainerColor = Colors.black,
    this.iconColor = Colors.white,
    @required this.itemText,
    this.itemTextColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10,
            ),
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconContainerColor,
              ),
              child: Icon(
                Icons.arrow_right_alt,
                color: iconColor,
                size: 15,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Text(
            itemText,
            style: TextStyle(
              fontSize: 12,
              color: itemTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
