import 'package:flutter/material.dart';

import './meal_card.dart';

class HourlyTileContainer extends StatelessWidget {
  const HourlyTileContainer({
    Key key,
    @required this.recipe,
  }) : super(key: key);

  final dynamic recipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.15,
        ),
        height: 72,
        child: recipe != null
            ? MealCard(
                imageUrl: recipe['imageUrl'],
                name: recipe['name'],
                description: recipe['description'],
              )
            : SizedBox(),
      ),
    );
  }
}
