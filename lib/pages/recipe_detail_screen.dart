import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eattlystefan/models/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import './HomePage.dart';
import '../models/User.dart';
import '../models/recipe.dart';
import '../widgets/core/pricing_dialog.dart';
import '../widgets/recipe_detail/recipe_detail_chip.dart';
import '../widgets/recipe_detail/recipe_detail_comment.dart';
import '../widgets/recipe_detail/recipe_detail_ingredient.dart';
import '../widgets/recipe_detail/recipe_detail_nutrients_box.dart';
import '../widgets/recipe_detail/recipe_sliver_app_bar.dart';

class RecipeDetailScreen extends StatefulWidget {
  static const String routeName = '/recipe-details';
  static const double _appBarBottomBtnPosition = 30.0;

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  ScrollController _controller;
  bool _sliverCollapsed = false;
  final shoppingListReference =
      firebaseFirestoreInstance.collection('shoppingList');
  final ingredientsReference =
      firebaseFirestoreInstance.collection('ingredients');

  List<Ingredient> ingredients = [];

  @override
  void initState() {
    super.initState();
    // getIngredients();

    _controller = ScrollController();

    _controller.addListener(() {
      if (_controller.offset > 220 && !_controller.position.outOfRange) {
        if (!_sliverCollapsed) {
          _sliverCollapsed = true;
          setState(() {});
        }
      }
      if (_controller.offset <= 220 && !_controller.position.outOfRange) {
        if (_sliverCollapsed) {
          _sliverCollapsed = false;
          setState(() {});
        }
      }
    });
  }

  // getIngredintsNameAndImageUrlForARecipe(List<Ingredient> nIngredients) {
  //   List<Ingredient> filteredIngredients = [];
  //   for (final ingredient in ingredients) {
  //     for (final nIngredient in nIngredients) {
  //       if (nIngredient.name == ingredient.name) {
  //         filteredIngredients.add(ingredient);
  //       }
  //     }
  //   }
  //   return filteredIngredients;

  // }

  int getTotalCalories(List<Ingredient> ingredients) {
    int totalCalories = 0;
    for (final ingredient in ingredients) {
      totalCalories = totalCalories + ingredient.calories;
    }
    return totalCalories;
  }

  getTotalSugar(List<Ingredient> ingredients) {
    double totalSugar = 0;
    for (final ingredient in ingredients) {
      totalSugar = totalSugar + ingredient.sugarAmount;
    }
    return totalSugar;
  }

  getTotalFat(List<Ingredient> ingredients) {
    double totalFat = 0;
    for (final ingredient in ingredients) {
      totalFat = totalFat + ingredient.fatAmount;
    }
    return totalFat;
  }

