import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eattlystefan/pages/recipe_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:uuid/uuid.dart';

import '../models/User.dart';
import '../pages/CommentsPage.dart';
import '../pages/HomePage.dart';
import '../pages/LikesPage.dart';
import '../pages/ProfilePage.dart';
import '../utils/text_style.dart';

class Post extends StatefulWidget {
  final Post post;
  final String postId;
  final String ownerId;
  final Map likes;
  final String profileName;
  final String description;
  final String name;
  final String prepare;
  final String ingredients;
  final String url;
  final Timestamp timestamp;
  final bool isShared;
  final String sharedBy;
  final Timestamp whenShared;
  final String sharedByImageUrl;
  final String sharedById;

  Post({
    this.postId,
    this.ownerId,
    this.likes,
    this.profileName,
    this.description,
    this.name,
    this.prepare,
    this.ingredients,
    this.url,
    this.post,
    this.timestamp,
    this.isShared,
    this.sharedBy,
    this.whenShared,
    this.sharedByImageUrl,
    this.sharedById,
  });

  factory Post.fromDocument(DocumentSnapshot documentSnapshot) {
    // final nIngredientsDoc = documentSnapshot.data()['n_ingredients'];
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

    return Post(
      postId: documentSnapshot.data()["postId"],
      ownerId: documentSnapshot.data()["ownerId"],
      likes: documentSnapshot.data()["likes"],
      profileName: documentSnapshot.data()["profileName"],
      description: documentSnapshot.data()["description"],
      name: documentSnapshot.data()["name"],
      prepare: documentSnapshot.data()["prepare"],
      ingredients: documentSnapshot.data()["ingredients"],
      url: documentSnapshot.data()["url"],
      timestamp: documentSnapshot.data()["timestamp"],
      isShared: localIsShared,
      sharedBy: localSharedBy,
      whenShared: localWhenShared,
      sharedByImageUrl: localSharedByImageUrl,
      sharedById: localSharedById,
    );
  }

  int getTotalNumberOfLikes(likes) {
    if (likes == null) {
      return 0;
    }

    int counter = 0;
    likes.values.forEach((eachValue) {
      if (eachValue == true) {
        counter = counter + 1;
      }
    });

    return counter;
  }

  @override
  _PostState createState() => _PostState(
        postId: this.postId,
        ownerId: this.ownerId,
        likes: this.likes,
        profileName: this.profileName,
        description: this.description,
        name: this.name,
        prepare: this.prepare,
        ingredients: this.ingredients,
        url: this.url,
        likeCount: getTotalNumberOfLikes(this.likes),

        //
      );
}

class _PostState extends State<Post> {
  final Post post;
  final String postId;
  final String ownerId;
  Map likes;
  final String profileName;
  final String description;
  final String name;
  final String prepare;
  final String ingredients;
  final String url;

  // List<User> whoLikes;
  //

  _PostState({
    this.postId,
    this.ownerId,
    this.likes,
    this.profileName,
    this.description,
    this.name,
    this.prepare,
    this.ingredients,
    this.url,
    this.likeCount,
    this.post,
    // this.whoLikes
    //
  });

  int likeCount = 0;
  bool isLiked;
  bool showHeart = false;
  final String currentOnlineUserId = currentUser?.id;
  bool isNotPostOwner;
  // bool isShared = false;
  var _globalUsers = [];
  List<String> followersList = [];
  final _postId = Uuid().v4();

  Timestamp sharedTime;
  Future<void> getWhoLikesThePost(likes) async {
    List<dynamic> usersWhoLikeThePost = [];

    if (likes == null) {
      List<Users> users = [];
      return users;
    }

    likes.keys.forEach((key) {
      if (likes[key] == true) {
        if (!usersWhoLikeThePost.contains(key)) {
          usersWhoLikeThePost.add(key);
        }
      }
    });

    // print('name: ${widget.name}');
    _globalUsers = await findUsersById(usersWhoLikeThePost);
  }

