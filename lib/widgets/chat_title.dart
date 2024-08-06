// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:chati/pages/chat_page.dart';

class ChatTitle extends StatelessWidget {
  //?
  final String chatId;
  final String lastMessage;
  final Timestamp timestamp;
  final Map<String, dynamic> receiverData;
  const ChatTitle({
    super.key,
    required this.chatId,
    required this.lastMessage,
    required this.timestamp,
    required this.receiverData,
  });

  @override
  Widget build(BuildContext context) {
    /**
     * timestamp to dsteTime 변환한다. 
     */
    var date = DateTime.parse(timestamp.toDate().toString());

    return lastMessage != ""
        ? ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(receiverData["imageUrl"]),
            ),
            title: Text(
              receiverData['name'],
            ),
            subtitle: Text(
              lastMessage,
              maxLines: 2,
            ),
            trailing: Text(
              '${date.hour}:${date.minute}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            onTap: () {
              Get.to(
                () => ChatPage(),
                arguments: {
                  "chatId": chatId,
                  "receiverId": receiverData['uid'],
                },
              );
            },
          )
        : Container();
  }
}
