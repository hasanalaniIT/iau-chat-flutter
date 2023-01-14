import 'package:flutter/material.dart';
import 'package:iau_chat/helpers/main_button.dart';
import 'package:iau_chat/helpers/style_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iau_chat/screens/chatting_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const route = "signup_page";

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _fireBaseAuth = FirebaseAuth.instance;
  String userEmail = "";
  String userPassword = "";
  bool loadingCircle = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: loadingCircle,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: "logo",
                child: SizedBox(
                  height: 220.0,
                  child: Image.asset('assets/images/iau_logo.png'),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (information) {
                    userEmail = information;
                  },
                  decoration: myTextFieldDecoration.copyWith(
                      hintText: "Enter your Email")),
              const SizedBox(
                height: 9.0,
              ),
              TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (information) {
                    userPassword = information;
                  },
                  decoration: myTextFieldDecoration.copyWith(
                      hintText: "Enter your password")),
              const SizedBox(
                height: 24.0,
              ),
              MainButton(
                text: 'Register',
                onPressed: () async {
                  setState(() {
                    loadingCircle = true;
                  });
                  print(userPassword);
                  print(userEmail);
                  try {
                    final newRegister =
                        await _fireBaseAuth.createUserWithEmailAndPassword(
                            email: userEmail, password: userPassword);
                    if (newRegister != null) {
                      Navigator.pushNamed(context, ChattingScreen.route);
                    }
                  } on Exception catch (e) {
                    print(e);
                  } finally {
                    setState(() {
                      loadingCircle = false;
                    });
                  }
                },
                color: Colors.indigoAccent,
              )
            ],
          ),
        ),
      ),
    );
  }
}