  Future<List<Users>> findUsersById(List<dynamic> keys) async {
    List<Users> users = [];
    for (final key in keys) {
      DocumentSnapshot documentSnapshot = await usersReference.doc(key).get();
      if (documentSnapshot.data != null) {
        Users user = Users.fromDocument(documentSnapshot);
        if (!users.contains(user)) {
          users.add(user);
        }
      }
    }

    return users;
  }

  retrieveFollowers() async {
    final querySnapshot = await followersReference
        .doc(currentUser.id)
        .collection("userFollowers")
        .get();

    setState(() {
      followersList =
          querySnapshot.docs.map((document) => document.id).toList();
    });
  }

  sharePost() async {
    // var timeRefs = await timelineReference
    //     .doc(currentUser.id)
    //     .collection('timelinePosts')
    //     .get();
    // timeRefs.docs.forEach((element) async {
    // if (widget.postId == element.id) {

    // await timelineReference
    //     .doc(currentUser.id)
    //     .collection('timelinePosts')
    //     .doc(widget.postId)
    //     .delete()
    // .then((value) async {

    await postsReference
        .doc(widget.ownerId)
        .collection('usersPosts')
        .doc(widget.postId)
        .get()
        .then((value) async {
      var nIngredients = value.data()['n_ingredients'];

      if (nIngredients != null) {
        await postsReference
            .doc(currentUser.id)
            .collection("usersPosts")
            .doc(_postId)
            .set({
          "postId": _postId,
          "ownerId": widget.ownerId,
          "timestamp": DateTime.now(),
          "likes": {},
          "profileName": widget.profileName,
          "description": widget.description,
          "name": widget.name,
          "prepare": widget.prepare,
          "ingredients": widget.ingredients,
          "cost": '',
          "portion": '',
          "neededTime": '',
          "category": '',
          "url": widget.url,
          'isShared': true,
          'sharedBy': currentUser.profileName,
          'whenShared': DateTime.now(),
          'sharedByImageUrl': currentUser.url,
          'sharedById': currentUser.id,
          'n_ingredients': nIngredients
        });
      } else {
        await postsReference
            .doc(currentUser.id)
            .collection("usersPosts")
            .doc(_postId)
            .set({
          "postId": _postId,
          "ownerId": widget.ownerId,
          "timestamp": DateTime.now(),
          "likes": {},
          "profileName": widget.profileName,
          "description": widget.description,
          "name": widget.name,
          "prepare": widget.prepare,
          "ingredients": widget.ingredients,
          "cost": '',
          "portion": '',
          "neededTime": '',
          "category": '',
          "url": widget.url,
          'isShared': true,
          'sharedBy': currentUser.profileName,
          'whenShared': DateTime.now(),
          'sharedByImageUrl': currentUser.url,
          'sharedById': currentUser.id,
        });
      }

      // setState(() {});
      // });

      // await timelineReference
      //     .doc(currentUser.id)
      //     .collection('timelinePosts')
      //     .doc(widget.postId)
      //     .set({
      //   "postId": widget.postId,
      //   "ownerId": widget.ownerId,
      //   "timestamp": DateTime.now(),
      //   "likes": {},
      //   "profileName": widget.profileName,
      //   "description": widget.description,
      //   "name": widget.name,
      //   "prepare": widget.prepare,
      //   "ingredients": widget.ingredients,
      //   "cost": '',
      //   "portion": '',
      //   "neededTime": '',
      //   "category": '',
      //   "url": widget.url,
      // });
      // }
      // checkWhetherThePostIsSharedOrNot();
      // });

      for (final follower in followersList) {
        if (follower != currentUser.id) {
          if (nIngredients != null) {
            await timelineReference
                .doc(follower)
                .collection('timelinePosts')
                .doc(_postId)
                .set(
              {
                "postId": _postId,
                "ownerId": widget.ownerId,
                "timestamp": DateTime.now(),
                "likes": {},
                "profileName": widget.profileName,
                "description": widget.description,
                "name": widget.name,
                "prepare": widget.prepare,
                "ingredients": widget.ingredients,
                "cost": '',
                "portion": '',
                "neededTime": '',
                "category": '',
                "url": widget.url,
                'isShared': true,
                'sharedBy': currentUser.profileName,
                'whenShared': DateTime.now(),
                'sharedByImageUrl': currentUser.url,
                'sharedById': currentUser.id,
                'n_ingredients': nIngredients
              },
            );
          } else {
            await timelineReference
                .doc(follower)
                .collection('timelinePosts')
                .doc(_postId)
                .set(
              {
                "postId": _postId,
                "ownerId": widget.ownerId,
                "timestamp": DateTime.now(),
                "likes": {},
                "profileName": widget.profileName,
                "description": widget.description,
                "name": widget.name,
                "prepare": widget.prepare,
                "ingredients": widget.ingredients,
                "cost": '',
                "portion": '',
                "neededTime": '',
                "category": '',
                "url": widget.url,
                'isShared': true,
                'sharedBy': currentUser.profileName,
                'whenShared': DateTime.now(),
                'sharedByImageUrl': currentUser.url,
                'sharedById': currentUser.id
              },
            );
          }
        }
      }
    });

    sharedPostReference
        .doc(currentUser.id)
        .collection('sharedPosts')
        .doc(_postId)
        .set({
      "postId": _postId,
      "ownerId": widget.ownerId,
      "timestamp": widget.timestamp,
      "likes": {},
      "profileName": widget.profileName,
      "description": widget.description,
      "name": widget.name,
      "prepare": widget.prepare,
      "ingredients": widget.ingredients,
      "cost": '',
      "portion": '',
      "neededTime": '',
      "category": '',
      "url": widget.url,
    });
    showToast();
  }

