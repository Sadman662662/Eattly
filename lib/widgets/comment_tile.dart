import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:timeago/timeago.dart' as tAgo;

class CommentTile extends StatelessWidget {
  final String profileName;
  final String comment;
  final String url;
  final Timestamp timestamp;

  const CommentTile({
    Key key,
    @required this.profileName,
    @required this.comment,
    @required this.url,
    @required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                profileName + ":  " + comment,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Color(0xFF1B5E20),
                  fontFamily: "Rubik",
                ),
              ),
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(url),
              ),
              subtitle: Text(
                tAgo.format(timestamp.toDate()),
                style: TextStyle(color: Color(0xFF1B5E20), fontFamily: "Rubik"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
