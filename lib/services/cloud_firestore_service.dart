import 'dart:developer';

import 'package:chat_app04/modal/chat_modal.dart';
import 'package:chat_app04/modal/cloud_modal.dart';
import 'package:chat_app04/services/auth_sevierse.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudFireStoreService {
  // collection :doc-set-update/add
  CloudFireStoreService._();

  static CloudFireStoreService cloudFireStoreService =
      CloudFireStoreService._();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> insertUserIntoFireStore(UserModal user) async {
    await fireStore.collection("users").doc(user.email).set({
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'image': user.image,
      'token': user.token,
    });
  }
  // Read data for current user - profile

  Future<DocumentSnapshot<Map<String, dynamic>>>
      readCurrentUserFromFireStore() async {
    User? user = AuthService.authService.getCurrentUser();
    return await fireStore.collection("users").doc(user!.email).get();
  }

  // read all user form firestore

  Future<QuerySnapshot<Map<String, dynamic>>>
      readAllUserFromCloudFireStore() async {
    User? user = AuthService.authService.getCurrentUser();
    return await fireStore
        .collection("users")
        .where("email", isNotEqualTo: user!.email!)
        .get();
  }

  // add chat in firestore

  //chatroom ->  ->list chat
  // sender_receiver
  //

  Future<void> addChatInFireStore(ChatModal chat) async {
    String? sender = chat.sender;
    String? receiver = chat.receiver;
    List doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");
    await fireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .add(chat.toMap(chat));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readChatFromFireStore(
      String receiver) {
    String sender = AuthService.authService.getCurrentUser()!.email!;

    List doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");
    return fireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .orderBy("time", descending: false)
        .snapshots();
  }

  Future<void> updateChat(String receiver, String massage, String dcId) async {
    String sender = AuthService.authService.getCurrentUser()!.email!;

    List doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");
    await fireStore
        .collection("chatroom ")
        .doc(docId)
        .collection("chat")
        .doc(dcId)
        .update(
      {'massage': massage},
    );
  }

  Future<void> removeChat(String dcId, String receiver) async {
    String sender = AuthService.authService.getCurrentUser()!.email!;

    List doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");
    await fireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .doc(dcId)
        .delete();
  }
  // change online status

  Future<void> ChangeOnlineStatus(bool status) async {
    String email = AuthService.authService.getCurrentUser()!.email!;
    await fireStore.collection("users").doc(email).update({'isOnline': status});

    final snapshot = await fireStore.collection("users").doc(email).get();
    Map? user = snapshot.data();
    log("user online status after :${user!['isOnline']}");
  }
  //fine user is online or not

  Stream<DocumentSnapshot<Map<String, dynamic>>> findUserIsOnlineOrNot(
      String email) {
    return fireStore.collection("users").doc(email).snapshots();
  }
}
