import 'package:flutter/material.dart';

import './hourly_tile.dart';

class CalendarBody extends StatelessWidget {
  final DateTime selectedMonth;
  final List<Map<String, dynamic>> hours;

  const CalendarBody({
    Key key,
    @required this.selectedMonth,
    @required this.hours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: hours
              .map(
                (hour) => HourlyTile(
                  selectedMonth: selectedMonth,
                  hour: hour,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
