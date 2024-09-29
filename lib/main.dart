import 'package:chat_app04/services/Firebase_messging_service.dart';
import 'package:chat_app04/services/local_notification_serivec.dart';
import 'package:chat_app04/views/auth/auth_manager.dart';
import 'package:chat_app04/views/home/chat_page.dart';
import 'package:chat_app04/views/home/home_page.dart';
import 'package:chat_app04/views/second_page/sign_in.dart';
import 'package:chat_app04/views/second_page/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await LocalNotificationService.notificationService.initNotificationService();
  await FirebaseMessagingService.fm.requestPermission();
  await FirebaseMessagingService.fm.getDeviceToken();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/', page: () => const AuthManager()),
        GetPage(name: '/signIn', page: () => const SignIn()),
        GetPage(name: '/signup', page: () => const SignUp()),
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/chatpage', page: () => const ChatPage()),
      ],
    );
  }
}
