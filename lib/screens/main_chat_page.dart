import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helpers/footnote.dart';
import 'chatting_page.dart';

class ChatHomeScreen extends StatefulWidget {
  static const route = "main_chat_page";
  const ChatHomeScreen({super.key});

  @override
  _ChatHomeScreenState createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  final _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        flexibleSpace: const FlexibleSpaceBar(
          title: Text(
            'Chats',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _fireStore.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final users = snapshot.data!.docs;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChattingScreen(selectedFriendEmail: user['email']),
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        children: <Widget>[
                          const SizedBox(
                            width: 10,
                          ),
                          Image.asset(
                            "assets/images/person.png",
                            width: 36,
                            height: 36,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            user['email'],
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
      bottomNavigationBar: const MyFootNote(),
    );
  }
}
