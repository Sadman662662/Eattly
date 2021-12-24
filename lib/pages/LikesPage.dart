import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eattlystefan/models/User.dart';
import 'package:eattlystefan/pages/EditProfilePage.dart';
import 'package:eattlystefan/pages/HomePage.dart';
import 'package:eattlystefan/pages/ProfilePage.dart';
import 'package:eattlystefan/widgets/HeaderWidget.dart';
import 'package:eattlystefan/widgets/PostWidget.dart';
import 'package:flutter/material.dart';

class LikesPage extends StatefulWidget {
  final List<Users> users;
  final String title;

  LikesPage({this.users, this.title});

  @override
  _LikesPageState createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, strTitle: widget.title),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
              itemCount: widget.users.length,
              itemBuilder: (BuildContext contex, int index) {
                return WhoLikesPageListItem(
                  user: widget.users[index],
                  title: widget.title,
                );
              }),
        ));
  }
}

class WhoLikesPageListItem extends StatefulWidget {
  final Users user;
  final String title;

  const WhoLikesPageListItem({Key key, @required this.user, this.title})
      : super(key: key);

  @override
  _WhoLikesPageListItemState createState() => _WhoLikesPageListItemState();
}

final String currentOnlineUserId = currentUser?.id;

class _WhoLikesPageListItemState extends State<WhoLikesPageListItem> {
  final String currentOnlineUserId = currentUser?.id;
  bool loading = false;
  int countPost = 0;
  List<Post> postsList = [];
  String postOrientation = "grid";
  int countTotalFollowers = 0;
  int countTotalFollowings = 0;
  bool following = false;
  @override
  void initState() {
    // checkIfAlreadyFollowing(widget.user.id);
    getAllFollowers();
    getAllFollowings();
    checkIfAlreadyFollowing();

    super.initState();
  }

  controlUnfollowUser() {
    setState(() {
      following = false;
    });

    followersReference
        .doc(widget.user.id)
        .collection("userFollowers")
        .doc(currentOnlineUserId)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });

    followingReference
        .doc(currentOnlineUserId)
        .collection("userFollowing")
        .doc(widget.user.id)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });

    activityFeedReference
        .doc(widget.user.id)
        .collection("feedItems")
        .doc(currentOnlineUserId)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
  }

  controlFollowUser() {
    setState(() {
      following = true;
    });

    followersReference
        .doc(widget.user.id)
        .collection("userFollowers")
        .doc(currentOnlineUserId)
        .set({});

    followingReference
        .doc(currentOnlineUserId)
        .collection("userFollowing")
        .doc(widget.user.id)
        .set({});

    activityFeedReference
        .doc(widget.user.id)
        .collection("feedItems")
        .doc(currentOnlineUserId)
        .set({
      "type": "follow",
      "ownerId": widget.user.id,
      "profileName": currentUser.profileName,
      "timestamp": DateTime.now(),
      "userProfileImg": currentUser.url,
      "userId": currentOnlineUserId,
    });
  }

  editUserProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditProfilePage(currentOnlineUserId: currentOnlineUserId)));
  }

  getAllFollowings() async {
    QuerySnapshot querySnapshot = await followingReference
        .doc(widget.user.id)
        .collection("userFollowing")
        .get();

    setState(() {
      countTotalFollowings = querySnapshot.docs.length;
    });
  }

  getAllFollowers() async {
    QuerySnapshot querySnapshot = await followersReference
        .doc(widget.user.id)
        .collection("userFollowers")
        .get();

    setState(() {
      countTotalFollowers = querySnapshot.docs.length;
    });
  }

  createButton() {
    bool ownProfile = currentOnlineUserId == widget.user.id;
    if (ownProfile) {
      return createButtonTitleAndFunction(
        title: "Edit Profile",
        performFunction: editUserProfile,
      );
    } else if (following) {
      return createButtonTitleAndFunction(
        title: "Following",
        performFunction: controlUnfollowUser,
      );
    } else if (!following) {
      return createButtonTitleAndFunction(
        title: "Follow",
        performFunction: controlFollowUser,
      );
    }
  }

  FlatButton createButtonTitleAndFunction(
      {String title, Function performFunction}) {
    return FlatButton(
      onPressed: performFunction,
      child: Container(
        width: 100.0,
        height: 40.0,
        child: Text(
          title,
          style: TextStyle(
              fontFamily: "Rubik",
              color: following ? Theme.of(context).primaryColor : Colors.white,
              fontWeight: FontWeight.bold),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: following ? Colors.white : Theme.of(context).primaryColor,
          border: Border.all(
              color: following ? Theme.of(context).primaryColor : Colors.white),
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
    );
  }

  checkIfAlreadyFollowing() async {
    DocumentSnapshot documentSnapshot = await followersReference
        .doc(widget.user.id)
        .collection("userFollowers")
        .doc(currentOnlineUserId)
        .get();

    setState(() {
      following = documentSnapshot.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage(userProfileId: widget.user.id),
                  ),
                );
              },
              child: Text(
                widget.user.profileName,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                    fontSize: 18.0, color: Colors.black, fontFamily: "Rubik"),
              ),
            ),
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Image.network(widget.user.url),
            ),
          ),
          subtitle: Text(
            widget.user.bio,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w500),
          ),
          trailing:
              (widget.title == 'Followings' || widget.title == 'Followers')
                  ? SizedBox()
                  : createButton(),
        ));
  }
}
