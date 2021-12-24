import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './custom_dialog.dart';
import './utils/text_style.dart';

class FirstView extends StatefulWidget {
  @override
  _FirstViewState createState() => _FirstViewState();
}

class _FirstViewState extends State<FirstView> {
  final primaryColor = const Color(0000000000);

  // var scribe =
  //     "Loren gypsum dolor sit mate, ad prompts feud gait, quid exercise emeritus bis e."
  //     "Usu cu ores quid am, me rides sapper croquet ex.";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    final _height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF1B5E20),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            height: _height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "EATTLY",
                  style: textStyle(Colors.white, 60.0, FontWeight.w500),
                ),
                Text(
                  "Eat's Easy",
                  style: textStyle(Colors.white, 25.0, FontWeight.w500),
                ),
                SizedBox(
                  height: 30,
                ),
                // Text(
                //   // scribe,
                //   textAlign: TextAlign.center,
                //   style: textStyle(whiteColor, 17.0, FontWeight.w400),
                // ),
                Container(
                  height: 70,
                ),
                CustomButtonOne(
                  text: "Get Started",
                  icon: Icons.arrow_forward,
                  value: 1,
                  callback: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomDialog(
                        title: 'Would you like to create a free account?',
                        description:
                            'With an account, your data will be securely saved, allowing you to access it from multiple devices. By creating account you agree with our Privacy Policy and Terms and Conditions',
                        primaryButtonText: 'Create My Account',
                        primaryButtonRoute: "/signUp",
                        secondaryButtonText: 'Maybe Later',
                        secondaryButtonRoute: "/home",
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButtonOne extends StatelessWidget {
  const CustomButtonOne(
      {Key key, this.text, this.icon, this.image, this.value, this.callback})
      : super(key: key);

  final String text;
  final String image;
  final IconData icon;
  final num value;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      width: MediaQuery.of(context).size.width / 1.5,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: whiteColor,
        child: Row(
          children: [
            value == 1
                ? Icon(
                    icon,
                    color: greenColor,
                  )
                : Image.asset(
                    image,
                    height: 30,
                    width: 30,
                  ),
            Expanded(
                child: Text(
              text,
              textAlign: TextAlign.center,
              style: textStyle(greenColor, 15.0, FontWeight.w500),
            )),
          ],
        ),
        onPressed: callback,
      ),
    );
  }
}
