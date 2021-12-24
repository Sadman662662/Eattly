import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eattlystefan/pages/ProfilePage.dart';
import 'package:eattlystefan/pages/ReplyPage.dart';
import 'package:eattlystefan/widgets/HeaderWidget.dart';
import 'package:eattlystefan/widgets/ProgressWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import './HomePage.dart';
import '../widgets/HeaderWidget.dart';
import '../widgets/ProgressWidget.dart';

class CommentsPage extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postImageUrl;

  CommentsPage({
    this.postId,
    this.postOwnerId,
    this.postImageUrl,
  });

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController commentTextEditingController = TextEditingController();

  retrieveComments() {
    return StreamBuilder(
      stream: commentsReference
          .doc(widget.postId)
          .collection("comments")
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        List<Comment> comments = [];
        dataSnapshot.data.documents.forEach((document) {
          comments.add(Comment.fromDocument(
              document, widget.postId, document.documentID));
        });
        return ListView(children: comments);
      },
    );
  }

  saveComment() {
    commentsReference.doc(widget.postId).collection("comments").add({
      "profileName": currentUser.profileName,
      "comment": commentTextEditingController.text,
      "timestamp": DateTime.now(),
      "url": currentUser.url,
      "useId": currentUser.id,
      "likes": {},
    });

    bool isNotPostOwner = widget.postOwnerId != currentUser.id;
    if (isNotPostOwner) {
      activityFeedReference
          .doc(widget.postOwnerId)
          .collection("feedItems")
          .add({
        "type": "liked a comment",
        "commentData": commentTextEditingController.text,
        "postId": widget.postId,
        "userId": currentUser.id,
        "profileName": currentUser.profileName,
        "userProfileImg": currentUser.url,
        "url": widget.postImageUrl,
        "timestamp": DateTime.now(),
      });
    }
    commentTextEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Comments"),
      body: Column(
        children: <Widget>[
          Expanded(
            child: retrieveComments(),
          ),
          Divider(),
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color(0xFFf8f8f8),
                borderRadius: BorderRadius.circular(12)),
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              controller: commentTextEditingController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Write comment..",
                prefix: SizedBox(
                  width: 16,
                ),
                suffixIcon: OutlineButton(
                    onPressed: saveComment,
                    borderSide: BorderSide.none,
                    child: ImageIcon(
                      AssetImage('assets/send_button_icon.png'),
                      color: Theme.of(context).primaryColor,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatefulWidget {
  final String profileName;
  final String userId;
  final String url;
  final String comment;
  final Timestamp timestamp;
  final Map likes;
  final Map replies;
  final String postId;
  final dynamic documentId;
  // final String ownerId;

  Comment(
      {this.profileName,
      this.userId,
      this.url,
      this.comment,
      this.timestamp,
      this.likes,
      this.replies,
      this.postId,
      this.documentId
      // this.ownerId
      });

  factory Comment.fromDocument(
      DocumentSnapshot documentSnapshot, String postId, dynamic documentId) {
    return Comment(
      profileName: documentSnapshot.data()["profileName"],
      userId: documentSnapshot.data()["useId"],
      url: documentSnapshot.data()["url"],
      comment: documentSnapshot.data()["comment"],
      timestamp: documentSnapshot.data()["timestamp"],
      postId: postId,
      likes: documentSnapshot.data()["likes"],
      documentId: documentId,
      // replies: documentSnapshot["replis"],
      // ownerId: documentSnapshot["useId"],
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
  _CommentState createState() => _CommentState(
      profileName: this.profileName,
      userId: this.userId,
      url: this.url,
      comment: this.comment,
      likes: this.likes,
      replies: this.replies,
      likeCount: getTotalNumberOfLikes(this.likes),
      documentId: this.documentId);
}

class _CommentState extends State<Comment> {
  final String profileName;
  final String userId;
  final String url;
  final String comment;
  final Map likes;
  final Map replies;
  final String documentId;
  int likeCount;
  bool isLiked;
  bool isNotPostOwner;
  // final String ow

  final String currentOnlineUserId = currentUser?.id;

  _CommentState(
      {this.profileName,
      this.userId,
      this.url,
      this.comment,
      this.likes,
      this.replies,
      this.likeCount,
      this.isNotPostOwner,
      this.documentId});

  checkLiked() {
    if (likes == null) {
      return false;
    } else
      return likes[currentOnlineUserId] == true;
  }

  countTotalReplies() async {
    QuerySnapshot documentSnapshot =
        await replyReference.doc(widget.documentId).collection('replies').get();
    int counter = 0;
    documentSnapshot.docs.forEach((element) {
      counter = counter + 1;
    });
    return counter;
  }

  controlUserLikeComment() async {
    bool isNotPostOwner = widget.userId != currentUser.id;
    bool _liked = checkLiked();
    if (_liked) {
      setState(() {
        likeCount = likeCount - 1;
        isLiked = false;
        likes[currentOnlineUserId] = false;
      });

      await commentsReference
          .doc(widget.postId)
          .collection("comments")
          .doc(widget.documentId)
          .update({"likes.$currentOnlineUserId": false});
    } else if (!_liked) {
      if (likes == null) {
        await commentsReference
            .doc(widget.postId)
            .collection("comments")
            .doc(widget.documentId)
            .update({"likes.$currentOnlineUserId": true});
        setState(() {
          likeCount = likeCount + 1;
          isLiked = true;
        });

        if (isNotPostOwner) {
          activityFeedReference
              .doc(widget.userId)
              .collection("feedItems")
              .doc(widget.postId)
              .set(
            {
              "type": "like",
              "profileName": currentUser.profileName,
              "userId": currentUser.id,
              "timestamp": DateTime.now(),
              "url": widget.url,
              "commentId": widget.documentId,
              "userProfileImg": currentUser.url,
            },
          );
        }
      }
      await commentsReference
          .doc(widget.postId)
          .collection("comments")
          .doc(widget.documentId)
          .update({"likes.$currentOnlineUserId": true});
      setState(() {
        likeCount = likeCount + 1;
        isLiked = true;
        likes[currentOnlineUserId] = true;
        // showHeart = true;
      });

      if (isNotPostOwner) {
        activityFeedReference
            .doc(widget.userId)
            .collection("feedItems")
            .doc(widget.postId)
            .set(
          {
            "type": "like",
            "profileName": currentUser.profileName,
            "userId": currentUser.id,
            "timestamp": DateTime.now(),
            "url": widget.url,
            "commentId": widget.documentId,
            "userProfileImg": currentUser.url,
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  returnIsLiked() {
    if (likes == null) {
      return false;
    } else {
      return likes[currentOnlineUserId] == true;
    }
  }

  @override
  Widget build(BuildContext context) {
    isLiked = returnIsLiked();
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage(userProfileId: widget.userId),
                      ),
                    );
                  },
                  child: Text(
                    widget.profileName,
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
                  child: widget.url != null
                      ? Image.network(widget.url)
                      : Image.asset('assets/eattly.png'),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeago.format(widget.timestamp.toDate()),
                    style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Rubik",
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.comment,
                        style: TextStyle(
                            color: Color(0xFF202020),
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => controlUserLikeComment(),
                            child: ImageIcon(
                              isLiked
                                  ? AssetImage('assets/apple2.png')
                                  : AssetImage('assets/apple_outline2.png'),
                              color: Colors.grey,
                              size: 18,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            likeCount.toString(),
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            child: ImageIcon(
                              AssetImage('assets/reply_button_icon.png'),
                              size: 18,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ReplyPage(
                                            commentOwnerImageUrl: widget.url,
                                            commenttOwnerId: widget.userId,
                                            postId: widget.postId,
                                            currentOnlineUserId:
                                                currentOnlineUserId,
                                            documentId: widget.documentId,
                                          )));
                            },
                          ),
                          StreamBuilder(
                              stream: replyReference
                                  .doc(widget.documentId)
                                  .collection("replies")
                                  .orderBy("timestamp", descending: false)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text('');
                                }
                                int counter = 0;
                                snapshot.data.documents.forEach((document) {
                                  counter = counter + 1;
                                });
                                return Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(counter.toString()),
                                );
                              })
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