  checkWhetherThePostIsSharedOrNot() async {
    //    checkTheRecipeIsAlreadySaved() async {
    //   var ref = await savedRecipesReference
    //       .doc(currentUser.id)
    //       .collection('savedRecipes')
    //       .get();

    //   ref.docs.forEach((element) {
    //     if (element.id == widget.recipe.postId) {
    //       setState(() {
    //         isSaved = true;
    //       });
    //     }
    //   });
    //   // ref.docs.forEach((key, value) {
    //   //   if (key == widget.recipe.postId) {
    //   //     isSaved = true;
    //   //   } else {
    //   //     isSaved = false;
    //   //   }
    //   // });
    // }
    var ref = await sharedPostReference
        .doc(currentUser.id)
        .collection('sharedPosts')
        .get();
    ref.docs.forEach((element) {
      if (element.id == widget.postId) {
        setState(() {
          // isShared = true;
        });
      }
    });
  }

  savePost() async {
    await savedRecipesReference
        .doc(currentUser.id)
        .collection('savedRecipes')
        .doc(widget.postId)
        .set({
      "postId": widget.postId,
      "ownerId": widget.ownerId,
      "timestamp": widget.timestamp,
      "likes": {},
      "profileName": widget.profileName,
      "description": widget.description,
      "name": widget.name,
      "prepare": widget.prepare,
      "ingredients": widget.ingredients,
      "cost": '',
      "portion": '',
      "neededTime": '',
      "category": '',
      "url": widget.url,
    });
    showToast();
  }

