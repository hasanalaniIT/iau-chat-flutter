import 'package:flutter/material.dart';
import '../helpers/footnote.dart';
import 'package:iau_chat/screens/login_page.dart';
import 'package:iau_chat/screens/signup_page.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:iau_chat/helpers/main_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const route = "home_page";

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation = ColorTween(begin: Colors.blue[700], end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: <Widget>[
                Hero(
                    tag: "logo",
                    child: SizedBox(
                      height: 65.0,
                      width: 85.0,
                      child: Image.asset('assets/images/iau_logo.png'),
                    )),
                WavyAnimatedTextKit(
                  text: const ["IAU Chat"],
                  textStyle: const TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            MainButton(
              text: 'Log In',
              onPressed: () => Navigator.pushNamed(context, LogInScreen.route),
              color: Colors.indigo,
            ),
            MainButton(
              text: 'Sign Up',
              onPressed: () => Navigator.pushNamed(context, SignUpScreen.route),
              color: Colors.blue,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MyFootNote(),
    );
  }
}
