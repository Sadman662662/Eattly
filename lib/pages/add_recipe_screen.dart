import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'package:image/image.dart' as ImD;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import './HomePage.dart';
import '../models/User.dart';
import '../models/recipe.dart';
import '../widgets/add_recipe/add_ingredients_field.dart';
import '../widgets/add_recipe/recipe_dropdown_form_field.dart';
import '../widgets/add_recipe/recipe_form_field.dart';

class AddRecipeScreen extends StatefulWidget {
  static const String routeName = '/add-recipe';

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = new GlobalKey<FormState>();

  final _descriptionFocusNode = FocusNode();
  final _ingredientsFocusNode = FocusNode();
  final _costToPrepareFocusNode = FocusNode();
  final _portionsFocusNode = FocusNode();
  final _timeNeededFocusNode = FocusNode();
  final _imagePicker = ImagePicker();
  final _postId = Uuid().v4();

  var _recipe = Recipe(nIngredients: []);

  File _imageFile;

  // File file;

  Future<String> uploadPhoto(mImageFile) async {
    final mStorageUploadTask =
        storageReference.child("post_$_postId.jpg").putFile(mImageFile);
    final storageTaskSnapshot = await mStorageUploadTask;
    final downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  void captureImageWithCamera() async {
    Navigator.pop(context);
    final imageFile = await _imagePicker.getImage(
      source: ImageSource.camera,
      imageQuality: 60,
    );

    setState(() {
      _imageFile = File(imageFile.path);
    });
  }

  void pickImageFromGallery() async {
    Navigator.pop(context);
    final imageFile = await _imagePicker.getImage(
      source: ImageSource.gallery,
      maxHeight: 680,
      maxWidth: 970,
      imageQuality: 60,
    );
    setState(() {
      _imageFile = File(imageFile.path);
    });
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _ingredientsFocusNode.dispose();
    _costToPrepareFocusNode.dispose();
    _portionsFocusNode.dispose();
    _timeNeededFocusNode.dispose();
    super.dispose();
  }

  Future<void> savePostInfoToFireStore(
    Recipe recipe,
    Users user,
    CollectionReference postsReference,
  ) async {
    final downloadUrl = await uploadPhoto(_imageFile);

    postsReference.doc(user.id).set({});

    postsReference.doc(user.id).collection("usersPosts").doc(_postId).set(
      {
        "postId": _postId,
        "ownerId": user.id,
        "timestamp": DateTime.now(),
        "likes": {},
        "profileName": user.profileName,
        "description": recipe.description,
        "name": recipe.name,
        "prepare": recipe.directions,
        "ingredients": "",
        "n_ingredients": jsonEncode(recipe.nIngredients),
        "cost": recipe.cost,
        "portion": recipe.portions,
        "neededTime": recipe.timeNeeded,
        "category": recipe.category,
        "url": downloadUrl,
      },
    );
  }

  void showToast() {
    Fluttertoast.showToast(
      msg: 'Recipe has been added successfully',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Users _currentUser = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: Text('Add Recipe'),
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xF3F3F3F3),
                  ),
                  child: _imageFile == null
                      ? GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    padding: const EdgeInsets.all(10),
                                    height: 150,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FlatButton.icon(
                                          icon: Icon(Icons.camera),
                                          label: Text('Open Gallery'),
                                          onPressed: pickImageFromGallery,
                                        ),
                                        FlatButton.icon(
                                          icon: Icon(Icons.camera_alt),
                                          label: Text('Open Camera'),
                                          onPressed: captureImageWithCamera,
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: Color(0x70707070),
                                size: 70,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Add Image/Video',
                                style: TextStyle(
                                  color: Color(0x70707070),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                image: FileImage(_imageFile),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                ),
                RecipeFormField(
                  hintText: 'eg. Fried Rice',
                  labelText: 'Name',
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                  onSaved: (val) => setState(() {
                    _recipe.name = val;
                  }),
                ),
                RecipeFormField(
                  maxLines: 2,
                  labelText: 'Description',
                  hintText: 'Enter Description',
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_ingredientsFocusNode);
                  },
                  focusNode: _descriptionFocusNode,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                  onSaved: (val) => setState(() {
                    _recipe.description = val;
                  }),
                ),
                AddIngredientsField(
                  ingredients: _recipe.nIngredients,
                  focusNode: _ingredientsFocusNode,
                ),
                RecipeFormField(
                  maxLines: 3,
                  labelText: 'Directions',
                  hintText: 'Enter Directions',
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Directions is required';
                    }
                    return null;
                  },
                  onSaved: (val) => setState(() {
                    _recipe.directions = val;
                  }),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context)
                        .requestFocus(_costToPrepareFocusNode);
                  },
                ),
                Row(
                  children: [
                    Flexible(
                      child: RecipeFormField(
                        keyboardType: TextInputType.number,
                        labelText: 'Cost To Prepare',
                        hintText: 'eg. \$\$\$',
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Cost is required';
                          } else if (double.tryParse(val) == null) {
                            return 'Cost must be a number';
                          } else {
                            return null;
                          }
                        },
                        focusNode: _costToPrepareFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_portionsFocusNode);
                        },
                        onSaved: (val) => setState(() {
                          _recipe.cost = val;
                        }),
                      ),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: RecipeFormField(
                        keyboardType: TextInputType.number,
                        labelText: 'Portions',
                        hintText: 'eg. 2',
                        focusNode: _portionsFocusNode,
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Portions is required';
                          } else if (int.tryParse(val) == null) {
                            return 'Portion must be a number';
                          } else {
                            return null;
                          }
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_timeNeededFocusNode);
                        },
                        onSaved: (val) => setState(() {
                          _recipe.portions = val;
                        }),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: RecipeFormField(
                        keyboardType: TextInputType.number,
                        labelText: 'Time Needed',
                        hintText: 'eg. 15',
                        suffixText: 'min',
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Time needed is required';
                          } else if (int.tryParse(val) == null) {
                            return 'Time needed must be a number';
                          } else {
                            return null;
                          }
                        },
                        focusNode: _timeNeededFocusNode,
                        onSaved: (val) => setState(() {
                          _recipe.timeNeeded = int.parse(val);
                        }),
                      ),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: RecipeDropdownFormField(
                        value: _recipe.category,
                        labelText: 'Category',
                        items: ['Vegan', 'Non-vegan'],
                        hintText: 'eg. vegan',
                        onChanged: (value) => setState(() {
                          _recipe.category = value;
                        }),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ButtonTheme(
                  minWidth: 10,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      if (_formKey.currentState.validate() &&
                          _imageFile != null) {
                        if (_recipe.nIngredients.length <= 0) {
                          Fluttertoast.showToast(
                            msg: 'Please add ingredient',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                          );
                          return;
                        }
                        showProgressDialog(
                            loadingText: 'Recipe is adding...',
                            context: context);
                        _formKey.currentState.save();

                        await savePostInfoToFireStore(
                          _recipe,
                          _currentUser,
                          postsReference,
                        );
                        dismissProgressDialog();
                        Navigator.of(context).pop();
                        // Navigator.of(context).pushNamed(
                        //   AddRecipeScreen.routeName,
                        //   arguments: _currentUser,
                        // );
                        showToast();
                        setState(() {
                          _recipe = Recipe();
                        });

                        _formKey.currentState.reset();

                        // Navigator.of(context).pushNamed('/signIn');
                      }
                    },
                    child: Text(
                      'Save Recipe',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 2,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
