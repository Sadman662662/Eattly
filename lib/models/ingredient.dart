import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  String id;
  String name;
  String unit;
  String ingredientsImageUrl;
  String value;
  double amount;
  int calories;
  String imageUrl;
  double fatAmount;
  String fatUnit;
  double sugarAmount;
  String sugarUnit;

  Ingredient(
      {this.id,
      this.name,
      this.unit,
      this.ingredientsImageUrl,
      this.value,
      this.amount,
      this.calories,
      this.imageUrl,
      this.fatAmount,
      this.fatUnit,
      this.sugarAmount,
      this.sugarUnit});

  Map toJson() => {
        'id': id,
        'name': name,
        'unit': unit,
        'amount': amount,
        'calories': calories,
        'imageUrl': imageUrl,
        'fatAmount': fatAmount,
        'fatUnit': fatUnit,
        'sugarAmount': sugarAmount,
        'sugarUnit': sugarUnit
      };

  Ingredient.fromJson(json) {
    id = json['id'];
    name = json['name'];
    unit = json['unit'];
    amount = json['amount'];
    calories = json['calories'];
    imageUrl = json['imageUrl'];
    fatAmount = json['fatAmount'];
    fatUnit = json['fatUnit'];
    sugarAmount = json['sugarAmount'];
    sugarUnit = json['sugarUnit'];
  }

  factory Ingredient.fromDocument(DocumentSnapshot doc) {
    return Ingredient(
      id: doc.id,
      name: doc.data()['itemName'],
      unit: '',
      amount: 0,
      calories: 0,
      imageUrl: doc.data()['url'],
    );
  }

  factory Ingredient.fromDocument2(DocumentSnapshot doc) {
    return Ingredient(
        id: doc.data()['id'],
        name: doc.data()['name'],
        imageUrl: doc.data()['image'],
        amount: doc.data()['amount'],
        unit: doc.data()['unit']);
  }
}
