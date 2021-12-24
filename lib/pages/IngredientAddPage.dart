import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eattlystefan/models/recipe.dart';
import 'package:eattlystefan/utils/text_style.dart';
import 'package:eattlystefan/widgets/textFormWidget.dart';
import 'package:eattlystefan/widgets/titleWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as ImD;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'HomePage.dart';

class AddIngredient extends StatefulWidget {
  @override
  _AddIngredientState createState() => _AddIngredientState();
}

class _AddIngredientState extends State<AddIngredient> {
  final _imagePicker = ImagePicker();
  var _id = Uuid().v4();

  var _recipe = Recipe();
  File _imageFile;

  var ingredientName;
  var _uploading = false;

  var _nameTextController = TextEditingController();

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

  controlUploadAndSave() async {
    print("postID: " + _id);

    setState(() {
      _uploading = true;
    });
    await compressingPhoto();

    String downloadUrl = await uploadPhoto(_imageFile);

    ingredientReference
        .add({"itemName": _nameTextController.text, "url": downloadUrl}).then(
            (value) => showToast('Ingredient Added Successfully'));

    setState(() {
      _imageFile = null;
      _uploading = false;
      _id = Uuid().v4();
    });
  }

  void showToast(str) {
    Fluttertoast.showToast(
      msg: str,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(_imageFile.readAsBytesSync());
    final compressedImageFile = File('$path/img_$_id.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 60));
    setState(() {
      _imageFile = compressedImageFile;
    });
  }

  Future<String> uploadPhoto(mImageFile) async {
    var mStorageUploadTask =
        ingredientNameReference.child("post_$_id.jpg").putFile(mImageFile);
    var storageTaskSnapshot = await mStorageUploadTask;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: greenColor),
        title: Text(
          "Ingredient",
          style: textStyle(greenColor, 20.0, FontWeight.bold),
        ),
      ),
      body: (_uploading == true)
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey,
              ),
            )
          : Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10.0),
                    width: 300,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                                  'Add Ingredient Image',
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
                ),
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      textTitle("Ingredient Name"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextFormWidget(
                    textEditingController: _nameTextController,
                    hint: "ingredient name",
                    height: 40.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                ButtonTheme(
                  minWidth: 300,
                  height: 40,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      await controlUploadAndSave();
                      // await uploadPic(context);
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('ingredients')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: greenColor,
                            ),
                          );
                        }
                        return ListView(
                          children: snapshot.data.docs.map((document) {
                            return Container(
                              //height: MediaQuery.of(context).size.height / 6,
                              height: 50.0,
                              margin: EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 40.0,
                                    backgroundImage:
                                        NetworkImage(document['url']),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  Text(
                                    document['itemName'],
                                    style: textStyle(
                                        Colors.black, 17.0, FontWeight.w500),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.green[800],
                                      ),
                                      onPressed: () async {
                                        print(document.id);

                                        await deleteField(document.id);
                                      })
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }),
                ),
              ],
            ),
    );
  }

  Future<void> deleteField(id) {
    return ingredientReference
        .doc(id)
        .delete()
        .then((value) => showToast("Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
