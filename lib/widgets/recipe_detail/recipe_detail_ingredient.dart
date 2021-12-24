import 'package:flutter/material.dart';

class RecipeDetailIngredient extends StatelessWidget {
  final String imageUrl;
  final String labelText;

  const RecipeDetailIngredient({
    Key key,
    this.imageUrl,
    this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 80,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              imageUrl,
              height: 80,
              width: 80,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(height: 5),
          Text(
            labelText,
            textAlign: TextAlign.center,
            style: TextStyle(),
          ),
        ],
      ),
    );
  }
}
