import 'package:eattlystefan/models/User.dart';
import 'package:eattlystefan/models/recipe.dart';
import 'package:eattlystefan/pages/HomePage.dart';
import 'package:eattlystefan/pages/recipe_detail_screen.dart';
import 'package:eattlystefan/widgets/HeaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class SavedRecipePage extends StatefulWidget {
  final Users currentUser;
  SavedRecipePage({this.currentUser});
  @override
  _SavedRecipePageState createState() => _SavedRecipePageState();
}

class _SavedRecipePageState extends State<SavedRecipePage> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: header(context, strTitle: "Saved Recipes"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              StreamBuilder(
                  stream: savedRecipesReference
                      .doc(widget.currentUser.id)
                      .collection('savedRecipes')
                      .snapshots(),
                  builder: (context, snapshot) {
                    var savedPosts = [];
                    if (snapshot.hasData) {
                      savedPosts = snapshot.data.documents
                          .map((snapshot) => Recipe.fromDocument(snapshot))
                          .toList();
                    }

                    return (snapshot.hasData)
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: savedPosts.length,
                            itemBuilder: (context, index) => SavedRecipeItem(
                                  currentUser: widget.currentUser,
                                  savedPost: savedPosts[index],
                                  deviceSize: deviceSize,
                                ))
                        : Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.grey,
                            ),
                          );
                  }),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SavedRecipeItem extends StatefulWidget {
  final Recipe savedPost;
  final Size deviceSize;
  final Users currentUser;

  SavedRecipeItem({this.currentUser, this.savedPost, this.deviceSize});

  @override
  _SavedRecipeItemState createState() => _SavedRecipeItemState();
}

class _SavedRecipeItemState extends State<SavedRecipeItem> {
  delteSavedRecipe() async {
    await savedRecipesReference
        .doc(widget.currentUser.id)
        .collection('savedRecipes')
        .doc(widget.savedPost.postId)
        .delete();
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
                              delteSavedRecipe();
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
      msg: 'Recipe has been deleted successfully',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Stack(
          children: [
            Container(
              height: 140,
              color: Colors.white,
            ),
            Card(
              elevation: 5,
              color: Colors.white,
              clipBehavior: Clip.antiAlias,
              child: Container(
                height: 120,
                padding: const EdgeInsets.all(0),
                child: Row(children: [
                  Expanded(
                    flex: 6,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(widget.savedPost.imageUrl),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 14,
                    child: Container(
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            children: [
                              Flexible(
                                child: Container(
                                  height: 20,
                                  width: (isPortrait) ? 80 : 140,
                                  child: RaisedButton(
                                    child: Text(
                                      '${widget.savedPost.portions} Portions',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 8),
                                    ),
                                    onPressed: () {},
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: (isPortrait) ? 4 : 24,
                              ),
                              Flexible(
                                child: Container(
                                  width: (isPortrait) ? 80 : 140,
                                  height: 20,
                                  child: RaisedButton(
                                    child: Text(
                                      'Medium',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 10),
                                    ),
                                    onPressed: () {},
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: (isPortrait) ? 4 : 24,
                              ),
                              Flexible(
                                child: Container(
                                  height: 20,
                                  width: (isPortrait) ? 80 : 140,
                                  child: RaisedButton(
                                    child: Text(
                                      '\$\$ ${widget.savedPost.cost}',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 10),
                                    ),
                                    onPressed: () {},
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 80,
                            child: Text(
                              widget.savedPost.description,
                              overflow: TextOverflow.clip,
                              maxLines: 3,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Positioned(
              child: Container(
                height: 25,
                width: 40,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'See More',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(RecipeDetailScreen.routeName, arguments: {
                      'userId': widget.savedPost.ownerId,
                      'postId': widget.savedPost.postId,
                    });
                  },
                ),
              ),

              bottom: 5,
              left: (isPortrait) ? 280 : 560,
              // top: 140,
              right: 10,
            ),
            Positioned(
              child: Container(
                height: 25,
                width: 40,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  onPressed: showDialogForDeletingPost,
                ),
              ),

              bottom: 5,
              left: (isPortrait) ? 140 : 340,
              // top: 140,
              right: (isPortrait) ? 140 : 240,
            )
          ],
        ));
  }
}
