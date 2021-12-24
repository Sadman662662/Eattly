import 'package:flutter/material.dart';

class RecipeDetailNutrientsBox extends StatelessWidget {
  final String labelText;
  final String amountText;

  const RecipeDetailNutrientsBox({
    Key key,
    this.labelText,
    this.amountText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      width: 95,
      height: 74,
      child: Stack(
        children: [
          Positioned(
            child: Container(
              width: 95,
              child: Center(
                child: Text(
                  labelText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            top: 15,
          ),
          Positioned(
            bottom: 15,
            right: 1,
            child: Container(
              height: 20,
              width: 93,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  amountText,
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
