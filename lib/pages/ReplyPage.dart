import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eattlystefan/pages/HomePage.dart';
import 'package:eattlystefan/pages/ProfilePage.dart';
import 'package:eattlystefan/widgets/HeaderWidget.dart';
import 'package:eattlystefan/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as tAgo;

class ReplyPage extends StatefulWidget {
  final String commenttOwnerId;
  final String postId;
  final String currentOnlineUserId;
  final dynamic documentId;
  final String commentOwnerImageUrl;
  ReplyPage(
      {this.postId,
      this.currentOnlineUserId,
      this.documentId,
      this.commenttOwnerId,
      this.commentOwnerImageUrl});

  @override
  _ReplyPageState createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {
  TextEditingController replyTextEditingController = TextEditingController();

  retrieveReplies() {
    return StreamBuilder(
      stream: replyReference
          .doc(widget.documentId)
          .collection("replies")
          .orderBy("timeSstamp", descending: false)
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        List<ReplyWidget> replies = [];

        dataSnapshot.data.documents.forEach((document) {
          Reply reply = Reply.fromDocument(
            document,
          );
          ReplyWidget replyWidget = ReplyWidget(
            reply: reply,
          );
          print('documentID:${document.documentID}');
          replies.add(replyWidget);
        });

        print('replyLength: ${replies.length}');
        return ListView(
          children: replies,
        );
      },
    );
  }

  saveReplies() {
    replyReference.doc(widget.documentId).collection("replies").add({
      'profileName': currentUser.profileName,
      'url': currentUser.url,
      'userId': currentUser.id,
      'reply': replyTextEditingController.text,
      'timeSstamp': DateTime.now()
    });

    bool isNotPostOwner = widget.commenttOwnerId != currentUser.id;
    if (isNotPostOwner) {
      activityFeedReference
          .doc(widget.commenttOwnerId)
          .collection("feedItems")
          .add({
        "type": "reply",
        "replyData": replyTextEditingController.text,
        "commentId": widget.documentId,
        "userId": currentUser.id,
        "profileName": currentUser.profileName,
        "userProfileImg": currentUser.url,
        "url": widget.commentOwnerImageUrl,
        "timestamp": DateTime.now(),
      });
    }

    replyTextEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Replies"),
      body: Column(
        children: <Widget>[
          Expanded(
            child: retrieveReplies(),
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
              controller: replyTextEditingController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Write comment..",
                prefix: SizedBox(
                  width: 16,
                ),
                suffixIcon: OutlineButton(
                    onPressed: saveReplies,
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

class Reply {
  final String profileName;
  final String userId;
  final String url;
  final String reply;
  final Timestamp timestamp;
  final Map likes;
  final Map replies;
  final String postId;

  Reply({
    this.profileName,
    this.userId,
    this.url,
    this.reply,
    this.timestamp,
    this.likes,
    this.replies,
    this.postId,
  });

  factory Reply.fromDocument(DocumentSnapshot documentSnapshot) {
    return Reply(
      profileName: documentSnapshot["profileName"],
      url: documentSnapshot["url"],
      userId: documentSnapshot["userId"],
      reply: documentSnapshot["reply"],
      timestamp: documentSnapshot["timeSstamp"],
    );
  }
}

class ReplyWidget extends StatefulWidget {
  final Reply reply;
  ReplyWidget({this.reply});

  @override
  _ReplyWidgetState createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {
  @override
  Widget build(BuildContext context) {
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
                            ProfilePage(userProfileId: widget.reply.userId),
                      ),
                    );
                  },
                  child: Text(
                    widget.reply.profileName,
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
                  child: Image.network(widget.reply.url),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tAgo.format(widget.reply.timestamp.toDate()),
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
                        widget.reply.reply,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
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
