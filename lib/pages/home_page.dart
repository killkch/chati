// ignore_for_file: prefer_const_constructors

import 'package:chati/pages/search_page.dart';
import 'package:chati/providers/chat_provider.dart';
import 'package:chati/providers/chat_provider.dart';
import 'package:chati/providers/chat_provider.dart';
import 'package:chati/providers/chat_provider.dart';
import 'package:chati/providers/chat_provider.dart';
import 'package:chati/services/auth_service.dart';
import 'package:chati/widgets/chat_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //?

  final _auth = FirebaseAuth.instance;

  User? loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() => loggedInUser = user);
    }
  }

  Future<Map<String, dynamic>> _fetchChatData(String chatId) async {
    /**
     * chat 정보를 가져온다 
     */
    final chatDoc =
        await FirebaseFirestore.instance.collection('chats').doc(chatId).get();
    final chatData = chatDoc.data();
    final users = chatData!['users'] as List<dynamic>;
    /**
     * 조건에 맞는 첫번쨰 리스트의 인자 값으르 가져온다. : firstwhere 
     * 상대방의 정보를 가져온다.
     */
    final receiverId = users.firstWhere((id) => id != loggedInUser!.uid);
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .get();
    final userData = userDoc.data()!;
    print("userData : ${userData.toString()}");

    return {
      'chatId': chatId,
      'lastMessage': chatData['lastMessage'] ?? '',
      'timeStemp': chatData['timeStemp']?.toString() ?? DateTime.now(),
      'userData': userData,
    };
  }

  @override
  Widget build(BuildContext context) {
    //?

    final AuthService authService = AuthService();

    final chatProvider = Provider.of<ChatProvider>(context);

    return PopScope(
      /**
       * 두ㅣ로 가기버튼 활성화 / 비활성화 를 정한다. 
       */
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Chati"),
          actions: [
            IconButton(
              icon: Icon(Icons.logout_outlined),
              onPressed: () {
                authService.signOut();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: chatProvider.getChats(loggedInUser!.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final chatDocs = snapshot.data!.docs;
                  return FutureBuilder<List<Map<String, dynamic>>>(
                    /** 
                     * 페이지를 처음 로딩할 때 많은 정보를 불러오는 경우가 있습니다. 
                     * 동시에 여러개의 api를 통해서 초기 정보를 많이 필요로 하는 앱들이 있는데요
                     * 이럴 경우 속도가 느려지는 경우가 있습니다. 
                     * Future.wait를 사용할 경우 이 안에 배열로 들어간 모든 api들이 동시에 실행이 되어 
                     * 속도를 빠르게 할 수 있습니다. 
                     * 즉 병렬화를 통해서 데이터 로딩 속도를 조절할 수 있습니다. 
                     * 
                     * ..map의 경우 인자들을 forEach로 죽 돌리면서 내재되 함수를 돌린다는 말입니다. 
                     * chatDoc에 map를 실행한다. 
                     * 
                     * map메소드는 해당 iterable의 요소들을 순서대로 훑으면서 map안에 넣어진 fuction을 돌린다.
                     * map 메소드는 iterable를 대상으로 foreach을 한 번 돌려주는 것이다.
                     */
                    future: Future.wait(
                        chatDocs.map((chatDoc) => _fetchChatData(chatDoc.id))),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final chatDataList = snapshot.data!;
                      return ListView.builder(
                        itemCount: chatDataList.length,
                        itemBuilder: (context, index) {
                          final chatData = chatDataList[index];
                          return ChatTitle(
                            chatId: chatData['chatId'],
                            lastMessage: chatData['lastMessage'],
                            timestemp: chatData['timeStemp'],
                            receiverData: chatData['userData'],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          onPressed: () {
            Get.to(() => SearchPage());
          },
          child: Icon(Icons.search),
        ),
      ),
    );
  }
}
