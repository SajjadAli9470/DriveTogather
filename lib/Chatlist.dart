import 'dart:developer';

import 'package:drivetogether/firebase_utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/CommonDrawer.dart';
import 'Rides/ChatPage.dart';

class ChatListPage extends StatefulWidget {
  final String userId;

  const ChatListPage({required this.userId, Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final CommonDrawer commonDrawer = const CommonDrawer();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat List"),
      ),
      drawer: commonDrawer.build(context),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore
            .collection("chats")
            .where("driver_id", isEqualTo: getCurrentUserId())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return const Center(
              child: Text("No chats available"),
            );

          var chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chat = chats[index].data();

              log(chat.toString());

              // Determine the other user ID from the chat ID

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: chat["user_image"]!=null
                      ? NetworkImage(
                          chat["user_image"].toString())
                      : null,
                ),
                title: Text(
                    "Chat with ${chat.isNotEmpty ? chats[index].data()["user_name"] : "unknown"}"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatPage(id: chats[index].data()["user_id"],
                          name: chats[index].data()["user_name"],
                          ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
