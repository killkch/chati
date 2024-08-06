// ignore_for_file: prefer_interpolation_to_compose_strings, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class ChatProvider extends ChangeNotifier {
  //?
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getChats(String userId) {
    return _fireStore
        .collection("chats")
        .where("users", arrayContains: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> searchUsers(String query) {
    return _fireStore
        .collection('users')
        .where('email', isGreaterThanOrEqualTo: query)
        .where('email', isLessThanOrEqualTo: query + '\uf8ff')
        .snapshots();
  }

  Future<void> sendMessage(
    String chatId,
    String message,
    String receiverId,
  ) async {
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      await _fireStore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        "senderId": currentUser.uid,
        "receiverId": receiverId,
        "messageBody": message,
        "timestamp": FieldValue.serverTimestamp(),
      });

      await _fireStore.collection('chats').doc(chatId).set(
        {
          "users": [currentUser.uid, receiverId],
          "lastMessage": message,
          "timestamp": FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    }
  }

  Future<String?> getChatroom(String receiverId) async {
    //?
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      final chatQuery = await _fireStore
          .collection('chats')
          .where('users', arrayContains: currentUser.uid)
          .get();
      final chats = chatQuery.docs
          .where((chat) => chat['users'].contains(receiverId))
          .toList();

      if (chats.isNotEmpty) {
        return chats.first.id;
      }
    }
    return null;
  }

  Future<String> createChatRoom(String receiverId) async {
    //?
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      // var now = DateTime.now();
      // String formatDate = DateFormat('yyMM/dd - HH:mm:ss').format(now);

      final chatRoom = await _fireStore.collection('chats').add({
        'users': [currentUser.uid, receiverId],
        'lastMessage': '',
        "timestamp": FieldValue.serverTimestamp(),
      });
      return chatRoom.id;
    }
    throw Exception('Current User is null');
  }
}
