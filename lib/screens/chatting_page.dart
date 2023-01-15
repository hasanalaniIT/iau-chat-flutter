import 'package:iau_chat/helpers/style_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

late User userLogIn;

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});
  static const route = "chatting_page";

  @override
  ChattingScreenState createState() => ChattingScreenState();
}

class ChattingScreenState extends State<ChattingScreen> {
  final _fireBaseAuth = FirebaseAuth.instance;
  final _fireStoreAuth = FirebaseFirestore.instance;
  final textFieldController = TextEditingController();
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
            StreamMessagesBuilder(fireStoreAuth: _fireStoreAuth),
            Container(
              decoration: myMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textFieldController,
                      onChanged: (text) {
                        textMessage = text;
                      },
                      decoration: myMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      textFieldController.clear();
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

class BubbleTextBuilder extends StatelessWidget {
  final String email;
  final bool isSelfSender;
  final String message;
  const BubbleTextBuilder(
      {required this.message, required this.email, required this.isSelfSender});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isSelfSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            email,
            style: const TextStyle(fontSize: 13, color: Colors.black45),
          ),
          Material(
            elevation: 6.0,
            borderRadius: isSelfSender
                ? myBubbleMessageRadiusDecoration.copyWith(
                    topLeft: const Radius.circular(28))
                : myBubbleMessageRadiusDecoration.copyWith(
                    topRight: const Radius.circular(28)),
            color: isSelfSender ? Colors.indigoAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                message,
                style: TextStyle(
                    fontSize: 16.0,
                    color: isSelfSender ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StreamMessagesBuilder extends StatelessWidget {
  const StreamMessagesBuilder({
    Key? key,
    required FirebaseFirestore fireStoreAuth,
  })  : _fireStoreAuth = fireStoreAuth,
        super(key: key);

  final FirebaseFirestore _fireStoreAuth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStoreAuth.collection("conversations").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final conversations = snapshot.data!.docs.reversed;
          List<BubbleTextBuilder> conversationWidget = [];
          for (var text in conversations) {
            final textMessage = text["sent_message"];
            final senderMail = text["user_mail"];
            final loggedInCurrentUser = userLogIn.email;
            final bubbleTextWidget = BubbleTextBuilder(
                isSelfSender: loggedInCurrentUser == senderMail,
                email: senderMail,
                message: textMessage);
            conversationWidget.add(bubbleTextWidget);
          }
          return Expanded(
              child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            children: conversationWidget,
          ));
        }
        return const Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.blue,
          ),
        );
      },
    );
  }
}
