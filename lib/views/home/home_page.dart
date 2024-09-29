import 'package:chat_app04/controller/auth_controller.dart';
import 'package:chat_app04/modal/cloud_modal.dart';
import 'package:chat_app04/services/auth_sevierse.dart';
import 'package:chat_app04/services/cloud_firestore_service.dart';
import 'package:chat_app04/services/local_notification_serivec.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/chat_controller.dart';

var chatController = Get.put(ChatController());

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    CloudFireStoreService.cloudFireStoreService.ChangeOnlineStatus(true);
  }

  void deactivate() {
    super.deactivate();
    CloudFireStoreService.cloudFireStoreService.ChangeOnlineStatus(false);
  }

  void dispose() {
    super.dispose();

    CloudFireStoreService.cloudFireStoreService.ChangeOnlineStatus(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: 100,
        child: FutureBuilder(
            future: CloudFireStoreService.cloudFireStoreService
                .readCurrentUserFromFireStore(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                  snapshot.error.toString(),
                ));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              Map? data = snapshot.data!.data();
              UserModal userModal = UserModal.fromMap(data!);
              return Column(
                children: [
                  DrawerHeader(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(userModal.image!),
                    ),
                  ),
                  Text(userModal.name!),
                  Text(userModal.email!),
                  Text(userModal.phone!),
                ],
              );
            }),
      ),
      appBar: AppBar(
        title: Text("Home page"),
        actions: [
          IconButton(
              onPressed: () {
                LocalNotificationService.notificationService
                    .scheduleNotification();
              },
              icon: Icon(Icons.notifications_active_outlined)),
          IconButton(
              onPressed: () async {
                AuthService.authService.signOutUser();
                User? user = await AuthService.authService.getCurrentUser();
                if (User == null) {
                  Get.toNamed('/signIn');
                }
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder(
          future: CloudFireStoreService.cloudFireStoreService
              .readAllUserFromCloudFireStore(),
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
            List<UserModal> userList = [];

            for (var user in data) {
              userList.add(UserModal.fromMap(user.data()));
            }
            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    chatController.getReceiver(
                        userList[index].email!, userList[index].name!);
                    Get.toNamed('/chatpage');
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userList[index].image!),
                  ),
                  title: Text(userList[index].name!),
                  subtitle: Text(userList[index].email!),
                );
              },
            );
          }),
    );
  }
}
