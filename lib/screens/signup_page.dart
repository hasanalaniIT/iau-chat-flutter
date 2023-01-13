import 'package:flutter/material.dart';
import 'package:iau_chat/helpers/main_button.dart';
import 'package:iau_chat/helpers/style_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const route = "signup_page";

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
              onChanged: (value) {
                //Do something with the user input.
              },
              decoration: myTextFieldDecoration.copyWith(hintText: "Enter your Email")
      ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
              },
              decoration: myTextFieldDecoration.copyWith(hintText: "Enter your password")
            ),
            const SizedBox(
              height: 24.0,
            ),
            MainButton(
              text: 'Register',
              onPressed: () {},
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}
