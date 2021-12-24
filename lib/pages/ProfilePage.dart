import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eattlystefan/pages/LikesPage.dart';
import 'package:eattlystefan/pages/recipe_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import './EditProfilePage.dart';
import './HomePage.dart';
import '../models/User.dart';
import '../utils/text_style.dart';
import '../widgets/PostWidget.dart';
import '../widgets/ProgressWidget.dart';

class ProfilePage extends StatefulWidget {
  final String userProfileId;

  ProfilePage({this.userProfileId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _currentOnlineUserId = currentUser?.id;
  var _loading = false;
  var _countPost = 0;
  var _countTotalFollowers = 0;
  var _countTotalFollowings = 0;
  var _following = false;
  var _postOrientation = "grid";
  List<Post> _postsList = [];
  Users currenUser;
  List<String> followersList = [];
  var _globalUsersFollowers = [];
  List<Users> followingUsers = [];
  List<String> followingList = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();

    print("User Profile ID: ${widget.userProfileId}");
    retrieveFollowings();
    getAllProfilePosts();
    getAllFollowers();
    getAllFollowings();
    checkIfAlreadyFollowing();
  }

  retrieveFollowings() async {
    final querySnapshot = await followingReference
        .doc(currentUser.id)
        .collection("userFollowing")
        .get();

    setState(() {
      followingList =
          querySnapshot.docs.map((document) => document.id).toList();
    });

    List<Users> users = [];
    for (final following in followingList) {
      final documentSnapshot = await usersReference.doc(following).get();
      if (documentSnapshot.data != null) {
        final user = Users.fromDocument(documentSnapshot);
        if (!users.contains(user)) {
          users.add(user);
        }
      }
    }
    followingUsers = users;
  }

  getAllFollowings() async {
    final querySnapshot = await followingReference
        .doc(widget.userProfileId)
        .collection("userFollowing")
        .get();

    setState(() {
      _countTotalFollowings = querySnapshot.docs.length;
    });
  }

  void checkIfAlreadyFollowing() async {
    final documentSnapshot = await followersReference
        .doc(widget.userProfileId)
        .collection("userFollowers")
        .doc(_currentOnlineUserId)
        .get();

    setState(() {
      _following = documentSnapshot.exists;
    });
  }

  void getAllFollowers() async {
    await followersReference
        .doc(widget.userProfileId)
        .collection("userFollowers")
        .get()
        .then((value) async {
      followersList = value.docs.map((document) => document.id).toList();
      if (followersList.length <= 0) {
        List<Users> users = [];
        return users;
      }

      // likes.keys.forEach((key) {
      //   if (likes[key] == true) {
      //     if (!followers.contains(key)) {
      //       followers.add(key);
      //     }
      //   }
      // });

      // print('name: ${widget.name}');
      _globalUsersFollowers = await findUsersById(followersList);
      setState(() {
        _countTotalFollowers = value.docs.length;
      });
    });

    // setState(() {
    //   _countTotalFollowers = val.docs.length;
    // });
  }

  Future<void> getAllFollowerUser(followers) async {
    // List<String> followers = [];

    if (followers.length <= 0) {
      List<Users> users = [];
      return users;
    }

    // likes.keys.forEach((key) {
    //   if (likes[key] == true) {
    //     if (!followers.contains(key)) {
    //       followers.add(key);
    //     }
    //   }
    // });

    // print('name: ${widget.name}');
    _globalUsersFollowers = await findUsersById(followers);
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

  createProfileTopView() {
    return FutureBuilder(
      future: usersReference.doc(widget.userProfileId).get(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        final user = Users.fromDocument(dataSnapshot.data);
        currenUser = user;
        return Padding(
          padding: EdgeInsets.all(17.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  user.url == null
                      ? Image.asset(
                          "assets/noprofile.png",
                          height: 85.0,
                          width: 85.0,
                        )
                      : CircleAvatar(
                          radius: 45.0,
                          backgroundColor: Color(0xFF1B5E20),
                          backgroundImage: CachedNetworkImageProvider(user.url),
                        ),
                  Expanded(
                    child: Container(
                      height: 130,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.profileName,
                            style: textStyle(
                              Colors.black,
                              25.0,
                              FontWeight.w400,
                            ),
                          ),
                          user.bio.isEmpty
                              ? Text(
                                  "Cook is my passion",
                                  style: textStyle(
                                    Colors.grey[700],
                                    15.0,
                                    FontWeight.w300,
                                  ),
                                )
                              : Text(
                                  user.bio,
                                  style: textStyle(
                                    Colors.black,
                                    15.0,
                                    FontWeight.w400,
                                  ),
                                ),
                          createButton()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 90.0,
                width: MediaQuery.of(context).size.height,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 70,
                        child: createColumns("posts", _countPost),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LikesPage(
                                        users: _globalUsersFollowers,
                                        title: 'Followers',
                                      )));
                        },
                        child: Container(
                          height: 70,
                          child:
                              createColumns("followers", _countTotalFollowers),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LikesPage(
                                        users: followingUsers,
                                        title: 'Followings',
                                      )));
                        },
                        child: Container(
                          height: 70,
                          child:
                              createColumns("following", _countTotalFollowings),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget createColumns(String title, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20.0,
            color: Color(0xFF1B5E20),
            fontWeight: FontWeight.bold,
            fontFamily: "Rubik",
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              color: Color(0xFF1B5E20),
              fontWeight: FontWeight.w400,
              fontFamily: "Rubik",
            ),
          ),
        ),
      ],
    );
  }

  createButton() {
    bool ownProfile = _currentOnlineUserId == widget.userProfileId;
    if (ownProfile) {
      return createButtonTitleAndFunction(
        title: "Edit Profile",
        performFunction: editUserProfile,
      );
    } else if (_following) {
      return createButtonTitleAndFunction(
        title: "Unfollow",
        performFunction: controlUnfollowUser,
      );
    } else if (!_following) {
      return createButtonTitleAndFunction(
        title: "Follow",
        performFunction: controlFollowUser,
      );
    }
  }

  controlUnfollowUser() {
    setState(() {
      _following = false;
    });

    followersReference
        .doc(widget.userProfileId)
        .collection("userFollowers")
        .doc(_currentOnlineUserId)
        .get()
        .then(
      (document) {
        if (document.exists) {
          document.reference.delete();
        }
      },
    );

    followingReference
        .doc(_currentOnlineUserId)
        .collection("userFollowing")
        .doc(widget.userProfileId)
        .get()
        .then(
      (document) {
        if (document.exists) {
          document.reference.delete();
        }
      },
    );

    activityFeedReference
        .doc(widget.userProfileId)
        .collection("feedItems")
        .doc(_currentOnlineUserId)
        .get()
        .then(
      (document) {
        if (document.exists) {
          document.reference.delete();
        }
      },
    );
  }

  controlFollowUser() {
    setState(() {
      _following = true;
    });

    followersReference
        .doc(widget.userProfileId)
        .collection("userFollowers")
        .doc(_currentOnlineUserId)
        .set({});

    followingReference
        .doc(_currentOnlineUserId)
        .collection("userFollowing")
        .doc(widget.userProfileId)
        .set({});

    activityFeedReference
        .doc(widget.userProfileId)
        .collection("feedItems")
        .doc(_currentOnlineUserId)
        .set(
      {
        "type": "follow",
        "ownerId": widget.userProfileId,
        "profileName": currentUser.profileName,
        "timestamp": DateTime.now(),
        "userProfileImg": currentUser.url,
        "userId": _currentOnlineUserId,
      },
    );
  }

  showDialogForDeletingPost(Post eachPost) {
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
                              await deletePost(eachPost);
                              Navigator.of(context).pop();
                              getAllProfilePosts();
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
      msg: 'Post has been deleted successfully',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
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

  deletePost(Post eachPost) async {
    //delete post from timeline

    await timelineReference
        .doc(currentUser.id)
        .collection('timelinePosts')
        .doc(eachPost.postId)
        .delete();

    // delete original post

    await postsReference
        .doc(currentUser.id)
        .collection('usersPosts')
        .doc(eachPost.postId)
        .delete();

    showToast();
    setState(() {});
  }

  displayFullPost(Post eachPost) {
    Navigator.of(context).pushNamed(RecipeDetailScreen.routeName, arguments: {
      'userId': eachPost.ownerId,
      'postId': eachPost.postId,
    });
  }

  Widget createButtonTitleAndFunction({
    String title,
    Function performFunction,
  }) {
    chooseColor(String title) {
      if (_following == true && title == 'Edit Profile') {
        return Color(0xFF1B5E20);
      }
      if (_following == true) {
        return Colors.white;
      }
      if (_following == false) {
        return Colors.white;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 35,
        child: RaisedButton(
          color: chooseColor(title),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(color: Color(0xFF1B5E20), width: 2)),
          onPressed: performFunction,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Rubik",
                      color: (title == 'Edit Profile')
                          ? Colors.white
                          : Color(0xFF1B5E20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }

  editUserProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditProfilePage(currentOnlineUserId: _currentOnlineUserId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        children: <Widget>[
          createProfileTopView(),
          Divider(),
          createListAndGridPostOrientation(),
          Divider(
            height: 0.0,
          ),
          displayProfilePost(),
        ],
      ),
    );
  }

  final double itemHeight = 1;
  final double itemWidth = 1;

  displayProfilePost() {
    if (_loading) {
      return circularProgress();
    } else if (_postsList.isEmpty) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Icon(
                Icons.library_books,
                color: Color(0xFF1B5E20),
                size: 200.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "No Posts",
                style: TextStyle(
                  color: Color(0xFF1B5E20),
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Rubik",
                ),
              ),
            ),
          ],
        ),
      );
    } else if (_postOrientation == "grid") {
      List<Widget> gridTilesList = [];
      _postsList.forEach((eachPost) {
        gridTilesList.add(Stack(
          children: [
            Container(
              height: 230,
              child: Column(
                children: [
                  Row(
                    children: [
                      // CircleAvatar(
                      //   maxRadius: 25,
                      //   backgroundImage:
                      //       NetworkImage(currentUser.url, scale: 0.01),
                      //   backgroundColor: Color(0xFF1B5E20),
                      // ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Container(
                              //   child: Text(
                              //     eachPost.name,
                              //     overflow: TextOverflow.ellipsis,
                              //     style: textStyle(
                              //         Colors.black, 17.0, FontWeight.w500),
                              //     textAlign: TextAlign.center,
                              //   ),
                              // ),
                              Container(
                                height: 25,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                          // child: Text(eachPost.profileName,
                                          //     style: textStyle(Colors.black87,
                                          //         15.0, FontWeight.w400),
                                          //     overflow: TextOverflow.ellipsis),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () => displayFullPost(eachPost),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                        ),
                        child: FadeInImage(
                            placeholder: AssetImage('assets/image_loading.png'),
                            image: NetworkImage(eachPost.url),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  // GridTile(
                  //   header: Row(
                  //     children: [
                  //       Spacer(),
                  //       Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: GestureDetector(
                  //           onTap: () {
                  //             showDialogForDeletingPost(eachPost);
                  //           },
                  //          child: Container(
                  //             height: 32,
                  //             width: 32,

                  //             decoration: BoxDecoration(
                  //                 color: Colors.white,
                  //                 shape: BoxShape.rectangle,
                  //                 borderRadius: BorderRadius.circular(10)),
                  //             // color: Colors.white,
                  //             child: Padding(
                  //               padding: const EdgeInsets.only(
                  //                   right: 0.0, bottom: 4, top: 0),
                  //               child: Icon(
                  //                 Icons.delete,
                  //                 color: Theme.of(context).primaryColor,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  //   child:

                  //       //  PostTile(eachPost)

                  //       GestureDetector(
                  //     onTap: () => displayFullPost(eachPost),
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         border: Border.all(color: Colors.white),
                  //       ),
                  //       child: FadeInImage(
                  //           placeholder: AssetImage('assets/image_loading.png'),
                  //           image: NetworkImage(eachPost.url),
                  //           fit: BoxFit.fill),
                  //     ),
                  //   ),

                  //   // Positioned(
                  //   //   child: IconButton(
                  //   //     icon: Icon(
                  //   //       Icons.delete,
                  //   //       color: Theme.of(context).primaryColor,
                  //   //     ),
                  //   //     onPressed: () {
                  //   //       showDialogForDeletingPost(eachPost);
                  //   //     },
                  //   //   ),
                  //   //   top: 0,
                  //   //   right: 0,
                  //   // )
                  // ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: GestureDetector(
                          child: ImageIcon(
                            AssetImage('assets/apple_outline2.png'),
                            color: Theme.of(context).primaryColor,
                            size: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            getTotalNumberOfLikes(eachPost.likes).toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
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
                          child: ImageIcon(
                            AssetImage('assets/comment_outline2.png'),
                            size: 16.0,
                            color: Theme.of(context).primaryColor,
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
                              .doc(eachPost.postId)
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
                                color: Theme.of(context).primaryColor,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                              ),
                            );
                          },
                        ),
                      ),
                      // SizedBox(
                      //   width: 8,
                      // ),
                      Spacer(),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  showDialogForDeletingPost(eachPost);
                },
                child: Container(
                  height: 32,
                  width: 32,

                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10)),
                  // color: Colors.white,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 0.0, bottom: 4, top: 0),
                    // child: Icon(
                    //   Icons.delete,
                    //   color: Theme.of(context).primaryColor,
                    // ),
                  ),
                ),
              ),
            )
          ],
        ));
      });
      return GridView.count(
        padding: EdgeInsets.all(16),
        crossAxisCount: 2,
        childAspectRatio: 0.70,
        //mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTilesList,
      );
    } else if (_postOrientation == "list") {
      return Column(
        children: _postsList,
      );
    }
  }

  getAllProfilePosts() async {
    setState(() {
      _loading = true;
    });

    QuerySnapshot querySnapshot = await postsReference
        .doc(widget.userProfileId)
        .collection("usersPosts")
        .orderBy("timestamp", descending: true)
        .get();

    setState(() {
      _loading = false;
      _countPost = querySnapshot.docs.length;
      _postsList = querySnapshot.docs
          .map((documentSnapshot) => Post.fromDocument(documentSnapshot))
          .toList();
    });
  }

  createListAndGridPostOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () => setOrientation("grid"),
          icon: Icon(Icons.grid_on),
          color: _postOrientation == "grid"
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColor,
        ),
        IconButton(
          onPressed: () => setOrientation("list"),
          icon: Icon(Icons.list),
          color: _postOrientation == "list"
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  setOrientation(String orientation) {
    setState(() {
      _postOrientation = orientation;
    });
  }
}
