import 'package:iau_chat/helpers/style_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

late User userLogIn;

class ChattingScreen extends StatefulWidget {
  final String selectedFriendEmail;
  const ChattingScreen({super.key, required this.selectedFriendEmail});
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

  void createConversation(String friendEmail) async {
    final currUser = _fireBaseAuth.currentUser;
    if (currUser != null) {
      // create conversation for current user
      final userDoc =
          await _fireStoreAuth.collection('users').doc(currUser.uid).get();
      if (userDoc.exists) {
        final conversation =
            userDoc.reference.collection('conversations').doc(friendEmail);
        conversation.set({
          "friend_email": friendEmail,
          "timestamp": Timestamp.now(),
        });
        conversation.collection('messages').add({
          "message": textMessage,
          "msg_date": Timestamp.now(),
          "sender": currUser.email,
        });
      } else {
        print('User document does not exist');
      }
      // create conversation for friend user
      final friendDoc = await _fireStoreAuth
          .collection('users')
          .where('email', isEqualTo: friendEmail)
          .get();
      if (friendDoc.docs.isNotEmpty) {
        final friendConversation = friendDoc.docs.first.reference
            .collection('conversations')
            .doc(currUser.email);
        friendConversation.set({
          "friend_email": currUser.email,
          "timestamp": Timestamp.now(),
        });
        friendConversation.collection('messages').add({
          "message": textMessage,
          "msg_date": Timestamp.now(),
          "sender": currUser.email,
        });
      } else {
        print('Friend document does not exist');
      }
    }
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
    return Container(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  _fireBaseAuth.signOut();
                  Navigator.pushNamedAndRemoveUntil(context, LogInScreen.route,
                      (Route<dynamic> route) => false);
                }),
          ],
          title: Text(widget.selectedFriendEmail,style: const TextStyle(fontSize: 24),),
          backgroundColor: Colors.indigoAccent[400],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              StreamMessagesBuilder(
                  fireStoreAuth: _fireStoreAuth,
                  friendEmail: widget.selectedFriendEmail),
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
                        createConversation(widget.selectedFriendEmail);
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
      ),
    );
  }
}

class StreamMessagesBuilder extends StatelessWidget {
  final FirebaseFirestore fireStoreAuth;
  final String friendEmail;

  const StreamMessagesBuilder({
    required this.fireStoreAuth,
    required this.friendEmail,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: fireStoreAuth
            .collection('users')
            .doc(userLogIn.uid)
            .collection('conversations')
            .where("friend_email", isEqualTo: friendEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final conversations = snapshot.data!.docs.reversed;
          if (conversations.isEmpty) {
            return const Text(
              "Sey hello ♡",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w100),
              textAlign: TextAlign.center,
            );
          }
          final conversation = conversations.first;
          return StreamBuilder<QuerySnapshot>(
              stream: conversation.reference
                  .collection('messages')
                  .orderBy('msg_date')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final messages = snapshot.data!.docs.reversed;
                List<BubbleTextBuilder> bubblesChatList = [];
                for (var message in messages) {
                  final messageData = message;
                  final messageBubble = BubbleTextBuilder(
                    message: messageData['message'],
                    email: messageData['sender'],
                    isSelfSender: userLogIn.email == messageData['sender'],
                  );
                  bubblesChatList.add(messageBubble);
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20.0),
                    children: bubblesChatList,
                  ),
                );
              });
        });
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
    return Container(
      child: Padding(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10.0),
      ),
    );
  }
}
