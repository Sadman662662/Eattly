import 'dart:io';
import 'dart:ui';

import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:flutter/material.dart';

import './HomePage.dart';
import '../widgets/HeaderWidget.dart';
import '../widgets/PostWidget.dart';
import '../widgets/ProgressWidget.dart';

class PostScreenPage extends StatelessWidget {
  final String postId;
  final String userId;

  PostScreenPage({
    this.userId,
    this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          postsReference.doc(userId).collection("usersPosts").doc(postId).get(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }

        final post = Post.fromDocument(dataSnapshot.data);
        return Center(
          child: Scaffold(
            appBar: header(context, strTitle: post.name),
            body: ListView(
              children: <Widget>[
                Container(
                  child: post,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Description",
                    style: TextStyle(
                        color: Color(0xFF1B5E20),
                        fontFamily: "Rubik",
                        fontWeight: FontWeight.bold,
                        fontSize: 21),
                  ),
                ),
                Divider(
                  height: 15.0,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    post.description,
                    style: TextStyle(
                        color: Color(0xFF1B5E20),
                        fontFamily: "Rubik",
                        fontSize: 18),
                  ),
                ),
                Divider(
                  height: 15.0,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Ingredients",
                    style: TextStyle(
                        color: Color(0xFF1B5E20),
                        fontFamily: "Rubik",
                        fontWeight: FontWeight.bold,
                        fontSize: 21),
                  ),
                ),
                Divider(
                  height: 15.0,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    post.ingredients,
                    style: TextStyle(
                        color: Color(0xFF1B5E20),
                        fontFamily: "Rubik",
                        fontSize: 18),
                  ),
                ),
                Divider(
                  height: 15.0,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Directions",
                    style: TextStyle(
                        color: Color(0xFF1B5E20),
                        fontFamily: "Rubik",
                        fontWeight: FontWeight.bold,
                        fontSize: 21),
                  ),
                ),
                Divider(
                  height: 15.0,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    post.prepare,
                    style: TextStyle(
                        color: Color(0xFF1B5E20),
                        fontSize: 18,
                        fontFamily: "Rubik"),
                  ),
                ),
                Divider(
                  height: 15.0,
                  color: Colors.white,
                ),
                Container(
                  child: _nativeAd(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _nativeAd() {
    return FacebookNativeAd(
      placementId: Platform.isAndroid
          ? "2987187294710802_3005677552861776"
          : "2987187294710802_3169838299779033",
      adType: NativeAdType.NATIVE_AD,
      width: double.infinity,
      height: 300,
      backgroundColor: Color(0xFF1B5E20),
      titleColor: Colors.white,
      descriptionColor: Colors.white,
      buttonColor: Color(0xFF1B5E20),
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.white,
      listener: (result, value) {
        print("Native Ad: $result --> $value");
      },
      keepExpandedWhileLoading: false,
      expandAnimationDuraion: 1000,
    );
  }
}
