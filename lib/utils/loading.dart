import 'package:eattlystefan/utils/text_style.dart';
import 'package:flutter/material.dart';


class Loading extends StatelessWidget {
  const Loading();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(greenColor),
        ),
      ),
      color: Colors.white.withOpacity(0.8),
    );
  }
}
