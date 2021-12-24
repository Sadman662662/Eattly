import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eattlystefan/pages/HomePage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Story {
  final String aboutStory;
  final String ownerId;
  final String ownerProfileImageUrl;
  final String profileName;
  final String storyId;
  final Timestamp timestamp;
  final String url;
  final List<Story> storis;

  Story(
      {this.aboutStory,
      this.ownerId,
      this.ownerProfileImageUrl,
      this.profileName,
      this.storyId,
      this.timestamp,
      this.url,
      this.storis});

  factory Story.fromDocument(DocumentSnapshot doc) {
    return Story(
        storyId: doc.id,
        aboutStory: doc.data()['aboutStory'],
        ownerId: doc.data()['ownerId'],
        ownerProfileImageUrl: doc.data()['ownerProfileImageUrl'],
        profileName: doc.data()['profileName'],
        timestamp: doc.data()['timestamp'],
        url: doc.data()['url']);
  }
}
