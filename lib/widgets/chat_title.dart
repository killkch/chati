// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ChatTitle extends StatelessWidget {
  //?
  final String chatId;
  final String lastMessage;
  final DateTime timestemp;
  final Map<String, dynamic> receiverData;

  const ChatTitle({
    super.key,
    required this.chatId,
    required this.lastMessage,
    required this.timestemp,
    required this.receiverData,
  });

  @override
  Widget build(BuildContext context) {
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
              '${timestemp.hour}:${timestemp.minute}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            onTap: () {
              // Get.to(() => ChatPage());
            })
        : Container();
  }
}
