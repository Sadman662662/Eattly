import 'package:flutter/material.dart';

import 'meal_tile.dart';

class MealCard extends StatelessWidget {
  /// Constructs a [MealCard] widget tht can be placed inside a [MealTile].
  ///
  /// [name] of the recipe.
  ///
  /// [description] of the recipe.
  ///
  /// [imageUrl] of the recipe.
  const MealCard({
    Key key,
    @required this.imageUrl,
    @required this.name,
    @required this.description,
  }) : super(key: key);

  final String imageUrl;
  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: _mealCardBorder(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: MealTile(
          image: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
          title: Text(
            name,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          subtitle: Text(
            description,
            style: TextStyle(
              fontSize: 8,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  ShapeBorder _mealCardBorder() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(9), // if you need this
      side: BorderSide(
        color: Colors.black,
        width: 1,
      ),
    );
  }
}
