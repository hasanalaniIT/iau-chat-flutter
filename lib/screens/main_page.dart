import 'package:flutter/material.dart';
import 'package:iau_chat/screens/login_page.dart';
import 'package:iau_chat/screens/signup_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const route = "home_page";


  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
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
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 65.0,
                    width: 85.0,
                    child: Image.asset('assets/images/iau_logo.png'),
                  ),
                  const Text(
                    'IAU Chat',
                    style: TextStyle(
                      fontSize: 48.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 48.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LogInScreen.route);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: const Text(
                    'Log In',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30.0),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignUpScreen.route);

                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: const Text(
                    'Sign Up',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
