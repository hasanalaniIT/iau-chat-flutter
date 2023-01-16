import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iau_chat/helpers/main_button.dart';
import 'package:iau_chat/helpers/style_utils.dart';
import 'package:iau_chat/screens/main_chat_page.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../helpers/footnote.dart';
import 'chatting_page.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});
  static const route = "login_page";

  @override
  LogInScreenState createState() => LogInScreenState();
}

class LogInScreenState extends State<LogInScreen> {
  final _fireBaseAuth = FirebaseAuth.instance;
  String userEmail = "";
  String userPassword = "";
  bool loadingCircle = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingOverlay(
        isLoading: loadingCircle,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: "logo",
                  child: SizedBox(
                    height: 220.0,
                    child: Image.asset('assets/images/iau_logo.png'),
                  ),
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
                text: 'Log In',
                onPressed: () async {
                  print(userPassword);
                  print(userEmail);
                  setState(() {
                    loadingCircle = true;
                  });
                  try {
                    final logUser =
                        await _fireBaseAuth.signInWithEmailAndPassword(
                            email: userEmail, password: userPassword);
                    if (logUser != null) {
                      Navigator.pushNamed(context, HomeScreen.route);
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
      bottomNavigationBar: const MyFootNote(),
    );
  }
}
