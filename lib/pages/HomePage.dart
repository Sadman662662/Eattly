import 'dart:convert' as JSON;
import 'dart:convert';
import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eattlystefan/emailSIgn/SignInWIthEmailPage.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './ChatUsers.dart';
import './NotificationsPage.dart';
import './ProfilePage.dart';
import './SearchPage.dart';
import './TimeLinePage.dart';
import './add_recipe_screen.dart';
import '../models/Story.dart';
import '../models/User.dart';
import '../utils/text_style.dart';
import '../widgets/core/eattly_drawer.dart';

final _auth = auth.FirebaseAuth.instance;
final gSignIn = GoogleSignIn();

final firebaseFirestoreInstance = FirebaseFirestore.instance;
final firebaseStorageRef = FirebaseStorage.instance.ref();
final replyReference = firebaseFirestoreInstance.collection('replies');
final usersReference = firebaseFirestoreInstance.collection("users");
final postsReference = firebaseFirestoreInstance.collection("posts");
final ingredientReference = firebaseFirestoreInstance.collection("ingredients");
final storyReference = firebaseFirestoreInstance.collection("stories");
final activityFeedReference = firebaseFirestoreInstance.collection("feed");
final commentsReference = firebaseFirestoreInstance.collection("comments");
final followersReference = firebaseFirestoreInstance.collection("followers");
final followingReference = firebaseFirestoreInstance.collection("following");
final timelineReference = firebaseFirestoreInstance.collection("timeline");
// final sharedPostReference = firebaseFirestoreInstance.collection('sharedPosts');

final storageReference = firebaseStorageRef.child("Posts Pictures");
final ingredientNameReference = firebaseStorageRef.child("ingredient picture");

final storageVideoReference = firebaseStorageRef.child("Posts Video");
final storageReferenceForStory = firebaseStorageRef.child("Story Picture");
final sharedPostReference = firebaseFirestoreInstance.collection('sharedPosts');
final savedRecipesReference =
    firebaseFirestoreInstance.collection('savedRecipes');

final DateTime timestamp = DateTime.now();
Users currentUser;

List<Users> usersWhoAreFollowingTheCurrentUser = [];

Future<String> signInWithGoogle() async {
  final googleSignInAccount = await gSignIn.signIn();
  final googleSignInAuthentication = await googleSignInAccount.authentication;

  final credential = auth.GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final authResult = await _auth.signInWithCredential(credential);
  final user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final currentUser = _auth.currentUser;
  assert(user.uid == currentUser.uid);

  return 'signInWithGoogle succeeded: $user';
}

Future<String> signInWithApple() async {
  try {
    final appleResult = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    if (appleResult.error != null) {
      return 'error';
    }

    final credential = auth.OAuthProvider('apple.com').credential(
      accessToken:
          String.fromCharCodes(appleResult.credential.authorizationCode),
      idToken: String.fromCharCodes(appleResult.credential.identityToken),
    );

    final authResult = await _auth.signInWithCredential(credential);
    final user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    return 'signInWithApple succeeded: $user';
  } catch (error) {
    print(error);
    return 'error';
  }
}

GoogleSignInAccount googleSignInAccount;

void signOutGoogle() async {
  await gSignIn.signOut();
}

class HomePage extends StatefulWidget {
  User emailUser;
  String tokenID;
  String flag;

  HomePage({this.emailUser, this.tokenID, this.flag});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final eattlyUserId = '116935211416490619618';
  final _firebaseMessaging = FirebaseMessaging();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final facebookLogIn = FacebookLogin();
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  var following = false;
  var isSignedIn = false;
  var followComplete = false;
  var getPageIndex = 0;
  var termsText =
      "By taping sign up, you agree with our Privacy Policy and Terms of Service";
  var checkedValue = false;
  var userId;
  var faceBookUserList = [];
  var fbToken = "";

  var isEmailLog = false;

  var emailLogBool;

  final gCurrentUser = gSignIn.currentUser;

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  PageController pageController;
  Map user;
  bool isLoggedIn = false;
  List<Users> followersUsers = [];
  List<Users> followingUsers = [];
  List<String> followingList = [];
  List<String> followersList = [];
  List<String> titles = ['Home', 'Search', 'Notifications', 'Profile'];
  List<Map<String, Object>> pages = [
    {'pages': TimeLinePage(), 'title': "Home"},
    {'pages': SearchPage(), 'title': "Search "},
    {'pages': NotificationsPage(), 'title': "Notification"},
    {'pages': ProfilePage(), 'title': "Profile"},
  ];

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