  showDialogForAddingShoppingList(Recipe recipe) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: [
                            Text(
                              "Do you want to add to the shopping list",
                              maxLines: 2,
                              style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.bold, fontSize: 14.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ButtonTheme(
                          height: 40.0,
                          minWidth: 100.0,
                          child: RaisedButton(
                            child: Text(
                              "Yes",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 17.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            onPressed: () async {
                              addIngredientsToShoppingList(recipe);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        ButtonTheme(
                          height: 40.0,
                          minWidth: 100.0,
                          child: RaisedButton(
                            child: Text(
                              "No",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 17.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ));
        });
  }

  void showToast() {
    Fluttertoast.showToast(
      msg: 'You add the ingredients to the shoppinglist successfully',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  addIngredientsToShoppingList(Recipe recipe) async {
    if (recipe.nIngredients.length > 0) {
      shoppingListReference
          .doc(currentUser.id)
          .collection('shoppingList')
          .doc(recipe.postId)
          .set({
        'recipeName': recipe.name,
        'ingredients': jsonEncode(recipe.nIngredients),
        'stringIngredients': null
      });
      showToast();
    }

    if (recipe.ingredients != "") {
      shoppingListReference
          .doc(currentUser.id)
          .collection('shoppingList')
          .doc(recipe.postId)
          .set({
        'ingredients': null,
        'recipeName': recipe.name,
        'stringIngredients': recipe.ingredients
      });
      showToast();
    }

    // for (int i = 0; i < recipe.nIngredients.length; i++) {
    //   var ingrdnts = recipe.nIngredients[i];
    //   shoppingListReference
    //       .doc(currentUser.id)
    //       .collection('shoppingList')
    //       .doc(recipe.postId)
    //       .set({
    //     'name': ingrdnts.name,
    //     'id': ingrdnts.id,
    //     'image': ingrdnts.imageUrl,
    //     'unit': ingrdnts.unit,
    //     'amount': ingrdnts.amount
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;

    print(currentUser.userType);

    return Scaffold(
      body: FutureBuilder(
        future: postsReference
            .doc(data['userId'])
            .collection("usersPosts")
            .doc(data['postId'])
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final recipe = Recipe.fromDocument(snapshot.data);
          var allIngredientsOfARecipe = recipe.nIngredients;

          return CustomScrollView(
            controller: _controller,
            slivers: [
              RecipeSliverAppBar(
                recipe: recipe,
                appBarBottomBtnPosition:
                    RecipeDetailScreen._appBarBottomBtnPosition,
                sliverCollapsed: _sliverCollapsed,
              ),
              SliverPadding(
                padding: EdgeInsets.only(
                    top: RecipeDetailScreen._appBarBottomBtnPosition),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                recipe.profileName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(0, 0, 0, 0.5),
                                ),
                              ),
                              if (recipe.timeNeeded != null)
                                Row(
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      size: 20,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      recipe.timeNeeded.toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Divider(),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (recipe.portions != null)
                                RecipeDetailChip(
                                  labelText: '${recipe.portions} Person',
                                ),
                              if (recipe.category != null)
                                RecipeDetailChip(labelText: 'Medium'),
                              if (recipe.cost != null)
                                RecipeDetailChip(
                                    labelText: '${recipe.cost} \$\$')
                            ],
                          ),
                          if (recipe.portions != null ||
                              recipe.category != null ||
                              recipe.cost != null)
                            SizedBox(height: 20),
                          Stack(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RecipeDetailNutrientsBox(
                                    labelText: 'Calories',
                                    amountText: getTotalCalories(
                                            allIngredientsOfARecipe)
                                        .toString(),
                                  ),
                                  RecipeDetailNutrientsBox(
                                    labelText: 'Fat',
                                    amountText: (getTotalFat(
                                                allIngredientsOfARecipe) ==
                                            0)
                                        ? 'null'
                                        : '${getTotalFat(allIngredientsOfARecipe).toString()} g',
                                  ),
                                  RecipeDetailNutrientsBox(
                                    labelText: 'Sugar',
                                    amountText: (getTotalSugar(
                                                allIngredientsOfARecipe) ==
                                            0)
                                        ? 'null'
                                        : '${getTotalSugar(allIngredientsOfARecipe).toStringAsFixed(2)} g',
                                  ),
                                ],
                              ),
                              StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentUser.id)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    }

                                    final user =
                                        Users.fromDocument(snapshot.data);

                                    if (user.userType != 'Free')
                                      return Container();

                                    return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              PricingDialog(
                                            currentUser: currentUser,
                                          ),
                                        );
                                      },
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: 3.0,
                                              sigmaY: 3.0,
                                            ),
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: double.infinity,
                                              height: 75,
                                              child: Container(
                                                decoration: new BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  recipe.description == null
                                      ? 'No Description Provided'
                                      : recipe.description,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color.fromRGBO(0, 0, 0, 0.60),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Ingredients',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    FlatButton(
                                      child: Text(
                                        'Add to the shopping list',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                      onPressed: () {
                                        showDialogForAddingShoppingList(recipe);

                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             ShopListPage(
                                        //               recipe: recipe,
                                        //             )));
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                if (recipe.ingredients != null)
                                  Text('${recipe.ingredients}'),
                                if (recipe.nIngredients.length > 0)
                                  Container(
                                    height: 135,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: recipe.nIngredients.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final ingredient =
                                            recipe.nIngredients[index];
                                        return RecipeDetailIngredient(
                                          imageUrl: ingredient.imageUrl,
                                          labelText:
                                              '${ingredient.amount} ${ingredient.unit} of ${ingredient.name}',
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Directions',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  recipe.directions == null
                                      ? 'No directions provided'
                                      : recipe.directions,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color.fromRGBO(0, 0, 0, 0.60),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Divider(),
                          SizedBox(height: 10),
                          RecipeDetailComment(
                            postId: recipe.postId,
                            ownerId: recipe.ownerId,
                            imageUrl: recipe.imageUrl,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // SliverFixedExtentList(),
            ],
          );
        },
      ),
    );
  }
}
