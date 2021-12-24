import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import './ingredient.dart';

class ShoppingListItem {
  String name;

  List<Ingredient> ingredientList = [];
  String stringIngredients;

  ShoppingListItem({this.name, this.ingredientList, this.stringIngredients});

  factory ShoppingListItem.fromDocument(DocumentSnapshot documentSnapshot) {
    final ingredientsListDoc = documentSnapshot.data()["ingredients"];
    List<Ingredient> ingredients = [];

    if (ingredientsListDoc != null) {
      Iterable l = json.decode(ingredientsListDoc);
      ingredients =
          List<Ingredient>.from(l.map((model) => Ingredient.fromJson(model)));
    }

    return ShoppingListItem(
        name: documentSnapshot.data()["recipeName"],
        ingredientList: ingredients,
        stringIngredients: documentSnapshot.data()["stringIngredients"]);
  }
}