  logInWithFacebook() async {
    final result = await facebookLogIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        fbToken = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$fbToken');
        final profile = JSON.jsonDecode(graphResponse.body);
        currentUser = Users.fromJson(profile);

        setState(() {
          user = profile;
          isLoggedIn = true;
          saveFacebookUserInfoToFireStore();
        });
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() {
          isLoggedIn = false;
        });
        break;
      case FacebookLoginStatus.error:
        setState(() {
          isLoggedIn = false;
        });
    }
  }

  Future<void> _checkIfIsLogged() async {
    final AccessToken accessToken = await FacebookAuth.instance.isLogged;

    if (accessToken != null) {
      // now you can call to  FacebookAuth.instance.getUserData();
      final userData = await FacebookAuth.instance.getUserData();

      setState(() {
        isLoggedIn = true;
        user = userData;
        currentUser = Users.fromJson(user);
        retrieveFollowings();
        retrieveFollowers();

        getStories(user["id"]);
      });
    }
  }

  getSharedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailLogBool = (prefs.getBool("emailSign") ?? false);

    print(" emaiLogBool $emailLogBool");

    emailLogBool == true
        ? FirebaseAuth.instance.authStateChanges().listen((user) {
            print("start $user");
            if (user != null) {
              print(" User Found");
              isEmailLog = true;

              currentUser =
                  Users(url: user.photoURL, id: user.uid, email: user.email);
              //final profile = JSON.jsonDecode(user);
              print("true? $isEmailLog");
              retrieveFollowings();
              retrieveFollowers();

              getStories(currentUser.id);
            } else {
              print('User is not signed in!');
            }
          })
        : gSignIn
            .signInSilently(suppressErrors: false)
            .then((gSignInAccount) async {
            await controlSignIn(gSignInAccount);
          }).catchError((gError) {
            print("Error Message: " + gError.toString());
          });
  }

  void initState() {
    super.initState();

    getSharedValue();

    _checkIfIsLogged();

    pageController = PageController();
    gSignIn.onCurrentUserChanged.listen((gSignInAccount) async {
      await controlSignIn(gSignInAccount);
    }, onError: (gError) {
      print("Error Message: " + gError.toString());
    });

//    gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) async {
//      await controlSignIn(gSignInAccount);
//    }).catchError((gError) {
//      print("Error Message: " + gError.toString());
//    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> controlSignIn(GoogleSignInAccount signInAccount) async {
    if (signInAccount != null) {
      await saveUserInfoToFireStore();
      configureRealTimePushNotifications(context);

      setState(() {
        isSignedIn = true;
      });
    } else {
      setState(() {
        isSignedIn = false;
      });
    }
  }

  void configureRealTimePushNotifications(BuildContext ctx) {
    final GoogleSignInAccount gUser = gSignIn.currentUser;

    _firebaseMessaging.requestNotificationPermissions();

    if (Platform.isIOS) {
      getIOSPermissions();
    }

    _firebaseMessaging.getToken().then((token) {
      usersReference.doc(gUser.id).update({"androidNotificationToken": token});
    });

    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> msg) async {
      final recipientId = msg["data"]["recipient"] as String;

      Platform.isAndroid
          ? showNotification(msg['notification'])
          : showNotification(msg['aps']['alert']);

      if (recipientId == gUser.id) {
        Platform.isAndroid
            ? showNotificationOther(msg['notification'])
            : showNotificationOther(msg['aps']['alert']);
      }
    }, onResume: (Map<String, dynamic> message) {
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      return;
    });
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.eattly.eattlystefan'
          : 'com.eattly.eattlystefan',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  void showNotificationOther(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.eattly.eattlystefan'
          : 'com.eattly.eattlystefan',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0, "New Notification",
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  getIOSPermissions() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(alert: true, badge: true, sound: true));

    _firebaseMessaging.onIosSettingsRegistered.listen((settings) {
      print("Settings Registered :  $settings");
    });
  }

  Future<void> saveUserInfoToFireStore() async {
    final gCurrentUser = gSignIn.currentUser;
    var documentSnapshot = await usersReference.doc(gCurrentUser.id).get();
    await getUsersWhomCurrentUserIsFollowing(gCurrentUser.id);
    await getStories(gCurrentUser.id);

    if (!documentSnapshot.exists) {
      usersReference.doc(gCurrentUser.id).set({
        "id": gCurrentUser.id,
        "profileName": gCurrentUser.displayName,
        "url": gCurrentUser.photoUrl,
        "email": gCurrentUser.email,
        "bio": "",
        "followedEattly": false,
        "timestamp": timestamp,
      }).then((value) => print("Google Sign in data store success"));

      await followersReference
          .doc(gCurrentUser.id)
          .collection("userFollowers")
          .doc(gCurrentUser.id)
          .set({});

      documentSnapshot = await usersReference.doc(gCurrentUser.id).get();
    }

    currentUser = Users.fromDocument(documentSnapshot);
    retrieveFollowings();
    retrieveFollowers();
    followComplete = await followEattly(currentUser);
  }

  Future<void> saveFacebookUserInfoToFireStore() async {
    var documentSnapshot = await usersReference.doc(user["id"]).get();
    await getUsersWhomCurrentUserIsFollowing(user["id"]);
    await getStories(user["id"]);

    if (!documentSnapshot.exists) {
      usersReference.doc(user["id"]).set({
        "androidNotificationToken": fbToken,
        "id": user["id"],
        "profileName": user["name"],
        "url": user["picture"]["data"]["url"],
        "email": user["email"],
        "bio": "",
        "followedEattly": false,
        "timestamp": timestamp,
      });

      await followersReference
          .doc(user["id"])
          .collection("userFollowers")
          .doc(user["id"])
          .set({});

      documentSnapshot = await usersReference.doc(user["id"]).get();
    }

    currentUser = Users.fromDocument(documentSnapshot);
    retrieveFollowings();
    retrieveFollowers();
    followComplete = await followEattly(currentUser);
  }

  getStories(String currentUserId) async {
    var abc =
        await storyReference.doc(currentUserId).collection("userStories").get();
    abc.docs.forEach((element) {
      var story = Story.fromDocument(element);
      print('aboutStory:${story.aboutStory}');
    });
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

  @override
  bool get wantKeepAlive => true;

  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  whenPageChanges(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  onTapChangePage(pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
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

  showComparisonDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              content: Text('New features are coming soon.',
                  style: TextStyle(
                    color: Colors.black,
                  )));
        });
  }

  Future<bool> followEattly(Users currentUser) async {
    await checkIfAlreadyFollowingEattly(currentUser);
    if (!following) {
      await controlFollowEattly(currentUser);
    }
    return true;
  }

  Scaffold buildHomeScreen() {
    List<Widget> actions = [
      Container(
        height: 40,
        width: 40,
        margin: EdgeInsets.only(left: 7.0, top: 7.0, bottom: 7.0, right: 10.0),
        decoration: BoxDecoration(
            color: Colors.green[200],
            borderRadius: BorderRadius.circular(10.0)),
        child: GestureDetector(
          child: ImageIcon(
            AssetImage('assets/chat.png'),
            //size: 40.0,
            color: greenColor,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  followers: followersUsers,
                  followings: followingUsers,
                ),
              ),
            );
          },
        ),
      ),
      SizedBox(
        height: 0,
        width: 0,
      ),
      SizedBox(
        height: 0,
        width: 0,
      ),
      Container(
        height: 40,
        width: 40,
        margin: EdgeInsets.only(left: 7.0, top: 7.0, bottom: 7.0, right: 10.0),
        decoration: BoxDecoration(
          color: Colors.green[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: GestureDetector(
          child: Icon(
            Icons.history,
            color: greenColor,
          ),
          onTap: () {},
        ),
      ),
    ];

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: whiteColor,
        leading: IconButton(
          icon: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(10.0)),
            child: Icon(
              Icons.bar_chart_rounded,
              color: greenColor,
            ),
          ),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Text(
          titles[getPageIndex],
          style: textStyle(greenColor, 24.0, FontWeight.bold),
        ),
        actions: [actions[getPageIndex]],
        elevation: 0.0,
      ),
      drawer: EattlyDrawer(),
      key: _scaffoldKey,
      body: isLoggedIn
          ? PageView(
              children: <Widget>[
                TimeLinePage(
                  gCurrentUser: currentUser,
                  whoAreFollowing: usersWhoAreFollowingTheCurrentUser,
                ),
                SearchPage(),
                NotificationsPage(),
                ProfilePage(userProfileId: user["id"]),
              ],
              controller: pageController,
              onPageChanged: whenPageChanges,
              physics: NeverScrollableScrollPhysics(),
            )
          : emailLogBool == true
              ? PageView(
                  children: <Widget>[
                    TimeLinePage(
                      gCurrentUser: currentUser,
                      whoAreFollowing: usersWhoAreFollowingTheCurrentUser,
                    ),
                    SearchPage(),
                    NotificationsPage(),
                    ProfilePage(userProfileId: currentUser?.id),
                  ],
                  controller: pageController,
                  onPageChanged: whenPageChanges,
                  physics: NeverScrollableScrollPhysics(),
                )
              : PageView(
                  children: <Widget>[
                    TimeLinePage(
                      gCurrentUser: currentUser,
                      whoAreFollowing: usersWhoAreFollowingTheCurrentUser,
                    ),
                    SearchPage(),
                    NotificationsPage(),
                    ProfilePage(userProfileId: currentUser?.id),
                  ],
                  controller: pageController,
                  onPageChanged: whenPageChanges,
                  physics: NeverScrollableScrollPhysics(),
                ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed(
            AddRecipeScreen.routeName,
            arguments: currentUser,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFFFFFEFE),
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        notchMargin: 5,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: '',
            ),
          ],
          currentIndex: getPageIndex,
          onTap: onTapChangePage,
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Scaffold buildSignInScreen() {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 40.0,
              ),
              Text(
                "EATTLY",
                style: textStyle(Colors.green[900], 60.0, FontWeight.bold),
              ),
              Text(
                "EAT'S EASY",
                style: textStyle(Colors.green[900], 25.0, FontWeight.bold),
              ),
              SizedBox(
                height: 40.0,
              ),
              SignInButtonBuilder(
                text: 'Sign with email',
                textColor: Colors.white,
                icon: Icons.email,
                backgroundColor: greenColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignInWithEmailAndPass()),
                  );
                },
              ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                height: 20.0,
                child: Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1.0,
                          margin: EdgeInsets.only(left: 20.0, right: 6.0),
                          color: Colors.grey,
                        ),
                      ),
                      Text("Or, connecting using"),
                      Expanded(
                        child: Container(
                          height: 1.0,
                          color: Colors.grey,
                          margin: EdgeInsets.only(left: 6.0, right: 20.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              SignInButtonBuilder(
                text: 'Continue with Google',
                textColor: Colors.black,
                elevation: 3.0,
                image: Image.asset(
                  "assets/google.png",
                  height: 20,
                  width: 20,
                ),
                onPressed: () {
                  signInWithGoogle();
                },
                backgroundColor: Colors.white,
              ),
              SizedBox(height: 15.0),
              SignInButtonBuilder(
                text: 'Continue with Facebook',
                textColor: whiteColor,
                elevation: 3.0,
                image: Image.asset(
                  "assets/facebook.png",
                  height: 20,
                  width: 20,
                ),
                onPressed: () {
                  logInWithFacebook();
                },
                backgroundColor: Colors.lightBlue[900],
              ),
              SizedBox(
                height: 15.0,
              ),
              SignInButtonBuilder(
                text: 'Continue with Apple ID',
                textColor: Colors.white,
                image: Image.asset(
                  "assets/apple_logo.png",
                  height: 20,
                  width: 20,
                ),
                onPressed: () {
                  signInWithApple();
                },
                backgroundColor: Colors.black,
              ),
              SizedBox(
                height: 35.0,
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    termsText,
                    style: GoogleFonts.roboto(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              CheckboxListTile(
                title: Text(
                  "I Agree with terms & condition",
                  style: textStyle(Colors.black54, 17.0, FontWeight.w500),
                ),
                value: checkedValue,
                activeColor: Colors.blue,
                checkColor: Colors.black,
                onChanged: (newValue) {
                  setState(() {
                    checkedValue = newValue;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    if (widget.flag == 'drawer') {
      return buildHomeScreen();
    }

    if (isSignedIn && followComplete || isLoggedIn || emailLogBool == true) {
      return buildHomeScreen();
    } else {
      return buildSignInScreen();
    }
  }
}

//isEmailLog==true
