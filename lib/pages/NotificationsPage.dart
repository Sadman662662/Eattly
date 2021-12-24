import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eattlystefan/pages/shopListPage.dart';
import 'package:eattlystefan/utils/text_style.dart';
import 'package:eattlystefan/widgets/HeaderWidget.dart';
import 'package:eattlystefan/widgets/ProgressWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as tAgo;

import 'ChatScreen.dart';
import 'HomePage.dart';
import 'ProfilePage.dart';
import 'TimeLinePage.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Notification> notificationsOnToday = [];
  List<Notification> notificationsOnThisWeek = [];
  List<Notification> notifications = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: FutureBuilder(
          future: retrieveNotifications(),
          builder: (context, dataSnapshot) {
            if (!dataSnapshot.hasData) {
              return circularProgress();
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Today',
                          style: TextStyle(
                              color: Color(0xFF1e1e1e),
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ),
                      (notificationsOnToday.length > 0)
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: notificationsOnToday.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) =>
                                  NotificationsItem(
                                    commentData:
                                        notificationsOnToday[index].commentData,
                                    userProfileImg: notificationsOnToday[index]
                                        .userProfileImg,
                                    postId: notificationsOnToday[index].postId,
                                    profileName:
                                        notificationsOnToday[index].profileName,
                                    timestamp:
                                        notificationsOnToday[index].timestamp,
                                    type: notificationsOnToday[index].type,
                                    url: notificationsOnToday[index].url,
                                    userId: notificationsOnToday[index].userId,
                                  ))
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'No notifications for today..',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                      SizedBox(
                        height: 16,
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'All Notifications',
                          style: TextStyle(
                              color: Color(0xFF1e1e1e),
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ),
                      (notifications.length > 0)
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: notifications.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) =>
                                  NotificationsItem(
                                    commentData:
                                        notifications[index].commentData,
                                    userProfileImg:
                                        notifications[index].userProfileImg,
                                    postId: notifications[index].postId,
                                    profileName:
                                        notifications[index].profileName,
                                    timestamp: notifications[index].timestamp,
                                    type: notifications[index].type,
                                    url: notifications[index].url,
                                    userId: notifications[index].userId,
                                  ))
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Sorry no notifications available',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            );
            // ListView(
            //   children: dataSnapshot.data,
            // );
          },
        ),
      ),
    );
  }

  retrieveNotifications() async {
    QuerySnapshot querySnapshot = await activityFeedReference
        .doc(currentUser.id)
        .collection("feedItems")
        .orderBy("timestamp", descending: true)
        .limit(60)
        .get();

    notifications = [];
    notificationsOnToday = [];
    notificationsOnThisWeek = [];

    querySnapshot.docs.forEach((document) {
      if (!notifications.contains(document)) {
        notifications.add(Notification.fromDocument(document));
      }
    });

    for (final notification in notifications) {
      final presentDate = DateTime.now();
      final difference =
          presentDate.difference(notification.timestamp.toDate()).inDays;
      if (difference == 0 && !notificationsOnToday.contains(notification)) {
        notificationsOnToday.add(notification);
      }

      if (difference <= 7 &&
          difference >= 0 &&
          !notificationsOnThisWeek.contains(notification)) {
        notificationsOnThisWeek.add(notification);
      }
    }

    return notifications;
  }
}

class Notification {
  final String profileName;
  final String type;
  final String commentData;
  final String postId;
  final String userId;
  final String userProfileImg;
  final String url;
  final Timestamp timestamp;

  Notification(
      {this.profileName,
      this.type,
      this.commentData,
      this.postId,
      this.userId,
      this.userProfileImg,
      this.url,
      this.timestamp});

  factory Notification.fromDocument(DocumentSnapshot documentSnapshot) {
    return Notification(
      profileName: documentSnapshot.data()["profileName"],
      type: documentSnapshot.data()["type"],
      commentData: documentSnapshot.data()["commentData"],
      postId: documentSnapshot.data()["postId"],
      userId: documentSnapshot.data()["userId"],
      userProfileImg: documentSnapshot.data()["userProfileImg"],
      url: documentSnapshot.data()["url"],
      timestamp: documentSnapshot.data()["timestamp"],
    );
  }
}

class NotificationsItem extends StatelessWidget {
  final String profileName;
  final String type;
  final String commentData;
  final String postId;
  final String userId;
  final String userProfileImg;
  final String url;
  final Timestamp timestamp;

  NotificationsItem(
      {this.profileName,
      this.type,
      this.commentData,
      this.postId,
      this.userId,
      this.userProfileImg,
      this.url,
      this.timestamp});

  String notificationItemText;
  Widget mediaPreview;

  displayOwnProfile(BuildContext context, {String userProfileId}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(userProfileId: currentUser.id)));
  }

  displayUserProfile(BuildContext context, {String userProfileId}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(userProfileId: userProfileId)));
  }

  configureMediaPreview(context) {
    if (type == "comment" || type == "like") {
      mediaPreview = GestureDetector(
        onTap: () => displayOwnProfile(context, userProfileId: currentUser.id),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: CachedNetworkImageProvider(url)),
              ),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = Text("");
    }

    if (type == "like") {
      notificationItemText = "liked your recipe.";
    } else if (type == "comment") {
      notificationItemText = "commented your recipe";
    } else if (type == "follow") {
      notificationItemText = "started following you.";
    } else if (type == "reply") {
      notificationItemText = 'replied to a comment';
    } else if (type == "liked a comment") {
      notificationItemText = "liked a comment";
    } else {
      notificationItemText = "Error, Unknown type = $type";
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 6.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: GestureDetector(
                  onTap: () {
                    displayUserProfile(context, userProfileId: userId);
                  },
                  child: Text(
                    profileName,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontFamily: "Rubik"),
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
                  child: Image.network(
                    userProfileImg,
                  ),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$notificationItemText',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Rubik",
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
