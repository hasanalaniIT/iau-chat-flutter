import 'package:iau_chat/helpers/style_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});
  static const route = "chatting_page";

  @override
  ChattingScreenState createState() => ChattingScreenState();
}

class ChattingScreenState extends State<ChattingScreen> {
  final _fireBaseAuth = FirebaseAuth.instance;
  final _fireStoreAuth = FirebaseFirestore.instance;
  late User userLogIn;
  late String textMessage;
  @override
  void initState() {
    getUser();
    super.initState();
  }

  void getUser() async {
    try {
      final currUser = _fireBaseAuth.currentUser;
      if (currUser != null) {
        userLogIn = currUser;
        print(userLogIn.email);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _fireBaseAuth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: const Text('Chat'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            StreamBuilder <QuerySnapshot>(
              stream: _fireStoreAuth.collection("conversations").snapshots(),
              builder:(context, snapshot){
                if (snapshot.hasData) {
                  final conversations = snapshot.data!.docs;
                  List<Text> conversationWidget = [];
                  for (var text in conversations){
                    final textMessage = text["sent_message"];
                    final senderMail = text["user_mail"];
                    final textWidget = Text("$textMessage from $senderMail");
                    conversationWidget.add(textWidget);
                  }
                  return Column(
                    children: conversationWidget,
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            Container(
              decoration: myMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (text) {
                        textMessage = text;
                      },
                      decoration: myMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _fireStoreAuth.collection('conversations').add({
                        "sent_message": textMessage,
                        "user_mail": userLogIn.email,
                      });
                    },
                    child: const Text(
                      'Send',
                      style: mySendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
