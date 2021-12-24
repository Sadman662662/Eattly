import 'package:eattlystefan/pages/HomePage.dart';
import 'package:eattlystefan/pages/recipe_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/PostWidget.dart';

class PostTile extends StatefulWidget {
  final Post post;

  PostTile(this.post);

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  displayFullPost(context) {
    Navigator.of(context).pushNamed(RecipeDetailScreen.routeName, arguments: {
      'userId': widget.post.ownerId,
      'postId': widget.post.postId,
    });
  }

  void showToast() {
    Fluttertoast.showToast(
      msg: 'Post has been deleted successfully',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  deletePost() async {
    //delete post from timeline

    await timelineReference
        .doc(currentUser.id)
        .collection('timelinePosts')
        .doc(widget.post.postId)
        .delete();

    // delete original post

    await postsReference
        .doc(currentUser.id)
        .collection('usersPosts')
        .doc(widget.post.postId)
        .delete();

    showToast();
    setState(() {});
  }

  showDialogForDeletingPost() {
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
                              "Do you want to delete the post",
                              maxLines: 2,
                              style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
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
                              await deletePost();
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => displayFullPost(context),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
        ),
        child: FadeInImage(
          placeholder: AssetImage('assets/image_loading.png'),
          image: NetworkImage(widget.post.url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
