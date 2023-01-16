import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iau_chat/screens/main_chat_page.dart';
import 'package:iau_chat/screens/main_page.dart';
import 'package:iau_chat/screens/login_page.dart';
import 'package:iau_chat/screens/signup_page.dart';
import 'package:iau_chat/screens/chatting_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyChat());
}

class MyChat extends StatelessWidget {
  const MyChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: MainScreen.route ,
      routes: {
        MainScreen.route: (context) => const MainScreen(),
        LogInScreen.route: (context) => const LogInScreen(),
        SignUpScreen.route: (context) => const SignUpScreen(),
        HomeScreen.route: (context) => const HomeScreen(),
        // ChattingScreen.route: (context) => const ChattingScreen(selectedFriendEmail: 'redfire5005@gmail.com',),
      },
    );
  }
}
