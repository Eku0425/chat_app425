import 'package:chat_app04/services/cloud_firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  RxString receiverEmail = "".obs;
  RxString receiverName = "".obs;
  RxString image = "".obs;

  TextEditingController txtMessage = TextEditingController();
  TextEditingController txtUpdateMessage = TextEditingController();

  void getImage(String url) {
    image.value = url;
  }

  void getReceiver(String email, String name) {
    receiverEmail.value = email;
    receiverName.value = name;
  }

  @override
  void onInit() {
    super.onInit();
    CloudFireStoreService.cloudFireStoreService.ChangeOnlineStatus(true);
  }

  @override
  void onClose() {
    super.onClose();
    CloudFireStoreService.cloudFireStoreService.ChangeOnlineStatus(false);
  }
}
