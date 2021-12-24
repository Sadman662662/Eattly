import 'dart:io';

import 'package:eattlystefan/pages/preview_story_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as ImD;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import './HomePage.dart';
import '../models/User.dart';
import '../utils/text_style.dart';
import '../widgets/ProgressWidget.dart';
import '../widgets/textFormWidget.dart';
import '../widgets/titleWidget.dart';

class UploadStoryPage extends StatefulWidget {
  final Users gCurrentUser;

  UploadStoryPage({this.gCurrentUser});
  @override
  _UploadStoryPageState createState() => _UploadStoryPageState();
}

class _UploadStoryPageState extends State<UploadStoryPage>
    with AutomaticKeepAliveClientMixin<UploadStoryPage> {
  final _storyTextController = TextEditingController();
  final _imagePicker = ImagePicker();

  var _uploading = false;
  var _storyId = Uuid().v4();

  var _imageFile;
  int totalStories = 0;

  bool get wantKeepAlive => true;

  getTotalStories() async {
    var allStoriesOfAUser = await storyReference
        .doc(currentUser.id)
        .collection('userStories')
        .get();
    allStoriesOfAUser.docs.forEach((element) {
      totalStories = totalStories + 1;
    });
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

  pickImageFromGallery() async {
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
      msg: 'Story Added Successfully',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  void clearPostInfo() {
    _storyTextController.clear();

    setState(() {
      _imageFile = null;
    });
  }

  controlUploadAndSave() async {
    print("postID: " + _storyId);

    setState(() {
      _uploading = true;
    });
    await compressingPhoto();

    String downloadUrl = await uploadPhoto(_imageFile);

    saveStoryInfoToFireStore(
      url: downloadUrl,
      aboutStory: _storyTextController.text,
    );

    _storyTextController.clear();

    setState(() {
      _imageFile = null;
      _uploading = false;
      _storyId = Uuid().v4();
    });
  }

  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(_imageFile.readAsBytesSync());
    final compressedImageFile = File('$path/img_$_storyId.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 60));
    setState(() {
      _imageFile = compressedImageFile;
    });
  }

  Future<String> uploadPhoto(mImageFile) async {
    var mStorageUploadTask =
        storageReference.child("post_$_storyId.jpg").putFile(mImageFile);
    var storageTaskSnapshot = await mStorageUploadTask;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  void saveStoryInfoToFireStore({
    String url,
    String aboutStory,
  }) {
    storyReference.doc(widget.gCurrentUser.id).set({});

    storyReference
        .doc(widget.gCurrentUser.id)
        .collection("userStories")
        .doc(_storyId)
        .set(
      {
        "storyId": _storyId,
        "ownerId": widget.gCurrentUser.id,
        "ownerProfileImageUrl": widget.gCurrentUser.url,
        "timestamp": DateTime.now(),
        "profileName": widget.gCurrentUser.profileName,
        "aboutStory": aboutStory,
        "url": url,
      },
    );
    showToast();
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
          onPressed: clearPostInfo,
        ),
        title: Text(
          "Add Story",
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.white,
            fontFamily: "Rubik",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          _uploading ? circularProgress() : Text(''),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(_imageFile),
                      fit: BoxFit.cover,
                    ),
                  ),
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
                controller: _storyTextController,
                decoration: InputDecoration(
                  hintText: "Write About Story",
                  hintStyle: TextStyle(
                    color: Color(0xFF1B5E20),
                    fontFamily: "Rubik",
                  ),
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.newline,
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getTotalStories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: whiteColor,
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            "Add Story",
            style: textStyle(
                Theme.of(context).primaryColor, 25.0, FontWeight.bold),
          ),
        ),
        body: (_uploading == true)
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
                    _imageFile == null
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
                                _imageFile,
                                fit: BoxFit.cover,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(25.0)),
                            ),
                          ),
                    textTitle("Write About Story"),
                    TextFormWidget(
                      textEditingController: _storyTextController,
                      hint: "about story",
                      height: 40.0,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 55.0,
                      margin: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 20.0),
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        splashColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onPressed: (_imageFile == null)
                            ? () {}
                            : (totalStories > 5)
                                ? () {
                                    showDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Text(
                                                        'Too many stories you can keep only 5 stories please delete some stories to add new stories.'),
                                                    GestureDetector(
                                                      child: Text(
                                                        'Click here to preview and delete stories',
                                                        style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline),
                                                      ),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        PreviewStorypage()));
                                                        // Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ));
                                  }
                                : () {
                                    controlUploadAndSave();
                                  },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Text(
                              "Save Story",
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
                    ),
                    Container(
                      height: 55.0,
                      margin: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 20.0),
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        splashColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PreviewStorypage()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Text(
                              "Preview Story",
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
