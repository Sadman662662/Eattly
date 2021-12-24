import 'package:flutter/material.dart';

import '../../pages/CommentsPage.dart';
import '../../pages/HomePage.dart';

class RecipeDetailComment extends StatelessWidget {
  final String postId;
  final String ownerId;
  final String imageUrl;
  final commentTextEditingController = TextEditingController();

  RecipeDetailComment({
    Key key,
    @required this.postId,
    @required this.ownerId,
    @required this.imageUrl,
  }) : super(key: key);

  Widget retrieveComments() {
    return StreamBuilder(
      stream: commentsReference
          .doc(postId)
          .collection("comments")
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return CircularProgressIndicator();
        }
        List<Comment> comments = [];
        dataSnapshot.data.documents.forEach((document) {
          comments
              .add(Comment.fromDocument(document, postId, document.documentID));
        });

        if (comments.length > 0) {
          return Container(
            height: 300,
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (BuildContext context, int index) {
                return comments[index];
              },
            ),
          );
        } else {
          return Text('No Comments');
        }
      },
    );
  }

  void saveComment() {
    commentsReference.doc(postId).collection("comments").add({
      "profileName": currentUser.profileName,
      "comment": commentTextEditingController.text,
      "timestamp": DateTime.now(),
      "url": currentUser.url,
      "useId": currentUser.id,
      "likes": {},
    });

    bool isNotPostOwner = ownerId != currentUser.id;

    if (isNotPostOwner) {
      activityFeedReference.doc(ownerId).collection("feedItems").add({
        "type": "liked a comment",
        "commentData": commentTextEditingController.text,
        "postId": postId,
        "userId": currentUser.id,
        "profileName": currentUser.profileName,
        "userProfileImg": currentUser.url,
        "url": imageUrl,
        "timestamp": DateTime.now(),
      });
    }
    commentTextEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        retrieveComments(),
        Divider(),
        Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0xFFf8f8f8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            controller: commentTextEditingController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Write comment..",
              prefix: SizedBox(width: 16),
              suffixIcon: OutlineButton(
                onPressed: () => saveComment(),
                borderSide: BorderSide.none,
                child: ImageIcon(
                  AssetImage('assets/send_button_icon.png'),
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
