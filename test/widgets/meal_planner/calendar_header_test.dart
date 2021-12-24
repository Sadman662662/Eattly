import 'package:eattlystefan/widgets/meal_planner/calendar_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget({Widget child}) {
    return MaterialApp(home: child);
  }

  testWidgets(
    'should contain Text with month and year and right chevron button and left chevron button',
    (WidgetTester tester) async {
      final month = DateTime(2020, 8);

      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        makeTestableWidget(
          child: CalendarHeader(
            selectedMonth: month,
            onNextMonth: () {},
            onPreviousMonth: () {},
          ),
        ),
      );

      expect(find.text('Aug, 2020'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    },
  );
}