  showDialogForSharingPost() {
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
                              "Do you want to share the post",
                              maxLines: 2,
                              style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
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
                              sharePost();
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

  showDialogForSavingPost() {
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
                              "Do you want to save the post",
                              maxLines: 2,
                              style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
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
                              savePost();
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
      msg: 'You shared the post successfully',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  int countLikes(likes) {
    if (likes == null) {
      return 0;
    }

    int counter = 0;

    likes.values.forEach((eachValue) {
      if (eachValue == true) {
        counter = counter + 1;
      }
    });

    return counter;
  }

  @override
  void initState() {
    super.initState();
    retrieveFollowers();
    // getTotalNumberOfLikes(widget.likes);

    // checkWhetherThePostIsSharedOrNot();
    // getSharedPostTimeAndProfileNameFromSharedPost();
    isNotPostOwner = currentOnlineUserId != widget.ownerId;
    if (widget.isShared == true) {
      isNotPostOwner = currentOnlineUserId != widget.sharedById;
    }
  }

  getSharedPostTimeAndProfileNameFromSharedPost() async {
    var ref = await sharedPostReference
        .doc(currentUser.id)
        .collection('sharedPosts')
        .doc(widget.postId)
        .get()
        .then((value) {
      sharedTime = value.data()['timestamp'];
    });
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (widget.likes[currentOnlineUserId] == true);
    getWhoLikesThePost(widget.likes);
    // checkWhetherThePostIsSharedOrNot();
    // getSharedPostTimeAndProfileNameFromSharedPost();

    return (widget.isShared == true)
        ? Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  maxRadius: 25,
                  backgroundColor: Color(0xFF1B5E20),
                  backgroundImage: NetworkImage(widget.sharedByImageUrl),
                ),
                title: Text(
                  widget.sharedBy,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF1B5E20),
                    fontWeight: FontWeight.bold,
                    fontFamily: "Rubik",
                  ),
                ),
                subtitle: Text(
                  '${tAgo.format(widget.whenShared.toDate())}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Rubik",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        createPostHead(),
                        SizedBox(
                          height: 20,
                        ),
                        createPostPicture(),
                        SizedBox(
                          height: 8,
                        ),
                        createPostFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        : Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                createPostHead(),
                SizedBox(
                  height: 20,
                ),
                createPostPicture(),
                SizedBox(
                  height: 8,
                ),
                createPostFooter(),
              ],
            ),
          );
  }

  Widget createPostHead() {
    return FutureBuilder(
      future: usersReference.doc(widget.ownerId).get(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xFF1B5E20),
            ),
            title: Text(
              widget.profileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF1B5E20),
                fontWeight: FontWeight.bold,
                fontFamily: "Rubik",
              ),
            ),
            subtitle: Text(
              widget.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF1B5E20),
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                fontFamily: "Rubik",
              ),
            ),
          );
        }

        final user = Users.fromDocument(dataSnapshot.data);

        // TODO: why is the profileName becoming null??
        final pName = widget.profileName ?? '';

        return Row(
          children: [
            CircleAvatar(
              maxRadius: 25,
              backgroundImage: NetworkImage(user.url, scale: 0.01),
              backgroundColor: Color(0xFF1B5E20),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        widget.name,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle(Colors.black, 17.0, FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height: 25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => displayUserProfile(context,
                                  userProfileId: user.id),
                              child: Text(
                                pName,
                                style: textStyle(
                                    Colors.black87, 15.0, FontWeight.w400),
                              ),
                            ),
                          ),
                          (widget.isShared == true)
                              ? FutureBuilder(
                                  future: sharedPostReference
                                      .doc(widget.sharedById)
                                      .collection('sharedPosts')
                                      .doc(widget.postId)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator(
                                        backgroundColor: Colors.grey,
                                      );
                                    }
                                    DocumentSnapshot ref = snapshot.data;
                                    var orignalPostTime =
                                        ref.data()['timestamp'];

                                    return Text(
                                        '${tAgo.format(orignalPostTime.toDate())}');
                                  })
                              : Text(
                                  '${tAgo.format(widget.timestamp.toDate())}',
                                  style: textStyle(
                                      Colors.black87, 15.0, FontWeight.w400),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> controlPostDelete(BuildContext mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "What do you want to do ?",
            style: TextStyle(color: Color(0xFF1B5E20), fontFamily: "Rubik"),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: Text(
                "Delete",
                style: TextStyle(
                  color: Color(0xFF1B5E20),
                  fontWeight: FontWeight.bold,
                  fontFamily: "Rubik",
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                removeUserPost();
              },
            ),
            SimpleDialogOption(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color(0xFF1B5E20),
                  fontWeight: FontWeight.bold,
                  fontFamily: "Rubik",
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void removeUserPost() async {
    postsReference
        .doc(widget.ownerId)
        .collection("usersPosts")
        .doc(widget.postId)
        .get()
        .then(
      (document) {
        if (document.exists) {
          document.reference.delete();
        }
      },
    );

    storageReference.child("post_${widget.postId}.jpg").delete();

    final querySnapshot = await activityFeedReference
        .doc(widget.ownerId)
        .collection("feedItems")
        .where("postId", isEqualTo: widget.postId)
        .get();

    querySnapshot.docs.forEach((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });

    final commentsQuerySnapshot =
        await commentsReference.doc(widget.postId).collection("comments").get();

    commentsQuerySnapshot.docs.forEach((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
  }

  void displayUserProfile(BuildContext context, {String userProfileId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(userProfileId: userProfileId),
      ),
    );
  }

  Future<void> removeLike() async {
    print(isNotPostOwner);

    if (isNotPostOwner) {
      if (widget.isShared == true) {
        activityFeedReference
            .doc(widget.sharedById)
            .collection("feedItems")
            .doc(widget.postId)
            .get()
            .then(
          (document) {
            if (document.exists) {
              document.reference.delete();
            }
          },
        );
      }
      activityFeedReference
          .doc(widget.ownerId)
          .collection("feedItems")
          .doc(widget.postId)
          .get()
          .then(
        (document) {
          if (document.exists) {
            document.reference.delete();
          }
        },
      );
    }
  }

  Future<void> addLike() async {
    if (isNotPostOwner) {
      if (widget.isShared == true) {
        activityFeedReference
            .doc(widget.sharedById)
            .collection("feedItems")
            .doc(widget.postId)
            .set(
          {
            "type": "like",
            "profileName": currentUser.profileName,
            "userId": currentUser.id,
            "timestamp": DateTime.now(),
            "url": widget.url,
            "postId": widget.postId,
            "userProfileImg": currentUser.url,
          },
        );
      }
      activityFeedReference
          .doc(widget.ownerId)
          .collection("feedItems")
          .doc(widget.postId)
          .set(
        {
          "type": "like",
          "profileName": currentUser.profileName,
          "userId": currentUser.id,
          "timestamp": DateTime.now(),
          "url": widget.url,
          "postId": widget.postId,
          "userProfileImg": currentUser.url,
        },
      );
    }
  }

  void controlUserLikePost() async {
    bool _liked = widget.likes[currentOnlineUserId] == true;
    if (_liked) {
      setState(() {
        likeCount = likeCount - 1;
        isLiked = false;
        widget.likes[currentOnlineUserId] = false;
      });

      // update timeline post

      await timelineReference
          .doc(currentOnlineUserId)
          .collection('timelinePosts')
          .doc(widget.postId)
          .get()
          .then(
        (document) {
          if (document.exists) {
            document.reference.update({"likes.$currentOnlineUserId": false});
          }
        },
      );

      // update original post

      if (widget.isShared == true) {
        await postsReference
            .doc(widget.sharedById)
            .collection("usersPosts")
            .doc(widget.postId)
            .update({"likes.$currentOnlineUserId": false});
      } else {
        await postsReference
            .doc(currentOnlineUserId)
            .collection("usersPosts")
            .doc(widget.postId)
            .update({"likes.$currentOnlineUserId": false});
      }

      await removeLike();
    } else if (!_liked) {
      setState(() {
        likeCount = likeCount + 1;
        isLiked = true;
        widget.likes[currentOnlineUserId] = true;
        showHeart = true;
      });

      // update timeline post
      await timelineReference
          .doc(currentOnlineUserId)
          .collection('timelinePosts')
          .doc(widget.postId)
          .get()
          .then(
        (document) {
          if (document.exists) {
            document.reference.update({"likes.$currentOnlineUserId": true});
          }
        },
      );

      // update original post

      if (widget.isShared == true) {
        await postsReference
            .doc(widget.sharedById)
            .collection("usersPosts")
            .doc(widget.postId)
            .update({"likes.$currentOnlineUserId": true});
      } else {
        await postsReference
            .doc(widget.ownerId)
            .collection("usersPosts")
            .doc(widget.postId)
            .update({"likes.$currentOnlineUserId": true});
      }

      await addLike();

      Timer(Duration(milliseconds: 800), () {
        setState(() {
          showHeart = false;
        });
      });
    }
    print(widget.likes.length);
  }

  createPostPicture() {
    return GestureDetector(
      onTap: () => displayFullPost(context),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: FadeInImage(
                fit: BoxFit.cover,
                height: 220,
                placeholder: AssetImage(
                  'assets/image_loading.png',
                ),
                image: NetworkImage(widget.url),
              ),
            ),
          ),
          showHeart
              ? ImageIcon(
                  AssetImage('apple.png'),
                  color: Colors.green,
                )
              : Text('')
        ],
      ),
    );
  }

  displayFullPost(context) {
    if (widget.isShared == true) {
      Navigator.of(context).pushNamed(RecipeDetailScreen.routeName, arguments: {
        'postId': widget.postId,
        'userId': widget.sharedById,
      });
    } else {
      Navigator.of(context).pushNamed(RecipeDetailScreen.routeName, arguments: {
        'postId': widget.postId,
        'userId': widget.ownerId,
      });
    }
  }

  createPostFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: GestureDetector(
                onTap: () => controlUserLikePost(),
                child: ImageIcon(
                  isLiked
                      ? AssetImage('assets/apple2.png')
                      : AssetImage('assets/apple_outline2.png'),
                  color: Colors.green,
                  size: 22,
                ),
              ),
            ),
            SizedBox(
              width: 4,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return LikesPage(
                          users: _globalUsers,
                          title: 'Likes',
                        );
                      },
                    ),
                  );

                  getWhoLikesThePost(widget.likes);
                },
                child: Text(
                  "${countLikes(widget.likes).toString()}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            SizedBox(width: 20.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: GestureDetector(
                onTap: () => displayComments(
                  context,
                  postId: widget.postId,
                  ownerId: widget.ownerId,
                  url: widget.url,
                ),
                child: ImageIcon(
                  AssetImage('assets/comment_outline2.png'),
                  size: 20.0,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(
              width: 4,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: StreamBuilder(
                stream: commentsReference
                    .doc(widget.postId)
                    .collection("comments")
                    .snapshots(),
                builder: (context, snapshot) {
                  int counter = 0;
                  if (snapshot.hasData) {
                    snapshot.data.documents.forEach((document) {
                      counter = counter + 1;
                    });
                  }

                  return Text(
                    "$counter",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green,
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Spacer(),
            Container(
              alignment: Alignment.bottomCenter,
              child: OutlineButton(
                borderSide: BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                onPressed: showDialogForSharingPost,
                color: Colors.white,
                child: Row(
                  children: [
                    ImageIcon(
                      AssetImage('assets/share2.png'),
                      size: 18,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Share',
                      style: TextStyle(fontFamily: "Rubik"),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        GestureDetector(
            onTap: () => displayComments(
                  context,
                  postId: widget.postId,
                  ownerId: widget.ownerId,
                  url: widget.url,
                ),
            child: Text(
              "view all comments",
              style: textStyle(Colors.black54, 15.0, FontWeight.w500),
            ))
      ],
    );
  }

  void displayComments(
    BuildContext context, {
    String postId,
    String ownerId,
    String url,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return CommentsPage(
          postId: postId,
          postOwnerId: ownerId,
          postImageUrl: url,
        );
      }),
    );
  }
}
