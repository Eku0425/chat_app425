import 'package:chat_app04/controller/chat_controller.dart';
import 'package:chat_app04/modal/chat_modal.dart';
import 'package:chat_app04/services/auth_sevierse.dart';
import 'package:chat_app04/services/cloud_firestore_service.dart';
import 'package:chat_app04/services/local_notification_serivec.dart';
import 'package:chat_app04/services/storge_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  ChatModal? get chat => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(ChatController().receiverEmail.value),
            StreamBuilder(
                stream: CloudFireStoreService.cloudFireStoreService
                    .findUserIsOnlineOrNot(
                        ChatController().receiverEmail.value),
                builder: (context, snapshot) {
                  Map? user = snapshot.data!.data();
                  return Text(
                    user!['isOnline'] ? 'Online' : '',
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  );
                })
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: CloudFireStoreService.cloudFireStoreService
                    .readChatFromFireStore(
                        ChatController().receiverEmail.value),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List data = snapshot.data!.docs;
                  List<ChatModal> chatList = [];
                  List<String> docIdList = [];
                  for (QueryDocumentSnapshot snap in data) {
                    docIdList.add(snap.id);
                    chatList.add(ChatModal.fromMap(snap.data() as Map));
                  }
                  return SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: List.generate(
                          chatList.length,
                          (index) => GestureDetector(
                            onLongPress: () {
                              if (chatList[index].sender ==
                                  AuthService.authService
                                      .getCurrentUser()!
                                      .email!) {
                                ChatController().txtUpdateMessage =
                                    TextEditingController(
                                        text: chatList[index].message);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Update'),
                                        content: TextField(
                                          controller:
                                              ChatController().txtUpdateMessage,
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                String dcId = docIdList[index];
                                                CloudFireStoreService
                                                    .cloudFireStoreService
                                                    .updateChat(
                                                        ChatController()
                                                            .receiverEmail
                                                            .value,
                                                        ChatController()
                                                            .txtUpdateMessage
                                                            .text,
                                                        dcId);
                                                Get.back();
                                              },
                                              child: const Text('update'))
                                        ],
                                      );
                                    });
                              }
                            },
                            onDoubleTap: () {
                              if (chatList[index].sender ==
                                  AuthService.authService
                                      .getCurrentUser()!
                                      .email!) {
                                CloudFireStoreService.cloudFireStoreService
                                    .removeChat(docIdList[index],
                                        ChatController().receiverEmail.value);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              alignment: (chatList[index].sender ==
                                      AuthService.authService
                                          .getCurrentUser()!
                                          .email!)
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: (chatList[index].image!.isEmpty &&
                                      chatList[index].image == "")
                                  ? Text(chatList[index].message!)
                                  : Card(
                                      child: Image.network(
                                      chatList[index].image!,
                                      height: 100,
                                    )),
                            ),
                          ),
                        )),
                  );
                },
              ),
            ),
            TextField(
              controller: ChatController().txtMessage,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () async {
                            String url =
                                await StorageService.service.uploadImage();
                            ChatController().getImage(url);
                          },
                          icon: Icon(Icons.image)),
                      IconButton(
                          onPressed: () async {
                            ChatModal chat = ChatModal(
                                image: ChatController().image.value,
                                sender: AuthService.authService
                                    .getCurrentUser()!
                                    .email,
                                receiver: ChatController().receiverEmail.value,
                                message: ChatController().txtMessage.text,
                                time: Timestamp.now());

                            await CloudFireStoreService.cloudFireStoreService
                                .addChatInFireStore(chat!);
                            await LocalNotificationService.notificationService
                                .showNotification(
                                    AuthService.authService
                                        .getCurrentUser()!
                                        .email!,
                                    ChatController().txtMessage.text);
                            ChatController().txtMessage.clear();
                            ChatController().getImage("");
                          },
                          icon: Icon(Icons.send)),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
