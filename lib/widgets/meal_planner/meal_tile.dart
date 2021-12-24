import 'package:flutter/material.dart';

class MealTile extends StatelessWidget {
  /// Constructs a [MealTile] widget that can be seen in the hourly
  /// view of the calendar.
  ///
  /// [image] preferably a [Image.network] Widget. It should not be null.
  ///
  /// [title] should be a Text Widget. It should not be null.
  ///
  /// [subtitle] should be a Text Widget. It should not be null.
  const MealTile({
    Key key,
    @required this.image,
    @required this.title,
    @required this.subtitle,
  })  : assert(image != null),
        assert(title != null),
        assert(subtitle != null),
        super(key: key);

  final Image image;
  final Text title;
  final Text subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(height: 40, width: 40, child: image),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              SizedBox(height: 5),
              subtitle,
            ],
          ),
        ),
      ],
    );
  }
}
