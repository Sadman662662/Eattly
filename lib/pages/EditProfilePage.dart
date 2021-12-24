import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eattlystefan/models/User.dart';
import 'package:eattlystefan/pages/shopListPage.dart';
import 'package:eattlystefan/widgets/HeaderWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../TermsAndConditions.dart';
import 'HomePage.dart';

class EditProfilePage extends StatefulWidget {
  final String currentOnlineUserId;

  EditProfilePage({
    this.currentOnlineUserId,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController profileNameTextEditingController =
      TextEditingController();
  TextEditingController bioTextEditingController = TextEditingController();
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  Users user;
  bool _bioValid = true;
  bool _profileNameValid = true;

  var isLoggedIn = false;

  void initState() {
    super.initState();

    _checkIfIsLogged();
    getAndDisplayUserInformation();
  }

  Future<void> _checkIfIsLogged() async {
    final AccessToken accessToken = await FacebookAuth.instance.isLogged;

    if (accessToken != null) {
      print("Is Loged::: ${accessToken.toJson()}");
      final userData = await FacebookAuth.instance.getUserData();

      setState(() {
        isLoggedIn = true;
      });
    }
  }

  Future<void> _logOutFacebook() async {
    await FacebookAuth.instance.logOut();

    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  logoutUser() async {
    await gSignIn.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  //   logoutUser() async {
  //   //await gSignIn.signOut();

  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   await preferences.clear();
  //   await FirebaseAuth.instance.signOut();
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => HomePage()));
  // }

  // Future<void> _logOutFacebook() async {
  //   await FacebookAuth.instance.logOut();

  //   setState(() {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => HomePage()));
  //   });
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   _checkIfIsLogged();
  //   super.initState();
  // }

  getAndDisplayUserInformation() async {
    setState(() {
      loading = true;
    });

    DocumentSnapshot documentSnapshot =
        await usersReference.doc(widget.currentOnlineUserId).get();
    user = Users.fromDocument(documentSnapshot);

    print("Name: ${user.profileName}");
    print("Bio: ${user.bio}");

    profileNameTextEditingController.text = user.profileName;
    bioTextEditingController.text = user.bio;

    setState(() {
      loading = false;
    });
  }

  updateUserData() {
    setState(() {
      profileNameTextEditingController.text.trim().length < 3 ||
              profileNameTextEditingController.text.isEmpty
          ? _profileNameValid = false
          : _profileNameValid = true;

      bioTextEditingController.text.trim().length > 110
          ? _bioValid = false
          : _bioValid = true;
    });

    if (_bioValid && _profileNameValid) {
      usersReference.doc(widget.currentOnlineUserId).update({
        "profileName": profileNameTextEditingController.text,
        "bio": bioTextEditingController.text,
      });

      SnackBar successSnackBar =
          SnackBar(content: Text("Profile has been updated successfully."));
      _scaffoldGlobalKey.currentState.showSnackBar(successSnackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldGlobalKey,
      appBar: header(context, strTitle: "Edit Profile"),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                user.url == null
                    ? Image.asset(
                        "assets/noprofile.png",
                        height: 65.0,
                        width: 65.0,
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: 16.0, bottom: 7.0),
                        child: CircleAvatar(
                          radius: 52.0,
                          backgroundImage: (user == null)
                              ? AssetImage('assets/avatar_image.jpg')
                              : CachedNetworkImageProvider(user.url),
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      createProfileNameTextFormField(),
                      createBioTextFormField(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: deviceSize.width,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Shopping List',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShopListPage()),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Container(
                          height: 40,
                          width: deviceSize.width,
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Meal Planner',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: deviceSize.width,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Premium Version',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Text(
                        "By using our Services you agree with our Privacy Policy and ",
                        style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Rubik",
                            color: Color(0xFF1e1e1e)),
                        textAlign: TextAlign.center,
                      ),
                      GestureDetector(
                        child: Text(
                          'Terms and Conditions',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 18.0,
                              fontFamily: "Rubik",
                              color: Color(0xFF1e1e1e),
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TermsAndConditions()),
                          );
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 160,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Theme.of(context).primaryColor,
                          onPressed: updateUserData,
                          child: Text(
                            "     Update     ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: "Rubik"),
                          ),
                        ),
                      ),
                      Spacer(),
                      isLoggedIn
                          ? Container(
                              width: 160,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Color(0xFFFE5F5F),
                                onPressed: _logOutFacebook,
                                child: Text(
                                  "Log Out",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontFamily: "Rubik"),
                                ),
                              ),
                            )
                          : Container(
                              width: 160,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Color(0xFFFE5F5F),
                                onPressed: logoutUser,
                                child: Text(
                                  "Log Out",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontFamily: "Rubik"),
                                ),
                              ),
                            )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column createProfileNameTextFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 13.0),
          child: Text(
            "Profile Name",
            style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontFamily: "Rubik",
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 8, bottom: 8),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color(0xFFf8f8f8),
              borderRadius: BorderRadius.circular(12)),
          child: TextField(
            style: TextStyle(color: Color(0xFF2A2A2A), fontFamily: "Rubik"),
            textAlignVertical: TextAlignVertical.center,
            controller: profileNameTextEditingController,
            decoration: InputDecoration(
              errorText: _profileNameValid ? null : "Profile name is too short",
              hintStyle:
                  TextStyle(color: Color(0xFF1B5E20), fontFamily: "Rubik"),
              border: InputBorder.none,
              hintText: "Write profile name here...",
              prefix: SizedBox(
                width: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column createBioTextFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 13.0),
          child: Text(
            "Bio",
            style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontFamily: "Rubik",
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 8, bottom: 8),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color(0xFFf8f8f8),
              borderRadius: BorderRadius.circular(12)),
          child: TextField(
            style: TextStyle(color: Color(0xFF2A2A2A), fontFamily: "Rubik"),
            textAlignVertical: TextAlignVertical.center,
            controller: bioTextEditingController,
            decoration: InputDecoration(
              errorText: _bioValid ? null : "Bio is too long.",
              hintStyle:
                  TextStyle(color: Color(0xFF2a2a2a), fontFamily: "Rubik"),
              border: InputBorder.none,
              hintText: "Write your bio here...",
              prefix: SizedBox(
                width: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
