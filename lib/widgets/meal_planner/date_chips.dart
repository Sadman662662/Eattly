import 'package:flutter/material.dart';

import './date_chip.dart';

const double FIRST_DATE_CHIP_WIDTH = 55.0;
const double DATE_CHIP_WIDTH = 65.0;
const double DATE_CHIP_BUFFER = 2;
const double PREVIOUS_DATE_CHIPS_NUMBER = 2;

class DateChips extends StatelessWidget {
  const DateChips({
    Key key,
    @required this.selectedMonth,
  })  : assert(selectedMonth != null),
        super(key: key);

  final DateTime selectedMonth;

  int getDaysInMonth(DateTime month) {
    return DateTime(month.year, month.month + 1, 0).day;
  }

  List<int> getDates() {
    final daysInMonth = getDaysInMonth(selectedMonth);

    return [for (var i = 1; i <= daysInMonth; i++) i];
  }

  Widget itemBuilder(BuildContext context, int index) {
    final dates = getDates();

    return DateChip(
      date: dates[index],
      month: selectedMonth.month,
      year: selectedMonth.year,
    );
  }

  @override
  Widget build(BuildContext context) {
    var scrollOffset = selectedMonth.month == DateTime.now().month
        ? FIRST_DATE_CHIP_WIDTH +
            (DATE_CHIP_WIDTH *
                (DateTime.now().day -
                    DATE_CHIP_BUFFER -
                    PREVIOUS_DATE_CHIPS_NUMBER))
        : 0.0;

    var controller = ScrollController(
      initialScrollOffset: scrollOffset,
      keepScrollOffset: false,
    );

    return Container(
      height: 78,
      width: double.infinity,
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: getDates().length,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
