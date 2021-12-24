import 'package:flutter/material.dart';

import './calendar_body.dart';
import './calendar_header.dart';
import './date_chips.dart';
// Remove later
import '../../pages/HomePage.dart';
import '../../utils/helper_functions.dart';

class EattlyCalendar extends StatefulWidget {
  @override
  _EattlyCalendarState createState() => _EattlyCalendarState();
}

class _EattlyCalendarState extends State<EattlyCalendar> {
  DateTime selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> hours = [];
    for (var i = 0; i < 25; i++) {
      hours.add({'startTime': i, 'recipe': null});
    }

    var index = hours.indexWhere((hour) => hour['startTime'] == 0);

    hours[index] = {
      'userId': currentUser.id,
      'startTime': hours[index]['startTime'],
      'recipe': {
        'imageUrl': 'https://picsum.photos/400/400',
        'name': 'Quinao Salad',
        'description': 'Lorem ipsum dolor amet consectetu ed  tgr  bnfh'
      },
    };

    return Container(
      color: Color(0xFFF3F3F3),
      child: Column(
        children: [
          CalendarHeader(
            selectedMonth: selectedMonth,
            onNextMonth: _handleNextMonth,
            onPreviousMonth: _handlePreviousMonth,
          ),
          SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DateChips(selectedMonth: selectedMonth),
          ),
          SizedBox(height: 32),
          Expanded(
            child: CalendarBody(
              selectedMonth: selectedMonth,
              hours: hours,
            ),
          ),
        ],
      ),
    );
  }

  void _handleNextMonth() {
    setState(() {
      selectedMonth = addMonthsToMonthDate(selectedMonth, 1);
    });
  }

  void _handlePreviousMonth() {
    setState(() {
      selectedMonth = addMonthsToMonthDate(selectedMonth, -1);
    });
  }
}
