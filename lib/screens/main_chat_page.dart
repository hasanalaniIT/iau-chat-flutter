import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatting_page.dart';

class HomeScreen extends StatefulWidget {

  static const route = "main_chat_page";

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
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
                        builder: (context) => ChattingScreen(selectedFriendEmail: userData['email']),
                      ),
                    );
                  },
                ));
              }
              return ListView(
                children: userTiles,
              );
            }));
  }
}

