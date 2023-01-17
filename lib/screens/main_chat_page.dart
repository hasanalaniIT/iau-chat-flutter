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
          title: const Text('Chats'),
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
              List<ListTile> userTiles = [];
              for (var user in users) {
                final userData = user;
                userTiles.add(ListTile(
                  title: Text(userData['email']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChattingScreen(
                            selectedFriendEmail: userData['email']),
                      ),
                    );
                  },
                ));
              }
              return ListView(
                children: userTiles,
              );
            }
            )
        ,bottomNavigationBar: const MyFootNote(),
    );
  }
}
