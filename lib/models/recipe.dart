import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import './ingredient.dart';

class Recipe {
  String postId;
  String ownerId;
  String imageUrl;
  String profileName;
  String name;
  String description;
  List<Ingredient> nIngredients = [];
  String ingredients;
  String directions;
  String cost;
  String portions;
  dynamic timeNeeded;
  String category;
  Map likes;
  Timestamp timestamp;
  final bool isShared;
  final String sharedBy;
  final Timestamp whenShared;
  final String sharedByImageUrl;
  final String sharedById;

  Recipe({
    this.postId,
    this.ownerId,
    this.imageUrl,
    this.name,
    this.description,
    this.ingredients,
    this.nIngredients,
    this.directions,
    this.cost,
    this.portions,
    this.timeNeeded,
    this.category,
    this.likes,
    this.profileName,
    this.timestamp,
    this.isShared,
    this.sharedBy,
    this.whenShared,
    this.sharedByImageUrl,
    this.sharedById,
  });

  factory Recipe.fromDocument(DocumentSnapshot documentSnapshot) {
    final nIngredientsDoc = documentSnapshot.data()["n_ingredients"];
    List<Ingredient> nIngredients = [];

    if (nIngredientsDoc != null) {
      Iterable l = json.decode(nIngredientsDoc);
      nIngredients =
          List<Ingredient>.from(l.map((model) => Ingredient.fromJson(model)));
    }

    final sharedDoc = documentSnapshot.data()['isShared'];
    final sharedByDoc = documentSnapshot.data()['sharedBy'];
    final whenSharedDoc = documentSnapshot.data()['whenShared'];
    final sharedByImageUrlDoc = documentSnapshot.data()['sharedByImageUrl'];
    final sharedByIdDoc = documentSnapshot.data()['sharedById'];
    String localSharedByImageUrl =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSb15j9eqm9NrndcPrju5OH1ZLqXdqgHjq9w&usqp=CAU';

    bool localIsShared = false;
    String localSharedBy = '';
    Timestamp localWhenShared = documentSnapshot.data()["timestamp"];
    String localSharedById = '';

    // if(sharedByImageUrlDoc != null){
    //   localSharedByImageUrl = curr
    // }

    if (sharedDoc != null) {
      localIsShared = true;
    }
    if (sharedByDoc != null) {
      localSharedBy = documentSnapshot.data()['sharedBy'];
    }
    if (whenSharedDoc != null) {
      localWhenShared = documentSnapshot.data()['whenShared'];
    }
    if (sharedByImageUrlDoc != null) {
      localSharedByImageUrl = documentSnapshot.data()['sharedByImageUrl'];
    }
    if (sharedByIdDoc != null) {
      localSharedById = documentSnapshot.data()['sharedById'];
    }

    var n_ingrdnts = documentSnapshot.data()['n_ingredients'];

    return Recipe(
      postId: documentSnapshot.data()["postId"],
      ownerId: documentSnapshot.data()["ownerId"],
      likes: documentSnapshot.data()["likes"],
      profileName: documentSnapshot.data()["profileName"],
      description: documentSnapshot.data()["description"],
      timeNeeded: documentSnapshot.data()["neededTime"],
      name: documentSnapshot.data()["name"],
      directions: documentSnapshot.data()["prepare"],
      ingredients: documentSnapshot.data()["ingredients"],
      nIngredients: nIngredients,
      imageUrl: documentSnapshot.data()["url"],
      timestamp: documentSnapshot.data()["timestamp"],
      cost: documentSnapshot.data()['cost'],
      portions: documentSnapshot.data()['portion'],
      category: documentSnapshot.data()['category'],
      isShared: localIsShared,
      sharedBy: localSharedBy,
      whenShared: localWhenShared,
      sharedByImageUrl: localSharedByImageUrl,
      sharedById: localSharedById,
    );
  }
}
