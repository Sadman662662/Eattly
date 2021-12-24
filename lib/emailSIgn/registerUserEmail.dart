import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eattlystefan/models/Story.dart';
import 'package:eattlystefan/models/User.dart';
import 'package:eattlystefan/widgets/textFormWidget.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/HomePage.dart';
import '../utils/text_style.dart';

class RegisterWithEmailAndPass extends StatefulWidget {
  @override
  _RegisterWithEmailAndPassState createState() =>
      _RegisterWithEmailAndPassState();
}

class _RegisterWithEmailAndPassState extends State<RegisterWithEmailAndPass> {
  final _firebaseAuth = auth.FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _confirmPasswordController = TextEditingController();

  List<String> followingList = [];
  List<Users> followersUsers = [];
  List<String> followersList = [];
  List<Users> followingUsers = [];

  var followComplete = false;

  var following = false;

  final eattlyUserId = '116935211416490619618';

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isClicked;

  Users users;

  void showToast(str) {
    Fluttertoast.showToast(
      msg: str,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
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
          "Create account",
          style: textStyle(greenColor, 20.0, FontWeight.bold),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                "EATTLY",
                style: textStyle(greenColor, 50.0, FontWeight.bold),
              ),
              Text(
                "EATS EASY",
                style: textStyle(Colors.green[900], 25.0, FontWeight.w500),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextFormWidget(
                  textEditingController: _nameController,
                  hint: "write your name",
                  height: 50.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextFormWidget(
                  textEditingController: _emailController,
                  hint: "write your email",
                  height: 50.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextFormWidget(
                  textEditingController: _passwordController,
                  hint: "insert your password",
                  height: 50.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextFormWidget(
                  textEditingController: _confirmPasswordController,
                  hint: "insert your password again",
                  height: 50.0,
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
                  onPressed: () {
                    if (_nameController.text.isEmpty) {
                      showToast("Enter your name");
                      return;
                    }
                    if (_emailController.text.isEmpty) {
                      showToast("Enter your email id");
                      return;
                    }
                    if (_passwordController.text.isEmpty) {
                      showToast("Enter your password");
                      return;
                    }
                    if (_confirmPasswordController.text.isEmpty) {
                      showToast("Enter your confirm password");
                      return;
                    }
                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      showToast("Password does not match");
                      return;
                    } else {
                      registerAccount(_emailController.text,
                          _passwordController.text, _nameController.text);
                    }

                    // await uploadPic(context);
                  },
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 80.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  getStories(String currentUserId) async {
    var abc =
        await storyReference.doc(currentUserId).collection("userStories").get();
    abc.docs.forEach((element) {
      var story = Story.fromDocument(element);
      print('aboutStory:${story.aboutStory}');
    });
  }

  Future<void> saveEmailInfoToFireStore(User user, name) async {
    var documentSnapshot = await usersReference.doc(user.uid).get();
    await getUsersWhomCurrentUserIsFollowing(user.uid);
    await getStories(user.uid);

    if (!documentSnapshot.exists) {
      usersReference.doc(user.uid).set({
        "androidNotificationToken": "",
        "id": user.uid,
        "profileName": name,
        "url": user.photoURL,
        "email": user.email,
        "bio": "",
        "followedEattly": false,
        "timestamp": timestamp,
      });

      await followersReference
          .doc(user.uid)
          .collection("userFollowers")
          .doc(user.uid)
          .set({});

      documentSnapshot = await usersReference.doc(user.uid).get();
    }

    currentUser = Users.fromDocument(documentSnapshot);
    retrieveFollowings();
    retrieveFollowers();
    followComplete = await followEattly(currentUser);
  }

  Future<bool> followEattly(Users currentUser) async {
    await checkIfAlreadyFollowingEattly(currentUser);
    if (!following) {
      await controlFollowEattly(currentUser);
    }
    return true;
  }

  checkIfAlreadyFollowingEattly(Users currentUser) async {
    if (currentUser.followedEattly) {
      setState(() {
        following = true;
      });
    }

    if (!currentUser.followedEattly) {
      final documentSnapshot = await followersReference
          .doc(eattlyUserId)
          .collection("userFollowers")
          .doc(currentUser?.id)
          .get();

      usersReference.doc(currentUser?.id).update({
        "followedEattly": true,
      });

      setState(() {
        following = documentSnapshot.exists;
      });
    }
  }

  controlFollowEattly(Users currentUser) {
    setState(() {
      following = true;
    });

    usersReference.doc(currentUser?.id).update({
      "followedEattly": true,
    });

    followersReference
        .doc(eattlyUserId)
        .collection("userFollowers")
        .doc(currentUser?.id)
        .set({});

    followingReference
        .doc(currentUser?.id)
        .collection("userFollowing")
        .doc(eattlyUserId)
        .set({});

    activityFeedReference
        .doc(eattlyUserId)
        .collection("feedItems")
        .doc(currentUser?.id)
        .set(
      {
        "type": "follow",
        "ownerId": eattlyUserId,
        "profileName": currentUser.profileName,
        "timestamp": DateTime.now(),
        "userProfileImg": currentUser.url,
        "userId": currentUser?.id,
      },
    );
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

    List<Users> users = [];
    for (final follower in followersList) {
      final documentSnapshot = await usersReference.doc(follower).get();
      if (documentSnapshot.data != null) {
        final user = Users.fromDocument(documentSnapshot);
        if (!users.contains(user)) {
          users.add(user);
        }
      }
    }
    followersUsers = users;
  }

  getUsersWhomCurrentUserIsFollowing(String currentUserId) async {
    List<String> userIds = [];

    QuerySnapshot querySnapshot = await followingReference
        .doc(currentUserId)
        .collection("userFollowing")
        .get();

    querySnapshot.docs.forEach((element) {
      if (element.data != null) {
        if (!userIds.contains(element.id)) {
          userIds.add(element.id);
        }
      }
    });

    List<Users> users = [];
    for (final userId in userIds) {
      final documentSnapshot = await usersReference.doc(userId).get();
      if (documentSnapshot.data != null) {
        final user = Users.fromDocument(documentSnapshot);
        if (!users.contains(user)) {
          users.add(user);
        }
      }
    }

    usersWhoAreFollowingTheCurrentUser = users;
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

  setProgressDialog(BuildContext context, ProgressDialog pr, String message) {
    pr.style(
        message: message,
        borderRadius: 10,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(
          backgroundColor: greenColor,
        ),
        elevation: 10,
        insetAnimCurve: Curves.easeInOut);
  }

  void registerAccount(email, pass, name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ProgressDialog pasdr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    setProgressDialog(context, pasdr, "Creating Account...");

    pasdr.show();

    final result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: pass,
    );

    final user = result.user;
    if (user != null) {
      print("User $user");
      prefs.setBool("emailSign", true);

      saveEmailInfoToFireStore(user, _nameController.text).then((value) {
        print("Success");
        showToast("Account Screated Successfully");
        pasdr.hide();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      });
    } else {
      print("None");
    }
  }
}
