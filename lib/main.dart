import 'package:flutter/material.dart';
import 'package:iau_chat/screens/main_page.dart';
import 'package:iau_chat/screens/login_page.dart';
import 'package:iau_chat/screens/signup_page.dart';
import 'package:iau_chat/screens/chatting_page.dart';

void main() => runApp(const MyChat());

class MyChat extends StatelessWidget {
  const MyChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: 'home_screen' ,
      routes: {
        'home_screen': (context) => const MainScreen(),
        'log_in_screen': (context) => LogInScreen(),
        'sign_up_screen': (context) => SignUpScreen(),
        'chatting_screen': (context) => ChattingScreen(),
      },
    );
  }
}
