import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import './recipe_label.dart';
import '../../models/ingredient.dart';

class AddIngredientsField extends StatefulWidget {
  final List<Ingredient> ingredients;
  final FocusNode focusNode;

  const AddIngredientsField({
    Key key,
    @required this.ingredients,
    this.focusNode,
  }) : super(key: key);

  @override
  _AddIngredientsFieldState createState() => _AddIngredientsFieldState();
}

class _AddIngredientsFieldState extends State<AddIngredientsField> {
  final _formKey = new GlobalKey<FormState>();

  final _typeAheadController = TextEditingController();
  final List<Ingredient> _ingredientList = [];
  final _units = ['kg', 'cup', 'oz', 'grams'];

  Ingredient _ingredient = Ingredient();
  var ingredientName;

  void showToast() {
    Fluttertoast.showToast(
      msg: 'Plese give all the informaition to add ingredient',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.ingredients);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RecipeLabel(label: 'Ingredients'),
          SizedBox(height: 5),
          if (widget.ingredients.length > 0)
            ...widget.ingredients.map((ingredient) {
              return ListTile(
                dense: true,
                title: Text(
                  '${ingredient?.amount} ${ingredient?.unit} of ${ingredient?.name}',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      widget.ingredients.remove(ingredient);
                    });
                  },
                ),
              );
            }).toList(),
          Form(
            key: _formKey,
            child: Row(
              children: [
                Flexible(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('ingredients')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }

                        snapshot.data.docs.forEach((document) {
                          final ingredient = Ingredient.fromDocument(document);
                          _ingredientList.add(ingredient);
                        });

                        return TypeAheadFormField(
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(
                                suggestion.name,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                          transitionBuilder:
                              (context, suggestionsBox, controller) {
                            return suggestionsBox;
                          },
                          onSuggestionSelected: (suggestion) {
                            setState(() {
                              _typeAheadController.text = suggestion.name;
                            });
                          },
                          suggestionsCallback: (pattern) {
                            return _ingredientList
                                .where(
                                  (ingredient) => ingredient.name
                                      .toString()
                                      .toLowerCase()
                                      .startsWith(pattern.toLowerCase()),
                                )
                                .toList();
                          },
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Required field';
                            }
                            return null;
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _typeAheadController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 15,
                              ),
                              hintText: 'eg. rice',
                              hintStyle: TextStyle(
                                color: Color(0x2A2A2A2A),
                                fontSize: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              fillColor: Color(0xF3F3F3F3),
                            ),
                            focusNode: widget.focusNode,
                          ),
                          onSaved: (val) {
                            ingredientName = val;
                            final ingredient = _ingredientList
                                .where(
                                  (ingredient) => ingredient.name
                                      .toString()
                                      .toLowerCase()
                                      .startsWith(val.toLowerCase()),
                                )
                                .toList()
                                .first;

                            setState(() {
                              _ingredient.name = val;
                              _ingredient.id = ingredient.id;
                              _ingredient.imageUrl = ingredient.imageUrl;
                            });
                          },
                        );
                      }),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      hintText: 'eg. 5',
                      hintStyle: TextStyle(
                        color: Color(0x2A2A2A2A),
                        fontSize: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xF3F3F3F3),
                    ),
                    validator: (val) {
                      if (val.isEmpty) {
                        showToast();
                        return 'Amount required';
                      } else if (double.tryParse(val) == null) {
                        return 'Amount must be a number';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => setState(() {
                      _ingredient.amount = double.parse(val);
                    }),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: DropdownButtonFormField(
                    value: _ingredient.unit,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      hintText: 'eg. kg',
                      hintStyle: TextStyle(
                        color: Color(0x2A2A2A2A),
                        fontSize: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xF3F3F3F3),
                    ),
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Unit Required';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _ingredient.unit = value;
                      });
                    },
                    onSaved: (value) {
                      setState(() {
                        _ingredient.unit = value;
                      });
                    },
                    items: _units
                        .map(
                          (unit) => DropdownMenuItem(
                            child: Text(unit),
                            value: unit,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  onPressed: () async {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }

                    if (_formKey.currentState.validate()) {
                      showProgressDialog(
                          context: context, loadingText: 'Adding wait...');
                      _formKey.currentState.save();

                      const APP_ID = '12a4ad15';
                      const APP_KEY = '24213f4993defa6d698c6b22f2f2fa4c';

                      final url =
                          'https://api.edamam.com/api/nutrition-data?app_id=$APP_ID&app_key=$APP_KEY&ingr=${_ingredient.amount}%20${_ingredient.unit}%20${_ingredient.name}';
                      final response = await http.get(url);

                      if (response.statusCode == 200) {
                        dismissProgressDialog();
                        Map<String, dynamic> jsonResponse =
                            jsonDecode(response.body);

                        final calories = jsonResponse['calories'];
                        // final fat = jsonResponse['totalNutrients'];
                        final fatUnit =
                            jsonResponse['totalNutrients']["FAT"]['unit'];
                        final fatAmount =
                            jsonResponse['totalNutrients']["FAT"]['quantity'];

                        final sugarUnit =
                            jsonResponse['totalNutrients']["SUGAR"]['unit'];
                        final sugarAmount =
                            jsonResponse['totalNutrients']["SUGAR"]['quantity'];

                        setState(() {
                          _ingredient.sugarAmount = sugarAmount;
                          _ingredient.sugarUnit = sugarUnit;
                          _ingredient.fatAmount = fatAmount;
                          _ingredient.fatUnit = fatUnit;
                          _ingredient.calories = calories;
                          widget.ingredients.add(_ingredient);
                          _ingredient = Ingredient();
                        });

                        _formKey.currentState.reset();
                        _typeAheadController.clear();
                      }
                    }
                  },
                  child: Text(
                    'Add Ingredient',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
