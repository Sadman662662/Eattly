import 'package:eattlystefan/pages/HomePage.dart';
import 'package:eattlystefan/widgets/textFormWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/text_style.dart';
import 'registerUserEmail.dart';

class SignInWithEmailAndPass extends StatefulWidget {
  @override
  _SignInWithEmailAndPassState createState() => _SignInWithEmailAndPassState();
}

class _SignInWithEmailAndPassState extends State<SignInWithEmailAndPass> {
  final _firebaseAuth = auth.FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  bool isLoading = false;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: greenColor),
        title: Text(
          "Sign In",
          style: textStyle(greenColor, 20.0, FontWeight.bold),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                "EATTLY",
                style: textStyle(greenColor, 50.0, FontWeight.bold),
              ),
              Text(
                "EATS EASY",
                style: textStyle(Colors.green[900], 25.0, FontWeight.w500),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextFormWidget(
                  textEditingController: _emailController,
                  hint: "write your email",
                  height: 50.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextFormWidget(
                  textEditingController: _passwordController,
                  hint: "insert your password",
                  height: 50.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                child: ButtonTheme(
                  minWidth: double.infinity,
                  height: 40,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        if (_emailController.text.isEmpty) {
                          showToast("Enter email id");
                          return;
                        }
                        if (_passwordController.text.isEmpty) {
                          showToast("Enter your password");
                          return;
                        } else {
                          signInWithEmailPass(
                              _emailController.text, _passwordController.text);
                        }
                      });

                      // await uploadPic(context);
                    },
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 80.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text("Don't have an account?"),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterWithEmailAndPass()),
                        );
                      },
                      child: Text(
                        "Register here",
                        style: textStyle(greenColor, 18.0, FontWeight.w500),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void showToast(str) {
    Fluttertoast.showToast(
      msg: str,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  setProgressDialog(BuildContext context, ProgressDialog pr, String message) {
    pr.style(
        message: message,
        borderRadius: 10,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(
          backgroundColor: greenColor,
        ),
        elevation: 10,
        insetAnimCurve: Curves.easeInOut);
  }

  signInWithEmailPass(email, pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ProgressDialog pasdr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    setProgressDialog(context, pasdr, "Sign In...");

    pasdr.show();

    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: pass);

      final _user = userCredential.user;

      if (_user != null) {
        print("Users $_user");
        prefs.setBool("emailSign", true);
        pasdr.hide();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        print("User not logged in");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        showToast('No user found for that email.');
        pasdr.hide();
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        showToast('No user found for that email.');
        pasdr.hide();
      }
    }
  }
}
