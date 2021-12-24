import 'package:flutter/material.dart';

import './hourly_tile_container.dart';
import '../../utils/helper_functions.dart';

class HourlyTile extends StatelessWidget {
  const HourlyTile({
    Key key,
    @required this.selectedMonth,
    @required this.hour,
  }) : super(key: key);

  final DateTime selectedMonth;
  final Map<String, dynamic> hour;

  @override
  Widget build(BuildContext context) {
    final recipe = hour['recipe'];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: Text(
                getFormattedDate(
                  selectedMonth,
                  hour['startTime'],
                ),
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(0, 0, 0, 0.46),
                ),
              ),
            ),
            SizedBox(width: 5),
            Flexible(
              flex: 5,
              child: Divider(),
            ),
          ],
        ),
        HourlyTileContainer(recipe: recipe),
      ],
    );
  }
}
