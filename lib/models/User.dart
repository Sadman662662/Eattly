import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String id;
  String profileName;
  String url;
  String email;
  String bio;
  String chattingWith;
  bool followedEattly;
  String userType;

  Users({
    this.id,
    this.profileName,
    this.url,
    this.email,
    this.bio,
    this.chattingWith,
    this.followedEattly,
    this.userType = 'Free',
  });

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profileName = json['name'];
    url = json['url'];
    email = json['email'];
  }

  factory Users.fromDocument(DocumentSnapshot doc) {
    return Users(
      id: doc.id,
      email: doc.data()['email'] == null ? "" : doc.data()['email'],
      url: doc.data()['url'],
      profileName: doc.data()['profileName'],
      bio: doc.data()['bio'],
      chattingWith: doc.data()['chattingWith'],
      followedEattly: doc.data()['followedEattly'] == null
          ? false
          : doc.data()['followedEattly'],
      userType:
          doc.data()['userType'] == null ? 'Free' : doc.data()['userType'],
    );
  }

  Users.fromMap(Map snapshot)
      : id = snapshot['id'] ?? '',
        email = snapshot['email'] ?? '',
        url = snapshot['url'] ?? '',
        profileName = snapshot['profileName'] ?? '',
        bio = snapshot['bio'] ?? '',
        chattingWith = snapshot['chattingWith'] ?? '',
        followedEattly = snapshot["followedEattly"],
        userType = snapshot['userType'] ?? 'Free';
}
