import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateChip extends StatelessWidget {
  final int date;
  final int month;
  final int year;

  const DateChip({
    Key key,
    @required this.date,
    @required this.month,
    @required this.year,
  })  : assert(date != null),
        assert(month != null),
        assert(year != null),
        super(key: key);

  BoxShadow getBoxShadow({bool isSelected = false}) {
    if (isSelected)
      return BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(0, 3),
      );
    else
      return BoxShadow(
        color: Colors.white,
        spreadRadius: 0,
        blurRadius: 0,
        offset: Offset.zero,
      );
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = DateTime.now().day == date &&
        DateTime.now().month == month &&
        DateTime.now().year == year;

    return Container(
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).primaryColor : Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
          bottom: Radius.circular(30),
        ),
        boxShadow: [getBoxShadow(isSelected: isSelected)],
      ),
      width: 45,
      height: 80,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 15,
              right: 10,
              left: 10,
              bottom: 10,
            ),
            child: Text(
              DateFormat.EEEE()
                  .format(new DateTime(year, month, date))
                  .substring(0, 3)
                  .toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                color: isSelected
                    ? Colors.white
                    : Color.fromRGBO(38, 37, 37, 0.44),
              ),
            ),
          ),
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isSelected ? Colors.white : Color.fromRGBO(38, 37, 37, 0.04),
            ),
            child: Center(
              child: Text(
                '$date',
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
