import 'dart:async';

import 'package:eattlystefan/pages/CommentsPage.dart';
import 'package:eattlystefan/pages/LikesPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import './recipe_detail_appbar_button.dart';
import '../../models/recipe.dart';
import '../../pages/HomePage.dart';
import '../core/badge_icon_button.dart';

class RecipeSliverAppBar extends StatefulWidget {
  RecipeSliverAppBar({
    Key key,
    @required this.recipe,
    @required double appBarBottomBtnPosition,
    @required this.sliverCollapsed,
  })  : _appBarBottomBtnPosition = appBarBottomBtnPosition,
        super(key: key);

  final Recipe recipe;
  final double _appBarBottomBtnPosition;
  final bool sliverCollapsed;

  @override
  _RecipeSliverAppBarState createState() => _RecipeSliverAppBarState();
}

class _RecipeSliverAppBarState extends State<RecipeSliverAppBar> {
  List<String> followersList = [];
  int totalComments = 0;
  int likeCount = 0;
  bool isLiked;
  bool showHeart = false;
  bool isNotPostOwner;
  bool isSaved = false;
  final _postId = Uuid().v4();

  getTotalNumberOfComments() async {
    var docReference = await commentsReference
        .doc(widget.recipe.postId)
        .collection('comments')
        .get();
    docReference.docs.forEach((element) {
      totalComments = totalComments + 1;
    });
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
    likeCount = counter;

    return counter;
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

  void showToast() {
    Fluttertoast.showToast(
      msg: 'You shared the post successfully',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  checkTheRecipeIsAlreadySaved() async {
    var ref = await savedRecipesReference
        .doc(currentUser.id)
        .collection('savedRecipes')
        .get();

    ref.docs.forEach((element) {
      if (element.id == widget.recipe.postId) {
        setState(() {
          isSaved = true;
        });
      }
    });
    // ref.docs.forEach((key, value) {
    //   if (key == widget.recipe.postId) {
    //     isSaved = true;
    //   } else {
    //     isSaved = false;
    //   }
    // });
  }

  savePost() async {
    await savedRecipesReference
        .doc(currentUser.id)
        .collection('savedRecipes')
        .doc(widget.recipe.postId)
        .set(
      {
        "postId": widget.recipe.postId,
        "ownerId": widget.recipe.ownerId,
        "timestamp": widget.recipe.timestamp,
        "likes": {},
        "profileName": widget.recipe.profileName,
        "description": widget.recipe.description,
        "name": widget.recipe.name,
        "prepare": '',
        "ingredients": widget.recipe.ingredients,
        "cost": widget.recipe.cost,
        "portion": widget.recipe.portions,
        "neededTime": widget.recipe.timeNeeded,
        "category": widget.recipe.category,
        "url": widget.recipe.imageUrl,
      },
    );
    setState(() {
      isSaved = true;
    });

    showToast();
  }

  showDialogForSavingPost() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Do you want to save the post",
                          maxLines: 2,
                          style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonTheme(
                      height: 40.0,
                      minWidth: 100.0,
                      child: RaisedButton(
                        child: Text(
                          "Yes",
                          style: GoogleFonts.ubuntu(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        onPressed: () async {
                          savePost();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(width: 20.0),
                    ButtonTheme(
                      height: 40.0,
                      minWidth: 100.0,
                      child: RaisedButton(
                        child: Text(
                          "No",
                          style: GoogleFonts.ubuntu(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  sharePost() async {
    // var timeRefs = await timelineReference
    //     .doc(currentUser.id)
    //     .collection('timelinePosts')
    //     .get();
    // final allPosts =
    //     timeRefs.docs.map((document) => Recipe.fromDocument(document)).toList();

    // if (!allPosts.contains(widget.recipe)) {

    await postsReference
        .doc(widget.recipe.ownerId)
        .collection('usersPosts')
        .doc(widget.recipe.postId)
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
          "ownerId": widget.recipe.ownerId,
          "timestamp": DateTime.now(),
          "likes": {},
          "profileName": widget.recipe.profileName,
          "description": widget.recipe.description,
          "name": widget.recipe.name,
          "prepare": '',
          "ingredients": widget.recipe.ingredients,
          "cost": '',
          "portion": '',
          "neededTime": '',
          "category": '',
          "url": widget.recipe.imageUrl,
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
          "ownerId": widget.recipe.ownerId,
          "timestamp": DateTime.now(),
          "likes": {},
          "profileName": widget.recipe.profileName,
          "description": widget.recipe.description,
          "name": widget.recipe.name,
          "prepare": '',
          "ingredients": widget.recipe.ingredients,
          "cost": '',
          "portion": '',
          "neededTime": '',
          "category": '',
          "url": widget.recipe.imageUrl,
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
            await postsReference
                .doc(follower)
                .collection('timelinePosts')
                .doc(_postId)
                .set(
              {
                "postId": _postId,
                "ownerId": widget.recipe.ownerId,
                "timestamp": DateTime.now(),
                "likes": {},
                "profileName": widget.recipe.profileName,
                "description": widget.recipe.description,
                "name": widget.recipe.name,
                "prepare": '',
                "ingredients": widget.recipe.ingredients,
                "cost": '',
                "portion": '',
                "neededTime": '',
                "category": '',
                "url": widget.recipe.imageUrl,
                'isShared': true,
                'sharedBy': currentUser.profileName,
                'whenShared': DateTime.now(),
                'sharedByImageUrl': currentUser.url,
                'sharedById': currentUser.id,
                'n_ingredients': nIngredients
              },
            );
          } else {
            await postsReference
                .doc(follower)
                .collection('timelinePosts')
                .doc(_postId)
                .set(
              {
                "postId": _postId,
                "ownerId": widget.recipe.ownerId,
                "timestamp": DateTime.now(),
                "likes": {},
                "profileName": widget.recipe.profileName,
                "description": widget.recipe.description,
                "name": widget.recipe.name,
                "prepare": '',
                "ingredients": widget.recipe.ingredients,
                "cost": '',
                "portion": '',
                "neededTime": '',
                "category": '',
                "url": widget.recipe.imageUrl,
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
    // }

    // timeRefs.docs.forEach((element) async {
    //   if (widget.recipe.postId == element.id) {
    //     await timelineReference
    //         .doc(currentUser.id)
    //         .collection('timelinePosts')
    //         .doc(widget.recipe.postId)
    //         .delete()
    //         .then((value) async {
    //       await timelineReference
    //           .doc(currentUser.id)
    //           .collection('timelinePosts')
    //           .doc(widget.recipe.postId)
    //           .set({
    //         "postId": widget.recipe.postId,
    //         "ownerId": widget.recipe.ownerId,
    //         "timestamp": DateTime.now(),
    //         "likes": {},
    //         "profileName": widget.recipe.profileName,
    //         "description": widget.recipe.description,
    //         "name": widget.recipe.name,
    //         "prepare": '',
    //         "ingredients": widget.recipe.ingredients,
    //         "cost": '',
    //         "portion": '',
    //         "neededTime": '',
    //         "category": '',
    //         "url": widget.recipe.imageUrl,
    //       });
    //     });

    //     await timelineReference
    //         .doc(currentUser.id)
    //         .collection('timelinePosts')
    //         .doc(widget.recipe.postId)
    //         .set({
    //       "postId": widget.recipe.postId,
    //       "ownerId": widget.recipe.ownerId,
    //       "timestamp": DateTime.now(),
    //       "likes": {},
    //       "profileName": widget.recipe.profileName,
    //       "description": widget.recipe.description,
    //       "name": widget.recipe.name,
    //       "prepare": '',
    //       "ingredients": widget.recipe.ingredients,
    //       "cost": '',
    //       "portion": '',
    //       "neededTime": '',
    //       "category": '',
    //       "url": widget.recipe.imageUrl,
    //     });
    //   }
    // });

    sharedPostReference
        .doc(currentUser.id)
        .collection('sharedPosts')
        .doc(_postId)
        .set({
      "postId": _postId,
      "ownerId": widget.recipe.ownerId,
      "timestamp": widget.recipe.timestamp,
      "likes": {},
      "profileName": widget.recipe.profileName,
      "description": widget.recipe.description,
      "name": widget.recipe.name,
      "prepare": '',
      "ingredients": widget.recipe.ingredients,
      "cost": '',
      "portion": '',
      "neededTime": '',
      "category": '',
      "url": widget.recipe.imageUrl,
    });

    // for (final follower in followersList) {
    //   if (follower != currentUser.id) {
    //     await timelineReference
    //         .doc(follower)
    //         .collection('timelinePosts')
    //         .doc(_postId)
    //         .set(
    //       {
    //         "postId": _postId,
    //         "ownerId": widget.recipe.ownerId,
    //         "timestamp": DateTime.now(),
    //         "likes": widget.recipe.likes,
    //         "profileName": widget.recipe.profileName,
    //         "description": widget.recipe.description,
    //         "name": widget.recipe.name,
    //         "prepare": '',
    //         "ingredients": widget.recipe.ingredients,
    //         "cost": '',
    //         "portion": '',
    //         "neededTime": '',
    //         "category": '',
    //         "url": widget.recipe.imageUrl,
    //         'isShared': true,
    //         'sharedBy': currentUser.profileName,
    //         'whenShared': tAgo.format(DateTime.now())
    //       },
    //     );
    //   }
    // }

    showToast();
  }

  showDialogForSharingPost() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Do you want to share the post",
                          maxLines: 2,
                          style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonTheme(
                      height: 40.0,
                      minWidth: 100.0,
                      child: RaisedButton(
                        child: Text(
                          "Yes",
                          style: GoogleFonts.ubuntu(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        onPressed: () async {
                          sharePost();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(width: 20.0),
                    ButtonTheme(
                      height: 40.0,
                      minWidth: 100.0,
                      child: RaisedButton(
                        child: Text(
                          "No",
                          style: GoogleFonts.ubuntu(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> addLike() async {
    if (isNotPostOwner) {
      if (widget.recipe.isShared == true) {
        activityFeedReference
            .doc(widget.recipe.sharedById)
            .collection("feedItems")
            .doc(widget.recipe.postId)
            .set(
          {
            "type": "like",
            "profileName": currentUser.profileName,
            "userId": currentUser.id,
            "timestamp": DateTime.now(),
            "url": widget.recipe.imageUrl,
            "postId": widget.recipe.postId,
            "userProfileImg": currentUser.url,
          },
        );
      }
      activityFeedReference
          .doc(widget.recipe.ownerId)
          .collection("feedItems")
          .doc(widget.recipe.postId)
          .set(
        {
          "type": "like",
          "profileName": currentUser.profileName,
          "userId": currentUser.id,
          "timestamp": DateTime.now(),
          "url": widget.recipe.imageUrl,
          "postId": widget.recipe.postId,
          "userProfileImg": currentUser.url,
        },
      );
    }
    // if (isNotPostOwner) {
    //   if (widget.recipe.isShared == true) {
    //     activityFeedReference
    //         .doc(widget.recipe.sharedById)
    //         .collection("feedItems")
    //         .doc(widget.recipe.postId)
    //         .set(
    //       {
    //         "type": "like",
    //         "profileName": currentUser.profileName,
    //         "userId": currentUser.id,
    //         "timestamp": DateTime.now(),
    //         "url": widget.recipe.imageUrl,
    //         "postId": widget.recipe.postId,
    //         "userProfileImg": currentUser.url,
    //       },
    //     );
    //   }
    //   activityFeedReference
    //       .doc(widget.recipe.ownerId)
    //       .collection("feedItems")
    //       .doc(widget.recipe.postId)
    //       .set(
    //     {
    //       "type": "like",
    //       "profileName": currentUser.profileName,
    //       "userId": currentUser.id,
    //       "timestamp": DateTime.now(),
    //       "url": widget.recipe.imageUrl,
    //       "postId": widget.recipe.postId,
    //       "userProfileImg": currentUser.url,
    //     },
    //   );
    // }
  }

  Future<void> removeLike() async {
    print(isNotPostOwner);

    if (isNotPostOwner) {
      if (widget.recipe.isShared == true) {
        activityFeedReference
            .doc(widget.recipe.sharedById)
            .collection("feedItems")
            .doc(widget.recipe.postId)
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
          .doc(widget.recipe.ownerId)
          .collection("feedItems")
          .doc(widget.recipe.postId)
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

  void controlUserLikePost() async {
    bool _liked = widget.recipe.likes[currentOnlineUserId] == true;
    if (_liked) {
      setState(() {
        likeCount = likeCount - 1;
        isLiked = false;
        widget.recipe.likes[currentOnlineUserId] = false;
      });

      // update timeline post

      await timelineReference
          .doc(currentOnlineUserId)
          .collection('timelinePosts')
          .doc(widget.recipe.postId)
          .get()
          .then(
        (document) {
          if (document.exists) {
            document.reference.update({"likes.$currentOnlineUserId": false});
          }
        },
      );

      // update original post

      if (widget.recipe.isShared == true) {
        await postsReference
            .doc(widget.recipe.sharedById)
            .collection("usersPosts")
            .doc(widget.recipe.postId)
            .update({"likes.$currentOnlineUserId": false});
      } else {
        await postsReference
            .doc(currentOnlineUserId)
            .collection("usersPosts")
            .doc(widget.recipe.postId)
            .update({"likes.$currentOnlineUserId": false});
      }

      await removeLike();
    } else if (!_liked) {
      setState(() {
        likeCount = likeCount + 1;
        isLiked = true;
        widget.recipe.likes[currentOnlineUserId] = true;
        showHeart = true;
      });

      // update timeline post
      await timelineReference
          .doc(currentOnlineUserId)
          .collection('timelinePosts')
          .doc(widget.recipe.postId)
          .get()
          .then(
        (document) {
          if (document.exists) {
            document.reference.update({"likes.$currentOnlineUserId": true});
          }
        },
      );

      // update original post

      if (widget.recipe.isShared == true) {
        await postsReference
            .doc(widget.recipe.sharedById)
            .collection("usersPosts")
            .doc(widget.recipe.postId)
            .update({"likes.$currentOnlineUserId": true});
      } else {
        await postsReference
            .doc(widget.recipe.ownerId)
            .collection("usersPosts")
            .doc(widget.recipe.postId)
            .update({"likes.$currentOnlineUserId": true});
      }

      await addLike();

      Timer(Duration(milliseconds: 800), () {
        setState(() {
          showHeart = false;
        });
      });
    }
    print(widget.recipe.likes.length);
    // bool _liked = widget.recipe.likes[currentOnlineUserId] == true;
    // if (_liked) {
    //   setState(() {
    //     likeCount = likeCount - 1;
    //     isLiked = false;
    //     widget.recipe.likes[currentOnlineUserId] = false;
    //   });

    //   // update timeline post

    //   if(widget.recipe.isShared == true){
    //           await timelineReference
    //       .doc(widget.recipe.sharedById)
    //       .collection('timelinePosts')
    //       .doc(widget.recipe.postId)
    //       .get()
    //       .then(
    //     (document) {
    //       if (document.exists) {
    //         document.reference.update({"likes.${widget.recipe.sharedById}": false});
    //       }
    //     },
    //   );
    //   }
    //   await timelineReference
    //       .doc(currentOnlineUserId)
    //       .collection('timelinePosts')
    //       .doc(widget.recipe.postId)
    //       .get()
    //       .then(
    //     (document) {
    //       if (document.exists) {
    //         document.reference.update({"likes.$currentOnlineUserId": false});
    //       }
    //     },
    //   );

    //   // update original post

    //   if(widget.recipe.isShared == true){
    //           await postsReference
    //       .doc(widget.recipe.sharedById)
    //       .collection("usersPosts")
    //       .doc(widget.recipe.postId)
    //       .update({"likes.${widget.recipe.sharedById}": false});

    //   await removeLike();
    //   }
    //   await postsReference
    //       .doc(widget.recipe.ownerId)
    //       .collection("usersPosts")
    //       .doc(widget.recipe.postId)
    //       .update({"likes.$currentOnlineUserId": false});

    //   await removeLike();
    // } else if (!_liked) {
    //   setState(() {
    //     likeCount = likeCount + 1;
    //     isLiked = true;
    //     widget.recipe.likes[currentOnlineUserId] = true;
    //     showHeart = true;
    //   });

    //   // update timeline post

    //   if(widget.recipe.isShared == true){
    //           await timelineReference
    //       .doc(widget.recipe.sharedById)
    //       .collection('timelinePosts')
    //       .doc(widget.recipe.postId)
    //       .get()
    //       .then(
    //     (document) {
    //       if (document.exists) {
    //         document.reference.update({"likes.${widget.recipe.sharedById}": true});
    //       }
    //     },
    //   );
    //   }
    //   await timelineReference
    //       .doc(currentOnlineUserId)
    //       .collection('timelinePosts')
    //       .doc(widget.recipe.postId)
    //       .get()
    //       .then(
    //     (document) {
    //       if (document.exists) {
    //         document.reference.update({"likes.$currentOnlineUserId": true});
    //       }
    //     },
    //   );

    //   // update original post

    //   if(widget.recipe.isShared == true){
    //           await postsReference
    //       .doc(widget.recipe.sharedById)
    //       .collection("usersPosts")
    //       .doc(widget.recipe.postId)
    //       .update({"likes.${widget.recipe.sharedById}": true});
    //   }
    //   await postsReference
    //       .doc(widget.recipe.ownerId)
    //       .collection("usersPosts")
    //       .doc(widget.recipe.postId)
    //       .update({"likes.$currentOnlineUserId": true});

    //   await addLike();

    //   Timer(Duration(milliseconds: 800), () {
    //     setState(() {
    //       showHeart = false;
    //     });
    //   });
    // }
    // // print(widget.likes.length);
  }

  @override
  void initState() {
    checkTheRecipeIsAlreadySaved();
    getTotalNumberOfLikes(widget.recipe.likes);
    getTotalNumberOfComments();
    retrieveFollowers();
    if (widget.recipe.isShared == true) {
      isNotPostOwner = currentOnlineUserId != widget.recipe.sharedById;
    }
    isNotPostOwner = currentOnlineUserId != widget.recipe.ownerId;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (widget.recipe.likes[currentOnlineUserId] == true);
    return SliverAppBar(
      actions: [
        if (widget.sliverCollapsed)
          BadgeIconButton(
            icon: Icons.favorite,
            badgeText: getTotalNumberOfLikes(widget.recipe.likes).toString(),
            onPressed: () {},
          ),
        if (widget.sliverCollapsed)
          BadgeIconButton(
            icon: Icons.mode_comment_outlined,
            badgeText: totalComments.toString(),
            onPressed: () {},
          ),
        if (widget.sliverCollapsed)
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.bookmark),
            onPressed: showDialogForSavingPost,
          ),
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.share),
          onPressed: showDialogForSharingPost,
        )
      ],
      expandedHeight: 300.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Image.network(
          widget.recipe.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: Transform.translate(
          offset: Offset(0, widget._appBarBottomBtnPosition),
          child: widget.sliverCollapsed
              ? Container()
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          RecipeDetailAppbarButton(

                              //           isLiked
                              // ? AssetImage('assets/apple2.png')
                              // : AssetImage('assets/apple_outline2.png'),
                              imagePath: (isLiked)
                                  ? 'assets/apple2.png'
                                  : 'assets/apple_outline2.png',
                              onPressed: controlUserLikePost,
                              labelText: likeCount.toString()
                              // getTotalNumberOfLikes(widget.recipe.likes)
                              //     .toString(),
                              ),
                          SizedBox(width: 10),
                          RecipeDetailAppbarButton(
                            imagePath: 'assets/comment_outline2.png',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return CommentsPage(
                                      postId: widget.recipe.postId,
                                      postOwnerId: widget.recipe.ownerId,
                                      postImageUrl: widget.recipe.imageUrl);
                                }),
                              );
                            },
                            labelText: totalComments.toString(),
                          ),
                        ],
                      ),
                      (isSaved == true)
                          ? CircleAvatar(
                              radius: 30,
                              backgroundColor: Theme.of(context).primaryColor,
                              // backgroundColor: Theme.of(context).primaryColor,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.bookmark,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {}),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Theme.of(context).primaryColor),
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.bookmark_border_outlined,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: showDialogForSavingPost,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
