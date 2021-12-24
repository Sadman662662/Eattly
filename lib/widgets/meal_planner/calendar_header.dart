import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './month_button.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    Key key,
    @required this.selectedMonth,
    @required this.onNextMonth,
    @required this.onPreviousMonth,
  })  : assert(selectedMonth != null),
        assert(onNextMonth != null),
        assert(onPreviousMonth != null),
        super(key: key);

  final DateTime selectedMonth;
  final Function() onNextMonth;
  final Function() onPreviousMonth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        right: 20,
        bottom: 0,
        left: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${DateFormat.MMM().format(selectedMonth)}, ${DateFormat.y().format(selectedMonth)}',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Row(
            children: [
              MonthButton(icon: Icons.chevron_left, onPressed: onPreviousMonth),
              SizedBox(width: 10),
              MonthButton(icon: Icons.chevron_right, onPressed: onNextMonth),
            ],
          )
        ],
      ),
    );
  }
}
