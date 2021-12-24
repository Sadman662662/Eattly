import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eattlystefan/models/Story.dart';
import 'package:eattlystefan/pages/ProfilePage.dart';
// import 'package:eattlystefan/pages/StoryPage.dart';
// import 'package:eattlystefan/pages/UploadStoryPage.dart';
import 'package:eattlystefan/widgets/ProgressWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/User.dart';
import '../pages/ChatScreen.dart';
import '../pages/HomePage.dart';
import '../utils/text_style.dart';

class ChatScreen extends StatefulWidget {
  final List<Users> followers;
  final List<Users> followings;

  ChatScreen({
    this.followers,
    this.followings,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final gCurrentUser = gSignIn.currentUser;

  var textController = TextEditingController();
  var uid;
  var uImage;
  var userID;

  User firebaseUser;
  var futureUserSearchResults;
  List<Users> seacrhUsers = [];
  List<String> list = [];
  List<Users> user = [];
  List<Users> chatUsers = [];
  List<Users> allUsers = [];
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List<List<Story>> stories = [];
  List<Users> usersWhoAreFollowingAndHaveStory = [];
  List<UserResult> searchUsersResult = [];
  String _searchText = "";

  var emailLogBool;

  controlSearching(String str) async {
    setState(() {
      _searchText = str;
    });
    if (str != null) {
      Future<QuerySnapshot> allUsers = usersReference
          .where("profileName", isGreaterThanOrEqualTo: str)
          .get();

      setState(() {
        futureUserSearchResults = allUsers;
      });
    }
  }

  displayUsersFoundScreen() {
    return FutureBuilder(
      future: futureUserSearchResults,
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        } else {
          seacrhUsers = [];
          List<UserResult> searchUsersResult = [];
          dataSnapshot.data.documents.forEach((document) {
            Users eachUser = Users.fromDocument(document);
            for (final user in allUsers) {
              if (user.profileName == eachUser.profileName) {
                UserResult userResult = UserResult(eachUser);
                seacrhUsers.add(eachUser);
                searchUsersResult.add(userResult);
              }
            }
          });

          return Container(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: seacrhUsers.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                // var te = getAllChatUser();
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Chat(
                          peerId: seacrhUsers[index].id,
                          peerAvatar: seacrhUsers[index].url,
                          peerName: seacrhUsers[index].profileName,
                          currentUserId: uid,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: seacrhUsers[index].url == null
                        ? Image.asset("assets/noprofile.png")
                        : CircleAvatar(
                            radius: 25.0,
                            backgroundImage: CachedNetworkImageProvider(
                                seacrhUsers[index].url),
                          ),
                    title: Text(
                      "${seacrhUsers[index].profileName}",
                      style: textStyle(Colors.black, 17.0, FontWeight.w500),
                    ),
                    // subtitle: Text(
                    //   "${seacrhUsers[index].email}",
                    //   style: textStyle(Colors.black87, 15.0, FontWeight.w400),
                    // ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.message,
                        color: greenColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  getSharedValue() async {
    // getStoriesOfAllUserWhoAreFollowingTheCurrentUSer().then((value) {
    //   usersWhoAreFollowingAndHaveStory = [];
    //   for (int i = 0; i < widget.followers.length; i++) {
    //     for (int j = 0; j < value.length; j++) {
    //       if (widget.followers[i].id == value[j][0].ownerId) {
    //         usersWhoAreFollowingAndHaveStory.add(widget.followers[i]);
    //       }
    //     }
    //   }
    //   print('storyLength:${usersWhoAreFollowingAndHaveStory.length}');
    // });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailLogBool = (prefs.getBool("emailSign") ?? false);

    print(" emaiLogBool $emailLogBool");

    emailLogBool == true
        ? FirebaseAuth.instance.authStateChanges().listen((user) {
            print("start $user");
            if (user != null) {
              print(" User Found");

              currentUser =
                  Users(url: user.photoURL, id: user.uid, email: user.email);
            } else {
              print('User is not signed in!');
            }
          })
        : uid = gCurrentUser.id;
  }

  _ChatScreenState() {
    textController.addListener(() {
      setState(() {
        if (textController.text.isEmpty) {
          _searchText = "";
          futureUserSearchResults = null;
        } else {
          _searchText = textController.text;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // retrieveStories();

    getSharedValue();
    // uid = gCurrentUser.id;

    //gCurrentUser!=null?uid=gCurrentUser.id:

/*    FirebaseAuth.instance
        .authStateChanges()
        .listen((user) {
      print("start $user");
      if (user != null) {
        print(" User Found");
        uid=user.uid;
        currentUser=Users(
            url: user.photoURL,
            id: user.uid,
            email: user.email
        );
      } else {
        print('User is not signed in!');
      }
    });*/

    print("UID $uid");

    // retrieveFollowers();
    // retrieveFollowings();
    // getUsersWhomCurrentUserIsFollowing();
    // getUsersWhoAreFollowing();

    allUsers = List.from(widget.followings)..addAll(widget.followers);
    createChatUserListWithoutDuplicateUser();
    getAllChatUser();
    getUsers();
    print('followingLength: ${widget.followings.length}');
    print('followersLength: ${widget.followers.length}');
  }

  // Future<List<List<Story>>> retrieveStories() async {
  //   final querySnapshot = await storyReference.get();
  //   querySnapshot.docs.forEach((element) async {
  //     final querySnapshotForStory =
  //         await storyReference.doc(element.id).collection('userStories').get();
  //     final storiesOfAUser = querySnapshotForStory.docs
  //         .map((document) => Story.fromDocument(document))
  //         .toList();

  //     stories.add(storiesOfAUser);
  //   });
  //   return stories;
  // }

  // Future<List<List<Story>>>
  //     getStoriesOfAllUserWhoAreFollowingTheCurrentUSer() async {
  //   List<List<Story>> storiesOfAllUserWhoAreFollowingTheCurrentUser = [];
  //   for (final userWhoIsFollowing in widget.followers) {
  //     List<Story> stories = await getStories(userWhoIsFollowing.id);
  //     if (!storiesOfAllUserWhoAreFollowingTheCurrentUser.contains(stories) &&
  //         stories.length > 0) {
  //       storiesOfAllUserWhoAreFollowingTheCurrentUser.add(stories);
  //     }
  //   }
  //   for (final storiesOfAllUserWhoAreFollowingTheCurrentUser
  //       in storiesOfAllUserWhoAreFollowingTheCurrentUser) {
  //     print(
  //         'allStories: ${storiesOfAllUserWhoAreFollowingTheCurrentUser.length}');
  //   }
  //   stories = storiesOfAllUserWhoAreFollowingTheCurrentUser;
  //   return storiesOfAllUserWhoAreFollowingTheCurrentUser;
  // }

  // Future<List<Story>> getStories(String userId) async {
  //   List<Story> selectedUserStories = [];
  //   var abc = await storyReference.doc(userId).collection("userStories").get();
  //   abc.docs.forEach((element) {
  //     var story = Story.fromDocument(element);

  //     print('aboutStory:${story.aboutStory}');
  //     var presentDate = DateTime.now();
  //     var difference = presentDate.difference(story.timestamp.toDate()).inDays;
  //     if (element.data != null) {
  //       if (!selectedUserStories.contains(story) && difference <= 1) {
  //         selectedUserStories.add(story);
  //       }
  //     }
  //   });
  //   return selectedUserStories;
  // }

  currentUserID() {
    uid = firebaseAuth.currentUser.uid;
    uImage = firebaseAuth.currentUser.photoURL;
  }

  Future<List<String>> retrieveFollowings() async {
    List<String> followings;
    final querySnapshot = await followingReference
        .doc(currentUser.id)
        .collection("userFollowing")
        .get();

    followings = querySnapshot.docs.map((document) => document.id).toList();

    return followings;
  }

  Future<List<String>> retrieveFollowers() async {
    List<String> followers;
    final querySnapshot = await followersReference
        .doc(currentUser.id)
        .collection("userFollowers")
        .get();

    followers = querySnapshot.docs.map((document) => document.id).toList();

    return followers;
  }

  getUsersWhoAreFollowing() async {
    List<Users> users = [];
    List<String> followers = await retrieveFollowers();
    for (final follower in followers) {
      final documentSnapshot = await usersReference.doc(follower).get();
      if (documentSnapshot.data != null) {
        final user = Users.fromDocument(documentSnapshot);
        if (!users.contains(user)) {
          users.add(user);
        }
      }
    }
    return users;
  }

  getUsersWhomCurrentUserIsFollowing() async {
    List<Users> users = [];
    var followings = await retrieveFollowings();
    for (final following in followings) {
      final documentSnapshot = await usersReference.doc(following).get();
      if (documentSnapshot.data != null) {
        final user = Users.fromDocument(documentSnapshot);
        if (!users.contains(user)) {
          users.add(user);
        }
      }
    }
    return users;
  }

  getAllChatUser() async {
    List<Users> followers = await getUsersWhoAreFollowing();

    chatUsers = followers;
    print('charUserLength: ${chatUsers.length}');
  }

  getUsers() async {
    var firestore = FirebaseFirestore.instance;

    await firestore
        .collection("users")
        .get()
        .then((QuerySnapshot snapshot) async {
      print("Length: " + snapshot.docChanges.length.toString());

      snapshot.docs.forEach((element) {
        setState(() {
          var a = Users.fromMap(element.data());
          user.add(a);

          print("Name: ${a.profileName}");
        });
      });
    });
  }

  createChatUserListWithoutDuplicateUser() {
    for (final follower in widget.followers) {
      allUsers.add(follower);
    }
    for (final following in widget.followings) {
      allUsers.add(following);
    }

    allUsers = allUsers.toSet().toList();
  }

  showSearchUser() {
    for (final user in allUsers) {
      UserResult userResult = UserResult(user);
      searchUsersResult.add(userResult);
    }

    return Expanded(
      child: ListView(children: searchUsersResult),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: greenColor),
        title: Text(
          "Chat",
          style: textStyle(greenColor, 20.0, FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(20.0),
                child: TextFormField(
                  onFieldSubmitted: controlSearching,
                  onChanged: controlSearching,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                    hintText: "Search By Name",
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            (_searchText.isEmpty)
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: allUsers.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        // var te = getAllChatUser();
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Chat(
                                  peerId: allUsers[index].id,
                                  peerAvatar: allUsers[index].url,
                                  peerName: allUsers[index].profileName,
                                  currentUserId: uid,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: allUsers[index].url == null
                                ? Image.asset("assets/noprofile.png")
                                : CircleAvatar(
                                    radius: 25.0,
                                    backgroundImage: CachedNetworkImageProvider(
                                        allUsers[index].url),
                                  ),
                            title: Text(
                              "${allUsers[index].profileName}",
                              style: textStyle(
                                  Colors.black, 17.0, FontWeight.w500),
                            ),
                            subtitle: Text(
                              "Start a conversation with this foodie",
                              style: textStyle(
                                Colors.black87,
                                10.0,
                                FontWeight.w400,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.message,
                                color: greenColor,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : displayUsersFoundScreen(),
          ],
        ),
      ),
    );
  }

  createMessage(String text, userId) async {
    var fireStore = FirebaseFirestore.instance;
    await fireStore.collection("messages").add({
      "userId": userId,
      "message": text,
      "time": DateTime.now(),
    }).then((_) {
      print("Success");
    });
  }
}

class UserResult extends StatelessWidget {
  final Users eachUser;

  UserResult(this.eachUser);

  displayUserProfile(BuildContext context, {String userProfileId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(userProfileId: userProfileId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () =>
                  displayUserProfile(context, userProfileId: eachUser.id),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(0xFF1B5E20),
                  backgroundImage: CachedNetworkImageProvider(eachUser.url),
                ),
                title: Text(
                  eachUser.profileName,
                  style: TextStyle(
                    color: Color(0xFF1B5E20),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Rubik",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
