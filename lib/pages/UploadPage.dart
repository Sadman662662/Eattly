import 'dart:async';
import 'dart:io';

import 'package:eattlystefan/models/User.dart';
import 'package:eattlystefan/utils/text_style.dart';
import 'package:eattlystefan/widgets/ProgressWidget.dart';
import 'package:eattlystefan/widgets/textFormWidget.dart';
import 'package:eattlystefan/widgets/titleWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as ImD;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'HomePage.dart';

class UploadPage extends StatefulWidget {
  static const String routeName = '/upload-page';
  final Users gCurrentUser;

  UploadPage({this.gCurrentUser});

  @override
  _UploadPageState createState() => _UploadPageState(gCurrentUser);
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  final Users gCurrentUser;
  _UploadPageState(this.gCurrentUser);

  File file;
  bool uploading = false;
  String postId = Uuid().v4();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController =
      TextEditingController();
  TextEditingController prepareTextEditingController = TextEditingController();
  TextEditingController ingredientsTextEditingController =
      TextEditingController();
  TextEditingController costTextEditingController = TextEditingController();
  TextEditingController portionTextEditingController = TextEditingController();
  TextEditingController timeTextEditingController = TextEditingController();
  TextEditingController categoryTextEditingController = TextEditingController();

  captureImageWithCamera() async {
    Navigator.pop(context);
    // TODO: using deprecated API use ImagePicker.getImage()
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      this.file = imageFile;
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    // TODO: using deprecated API use ImagePicker.getImage()
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      this.file = imageFile;
    });
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "New Recipe",
            style: textStyle(
              Color(0xFF1B5E20),
              18.0,
              FontWeight.bold,
            ),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: Text(
                "Capture Image with Camera",
                style: TextStyle(color: Color(0xFF1B5E20), fontFamily: "Rubik"),
              ),
              onPressed: captureImageWithCamera,
            ),
            SimpleDialogOption(
              child: Text(
                "Select Image From Gallery",
                style: TextStyle(color: Color(0xFF1B5E20), fontFamily: "Rubik"),
              ),
              onPressed: pickImageFromGallery,
            ),
          ],
        );
      },
    );
  }

  void showToast() {
    Fluttertoast.showToast(
        msg: 'Recipe Added Successfully',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white);
  }

  displayUploadScreen() {
    return Container(
      color: Colors.white.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            child: Icon(
              Icons.note_add,
              color: Color(0xFF1B5E20),
              size: 200,
            ),
            onTap: () => takeImage(context),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9.0),
              ),
              child: Text(
                "Add Your Recipe",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              color: Color(0xFF1B5E20),
              onPressed: () => takeImage(context),
            ),
          ),
        ],
      ),
    );
  }

  clearPostInfo() {
    nameTextEditingController.clear();
    descriptionTextEditingController.clear();
    prepareTextEditingController.clear();
    ingredientsTextEditingController.clear();

    setState(() {
      file = null;
    });
  }

  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 60));
    setState(() {
      file = compressedImageFile;
    });
  }

  controlUploadAndSave() async {
    print("postID: " + postId);

    setState(() {
      uploading = true;
    });

    await compressingPhoto();

    String downloadUrl = await uploadPhoto(file);

    savePostInfoToFireStore(
        url: downloadUrl,
        name: nameTextEditingController.text,
        description: descriptionTextEditingController.text,
        prepare: prepareTextEditingController.text,
        ingredients: ingredientsTextEditingController.text,
        cost: costTextEditingController.text,
        neededTime: timeTextEditingController.text,
        category: categoryTextEditingController.text,
        portion: portionTextEditingController.text);

    nameTextEditingController.clear();
    descriptionTextEditingController.clear();
    prepareTextEditingController.clear();
    ingredientsTextEditingController.clear();
    categoryTextEditingController.clear();
    portionTextEditingController.clear();
    timeTextEditingController.clear();
    costTextEditingController.clear();

    setState(() {
      file = null;
      uploading = false;
      postId = Uuid().v4();
    });
  }

  savePostInfoToFireStore({
    String url,
    String name,
    String description,
    String prepare,
    String ingredients,
    String cost,
    String portion,
    String neededTime,
    String category,
  }) {
    postsReference.document(widget.gCurrentUser.id).setData({});

    postsReference
        .doc(widget.gCurrentUser.id)
        .collection("usersPosts")
        .doc(postId)
        .set({
      "postId": postId,
      "ownerId": widget.gCurrentUser.id,
      "timestamp": DateTime.now(),
      "likes": {},
      "profileName": widget.gCurrentUser.profileName,
      "description": description,
      "name": name,
      "prepare": prepare,
      "ingredients": ingredients,
      "cost": cost,
      "portion": portion,
      "neededTime": neededTime,
      "category": category,
      "url": url,
    }).then((value) => showToast());
  }

  Future<String> uploadPhoto(mImageFile) async {
    var mStorageUploadTask =
        storageReference.child("post_$postId.jpg").putFile(mImageFile);
    var storageTaskSnapshot = await mStorageUploadTask;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  displayUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B5E20),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: clearPostInfo),
        title: Text(
          "New Post",
          style: TextStyle(
              fontSize: 24.0,
              color: Colors.white,
              fontFamily: "Rubik",
              fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: uploading ? null : () => controlUploadAndSave(),
            child: Text(
              "Share",
              style: TextStyle(
                  color: Color(0xFFFBC02D),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  fontFamily: "Rubik"),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          uploading ? linearProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: FileImage(file),
                    fit: BoxFit.cover,
                  )),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
          ),
          ListTile(
            leading: Icon(
              Icons.library_books,
              color: Color(0xFF1B5E20),
              size: 36,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(color: Color(0xFF1B5E20), fontFamily: "Rubik"),
                controller: nameTextEditingController,
                decoration: InputDecoration(
                    hintText: "Recipe name",
                    hintStyle: TextStyle(
                        color: Color(0xFF1B5E20), fontFamily: "Rubik"),
                    border: InputBorder.none),
                textInputAction: TextInputAction.newline,
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.description,
              color: Color(0xFF1B5E20),
              size: 36,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(color: Color(0xFF1B5E20), fontFamily: "Rubik"),
                controller: descriptionTextEditingController,
                decoration: InputDecoration(
                    hintText: "Say something about your recipe...",
                    hintStyle: TextStyle(
                        color: Color(0xFF1B5E20), fontFamily: "Rubik"),
                    border: InputBorder.none),
                textInputAction: TextInputAction.newline,
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.fastfood,
              color: Color(0xFF1B5E20),
              size: 36,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(color: Color(0xFF1B5E20), fontFamily: "Rubik"),
                decoration: InputDecoration(
                    hintText: 'Ingredients',
                    hintStyle: TextStyle(
                        color: Color(0xFF1B5E20), fontFamily: "Rubik"),
                    border: InputBorder.none),
                textInputAction: TextInputAction.newline,
                controller: ingredientsTextEditingController,
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.playlist_add_check,
              color: Color(0xFF1B5E20),
              size: 36,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(color: Color(0xFF1B5E20), fontFamily: "Rubik"),
                controller: prepareTextEditingController,
                decoration: InputDecoration(
                  hintText: "Directions",
                  hintStyle:
                      TextStyle(color: Color(0xFF1B5E20), fontFamily: "Rubik"),
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.newline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: whiteColor,
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            "Add Recipe",
            style: textStyle(greenColor, 25.0, FontWeight.bold),
          ),
        ),
        body: (uploading == true)
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                ),
              )
            : Container(
                margin: EdgeInsets.only(
                  left: 25.0,
                  right: 25.0,
                ),
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: [
                    file == null
                        ? GestureDetector(
                            onTap: () {
                              takeImage(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 15.0, bottom: 25.0),
                              height: 230.0,
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(25.0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 100,
                                    color: Colors.grey[400],
                                  ),
                                  Text(
                                    "Add image/video",
                                    style: textStyle(
                                        Colors.grey, 13.0, FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              takeImage(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 15.0, bottom: 25.0),
                              height: 230.0,
                              child: Image.file(
                                file,
                                fit: BoxFit.cover,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(25.0)),
                            ),
                          ),
                    textTitle("Recipe Name"),
                    TextFormWidget(
                      textEditingController: nameTextEditingController,
                      hint: "name",
                      height: 40.0,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    textTitle("Recipe Description"),
                    TextFormWidget(
                      textEditingController: descriptionTextEditingController,
                      hint: "description",
                      height: 70.0,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    textTitle("Ingredient"),
                    TextFormWidget(
                      textEditingController: ingredientsTextEditingController,
                      hint: "ingredient",
                      height: 70.0,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    textTitle("Recipe Direction"),
                    TextFormWidget(
                      textEditingController: prepareTextEditingController,
                      hint: "recipe direction",
                      height: 70.0,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                textTitle("Cost to Prepare"),
                                TextFormWidget(
                                  textEditingController:
                                      costTextEditingController,
                                  hint: "cost",
                                  height: 40.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                textTitle("Portion"),
                                TextFormWidget(
                                  textEditingController:
                                      portionTextEditingController,
                                  hint: "portion",
                                  height: 40.0,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                textTitle("Time Needed"),
                                TextFormWidget(
                                  textEditingController:
                                      timeTextEditingController,
                                  hint: "recipe direction",
                                  height: 40.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                textTitle("Category"),
                                TextFormWidget(
                                  textEditingController:
                                      categoryTextEditingController,
                                  hint: "categoty",
                                  height: 40.0,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 55.0,
                      margin: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 20.0),
                      child: RaisedButton(
                        color: greenColor,
                        splashColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onPressed: () {
                          controlUploadAndSave();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Text(
                              "Save Recipe",
                              textAlign: TextAlign.center,
                              style:
                                  textStyle(whiteColor, 14.0, FontWeight.w400),
                            )),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
